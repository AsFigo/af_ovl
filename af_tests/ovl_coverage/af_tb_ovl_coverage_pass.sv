// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_coverage fires (coverage event) when test_expr == 1'b1
//       This is a coverage checker, not an assertion violation checker.
// Pass scenario: test_expr stays 0 — coverage point never hit, no fire.

module af_tb_ovl_coverage_pass;

  reg        clk, rst_n, test_expr;
  wire [2:0] fire;

  ovl_coverage #(.msg("COVERAGE_PASS_TB")) u_ovl_coverage (
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

    repeat(2) @(posedge clk);   // hold reset
    rst_n = 1'b1;

    // test_expr stays 0 — coverage point never triggered
    repeat(5) @(posedge clk);

    $finish;
  end

endmodule
