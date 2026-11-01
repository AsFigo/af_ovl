// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec (sva31a): property ASSERT_NEVER_P — test_expr != 1'b1 at posedge clk
//                disable iff (reset != 1'b1)
// Fail scenario: test_expr goes 1 after reset — checker must fire OVL_ERROR.

module af_tb_ovl_never_fail;

  reg clk, rst_n, test_expr;
  wire [2:0] fire;

  ovl_never #(.msg("NEVER_FAIL_TB")) u_ovl_never (
    .clock     (clk),
    .reset     (rst_n),
    .enable    (1'b1),
    .test_expr (test_expr),
    .fire      (fire)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n     = 1'b0;
    test_expr = 1'b0;

    repeat(2) @(posedge clk);   // hold reset for 2 cycles
    rst_n = 1'b1;               // release reset

    repeat(3) @(posedge clk);   // 3 passing cycles

    // Spec violation: test_expr goes 1 — property ASSERT_NEVER_P must fire
    test_expr = 1'b1;

    repeat(3) @(posedge clk);

    $finish;
  end

endmodule
