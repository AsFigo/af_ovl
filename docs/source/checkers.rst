.. This file is generated from std_ovl/ovl_*.v. Regenerate rather than hand-edit the tables.

Checker Reference
=================

All 55 OVL 2.8.1 checkers, A–Z. Every checker also takes the shared parameters in
:doc:`common_params` and drives the 3-bit ``fire`` output described there.
Only the parameters specific to each checker are listed here.

Defaults named ``OVL_*`` are Verilog macros from ``std_ovl/std_ovl_defines.h``
(used with a leading backtick in Verilog); the value they resolve to is shown after the arrow.

**Status key**: whether the checker has plain-Verilog logic that runs on Icarus
(``-DOVL_VERILOG``), and whether AsFigo has pass/fail tests for it in ``af_tests/``.

----

.. _ovl_always:

ovl_always
----------

``test_expr`` must be true at every active clock edge.

**Status**: Upstream Verilog logic, pass/fail tested

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_always_on_edge:

ovl_always_on_edge
------------------

``test_expr`` must be true whenever ``sampling_event`` shows the edge selected by ``edge_type``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``edge_type``
     - ``OVL_NOEDGE`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``sampling_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_arbiter:

ovl_arbiter
-----------

Grants on ``gnts`` must follow requests on ``reqs`` under the selected arbitration rule, priority and latency limits.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``2``
   * - ``priority_width``
     - ``1``
   * - ``min_cks``
     - ``1``
   * - ``max_cks``
     - ``0``
   * - ``one_cycle_gnt_check``
     - ``1``
   * - ``priority_check``
     - ``0``
   * - ``arbitration_rule``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``reqs``
     - input
     - ``[width-1:0]``
   * - ``priorities``
     - input
     - ``[(width*priority_width)-1:0]``
   * - ``gnts``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_bits:

ovl_bits
--------

The number of asserted (or deasserted) bits in ``test_expr`` must stay within ``[min, max]``.

**Status**: AsFigo Icarus logic, pass/fail tested (see :doc:`enhanced`)

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min``
     - ``1``
   * - ``max``
     - ``1``
   * - ``width``
     - ``1``
   * - ``asserted``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_change:

ovl_change
----------

After ``start_event``, ``test_expr`` must change within ``num_cks`` cycles.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``num_cks``
     - ``1``
   * - ``action_on_new_start``
     - ``OVL_ACTION_ON_NEW_START_DEFAULT`` → ``OVL_IGNORE_NEW_START`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_code_distance:

ovl_code_distance
-----------------

When ``test_expr1`` changes, its Hamming distance to ``test_expr2`` must be within ``[min, max]``.

**Status**: AsFigo Icarus logic, pass/fail tested (see :doc:`enhanced`)

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min``
     - ``1``
   * - ``max``
     - ``1``
   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr1``
     - input
     - ``[width-1:0]``
   * - ``test_expr2``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_coverage:

ovl_coverage
------------

Reports when ``test_expr`` is true. This is a coverage point, not a design rule.

**Status**: AsFigo Icarus logic, pass/fail tested (see :doc:`enhanced`)

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_crc:

ovl_crc
-------

The checker computes a CRC over ``test_expr`` while ``valid`` is high, restarting on ``initialize``. When ``compare`` is asserted, the value on ``crc`` must match.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``data_width``
     - ``0``
   * - ``crc_width``
     - ``5``
   * - ``crc_enable``
     - ``0``
   * - ``crc_latch_enable``
     - ``0``
   * - ``polynomial``
     - ``5``
   * - ``standard_polynomial``
     - ``0``
   * - ``initial_value``
     - ``0``
   * - ``lsb_first``
     - ``0``
   * - ``big_endian``
     - ``0``
   * - ``reverse_endian``
     - ``0``
   * - ``invert``
     - ``0``
   * - ``combinational``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``initialize``
     - input
     - 1
   * - ``valid``
     - input
     - 1
   * - ``compare``
     - input
     - 1
   * - ``crc``
     - input
     - ``[crc_width-1:0]``
   * - ``crc_latch``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_cycle_sequence:

ovl_cycle_sequence
------------------

The bits of ``event_sequence`` must occur on consecutive cycles. ``necessary_condition`` sets what starts the check: the first bit, or all bits except the last (the default).

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``num_cks``
     - ``2``
   * - ``necessary_condition``
     - ``OVL_NECESSARY_CONDITION_DEFAULT`` → ``OVL_TRIGGER_ON_MOST_PIPE`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``event_sequence``
     - input
     - ``[num_cks-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_decrement:

ovl_decrement
-------------

When ``test_expr`` changes, it must decrease by exactly ``value``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``value``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_delta:

ovl_delta
---------

When ``test_expr`` changes, the size of the change must be within ``[min, max]``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``min``
     - ``1``
   * - ``max``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_even_parity:

ovl_even_parity
---------------

``test_expr`` must have an even number of 1 bits.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_fifo:

ovl_fifo
--------

FIFO enqueue/dequeue rules: no overflow or underflow, correct ``full``/``empty`` flags, and optional data checks.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``depth``
     - ``2``
   * - ``width``
     - ``1``
   * - ``high_water_mark``
     - ``0``
   * - ``enq_latency``
     - ``0``
   * - ``deq_latency``
     - ``0``
   * - ``value_check``
     - ``1``
   * - ``pass_thru``
     - ``0``
   * - ``registered``
     - ``0``
   * - ``preload_count``
     - ``0``
   * - ``preload_data_width``
     - ``(preload_count == 0) ? width : (preload_count*width)``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``enq``
     - input
     - 1
   * - ``enq_data``
     - input
     - ``[width-1:0]``
   * - ``deq``
     - input
     - 1
   * - ``deq_data``
     - input
     - ``[width-1:0]``
   * - ``full``
     - input
     - 1
   * - ``empty``
     - input
     - 1
   * - ``preload``
     - input
     - ``[preload_data_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_fifo_index:

ovl_fifo_index
--------------

The FIFO fill level tracked from ``push``/``pop`` must never exceed ``depth`` or drop below zero.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``depth``
     - ``1``
   * - ``push_width``
     - ``1``
   * - ``pop_width``
     - ``1``
   * - ``simultaneous_push_pop``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``push``
     - input
     - ``[push_width-1:0]``
   * - ``pop``
     - input
     - ``[pop_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_frame:

ovl_frame
---------

After ``start_event``, ``test_expr`` must become true no earlier than ``min_cks`` and no later than ``max_cks`` cycles.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_cks``
     - ``0``
   * - ``max_cks``
     - ``0``
   * - ``action_on_new_start``
     - ``OVL_ACTION_ON_NEW_START_DEFAULT`` → ``OVL_IGNORE_NEW_START`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_handshake:

ovl_handshake
-------------

``req``/``ack`` handshake: no ``ack`` without ``req``, no new ``req`` while one is pending, and ``ack`` within ``[min_ack_cycle, max_ack_cycle]``. Optional rules cover ``req`` staying high until ``ack`` (``req_drop``), ``req`` dropping after ``ack`` (``deassert_count``), and maximum ``ack`` length (``max_ack_length``).

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_ack_cycle``
     - ``0``
   * - ``max_ack_cycle``
     - ``0``
   * - ``req_drop``
     - ``0``
   * - ``deassert_count``
     - ``0``
   * - ``max_ack_length``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``req``
     - input
     - 1
   * - ``ack``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_hold_value:

ovl_hold_value
--------------

When ``test_expr`` equals ``value``, it must keep that value for a number of cycles within ``[min, max]``.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min``
     - ``0``
   * - ``max``
     - ``0``
   * - ``width``
     - ``2``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``value``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_implication:

ovl_implication
---------------

Whenever ``antecedent_expr`` is true, ``consequent_expr`` must be true in the same cycle.

**Status**: Upstream Verilog logic, not yet tested

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``antecedent_expr``
     - input
     - 1
   * - ``consequent_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_increment:

ovl_increment
-------------

When ``test_expr`` changes, it must increase by exactly ``value``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``value``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_memory_async:

ovl_memory_async
----------------

Address-range, initialisation and read/write rules for an asynchronous memory.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``data_width``
     - ``1``
   * - ``addr_width``
     - ``1``
   * - ``mem_size``
     - ``2``
   * - ``addr_check``
     - ``1``
   * - ``init_check``
     - ``1``
   * - ``one_read_check``
     - ``0``
   * - ``one_write_check``
     - ``0``
   * - ``value_check``
     - ``0``
   * - ``wen_edge``
     - ``OVL_CLOCK_EDGE_DEFAULT`` → ``OVL_POSEDGE`` (1)
   * - ``ren_edge``
     - ``OVL_CLOCK_EDGE_DEFAULT`` → ``OVL_POSEDGE`` (1)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_addr``
     - input
     - ``[addr_width-1:0]``
   * - ``end_addr``
     - input
     - ``[addr_width-1:0]``
   * - ``ren``
     - input
     - 1
   * - ``raddr``
     - input
     - ``[addr_width-1:0]``
   * - ``rdata``
     - input
     - ``[data_width-1:0]``
   * - ``wen``
     - input
     - 1
   * - ``waddr``
     - input
     - ``[addr_width-1:0]``
   * - ``wdata``
     - input
     - ``[data_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_memory_sync:

ovl_memory_sync
---------------

Address-range, initialisation, conflict and read/write rules for a synchronous memory with separate read and write clocks.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``data_width``
     - ``1``
   * - ``addr_width``
     - ``1``
   * - ``mem_size``
     - ``2``
   * - ``addr_check``
     - ``1``
   * - ``init_check``
     - ``1``
   * - ``conflict_check``
     - ``0``
   * - ``pass_thru``
     - ``0``
   * - ``one_read_check``
     - ``0``
   * - ``one_write_check``
     - ``0``
   * - ``value_check``
     - ``0``
   * - ``wen_edge``
     - ``OVL_CLOCK_EDGE_DEFAULT`` → ``OVL_POSEDGE`` (1)
   * - ``ren_edge``
     - ``OVL_CLOCK_EDGE_DEFAULT`` → ``OVL_POSEDGE`` (1)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_addr``
     - input
     - ``[addr_width-1:0]``
   * - ``end_addr``
     - input
     - ``[addr_width-1:0]``
   * - ``r_clock``
     - input
     - 1
   * - ``ren``
     - input
     - 1
   * - ``raddr``
     - input
     - ``[addr_width-1:0]``
   * - ``rdata``
     - input
     - ``[data_width-1:0]``
   * - ``w_clock``
     - input
     - 1
   * - ``wen``
     - input
     - 1
   * - ``waddr``
     - input
     - ``[addr_width-1:0]``
   * - ``wdata``
     - input
     - ``[data_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_multiport_fifo:

ovl_multiport_fifo
------------------

FIFO rules for a FIFO with several enqueue and dequeue ports.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``depth``
     - ``2``
   * - ``enq_count``
     - ``2``
   * - ``deq_count``
     - ``2``
   * - ``preload_count``
     - ``0``
   * - ``pass_thru``
     - ``0``
   * - ``registered``
     - ``0``
   * - ``high_water_mark``
     - ``0``
   * - ``enq_latency``
     - ``0``
   * - ``deq_latency``
     - ``0``
   * - ``value_check``
     - ``0``
   * - ``full_check``
     - ``0``
   * - ``empty_check``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``enq``
     - input
     - ``[enq_count-1:0]``
   * - ``deq``
     - input
     - ``[deq_count-1:0]``
   * - ``enq_data``
     - input
     - ``[enq_count*width-1:0]``
   * - ``deq_data``
     - input
     - ``[deq_count*width-1:0]``
   * - ``full``
     - input
     - 1
   * - ``empty``
     - input
     - 1
   * - ``preload``
     - input
     - ``[(preload_count?(preload_count*width):1)-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_mutex:

ovl_mutex
---------

At most one bit of ``test_expr`` may be asserted (or deasserted, with ``invert_mode``).

**Status**: AsFigo Icarus logic, pass/fail tested (see :doc:`enhanced`)

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``2``
   * - ``invert_mode``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_never:

ovl_never
---------

``test_expr`` must never be true at an active clock edge.

**Status**: Upstream Verilog logic, pass/fail tested

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_never_unknown:

ovl_never_unknown
-----------------

When ``qualifier`` is true, ``test_expr`` must not contain X or Z.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``qualifier``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_never_unknown_async:

ovl_never_unknown_async
-----------------------

``test_expr`` must never contain X or Z; checked without a clock.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_next:

ovl_next
--------

``num_cks`` cycles after ``start_event``, ``test_expr`` must be true.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``num_cks``
     - ``1``
   * - ``check_overlapping``
     - ``1``
   * - ``check_missing_start``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_next_state:

ovl_next_state
--------------

When ``test_expr`` equals ``curr_state``, it must move to one of the ``next_state`` values, within the hold limits.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``next_count``
     - ``1``
   * - ``width``
     - ``1``
   * - ``min_hold``
     - ``1``
   * - ``max_hold``
     - ``1``
   * - ``disallow``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``curr_state``
     - input
     - ``[width-1:0]``
   * - ``next_state``
     - input
     - ``[next_count*width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_no_contention:

ovl_no_contention
-----------------

Shared bus with ``num_drivers`` drivers: at most one bit of ``driver_enables`` high at a time, no X or Z on ``test_expr`` while a driver is enabled, and between ``min_quiet`` and ``max_quiet`` idle cycles when the bus changes driver.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_quiet``
     - ``0``
   * - ``max_quiet``
     - ``0``
   * - ``num_drivers``
     - ``2``
   * - ``width``
     - ``2``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``driver_enables``
     - input
     - ``[num_drivers-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_no_overflow:

ovl_no_overflow
---------------

A counter on ``test_expr`` must not go past ``max``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``min``
     - ``0``
   * - ``max``
     - ``((1<<width)-1)``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_no_transition:

ovl_no_transition
-----------------

When ``test_expr`` equals ``start_state``, it must not change to ``next_state``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``start_state``
     - input
     - ``[width-1:0]``
   * - ``next_state``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_no_underflow:

ovl_no_underflow
----------------

A counter on ``test_expr`` must not go below ``min``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``min``
     - ``0``
   * - ``max``
     - ``((1<<width)-1)``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_odd_parity:

ovl_odd_parity
--------------

``test_expr`` must have an odd number of 1 bits.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_one_cold:

ovl_one_cold
------------

Exactly one bit of ``test_expr`` must be 0; ``inactive`` sets whether an all-0 or all-1 value is also allowed.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``32``
   * - ``inactive``
     - ``OVL_INACTIVE_DEFAULT`` → ``OVL_ONE_COLD`` (2)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_one_hot:

ovl_one_hot
-----------

Exactly one bit of ``test_expr`` must be 1.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``32``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_proposition:

ovl_proposition
---------------

``test_expr`` must always be true; checked combinationally, without a clock.

**Status**: Upstream Verilog logic, not yet tested

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_quiescent_state:

ovl_quiescent_state
-------------------

When ``sample_event`` occurs, ``state_expr`` must equal ``check_value``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``state_expr``
     - input
     - ``[width-1:0]``
   * - ``check_value``
     - input
     - ``[width-1:0]``
   * - ``sample_event``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_range:

ovl_range
---------

``test_expr`` must be within ``[min, max]``.

**Status**: Upstream Verilog logic, pass/fail tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``min``
     - ``1``
   * - ``max``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_reg_loaded:

ovl_reg_loaded
--------------

After ``start_event``, ``dest_expr`` must be loaded with ``src_expr`` within the window set by ``start_count``/``end_count`` or ``end_event``.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``4``
   * - ``start_count``
     - ``1``
   * - ``end_count``
     - ``10``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``end_event``
     - input
     - 1
   * - ``src_expr``
     - input
     - ``[width-1:0]``
   * - ``dest_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_req_ack_unique:

ovl_req_ack_unique
------------------

Each ``req`` must get exactly one ``ack`` within ``[min_cks, max_cks]`` cycles.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_cks``
     - ``1``
   * - ``max_cks``
     - ``15``
   * - ``method``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``req``
     - input
     - 1
   * - ``ack``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_req_requires:

ovl_req_requires
----------------

A request started by ``req_trigger`` must be followed by ``req_follower``, then the ``resp_leader``/``resp_trigger`` response.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_cks``
     - ``1``
   * - ``max_cks``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``req_trigger``
     - input
     - 1
   * - ``req_follower``
     - input
     - 1
   * - ``resp_leader``
     - input
     - 1
   * - ``resp_trigger``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_stack:

ovl_stack
---------

Stack push/pop rules: no overflow or underflow, correct ``full``/``empty`` flags, latency and data checks.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``depth``
     - ``2``
   * - ``width``
     - ``1``
   * - ``high_water_mark``
     - ``0``
   * - ``push_latency``
     - ``0``
   * - ``pop_latency``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``push``
     - input
     - 1
   * - ``push_data``
     - input
     - ``[width-1:0]``
   * - ``pop``
     - input
     - 1
   * - ``pop_data``
     - input
     - ``[width-1:0]``
   * - ``full``
     - input
     - 1
   * - ``empty``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_time:

ovl_time
--------

After ``start_event``, ``test_expr`` must stay true for ``num_cks`` cycles.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``num_cks``
     - ``1``
   * - ``action_on_new_start``
     - ``OVL_ACTION_ON_NEW_START_DEFAULT`` → ``OVL_IGNORE_NEW_START`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_transition:

ovl_transition
--------------

When ``test_expr`` leaves ``start_state``, it must move to ``next_state``.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``start_state``
     - input
     - ``[width-1:0]``
   * - ``next_state``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_unchange:

ovl_unchange
------------

After ``start_event``, ``test_expr`` must not change for ``num_cks`` cycles.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``num_cks``
     - ``1``
   * - ``action_on_new_start``
     - ``OVL_ACTION_ON_NEW_START_DEFAULT`` → ``OVL_IGNORE_NEW_START`` (0)

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_valid_id:

ovl_valid_id
------------

Each ``returned_id`` must match an outstanding ``issued_id`` and return within ``[min_cks, max_cks]``, with flush and instance-count limits.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_cks``
     - ``1``
   * - ``max_cks``
     - ``1``
   * - ``width``
     - ``2``
   * - ``max_id_instances``
     - ``2``
   * - ``max_ids``
     - ``1``
   * - ``max_instances_per_id``
     - ``1``
   * - ``instance_count_width``
     - ``2``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``issued``
     - input
     - 1
   * - ``issued_id``
     - input
     - ``[width-1:0]``
   * - ``returned``
     - input
     - 1
   * - ``returned_id``
     - input
     - ``[width-1:0]``
   * - ``flush``
     - input
     - 1
   * - ``flush_id``
     - input
     - ``[width-1:0]``
   * - ``issued_count``
     - input
     - ``[instance_count_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_value:

ovl_value
---------

``test_expr`` must match one of the values in ``vals`` (or, with ``disallow``, must not match any of them).

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``num_values``
     - ``1``
   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``vals``
     - input
     - ``[(num_values*width)-1:0]``
   * - ``disallow``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_value_coverage:

ovl_value_coverage
------------------

Coverage of the values ``test_expr`` takes, leaving out the values in ``is_not``.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``
   * - ``is_not_width``
     - ``1``
   * - ``is_not_count``
     - ``0``
   * - ``value_coverage``
     - ``0``
   * - ``total_is_not_width``
     - ``(is_not_width*is_not_count)?(is_not_width*is_not_count):1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``is_not``
     - input
     - ``[total_is_not_width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_width:

ovl_width
---------

When ``test_expr`` goes true, it must stay true for between ``min_cks`` and ``max_cks`` cycles.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``min_cks``
     - ``1``
   * - ``max_cks``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_win_change:

ovl_win_change
--------------

Between ``start_event`` and ``end_event``, ``test_expr`` must change.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``end_event``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_win_unchange:

ovl_win_unchange
----------------

Between ``start_event`` and ``end_event``, ``test_expr`` must not change.

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``1``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``end_event``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_window:

ovl_window
----------

Between ``start_event`` and ``end_event``, ``test_expr`` must stay true.

**Status**: Upstream Verilog logic, not yet tested

**Parameters**: shared parameters only.

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``start_event``
     - input
     - 1
   * - ``test_expr``
     - input
     - 1
   * - ``end_event``
     - input
     - 1
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_xproduct_bit_coverage:

ovl_xproduct_bit_coverage
-------------------------

Cross-product coverage of the bits of ``test_expr1`` and ``test_expr2``.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width1``
     - ``1``
   * - ``width2``
     - ``1``
   * - ``test_expr2_enable``
     - ``0``
   * - ``coverage_check``
     - ``0``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr1``
     - input
     - ``[width1-1:0]``
   * - ``test_expr2``
     - input
     - ``[width2-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_xproduct_value_coverage:

ovl_xproduct_value_coverage
---------------------------

Cross-product coverage of the values of ``test_expr1`` and ``test_expr2``.

**Status**: No plain-Verilog logic yet: elaborates on Icarus but never fires

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width1``
     - ``1``
   * - ``width2``
     - ``1``
   * - ``val1_width``
     - ``1``
   * - ``val2_width``
     - ``1``
   * - ``val1_count``
     - ``0``
   * - ``val2_count``
     - ``0``
   * - ``min1``
     - ``0``
   * - ``min2``
     - ``0``
   * - ``max1``
     - ``0``
   * - ``max2``
     - ``0``
   * - ``coverage_check``
     - ``0``
   * - ``val1_width_internal``
     - ``(val1_count > 0 ? ((val1_width*val1_count)-1) : 0)``
   * - ``val2_width_internal``
     - ``(val2_count > 0 ? ((val2_width*val2_count)-1) : 0)``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr1``
     - input
     - ``[width1-1:0]``
   * - ``test_expr2``
     - input
     - ``[width2-1:0]``
   * - ``val1``
     - input
     - ``[val1_width_internal:0]``
   * - ``val2``
     - input
     - ``[val2_width_internal:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)

----

.. _ovl_zero_one_hot:

ovl_zero_one_hot
----------------

At most one bit of ``test_expr`` may be 1 (all-0 is allowed).

**Status**: Upstream Verilog logic, not yet tested

.. list-table:: Parameters
   :header-rows: 1
   :widths: 30 70

   * - Name
     - Default

   * - ``width``
     - ``32``

.. list-table:: Ports
   :header-rows: 1
   :widths: 30 20 50

   * - Name
     - Direction
     - Width

   * - ``clock``
     - input
     - 1
   * - ``reset``
     - input
     - 1
   * - ``enable``
     - input
     - 1
   * - ``test_expr``
     - input
     - ``[width-1:0]``
   * - ``fire``
     - output
     - ``OVL_FIRE_WIDTH`` (3)
