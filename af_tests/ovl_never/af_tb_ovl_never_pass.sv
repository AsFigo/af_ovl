// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Spec (sva31a): property ASSERT_NEVER_P — test_expr != 1'b1 at posedge clk
//                disable iff (reset != 1'b1)
// Pass scenario: test_expr stays 0 throughout active period — checker must not fire.

module af_tb_ovl_never_pass;

  reg clk, rst_n, test_expr;
  wire [2:0] fire;

  ovl_never #(.msg("NEVER_PASS_TB")) u_ovl_never (
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

    // Spec: test_expr must never be 1. Keep it 0.
    repeat(5) @(posedge clk);

    $finish;
  end

endmodule
