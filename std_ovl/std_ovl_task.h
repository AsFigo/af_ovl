// Accellera Standard V2.8.1 Open Verification Library (OVL).
// Accellera Copyright (c) 2005-2014. All rights reserved.
// Modified by AsFigo: SV-2012 rewrite.
//
// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
//
// SV-2012 rewrite:
//   - automatic tasks  : re-entrant; each call gets its own local storage
//   - string err_msg   : no 128-char truncation; runtime-variable content possible
//   - $error/$fatal/$warning/$info : proper EDA severity semantics
//   - OVL_FINISH_OFF   : ifdef guard inside FATAL case; $error used instead of $fatal
//   - OVL_UVM          : uvm_error/uvm_fatal/uvm_warning/uvm_info reporting path
//   - endtask : name   : end labels per coding guideline
//
// OVL_LEGACY_TASK: define to revert to original Verilog-95 behavior (std_ovl_task_legacy.h).

`ifdef OVL_LEGACY_TASK
  `include "std_ovl_task_legacy.h"
`else

`ifdef OVL_SYNTHESIS
`else
  integer error_count;
  integer cover_count;
  initial error_count = 0;
  initial cover_count = 0;
`endif // OVL_SYNTHESIS


  task automatic ovl_error_t;
    input [0:0] xcheck;
    input string err_msg;
    bit do_report;
  begin
  `ifdef OVL_SYNTHESIS
  `else
    // Determine whether this call should produce output, based on
    // property_type and (for 2-state-only types) the fire type.
    do_report = 1'b0;
    case (property_type)
      `OVL_ASSERT,
      `OVL_ASSUME        : do_report = 1'b1;
      `OVL_ASSERT_2STATE,
      `OVL_ASSUME_2STATE : do_report = (xcheck == `OVL_FIRE_2STATE);
      `OVL_IGNORE        : do_report = 1'b0;
      default            : begin
        $error("OVL_ERROR: Illegal property_type : %s : %s : %s",
               assert_name, msg, err_msg);
      end
    endcase

    `ifdef OVL_MAX_REPORT_ERROR
      if (do_report && (error_count >= `OVL_MAX_REPORT_ERROR)) begin
        do_report = 1'b0;
      end
    `endif // OVL_MAX_REPORT_ERROR

    if (do_report) begin
      error_count = error_count + 1;

  `ifdef OVL_UVM
      case (severity_level)
        `OVL_FATAL   : `uvm_fatal(  assert_name, $sformatf("%0s : %0s", msg, err_msg))
        `OVL_ERROR   : `uvm_error(  assert_name, $sformatf("%0s : %0s", msg, err_msg))
        `OVL_WARNING : `uvm_warning(assert_name, $sformatf("%0s : %0s", msg, err_msg))
        `OVL_INFO    : `uvm_info(   assert_name, $sformatf("%0s : %0s", msg, err_msg), UVM_MEDIUM)
        default      : `uvm_error(  assert_name, $sformatf("%0s : %0s (illegal severity_level)", msg, err_msg))
      endcase
  `else
      case (severity_level)
        `OVL_FATAL : begin
          `ifdef OVL_FINISH_OFF
            $error(  "OVL_FATAL   : %s : %s : %s", assert_name, msg, err_msg);
          `else
            $fatal(0,"OVL_FATAL   : %s : %s : %s", assert_name, msg, err_msg);
          `endif // OVL_FINISH_OFF
        end
        `OVL_ERROR   : $error(  "OVL_ERROR   : %s : %s : %s", assert_name, msg, err_msg);
        `OVL_WARNING : $warning("OVL_WARNING : %s : %s : %s", assert_name, msg, err_msg);
        `OVL_INFO    : $info(   "OVL_INFO    : %s : %s : %s", assert_name, msg, err_msg);
        default      : $error(  "OVL_ERROR   : %s : %s : %s (illegal severity_level)",
                                assert_name, msg, err_msg);
      endcase
  `endif // OVL_UVM
    end
  `endif // OVL_SYNTHESIS
  end
  endtask : ovl_error_t


  task automatic ovl_finish_t;
  begin
    // Simulation stop for OVL_FATAL is handled by $fatal inside ovl_error_t.
    // This task is a no-op retained for backward compatibility only.
    // For OVL_FINISH_OFF behavior, see the ifdef OVL_FINISH_OFF guard in ovl_error_t.
  end
  endtask : ovl_finish_t


  task automatic ovl_init_msg_t;
  begin
  `ifdef OVL_SYNTHESIS
  `else
    case (property_type)
      `OVL_ASSERT,
      `OVL_ASSUME,
      `OVL_ASSERT_2STATE,
      `OVL_ASSUME_2STATE : begin
        `ifdef OVL_INIT_COUNT
          #0.1 `OVL_INIT_COUNT = `OVL_INIT_COUNT + 1;
        `else
          $info("OVL_NOTE: %s: %s initialized @ %m Severity: %0d, Message: %s",
                `OVL_VERSION, assert_name, severity_level, msg);
        `endif // OVL_INIT_COUNT
      end
      `OVL_IGNORE : begin
      end
      default : begin
        $error("OVL_ERROR: Illegal property_type parameter : %m");
      end
    endcase
  `endif // OVL_SYNTHESIS
  end
  endtask : ovl_init_msg_t


  task automatic ovl_cover_t;
    input [8*128-1:0] cvr_msg;
  begin
  `ifdef OVL_SYNTHESIS
  `else
    cover_count = cover_count + 1;
    `ifdef OVL_MAX_REPORT_COVER_POINT
      if (cover_count <= `OVL_MAX_REPORT_COVER_POINT) begin
    `endif // OVL_MAX_REPORT_COVER_POINT
        if (coverage_level > `OVL_COVER_ALL) begin
          $error("OVL_ERROR: Illegal coverage_level parameter : time %0t : %m", $time);
        end
        else begin
          $info("OVL_COVER_POINT : %s : %0s : time %0t : %m", assert_name, cvr_msg, $time);
        end
    `ifdef OVL_MAX_REPORT_COVER_POINT
      end
    `endif // OVL_MAX_REPORT_COVER_POINT
  `endif // OVL_SYNTHESIS
  end
  endtask : ovl_cover_t


`ifdef OVL_SVA
  function integer log2;
    input integer x;
    integer i;
    integer result;
  begin
    result = 1;
    if (x <= 0) begin
      result = -1;
    end
    else begin
      for (i = 0; (1<<i) <= x; i=i+1) begin
        result = i+1;
      end
    end
    log2 = result;
  end
  endfunction : log2
`endif // OVL_SVA


  function ovl_fire_2state_f;
    input   property_type;
    integer property_type;
  begin
    case (property_type)
      `OVL_ASSERT,
      `OVL_ASSUME        : ovl_fire_2state_f = 1'b1;
      `OVL_ASSERT_2STATE,
      `OVL_ASSUME_2STATE : ovl_fire_2state_f = 1'b1;
      `OVL_IGNORE        : ovl_fire_2state_f = 1'b0;
      default            : ovl_fire_2state_f = 1'b0;
    endcase
  end
  endfunction : ovl_fire_2state_f


  function ovl_fire_xcheck_f;
    input   property_type;
    integer property_type;
  begin
  `ifdef OVL_SYNTHESIS
    // fire_xcheck is not synthesizable
    ovl_fire_xcheck_f = 1'b0;
  `else
    case (property_type)
      `OVL_ASSERT,
      `OVL_ASSUME        : ovl_fire_xcheck_f = 1'b1;
      `OVL_ASSERT_2STATE,
      `OVL_ASSUME_2STATE : ovl_fire_xcheck_f = 1'b0;
      `OVL_IGNORE        : ovl_fire_xcheck_f = 1'b0;
      default            : ovl_fire_xcheck_f = 1'b0;
    endcase
  `endif // OVL_SYNTHESIS
  end
  endfunction : ovl_fire_xcheck_f


  function ovl_fire_cover_f;
    input   coverage_level;
    integer coverage_level;
  begin
    ovl_fire_cover_f = 1'b0;
    case (coverage_level)
      `OVL_COVER_SANITY,
      `OVL_COVER_BASIC,
      `OVL_COVER_CORNER,
      `OVL_COVER_STATISTIC,
      `OVL_COVER_ALL     : ovl_fire_cover_f = 1'b1;
      `OVL_COVER_NONE    : ovl_fire_cover_f = 1'b0;
      default            : ovl_fire_cover_f = 1'b0;
    endcase
  end
  endfunction : ovl_fire_cover_f


`endif // OVL_LEGACY_TASK
