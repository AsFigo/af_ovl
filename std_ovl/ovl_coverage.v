// Accellera Standard V2.8.1 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2014. All rights reserved.
// Modified by AsFigo: added OVL_VERILOG behavioral implementation for Icarus Verilog.
// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0

`include "std_ovl_defines.h"

`module ovl_coverage  (clock, reset, enable, test_expr, fire);

  parameter severity_level  = `OVL_SEVERITY_DEFAULT;
  parameter property_type   = `OVL_PROPERTY_DEFAULT;
  parameter msg             = `OVL_MSG_DEFAULT;
  parameter coverage_level  = `OVL_COVER_DEFAULT;

  parameter clock_edge      = `OVL_CLOCK_EDGE_DEFAULT;
  parameter reset_polarity  = `OVL_RESET_POLARITY_DEFAULT;
  parameter gating_type     = `OVL_GATING_TYPE_DEFAULT;

  // Internal parameters (do not change)
  parameter assert_name     = "OVL_COVERAGE";

  input                          clock, reset, enable;
  input                          test_expr;
  output [`OVL_FIRE_WIDTH-1 : 0] fire;

  `include "std_ovl_reset.h"
  `include "std_ovl_clock.h"
  `include "std_ovl_cover.h"
  `include "std_ovl_task.h"
  `include "std_ovl_init.h"

`ifdef OVL_VERILOG
  `include "./sv2012/af_ovl_coverage_logic.v"
  assign fire = {fire_2state, fire_xcheck, fire_cover};
`endif

`ifdef OVL_SVA
  `include "./sva05/ovl_coverage_logic.sv"
  assign fire = {`OVL_FIRE_WIDTH{1'b0}}; // Tied low in V2.3
`endif

`endmodule // ovl_coverage
