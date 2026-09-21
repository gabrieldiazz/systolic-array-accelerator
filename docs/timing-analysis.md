## Timing Analysis & Optimization

Post-route static timing analysis (STA) was performed on the 3×3, INT8 configuration using the SKY130 physical-design flow with a 10 ns (100 MHz) clock constraint.

### Baseline

The initial processing element performed multiplication and accumulation in a single clock cycle:

`acc <= acc + a_in * b_in`

Post-route STA reported:

- Worst setup slack (WNS): **-4.52 ns**
- Total negative slack (TNS): **-487.18 ns**

Critical-path analysis traced the worst register-to-register path through the PE arithmetic datapath, indicating that performing both multiplication and accumulation within one cycle was a major timing bottleneck.

### Pipelined MAC

The PE was modified to introduce an intermediate product register, splitting the MAC operation across two pipeline stages:

1. Multiply `a_in × b_in` and store the result in `product_reg`
2. Accumulate the previously registered product into `acc`

The pipelined implementation was reverified against the Python reference model across all **105 directed and randomized tests**.

At the same 10 ns clock constraint, post-route STA reported:

- WNS: **-2.02 ns**
- TNS: **-43.33 ns**

Compared with the baseline, pipelining reduced the magnitude of WNS by approximately **55%** and TNS by approximately **91%**.

### Reset-Handling Experiment

STA on the pipelined design showed that the worst remaining setup path originated from the synchronous reset input and terminated at a `product_reg` flip-flop.

An experimental implementation removed reset from `product_reg` and introduced a validity bit to prevent uninitialized pipeline data from being accumulated.

Results at the same 10 ns constraint:

- WNS: **-1.95 ns**
- TNS: **-106.60 ns**
- Standard cells: **9,384**, compared with **8,423** for the simpler pipelined implementation
- Standard-cell area: **81,757**, compared with **72,859**

Although worst-case slack improved slightly, total negative slack and implementation cost worsened. The simpler pipelined architecture was therefore retained for subsequent characterization.

> The current implementation does not close timing at the 10 ns target; the 100 MHz constraint is used as a consistent reference point for comparing architectures.