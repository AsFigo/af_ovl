Shared Parameters and Ports
===========================

Every OVL checker takes the parameters and ports on this page, in addition to
its own (see :doc:`checkers`). Defaults come from ``std_ovl/std_ovl_defines.h``
and can be changed globally by defining the matching ``OVL_*_DEFAULT`` macro
before compiling.

Shared parameters
-----------------

.. list-table::
   :header-rows: 1
   :widths: 20 25 55

   * - Name
     - Default
     - Meaning
   * - ``severity_level``
     - ``OVL_ERROR`` (1)
     - How a violation is reported: ``OVL_FATAL`` (0), ``OVL_ERROR`` (1),
       ``OVL_WARNING`` (2), ``OVL_INFO`` (3).
   * - ``property_type``
     - ``OVL_ASSERT`` (0)
     - ``OVL_ASSERT`` (0) and ``OVL_ASSUME`` (1) report rule and X/Z
       violations. ``OVL_ASSERT_2STATE`` (3) and ``OVL_ASSUME_2STATE`` (4)
       report rule violations only, not X/Z. ``OVL_IGNORE`` (2) reports
       nothing and never drives ``fire``.
   * - ``msg``
     - ``"VIOLATION"``
     - Text added to every message from this instance. Use it to tell
       instances apart.
   * - ``coverage_level``
     - ``OVL_COVER_BASIC`` (2)
     - Bit mask of coverage to collect: ``OVL_COVER_SANITY`` (1),
       ``OVL_COVER_BASIC`` (2), ``OVL_COVER_CORNER`` (4),
       ``OVL_COVER_STATISTIC`` (8); ``OVL_COVER_ALL`` (15),
       ``OVL_COVER_NONE`` (0).
   * - ``clock_edge``
     - ``OVL_POSEDGE`` (1)
     - Clock edge the checker samples on: ``OVL_POSEDGE`` (1) or
       ``OVL_NEGEDGE`` (2). Not present on ``ovl_memory_async`` and
       ``ovl_memory_sync``, which use ``wen_edge``/``ren_edge`` instead.
   * - ``reset_polarity``
     - ``OVL_ACTIVE_LOW`` (0)
     - Active level of ``reset``: ``OVL_ACTIVE_LOW`` (0) or
       ``OVL_ACTIVE_HIGH`` (1).
   * - ``gating_type``
     - ``OVL_GATE_CLOCK`` (1)
     - What ``enable`` gates: ``OVL_GATE_CLOCK`` (1) gates the clock,
       ``OVL_GATE_RESET`` (2) holds the checker in reset, ``OVL_GATE_NONE``
       (0) ignores ``enable``. Define ``OVL_GATING_OFF`` to turn gating off
       for all checkers.

Shared ports
------------

.. list-table::
   :header-rows: 1
   :widths: 20 15 65

   * - Name
     - Direction
     - Meaning
   * - ``clock``
     - input
     - Sampling clock. Not present on the unclocked checkers
       (``ovl_proposition``, ``ovl_never_unknown_async``) or on
       ``ovl_memory_async``/``ovl_memory_sync``.
   * - ``reset``
     - input
     - Checker reset; polarity set by ``reset_polarity``.
   * - ``enable``
     - input
     - Checker enable; effect set by ``gating_type``.
   * - ``fire``
     - output [2:0]
     - Violation flags, one cycle per violation (see below).

The ``fire`` output
-------------------

.. list-table::
   :header-rows: 1
   :widths: 15 25 60

   * - Bit
     - Name
     - Set when
   * - ``fire[0]`` (``OVL_FIRE_2STATE``)
     - ``fire_2state``
     - The checker's rule is violated.
   * - ``fire[1]`` (``OVL_FIRE_XCHECK``)
     - ``fire_xcheck``
     - A checked input has X or Z (``OVL_ASSERT`` and ``OVL_ASSUME`` only).
   * - ``fire[2]`` (``OVL_FIRE_COVER``)
     - ``fire_cover``
     - A coverage point is hit. Not implemented in the AsFigo
       ``sv2012/`` logic: always 0.

``fire`` is driven only with ``-DOVL_VERILOG``. With ``-DOVL_SVA`` the
upstream wrappers tie it to 0 and report through SVA action blocks only.
Checkers with no plain-Verilog logic yet tie ``fire`` to 0 with ``-DOVL_VERILOG``.

Compile-time macros
-------------------

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Macro
     - Effect
   * - ``OVL_VERILOG`` / ``OVL_SVA``
     - Select plain-Verilog or SVA checker logic.
   * - ``OVL_ASSERT_ON``
     - Turn on the assertion checks. Without it the checkers do nothing.
   * - ``OVL_COVER_ON``
     - Turn on coverage collection.
   * - ``OVL_XCHECK_OFF``
     - Turn off all X/Z checks.
   * - ``OVL_IMPLICIT_XCHECK_OFF``
     - Turn off the implicit X/Z checks that each checker adds on its inputs.
   * - ``OVL_MAX_REPORT_ERROR``
     - Stop reporting after this many errors per instance.
   * - ``OVL_FINISH_OFF``
     - Report ``OVL_FATAL`` with ``$error`` instead of ending the simulation.
   * - ``OVL_UVM``
     - Report through ``uvm_fatal``/``uvm_error``/``uvm_warning``/``uvm_info``
       instead of ``$fatal``/``$error``/``$warning``/``$info``.
   * - ``OVL_LEGACY_TASK``
     - Use the original upstream reporting task
       (``std_ovl_task_legacy.h``).

Message format
--------------

Without ``OVL_UVM``, a violation prints:

.. code-block:: text

   OVL_ERROR   : <assert_name> : <msg> : <error message>

where ``<assert_name>`` is the checker name in capitals (for example
``OVL_BITS``) and ``<msg>`` is the instance's ``msg`` parameter. The simulator
adds the file, line, time and scope.

.. _not_implemented_warning:

Warnings: ``af_ovl_warn_t``
---------------------------

AsFigo warnings go through ``af_ovl_warn_t`` (``af_ovl/af_std_ovl_task.h``). It is
separate from ``std_ovl_task.h``, so it works with or without ``OVL_LEGACY_TASK``.
Without ``OVL_UVM`` it prints, with ``$warning``:

.. code-block:: text

   OVL_WARNING : <assert_name> : <msg> : <scope> : <warning text>

The ``<msg>`` field is left out when ``msg`` is still the default
(``OVL_MSG_DEFAULT``, ``"VIOLATION"``), since "VIOLATION" reads wrongly on a warning.

With ``OVL_UVM`` it calls ``uvm_warning`` with ``<assert_name>`` as the ID.
It is always a warning: it ignores ``severity_level``, does not add to the error
count, and is not limited by ``OVL_MAX_REPORT_ERROR``. Nothing is printed with
``OVL_SYNTHESIS``.

Its current use: each instance of a checker with no plain-Verilog logic yet warns
once at time 0, unless neither ``OVL_ASSERT_ON`` nor ``OVL_COVER_ON`` is defined or
``property_type`` is ``OVL_IGNORE``:

.. code-block:: text

   OVL_WARNING : OVL_FIFO : tb.u_fifo.af_ovl_warn_t : No OVL_VERILOG logic; checker never fires.
       To request support, open an issue at https://github.com/AsFigo/af_ovl/issues naming this checker
