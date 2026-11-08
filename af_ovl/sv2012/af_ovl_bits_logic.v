// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0

//------------------------------------------------------------------------------
// SHARED CODE
//------------------------------------------------------------------------------
`ifdef OVL_SHARED_CODE
  wire [width-1:0] bit_vector = (asserted == 1) ? test_expr : ~test_expr;
`endif // OVL_SHARED_CODE


//------------------------------------------------------------------------------
// ASSERTION
//------------------------------------------------------------------------------
`ifdef OVL_ASSERT_ON

  // 2-STATE: fire if popcount(bit_vector) < min or > max.
  // min=0 means no lower-bound check; max=0 means no upper-bound check.
  // Separate wires match Accellera SVA: two independent properties with distinct messages.
  wire fire_min      = (min != 0 && $countones(bit_vector) < min);
  wire fire_max      = (max != 0 && $countones(bit_vector) > max);
  wire fire_2state_1 = fire_min || fire_max;

  bit fire_2state;
  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL == 1'b0) begin
      fire_2state <= 1'b0;
    end
    else begin
      if (fire_min) begin
        if (asserted == 1) begin
          ovl_error_t(`OVL_FIRE_2STATE, "Fewer than min bits were asserted");
        end
        else begin
          ovl_error_t(`OVL_FIRE_2STATE, "Fewer than min bits were deasserted");
        end
      end
      if (fire_max) begin
        if (asserted == 1) begin
          ovl_error_t(`OVL_FIRE_2STATE, "More than max bits were asserted");
        end
        else begin
          ovl_error_t(`OVL_FIRE_2STATE, "More than max bits were deasserted");
        end
      end
      fire_2state <= fire_2state_1 ? ovl_fire_2state_f(property_type) : 1'b0;
    end
  end

  // X-CHECK
  // =======
  `ifdef OVL_XCHECK_OFF
    wire fire_xcheck = 1'b0;
  `else
    `ifdef OVL_IMPLICIT_XCHECK_OFF
      wire fire_xcheck = 1'b0;
    `else
      wire fire_xcheck_1 = $isunknown(test_expr);
      bit  fire_xcheck;
      always @(posedge clk) begin
        if (`OVL_RESET_SIGNAL == 1'b0) begin
          fire_xcheck <= 1'b0;
        end
        else begin
          if (fire_xcheck_1) begin
            ovl_error_t(`OVL_FIRE_XCHECK,"test_expr contains X or Z");
            fire_xcheck <= ovl_fire_xcheck_f(property_type);
          end
          else begin
            fire_xcheck <= 1'b0;
          end
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
