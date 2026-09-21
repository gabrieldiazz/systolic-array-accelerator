# Systolic Array Accelerator

A configurable systolic-array accelerator for matrix multiplication, designed and verified in SystemVerilog and implemented through an open-source ASIC physical-design flow.

> **WIP:** RTL design, verification, synthesis, physical implementation, and initial timing optimization are complete. Design-space exploration is in progress.

## Overview

This project implements a parameterized systolic array composed of multiply-accumulate (MAC) processing elements. Matrix operands are streamed through the array, with each processing element forwarding data to neighboring PEs while accumulating one element of the output matrix.

The design supports configurable:

- Array dimensions (`SIZE`)
- Operand width (`WIDTH`)
- Accumulator width (`ACC_WIDTH`)
- Signed integer arithmetic

The current physical-design configuration uses a **3×3 array with 8-bit signed operands and 32-bit accumulators**.

## Architecture

Each processing element (PE):

- Receives an `A` operand from the left
- Receives a `B` operand from above
- Forwards `A` to the right
- Forwards `B` downward
- Multiplies the incoming operands
- Accumulates the product into a local accumulator

The MAC datapath is pipelined by registering the multiplication result before accumulation, reducing the amount of combinational arithmetic performed within a single clock cycle.

The top-level systolic array is generated parametrically in SystemVerilog, allowing different array dimensions to be instantiated from the same RTL.

## Verification

RTL verification is automated using a Python reference model.

The verification flow:

1. Generates input matrices
2. Computes the expected matrix product in Python
3. Compiles and simulates the SystemVerilog design with Icarus Verilog
4. Reads the hardware result
5. Compares every output element against the software reference

The current test suite includes directed edge cases and **100 randomized matrix tests**, for a total of **105 passing tests**.

Directed cases include:

- Identity matrices
- Zero matrices
- Negative operands
- INT8 maximum values
- INT8 minimum values

## ASIC Implementation

The accelerator has been synthesized and physically implemented using an open-source ASIC flow targeting the **SkyWater SKY130** process.

The flow includes:

- RTL synthesis with Yosys
- Floorplanning and placement
- Clock-tree synthesis
- Routing
- Static timing analysis
- Physical verification
- GDSII generation

A 3×3 INT8 configuration has been implemented through RTL-to-GDS.

## Timing Optimization

Post-route static timing analysis of the initial 3×3 implementation at a **10 ns clock constraint** identified the multiply-accumulate datapath as a major timing bottleneck.

The original PE performed multiplication and accumulation within the same clock cycle. Introducing an intermediate product register split the operation into separate multiplication and accumulation stages.

At the same 10 ns constraint:

| Metric | Baseline | Pipelined |
| --- | ---: | ---: |
| Worst Negative Slack (WNS) | -4.52 ns | -2.02 ns |
| Total Negative Slack (TNS) | -487.18 ns | -43.33 ns |
| Standard Cells | 8,228 | 8,423 |

Pipelining reduced the magnitude of WNS by approximately **55%** and TNS by approximately **91%**.

A subsequent reset-handling optimization was also evaluated. Although it slightly improved worst-case slack, it increased total negative slack and implementation area, so the simpler pipelined architecture was retained.

> The design does not currently close timing at the 10 ns target. The constraint is used as a consistent reference for architectural comparison.

See [`docs/timing-analysis.md`](docs/timing-analysis.md) for the detailed timing investigation and optimization process.

## Project Structure

```text
.
├── rtl/                  # SystemVerilog RTL
├── verification/         # Testbench and Python reference verification
├── asic/                 # ASIC wrapper and physical-design configuration
├── docs/                 # Design and analysis documentation
└── README.md
```

## Tools

- **SystemVerilog** — RTL design and testbench
- **Python** — reference model and automated verification
- **Icarus Verilog** — RTL simulation
- **Yosys** — logic synthesis
- **LibreLane / OpenROAD** — ASIC physical-design flow
- **SKY130** — target process design kit

## Next Steps

- Characterize multiple array dimensions and operand widths
- Compare area, timing, throughput, and utilization across configurations
- Analyze architectural scaling and PPA tradeoffs
- Document design-space exploration results