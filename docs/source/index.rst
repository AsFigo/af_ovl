af_ovl — OVL Checkers for Open-Source Simulators
================================================

**af_ovl** brings the Accellera Open Verification Library (OVL) 2.8.1 checkers
to open-source simulators, starting with Icarus Verilog. It is developed by
`AsFigo Technologies <https://asfigo.com>`_.

All 55 checkers elaborate on Icarus Verilog 14.0 (development build). AsFigo
adds plain-Verilog logic for checkers that upstream OVL only implemented in
SVA, and a pass/fail test suite in ``af_tests/``.

.. note::

   af_ovl is not affiliated with or endorsed by Accellera.

Compiling a checker
-------------------

.. code-block:: bash

   iverilog -g2012 -DOVL_VERILOG -DOVL_ASSERT_ON \
            -I std_ovl -I af_ovl \
            std_ovl/ovl_bits.v my_tb.sv -o sim.vvp
   vvp sim.vvp

Running a checker's tests
-------------------------

Each checker under ``af_tests/`` has a ``Makefile`` with a pass and a fail
testbench. The pass test must produce no checker errors; the fail test must
produce the expected errors.

.. code-block:: bash

   cd af_tests/ovl_bits
   make check

Repository layout
-----------------

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Directory
     - Contents
   * - ``std_ovl/``
     - Upstream OVL 2.8.1 checker wrappers and headers (some modified).
   * - ``std_ovl/vlog95/``
     - Upstream plain-Verilog checker logic.
   * - ``std_ovl/sva05/``
     - Upstream SVA checker logic (``-DOVL_SVA``).
   * - ``af_ovl/sv2012/``
     - AsFigo plain-Verilog logic for checkers that had only SVA logic upstream.
   * - ``af_tests/``
     - AsFigo pass/fail testbenches, one directory per checker.

----

.. toctree::
   :maxdepth: 2
   :caption: Reference

   common_params
   enhanced
   checkers
