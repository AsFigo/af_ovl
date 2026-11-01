// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec (sva31a): property ASSERT_RANGE_P — (test_expr >= min) && (test_expr <= max)
//                disable iff (reset != 1'b1)
//                Parameters: width=4, min=2, max=8
// Fail scenario 1: test_expr = 1 (below min=2) — checker must fire.
// Fail scenario 2: test_expr = 9 (above max=8) — checker must fire again.
//
// Stimulus note: "@(posedge clk); test_expr = X" sets X AFTER posedge.
// The checker evaluates the value PRESENT at the posedge (previous assignment).
// test_expr initialized to 4 (in-range) so first active posedge sees no violation.

module af_tb_ovl_range_fail;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_range #(
    .width (4),
    .min   (2),
    .max   (8),
    .msg   ("RANGE_FAIL_TB")
  ) u_ovl_range (
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
    test_expr = 4'd4;           // in-range initial value

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // Checker sees: 4(ok), 5(ok), 1(FIRE), 4(ok), 9(FIRE), 5(ok), 5(ok)
    @(posedge clk); test_expr = 4'd5;  // checker sees 4 — in range
    @(posedge clk); test_expr = 4'd1;  // checker sees 5 — in range; load 1 for next
    @(posedge clk); test_expr = 4'd4;  // checker sees 1 < 2 — FIRE (below min)
    @(posedge clk); test_expr = 4'd9;  // checker sees 4 — in range; load 9 for next
    @(posedge clk); test_expr = 4'd5;  // checker sees 9 > 8 — FIRE (above max)
    repeat(2) @(posedge clk);          // checker sees 5, 5 — in range

    $finish;
  end

endmodule
