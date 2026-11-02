AsFigo-Enhanced Checkers
========================

Upstream OVL 2.8.1 implements four of its checkers only in SVA:
``ovl_bits``, ``ovl_mutex``, ``ovl_code_distance`` and ``ovl_coverage``. On a
simulator without SVA support, such as Icarus Verilog, they elaborate but
never report anything.

AsFigo wrote plain-Verilog logic for each of them in ``af_ovl/sv2012/``
(named after the Icarus ``-g2012`` flag). The upstream wrappers in
``std_ovl/`` are kept, and with ``-DOVL_VERILOG`` they include the AsFigo
logic instead of the SVA logic.

Each implementation was cross-checked against the upstream SVA logic in
``std_ovl/sva05/``: same fire conditions, same parameters and ports, and the
same error messages except where noted. Each has a pass and a fail testbench
in ``af_tests/``.

What is common to all four
--------------------------

- **Sampling**: the checker evaluates its inputs at the active clock edge
  (``clock_edge``) and registers the result, so ``fire`` goes high just
  after the violating edge and stays high until the next edge.
- **Reset**: while reset is active (``reset_polarity``), nothing is checked
  and ``fire`` is held at 0.
- **Rule violation**: reported with ``ovl_error_t`` at ``severity_level`` and
  flagged on ``fire_2state``.
- **X/Z check**: on by default. Reports ``"<port> contains X or Z"`` and
  flags ``fire_xcheck``. Turned off by ``OVL_XCHECK_OFF``,
  ``OVL_IMPLICIT_XCHECK_OFF``, or a ``*_2STATE`` ``property_type``.
- **Coverage**: not implemented. ``fire_cover`` is always 0, whatever
  ``coverage_level`` is set to.
- **Assumptions**: with ``OVL_ASSUME`` or ``OVL_ASSUME_2STATE``, the logic
  checks and reports exactly as for an assertion. Upstream SVA turns these
  into ``assume property`` for formal tools.

.. warning::

   **Known issue: fire bit order.** The four AsFigo wrappers assign
   ``fire = {fire_2state, fire_xcheck, fire_cover}``, which puts the rule
   violation on ``fire[2]``. The upstream wrappers (for example
   ``ovl_always``) use ``{fire_cover, fire_xcheck, fire_2state}``, matching
   ``OVL_FIRE_2STATE`` = 0. Until this is fixed, read the rule violation of
   these four checkers from ``fire[2]`` and coverage from ``fire[0]``.

----

.. _enh_ovl_bits:

ovl_bits
--------

Counts the bits of ``test_expr`` that are asserted (or deasserted, with
``asserted = 0``) and checks the count stays within ``[min, max]``.

**Parameters**

.. list-table::
   :header-rows: 1
   :widths: 20 15 65

   * - Name
     - Default
     - Meaning
   * - ``width``
     - 1
     - Width of ``test_expr``.
   * - ``min``
     - 1
     - Lowest allowed count. 0 turns off the lower-bound check.
   * - ``max``
     - 1
     - Highest allowed count. 0 turns off the upper-bound check.
   * - ``asserted``
     - 1
     - 1: count the 1 bits. 0: count the 0 bits.

**Ports**: ``clock``, ``reset``, ``enable``, ``test_expr [width-1:0]``,
``fire [2:0]``.

**Fire conditions**

.. code-block:: verilog

   bit_vector = (asserted == 1) ? test_expr : ~test_expr;
   fire_min   = (min != 0) && ($countones(bit_vector) < min);
   fire_max   = (max != 0) && ($countones(bit_vector) > max);

The two bounds are checked separately and report separate messages, as in
the two upstream SVA properties. At time 0, the wrapper reports
``"Illegal parameter values set where min > max"`` if ``max > 0`` and
``min > max``.

**Messages**

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Condition
     - Message
   * - ``fire_min``, ``asserted = 1``
     - ``Fewer than min bits were asserted``
   * - ``fire_min``, ``asserted = 0``
     - ``Fewer than min bits were deasserted``
   * - ``fire_max``, ``asserted = 1``
     - ``More than max bits were asserted``
   * - ``fire_max``, ``asserted = 0``
     - ``More than max bits were deasserted``
   * - X or Z on ``test_expr``
     - ``test_expr contains X or Z``

Upstream SVA puts ``min`` and ``max`` in quotes (a backtick before, an
apostrophe after). The AsFigo messages drop the quotes.

**Tests** (``af_tests/ovl_bits/``, ``width = 4``, ``min = 1``, ``max = 3``,
``asserted = 1``)

- *Pass*: ``test_expr`` steps through counts 1, 1, 2, 3, 2. No fire.
- *Fail*: ``4'b0000`` (count 0, below ``min``) and ``4'b1111`` (count 4,
  above ``max``). Fires once for each.

----

.. _enh_ovl_mutex:

ovl_mutex
---------

Checks that at most one bit of ``test_expr`` is asserted (or deasserted,
with ``invert_mode = 1``). All bits inactive is allowed. Use
:ref:`ovl_one_hot` when exactly one bit must be active.

**Parameters**

.. list-table::
   :header-rows: 1
   :widths: 20 15 65

   * - Name
     - Default
     - Meaning
   * - ``width``
     - 2
     - Width of ``test_expr``.
   * - ``invert_mode``
     - 0
     - 0: at most one bit may be 1. 1: at most one bit may be 0.

**Ports**: ``clock``, ``reset``, ``enable``, ``test_expr [width-1:0]``,
``fire [2:0]``.

**Fire condition**

.. code-block:: verilog

   bit_vector    = (invert_mode == 0) ? test_expr : ~test_expr;
   fire_2state_1 = ($countones(bit_vector) > 1);

**Messages**

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Condition
     - Message
   * - More than one bit active
     - ``Expression's bits are not mutually exclusive``
   * - X or Z on ``test_expr``
     - ``test_expr contains X or Z``

**Tests** (``af_tests/ovl_mutex/``, ``width = 4``, ``invert_mode = 0``)

- *Pass*: ``test_expr`` walks one bit from bit 0 to bit 3, then goes to all
  zeros. No fire.
- *Fail*: ``4'b0011`` and ``4'b0110`` (two bits set). Fires once for each.

----

.. _enh_ovl_code_distance:

ovl_code_distance
-----------------

Checks the Hamming distance between ``test_expr1`` and ``test_expr2`` (the
number of bit positions where they differ) whenever ``test_expr1`` changes.
A typical use is checking an encoded value against its source, such as an
ECC word or a Gray-coded counter.

**Parameters**

.. list-table::
   :header-rows: 1
   :widths: 20 15 65

   * - Name
     - Default
     - Meaning
   * - ``width``
     - 1
     - Width of ``test_expr1`` and ``test_expr2``.
   * - ``min``
     - 1
     - Lowest allowed distance.
   * - ``max``
     - 1
     - Highest allowed distance.

**Ports**: ``clock``, ``reset``, ``enable``, ``test_expr1 [width-1:0]``,
``test_expr2 [width-1:0]``, ``fire [2:0]``.

**When the check runs**

The distance is checked only at a clock edge where ``test_expr1`` has a
different value from the previous edge, and at the first active edge after
reset. A change on ``test_expr2`` alone does not trigger a check. This
matches the upstream SVA antecedent
``(!$stable(test_expr1) || sva_checker_time_0)``: AsFigo keeps the previous
value of ``test_expr1`` in a register in place of ``$stable``, and keeps
the same ``sva_checker_time_0`` flag.

**Fire condition**

.. code-block:: verilog

   check_enable  = (test_expr1 !== test_expr1_q) || sva_checker_time_0;
   hd            = $countones(test_expr1 ^ test_expr2);
   fire_2state_1 = check_enable && (hd < min || hd > max);

Unlike ``ovl_bits``, ``min`` and ``max`` of 0 do not turn a bound off, and
the wrapper does not check ``min > max``.

**Messages**

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Condition
     - Message
   * - Distance outside ``[min, max]``
     - ``Code distance is not within specified limits``
   * - X or Z on ``test_expr1``
     - ``test_expr1 contains X or Z``
   * - X or Z on ``test_expr2``
     - ``test_expr2 contains X or Z``

The two X/Z checks report separately but share the one ``fire_xcheck`` bit.
Upstream SVA words the first message ``Code distance was not within
specified limits``.

**Tests** (``af_tests/ovl_code_distance/``, ``width = 4``, ``min = 2``,
``max = 3``; inputs are driven at the falling edge)

- *Pass*: first check after reset has distance 2. ``test_expr1`` changes
  twice, giving distances 3 and 2. Then only ``test_expr2`` changes, which
  must not trigger a check. No fire.
- *Fail*: ``test_expr1`` changes to ``4'b0010`` (distance 1, below ``min``),
  and later to ``4'b1001`` (distance 4, above ``max``). Fires once for each.

----

.. _enh_ovl_coverage:

ovl_coverage
------------

A coverage point: reports each clock edge at which ``test_expr`` is 1. It
flags that a condition happened, not that the design is wrong.

.. note::

   A hit is reported with ``ovl_error_t`` at ``severity_level``, so with the
   default ``OVL_ERROR`` every hit prints as an error. Set
   ``severity_level`` to ``OVL_INFO`` to log hits as information.

**Parameters**: shared parameters only (see :doc:`common_params`).

**Ports**: ``clock``, ``reset``, ``enable``, ``test_expr`` (1 bit),
``fire [2:0]``.

**Fire condition**

.. code-block:: verilog

   fire_2state_1 = (enable === 1'b1) && !$isunknown(test_expr)
                   && (test_expr == 1'b1);

The explicit ``enable`` term matches upstream SVA (``covered_fire_combo``).
It applies on top of ``gating_type``, so with ``OVL_GATE_NONE`` the checker
still only reports while ``enable`` is 1.

**Messages**

.. list-table::
   :header-rows: 1
   :widths: 45 55

   * - Condition
     - Message
   * - ``test_expr`` is 1 while enabled
     - ``The HDL statement was covered``
   * - X or Z on ``test_expr``
     - ``test_expr contains X or Z``

Upstream SVA also keeps a saturating 32-bit count of hits
(``covered_count``). The AsFigo logic does not.

**Tests** (``af_tests/ovl_coverage/``)

- *Pass*: ``test_expr`` stays 0. No hit is reported.
- *Fail*: ``test_expr`` goes to 1 for 3 cycles after reset. A hit is
  reported on each of those cycles.
