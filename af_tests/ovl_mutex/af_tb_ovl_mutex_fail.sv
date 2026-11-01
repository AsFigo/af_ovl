// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_mutex fires when popcount(test_expr) >= 2
//       i.e. (test_expr & (test_expr-1)) != 0
//       Parameters: width=4, invert_mode=0
// Fail scenario 1: test_expr = 4'b0011 (bits 0,1 set) — checker must fire.
// Fail scenario 2: test_expr = 4'b0110 (bits 1,2 set) — checker must fire again.

module af_tb_ovl_mutex_fail;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_mutex #(
    .width       (4),
    .invert_mode (0),
    .msg         ("MUTEX_FAIL_TB")
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
    test_expr = 4'b0001;        // valid initial value (1 bit)

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // checker sees: 0001(ok), 0001(ok), 0011(FIRE), 0001(ok), 0110(FIRE), 0001(ok)
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0001 — ok
    @(posedge clk); test_expr = 4'b0011;  // checker sees 0001 — ok; load violation 1
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0011 — FIRE (2 bits set)
    @(posedge clk); test_expr = 4'b0110;  // checker sees 0001 — ok; load violation 2
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0110 — FIRE (2 bits set)
    repeat(2) @(posedge clk);             // checker sees 0001 — ok

    $finish;
  end

endmodule
