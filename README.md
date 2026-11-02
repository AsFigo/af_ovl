# af_ovl

A community continuation of the Open Verification Library (OVL) assertion
checkers, brought up to date for open-source simulators such as
[Icarus Verilog](https://steveicarus.github.io/iverilog/) and
[Verilator](https://www.veripool.org/verilator/), with the goal of enabling
assertion-based verification (ABV) with open-source simulation and formal tools.

## Lineage and credit

af_ovl is derived from the **Accellera Standard Open Verification Library
(OVL), Version 2.8.1**, created and maintained by the Accellera OVL working
group and released by Accellera Systems Initiative. We are grateful to the
many contributors named in the original OVL documentation.

- Original release: Accellera OVL 2.8.1 (https://accellera.org/downloads/standards/ovl)
- Original license: Apache License, Version 2.0 (see `LICENSE` and `NOTICE`)
- Original copyright notices are preserved in every source file.

**af_ovl is not an official Accellera release and is not affiliated with or
endorsed by Accellera.** The version numbers here are our own and do not
imply succession to the Accellera standard. The OVL working group is currently
listed as inactive by Accellera, and we welcome any guidance on how to best
coordinate with it.

## What is different from OVL 2.8.1

- Compatibility fixes so checkers compile and simulate with open-source tools.
- New checkers and related IP are planned. New checkers will use their own
  prefix so they cannot be confused with the Accellera set.
- Existing `ovl_*` module names, ports and parameters are kept unchanged so
  existing testbenches keep working.

Every modified file carries a "Modified by AsFigo" note in its header;
compare against the Accellera OVL 2.8.1 download to see the exact changes.

Current status: all 55 `ovl_*` checkers elaborate on Icarus Verilog 14.0 (devel);
7 have pass/fail tests (`always`, `never`, `range`, `bits`, `mutex`,
`code_distance`, `coverage`). Verilator is not yet tested.

## Quick start

```
# Icarus Verilog
iverilog -g2012 -DOVL_VERILOG -DOVL_ASSERT_ON -I<path>/std_ovl -I<path>/af_ovl \
  <path>/std_ovl/ovl_<name>.v my_tb.sv
vvp a.out
```

See `af_tests/ovl_*/` for working pass/fail examples with Makefiles.

## Documentation

The original Accellera OVL Library Reference Manual is Accellera's document
and is not redistributed in this repository. Please obtain it from Accellera.

Documentation for af_ovl is at https://asfigo.github.io/af_ovl/ (sources in docs/) and is written by
AsFigo.

## Contributing

Contributions are welcome under the Apache License 2.0. Please sign off your
commits (`git commit -s`, Developer Certificate of Origin) and mark any
modified upstream file in its header.

## License

Licensed under the Apache License, Version 2.0. See `LICENSE` and `NOTICE`.
Unless required by applicable law or agreed to in writing, software is
distributed on an "AS IS" BASIS, without warranties or conditions of any kind.
