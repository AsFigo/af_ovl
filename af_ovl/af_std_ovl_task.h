// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
//
// AsFigo reporting tasks for af_ovl. Independent of std_ovl_task.h and
// std_ovl_task_legacy.h, so it works with or without OVL_LEGACY_TASK.
//
// Usage: `include "af_std_ovl_task.h" inside a checker module, after the
// assert_name and msg parameters are declared. Resolved via -I af_ovl.
//
// Include exactly ONCE per module. There is deliberately no include guard:
// tasks are module-scoped, so every module needs its own copy, and a global
// `define guard would suppress the include in every module after the first.
//
// Requires SystemVerilog (-g2012): uses string and $warning.

  // af_ovl_warn_t: always a warning.
  //   - ignores severity_level (an OVL_FATAL checker must not stop here)
  //   - does not touch error_count; not limited by OVL_MAX_REPORT_ERROR
  //   - property_type / OVL_ASSERT_ON / OVL_COVER_ON checks are the caller's job
  // Format: OVL_WARNING : <assert_name> : <msg> : <scope> : <warn_msg>
  //   The <msg> field is omitted when msg is still `OVL_MSG_DEFAULT ("VIOLATION"),
  //   which reads wrongly on a warning; a user-set msg is kept.
  task automatic af_ovl_warn_t;
    input string warn_msg;
  begin
  `ifdef OVL_SYNTHESIS
  `else
    `ifdef OVL_UVM
      if (msg == `OVL_MSG_DEFAULT)
        `uvm_warning(assert_name, $sformatf("%m : %0s", warn_msg))
      else
        `uvm_warning(assert_name, $sformatf("%0s : %m : %0s", msg, warn_msg))
    `else
      if (msg == `OVL_MSG_DEFAULT)
        $warning("OVL_WARNING : %s : %m : %s", assert_name, warn_msg);
      else
        $warning("OVL_WARNING : %s : %s : %m : %s", assert_name, msg, warn_msg);
    `endif // OVL_UVM
  `endif // OVL_SYNTHESIS
  end
  endtask : af_ovl_warn_t
