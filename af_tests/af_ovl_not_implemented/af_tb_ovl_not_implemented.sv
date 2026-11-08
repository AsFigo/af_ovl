// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
`timescale 1ns/1ns
// Smoke test for the 18 checkers with no OVL_VERILOG logic (af_ovl/af_ovl_not_implemented.v).
// Each checker is instantiated once with default parameters; only clock(s), reset,
// enable and fire are connected (no logic reads the other inputs).
// Expect:
//   - with OVL_ASSERT_ON (or OVL_COVER_ON): one OVL_WARNING per instance at time 0 (18 total)
//   - with neither defined: no warnings
//   - in both cases: every fire output is 3'b000 (not Z)

module af_tb_ovl_not_implemented;

  localparam N = 18;

  reg            clk, rst_n;
  wire [3*N-1:0] fire_all;

  ovl_arbiter                 u00 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 0*3 +: 3]));
  ovl_crc                     u01 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 1*3 +: 3]));
  ovl_fifo                    u02 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 2*3 +: 3]));
  ovl_hold_value              u03 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 3*3 +: 3]));
  ovl_memory_async            u04 (                .reset(rst_n), .enable(1'b1), .fire(fire_all[ 4*3 +: 3]));
  ovl_memory_sync             u05 (.r_clock(clk), .w_clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 5*3 +: 3]));
  ovl_multiport_fifo          u06 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 6*3 +: 3]));
  ovl_next_state              u07 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 7*3 +: 3]));
  ovl_no_contention           u08 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 8*3 +: 3]));
  ovl_reg_loaded              u09 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[ 9*3 +: 3]));
  ovl_req_ack_unique          u10 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[10*3 +: 3]));
  ovl_req_requires            u11 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[11*3 +: 3]));
  ovl_stack                   u12 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[12*3 +: 3]));
  ovl_valid_id                u13 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[13*3 +: 3]));
  ovl_value                   u14 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[14*3 +: 3]));
  ovl_value_coverage          u15 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[15*3 +: 3]));
  ovl_xproduct_bit_coverage   u16 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[16*3 +: 3]));
  ovl_xproduct_value_coverage u17 (.clock(clk), .reset(rst_n), .enable(1'b1), .fire(fire_all[17*3 +: 3]));

  initial clk = 1'b0;
  always #5 clk = ~clk;

  integer i;
  integer bad;

  initial begin
    rst_n = 1'b0;
    #1;                                   // after the time-0 warnings
    bad = 0;
    for (i = 0; i < N; i = i + 1) begin
      if (fire_all[i*3 +: 3] !== 3'b000) begin
        $display("FAIL: instance u%0d fire = %b (expected 000)", i, fire_all[i*3 +: 3]);
        bad = bad + 1;
      end
    end
    repeat(2) @(posedge clk);
    rst_n = 1'b1;
    repeat(3) @(posedge clk);
    if (fire_all !== {3*N{1'b0}}) begin
      $display("FAIL: fire not all zero after reset: %b", fire_all);
      bad = bad + 1;
    end
    if (bad == 0) $display("PASS: all %0d fire outputs are 000", N);
    $finish;
  end

endmodule
