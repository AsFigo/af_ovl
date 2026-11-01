// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_mutex fires when popcount(test_expr) >= 2
//       i.e. (test_expr & (test_expr-1)) != 0
//       Parameters: width=4, invert_mode=0
// Pass scenario: test_expr always has at most 1 bit set — checker must not fire.
// Checker sees sequence: 0001,0001,0010,0100,1000,0000,0000 — all one-hot or zero.

module af_tb_ovl_mutex_pass;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_mutex #(
    .width       (4),
    .invert_mode (0),
    .msg         ("MUTEX_PASS_TB")
  ) u_ovl_mutex (
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
    test_expr = 4'b0001;        // 1 bit set — valid initial value

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // checker sees: 0001(ok), 0001(ok), 0010(ok), 0100(ok), 1000(ok), 0000(ok)
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0001 — 1 bit
    @(posedge clk); test_expr = 4'b0010;  // checker sees 0001 — 1 bit
    @(posedge clk); test_expr = 4'b0100;  // checker sees 0010 — 1 bit
    @(posedge clk); test_expr = 4'b1000;  // checker sees 0100 — 1 bit
    @(posedge clk); test_expr = 4'b0000;  // checker sees 1000 — 1 bit
    repeat(2) @(posedge clk);             // checker sees 0000 — 0 bits

    $finish;
  end

endmodule
