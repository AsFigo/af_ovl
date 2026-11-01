// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec (sva31a): property ASSERT_RANGE_P — (test_expr >= min) && (test_expr <= max)
//                disable iff (reset != 1'b1)
//                Parameters: width=4, min=2, max=8
// Pass scenario: test_expr always in [2,8] after reset — checker must not fire.
//
// Stimulus note: "@(posedge clk); test_expr = X" means the checker evaluates
// the PREVIOUS value at the posedge, then X takes effect for the next cycle.
// test_expr is initialized to 4 (in-range) so the first active posedge sees 4.

module af_tb_ovl_range_pass;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_range #(
    .width (4),
    .min   (2),
    .max   (8),
    .msg   ("RANGE_PASS_TB")
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
    test_expr = 4'd4;           // in-range initial value — seen at first active posedge

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // Checker sees: 4, 2, 5, 7, 8, 3, 3 — all in [2,8]
    @(posedge clk); test_expr = 4'd2;   // checker sees 4 — in range
    @(posedge clk); test_expr = 4'd5;   // checker sees 2 — min boundary
    @(posedge clk); test_expr = 4'd7;   // checker sees 5
    @(posedge clk); test_expr = 4'd8;   // checker sees 7
    @(posedge clk); test_expr = 4'd3;   // checker sees 8 — max boundary
    repeat(2) @(posedge clk);           // checker sees 3, 3

    $finish;
  end

endmodule
