// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec: ovl_coverage fires (coverage event) when test_expr == 1'b1
//       This is a coverage checker — "fire" = coverage hit, not a design error.
// Fail scenario: test_expr goes 1 after reset — coverage event must be reported.

module af_tb_ovl_coverage_fail;

  reg        clk, rst_n, test_expr;
  wire [2:0] fire;

  ovl_coverage #(.msg("COVERAGE_FAIL_TB")) u_ovl_coverage (
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

    repeat(3) @(posedge clk);   // 3 cycles not covered

    // Trigger coverage event: test_expr goes 1
    test_expr = 1'b1;

    repeat(3) @(posedge clk);   // fire for 3 cycles

    $finish;
  end

endmodule
