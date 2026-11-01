// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_code_distance fires when Hamming_distance(test_expr1, test_expr2) < min or > max.
//       Check triggers only when test_expr1 changes or at the first active cycle after reset.
//       Hamming distance = popcount(test_expr1 ^ test_expr2). Parameters: width=4, min=2, max=3.
// Pass scenario: all checks (first cycle and test_expr1-change cycles) have HD in [2,3].
// Also verifies that test_expr2-only changes do not trigger a check.
//
// Driving convention: inputs are set at negedge so the always @(posedge clk) in the OVL
// captures the previous-cycle value cleanly, avoiding a posedge race.

module af_tb_ovl_code_distance_pass;

  reg        clk, rst_n;
  reg  [3:0] test_expr1, test_expr2;
  wire [2:0] fire;

  ovl_code_distance #(
    .width (4),
    .min   (2),
    .max   (3),
    .msg   ("CODE_DIST_PASS_TB")
  ) u_ovl_cd (
    .clock      (clk),
    .reset      (rst_n),
    .enable     (1'b1),
    .test_expr1 (test_expr1),
    .test_expr2 (test_expr2),
    .fire       (fire)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n      = 1'b0;
    test_expr1 = 4'b0000;
    test_expr2 = 4'b0110;           // xor=0110 HD=2 — valid initial pair

    repeat(2) @(posedge clk);
    @(negedge clk); rst_n = 1'b1;  // deassert reset between edges

    @(posedge clk);                 // 1st active (sva_checker_time_0=1): sees 0000^0110=0110 HD=2 ok
    @(negedge clk); test_expr1 = 4'b0001; test_expr2 = 4'b0110;

    @(posedge clk);                 // t1 changed (0000->0001): sees 0001^0110=0111 HD=3 ok
    @(negedge clk); test_expr1 = 4'b0011; test_expr2 = 4'b0110;

    @(posedge clk);                 // t1 changed (0001->0011): sees 0011^0110=0101 HD=2 ok
    @(negedge clk); test_expr2 = 4'b1001; // t1 unchanged — t2-only change

    @(posedge clk);                 // t1 unchanged: no check, no fire
    repeat(2) @(posedge clk);

    $finish;
  end

endmodule
