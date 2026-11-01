// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_bits fires when popcount(test_expr) < min or > max
//       Parameters: width=4, min=1, max=3, asserted=1
// Fail scenario 1: test_expr=4'b0000 (popcount=0 < min=1) — checker must fire.
// Fail scenario 2: test_expr=4'b1111 (popcount=4 > max=3) — checker must fire again.

module af_tb_ovl_bits_fail;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_bits #(
    .width    (4),
    .min      (1),
    .max      (3),
    .asserted (1),
    .msg      ("BITS_FAIL_TB")
  ) u_ovl_bits (
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
    test_expr = 4'b0001;        // popcount=1 — valid initial value

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // checker sees: 0001(ok), 0011(ok), 0000(FIRE pc=0<1), 0001(ok), 1111(FIRE pc=4>3), 0001(ok)
    @(posedge clk); test_expr = 4'b0011;  // checker sees 0001 pc=1 — ok
    @(posedge clk); test_expr = 4'b0000;  // checker sees 0011 pc=2 — ok; load violation
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0000 pc=0 — FIRE (below min)
    @(posedge clk); test_expr = 4'b1111;  // checker sees 0001 pc=1 — ok; load violation
    @(posedge clk); test_expr = 4'b0001;  // checker sees 1111 pc=4 — FIRE (above max)
    repeat(2) @(posedge clk);             // checker sees 0001 — ok

    $finish;
  end

endmodule
