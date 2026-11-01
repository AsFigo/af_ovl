// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_bits fires when popcount(test_expr) < min or > max
//       Parameters: width=4, min=1, max=3, asserted=1
// Pass scenario: test_expr always has popcount in [1,3] — checker must not fire.
// Checker sees sequence: pc=1,1,2,3,2,2 — all in [1,3].

module af_tb_ovl_bits_pass;

  reg        clk, rst_n;
  reg  [3:0] test_expr;
  wire [2:0] fire;

  ovl_bits #(
    .width    (4),
    .min      (1),
    .max      (3),
    .asserted (1),
    .msg      ("BITS_PASS_TB")
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

    // checker sees: 0001(pc=1,ok), 0001(pc=1,ok), 0011(pc=2,ok), 0111(pc=3,ok), 0101(pc=2,ok)
    @(posedge clk); test_expr = 4'b0001;  // checker sees 0001 pc=1
    @(posedge clk); test_expr = 4'b0011;  // checker sees 0001 pc=1
    @(posedge clk); test_expr = 4'b0111;  // checker sees 0011 pc=2
    @(posedge clk); test_expr = 4'b0101;  // checker sees 0111 pc=3
    repeat(2) @(posedge clk);             // checker sees 0101 pc=2

    $finish;
  end

endmodule
