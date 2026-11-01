# Single-Cycle-RV32I
Single-cycle RISC-V (RV32I) processor implemented in System Verilog.
# Single-Cycle RV32I Processor (SystemVerilog)

A single-cycle 32-bit RISC-V (RV32I) processor written in SystemVerilog. The design is organised by the five classic datapath stages: **IF, ID, EX, MEM and WB**. Every instruction completes in one clock cycle.

## Features

- RV32I base integer instruction set
- Modular design: one module per pipeline stage, wired together in a top-level module
- Separate instruction and data memory
- 32 x 32-bit register file (`x0` hard-wired to zero)
- Testbench for simulation and waveform inspection

## Supported Instructions

| Type | Instructions |
|------|--------------|
| R-type | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| I-type (ALU) | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` |
| Load | `LB`, `LH`, `LW`, `LBU`, `LHU` |
| Store | `SB`, `SH`, `SW` |
| Branch | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| Jump | `JAL`, `JALR` |
| Upper immediate | `LUI`, `AUIPC` |

> Edit this table to match what your core actually implements.

## Architecture

```
        +----+     +----+     +----+     +-----+     +----+
 PC --> | IF | --> | ID | --> | EX | --> | MEM | --> | WB |
        +----+     +----+     +----+     +-----+     +----+
          ^                                             |
          +------------- next PC / write-back ----------+
```

| Stage | Module | Role |
|-------|--------|------|
| **IF** (Instruction Fetch) | `IF_stage.sv` | Holds the program counter, fetches the instruction from instruction memory, computes PC + 4 |
| **ID** (Instruction Decode) | `ID_stage.sv` | Decodes the instruction, reads the register file, generates the immediate, produces control signals |
| **EX** (Execute) | `EX_stage.sv` | ALU operations, branch condition evaluation, branch/jump target calculation |
| **MEM** (Memory Access) | `MEM_stage.sv` | Data memory reads and writes for loads and stores |
| **WB** (Write Back) | `WB_stage.sv` | Selects the result (ALU, memory or PC + 4) and writes it back to the register file |

> Rename the files above to match your repository.

## Getting Started

### Prerequisites

Any SystemVerilog simulator, for example:

- ModelSim / QuestaSim
- Vivado Simulator (xsim)
- Verilator
- Icarus Verilog (`-g2012`)

### Running a Simulation

**ModelSim / QuestaSim**
```bash
vlog -sv src/*.sv tb/riscv_tb.sv
vsim -c riscv_tb -do "run -all; quit"
```

**Icarus Verilog**
```bash
iverilog -g2012 -o sim.out src/*.sv tb/riscv_tb.sv
vvp sim.out
```

**Vivado**
1. Create a new project and add everything in `src/` as design sources.
2. Add `tb/riscv_tb.sv` as a simulation source.
3. Run Behavioral Simulation.

### Loading a Program

Instruction memory is initialised from a hex file:

```systemverilog
initial $readmemh("programs/test.hex", mem);
```

Replace `test.hex` with your own assembled RV32I program.

## Verification

The testbench drives the clock and reset, runs a test program, and lets you check results through:

- Waveforms (PC, instruction, register values, ALU result, memory signals)
- Console output of register or memory contents at the end of simulation

Add screenshots of your waveforms in a `docs/` folder and link them here:

```markdown
![Waveform](docs/waveform.png)
```


## Author

**JAWAD KHAN**
[GitHub](https://github.com/JAWADKHAN146)

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
