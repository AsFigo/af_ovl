// Copyright (c) 2026 AsFigo (https://www.asfigo.com)
// Authors: Ajeetha Kumari Venkatesan, Srinivasan Venkataramanan
// SPDX-License-Identifier: Apache-2.0
//
// Included under `ifdef OVL_VERILOG by checker wrappers that have no
// plain-Verilog logic yet. When a checker is implemented, replace its
// include of this file with its own ./sv2012/af_ovl_<name>_logic.v.
// To list the checkers still missing:  grep -l af_ovl_not_implemented std_ovl/*.v
//
// - Warns once per instance at time 0, unless OVL_SYNTHESIS is defined,
//   neither OVL_ASSERT_ON nor OVL_COVER_ON is defined, or
//   property_type is OVL_IGNORE.
// - Ties fire low unconditionally (it would otherwise float as Z).

  `include "af_std_ovl_task.h"

`ifdef OVL_SYNTHESIS
`else
  `ifdef OVL_ASSERT_ON
    initial if (property_type != `OVL_IGNORE)
      af_ovl_warn_t({"No OVL_VERILOG logic; checker never fires.\n",
                     "    To request support, open an issue at https://github.com/AsFigo/af_ovl/issues naming this checker"});
  `else
    `ifdef OVL_COVER_ON
      initial if (property_type != `OVL_IGNORE)
        af_ovl_warn_t({"No OVL_VERILOG logic; checker never fires.\n",
                       "    To request support, open an issue at https://github.com/AsFigo/af_ovl/issues naming this checker"});
    `endif // OVL_COVER_ON
  `endif // OVL_ASSERT_ON
`endif // OVL_SYNTHESIS

  assign fire = {`OVL_FIRE_WIDTH{1'b0}};
