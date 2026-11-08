// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0

//------------------------------------------------------------------------------
// SHARED CODE
//------------------------------------------------------------------------------
`ifdef OVL_SHARED_CODE
  // 1 at init and during reset; 0 after first posedge with reset deasserted.
  // Forces a code-distance check on the first active cycle after reset,
  // mirroring the Accellera SVA antecedent: (!$stable(test_expr1) || sva_checker_time_0)
  bit sva_checker_time_0 = 1'b1;
  always_ff @(posedge clk) begin
    if (`OVL_RESET_SIGNAL) begin
      sva_checker_time_0 <= 1'b0;
    end
    else begin
      sva_checker_time_0 <= 1'b1;
    end
  end
`endif // OVL_SHARED_CODE


//------------------------------------------------------------------------------
// ASSERTION
//------------------------------------------------------------------------------
`ifdef OVL_ASSERT_ON

  // Registered test_expr1: behavioural equivalent of $stable(test_expr1).
  // Check fires only when test_expr1 changes or at the first active cycle.
  logic [width-1:0] test_expr1_q;
  always_ff @(posedge clk) begin
    test_expr1_q <= test_expr1;
  end

  wire             check_enable  = ((test_expr1 !== test_expr1_q) || sva_checker_time_0);
  wire [width-1:0] hd_vec        = test_expr1 ^ test_expr2;
  wire             fire_2state_1 = check_enable &&
                                   ($countones(hd_vec) < min || $countones(hd_vec) > max);

  bit fire_2state;
  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL == 1'b0) begin
      fire_2state <= 1'b0;
    end
    else begin
      if (fire_2state_1) begin
        ovl_error_t(`OVL_FIRE_2STATE, "Code distance is not within specified limits");
        fire_2state <= ovl_fire_2state_f(property_type);
      end
      else begin
        fire_2state <= 1'b0;
      end
    end
  end

  // X-CHECK — separate fires for test_expr1 and test_expr2 (matches Accellera)
  `ifdef OVL_XCHECK_OFF
    wire fire_xcheck = 1'b0;
  `else
    `ifdef OVL_IMPLICIT_XCHECK_OFF
      wire fire_xcheck = 1'b0;
    `else
      wire fire_xcheck_1 = $isunknown(test_expr1);
      wire fire_xcheck_2 = $isunknown(test_expr2);
      bit  fire_xcheck;

      always @(posedge clk) begin
        if (`OVL_RESET_SIGNAL == 1'b0) begin
          fire_xcheck <= 1'b0;
        end
        else begin
          if (fire_xcheck_1) begin
            ovl_error_t(`OVL_FIRE_XCHECK, "test_expr1 contains X or Z");
          end
          if (fire_xcheck_2) begin
            ovl_error_t(`OVL_FIRE_XCHECK, "test_expr2 contains X or Z");
          end
          fire_xcheck <= (fire_xcheck_1 || fire_xcheck_2) ?
                         ovl_fire_xcheck_f(property_type) : 1'b0;
        end
      end

    `endif // OVL_IMPLICIT_XCHECK_OFF
  `endif // OVL_XCHECK_OFF

`else
  wire fire_2state = 1'b0;
  wire fire_xcheck = 1'b0;
`endif // OVL_ASSERT_ON


//------------------------------------------------------------------------------
// COVERAGE
//------------------------------------------------------------------------------
`ifdef OVL_COVER_ON
  wire fire_cover = 1'b0;
`else
  wire fire_cover = 1'b0;
`endif // OVL_COVER_ON
