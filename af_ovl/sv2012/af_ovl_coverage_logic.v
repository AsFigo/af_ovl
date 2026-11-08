// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0

//------------------------------------------------------------------------------
// SHARED CODE
//------------------------------------------------------------------------------
`ifdef OVL_SHARED_CODE
`endif // OVL_SHARED_CODE


//------------------------------------------------------------------------------
// ASSERTION
//------------------------------------------------------------------------------
`ifdef OVL_ASSERT_ON

  // 2-STATE: fire (coverage event) when test_expr is asserted.
  // This checker reports a coverage hit, not a design violation.
  // enable check matches Accellera SVA: covered_fire_combo = (enable===1 && !X/Z && test_expr===1)
  wire fire_2state_1 = (enable === 1'b1 && !$isunknown(test_expr) && (test_expr == 1'b1));
  bit  fire_2state;
  always @(posedge clk) begin
    if (`OVL_RESET_SIGNAL == 1'b0) begin
      fire_2state <= 1'b0;
    end
    else begin
      if (fire_2state_1) begin
        ovl_error_t(`OVL_FIRE_2STATE,"The HDL statement was covered");
        fire_2state <= ovl_fire_2state_f(property_type);
      end
      else begin
        fire_2state <= 1'b0;
      end
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
