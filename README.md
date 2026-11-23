# Single-Cycle RV32I Processor (SystemVerilog)

A single-cycle 32-bit RISC-V (RV32I) processor implemented in SystemVerilog. The processor is organised into modular datapath stages: **Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB)**.

The design uses a dedicated top-level module, `RV_32_TOP`, to integrate the individual modules into a complete processor datapath. Every instruction is designed to complete in one clock cycle.

## Features

- RV32I base integer instruction set implementation.
- Modular architecture with separate IF, ID, EX and WB modules.
- Dedicated top-level integration module (`RV_32_TOP`).
- Separate external instruction and data memory interfaces.
- 32 × 32-bit register file with `x0` hardwired to zero.
- Branch and jump handling, including JAL and JALR.
- ALU operations and immediate generation.
- Load and store memory interface.
- Write-back selection for ALU results, memory data, and return addresses.
- Stall and reset support.
- SystemVerilog testbench for simulation and waveform verification.

## Supported Instructions

| Type | Instructions |
|---|---|
| R-type | `ADD`, `SUB`, `SLL`, `SLT`, `SLTU`, `XOR`, `SRL`, `SRA`, `OR`, `AND` |
| I-type (ALU) | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` |
| Load | `LB`, `LH`, `LW`, `LBU`, `LHU` |
| Store | `SB`, `SH`, `SW` |
| Branch | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` |
| Jump | `JAL`, `JALR` |
| Upper Immediate | `LUI`, `AUIPC` |

*Note: The instruction list should match the operations implemented and verified in the individual modules.*

## Architecture

The processor follows the five classic RISC-V datapath stages. These are modular functional blocks connected within a single-cycle datapath, not five separate pipeline stages.

```text
                 +----------------+
                 |   RV_32_TOP    |
                 +----------------+
                         |
          +--------------+--------------+
          |              |              |
      +-------+      +-------+      +-------+
      |  IF   | ---> |  ID   | ---> |  EX   |
      +-------+      +-------+      +-------+
          ^                            |
          |                            |
          |                       +---------+
          |                       |  MEM    |
          |                       +---------+
          |                            |
          |                       +-------+
          +-----------------------|  WB   |
                                  +-------+
```

### Module Description

| Stage | Module | Responsibility |
|---|---|---|
| IF | `IF_stage.sv` | Maintains the program counter and selects the next instruction address. |
| ID | `ID_Top.sv` | Decodes instructions, reads the register file, generates immediate values and control signals. |
| EX | `EX_Top.sv` | Performs ALU operations, evaluates branch conditions and calculates execution results. |
| MEM | External memory interface | Handles data memory read and write operations through the top module. |
| WB | `WB_Stage.sv` | Selects the appropriate result for writing back into the register file. |
| Top | `RV_32_TOP.sv` | Integrates all modules and connects the datapath and external memory interfaces. |

## Top-Level Integration

The `RV_32_TOP` module connects the processor components and provides the external interfaces required for instruction fetching and data memory access.

### Module: `RV_32_TOP`

**Inputs**

| Signal | Width | Description |
|---|---|---|
| `clk` | 1 bit | System clock |
| `reset` | 1 bit | Processor reset |
| `stall` | 1 bit | Controls PC stalling |
| `instruction` | 32 bits | Instruction received from instruction memory |
| `mem_rdata` | 32 bits | Data received from data memory |

**Outputs**

| Signal | Width | Description |
|---|---|---|
| `pc` | 32 bits | Current instruction address |
| `mem_addr` | 32 bits | Data memory address |
| `mem_wdata` | 32 bits | Data to be written into memory |
| `mem_read` | 1 bit | Data memory read control |
| `mem_write` | 1 bit | Data memory write control |

### Program Counter Control

The top module handles next-PC selection for different instruction types:

- **Sequential execution:** PC + 4
- **Conditional branches:** Updates PC when the branch condition is satisfied.
- **JAL:** Updates PC using the J-type immediate.
- **JALR:** Calculates the target address using the source register and immediate, with the least significant bit cleared.

The return address (PC + 4) is also provided to the write-back module for jump instructions.

### Memory Interface

Instruction memory and data memory are external to `RV_32_TOP`.

- Instruction memory supplies the 32-bit instruction corresponding to the current PC.
- Data memory receives the address, write data and read/write control signals.
- Read data from data memory is forwarded to the write-back module.

This separation allows the processor datapath to be connected to different memory implementations.

## Getting Started

### Prerequisites

Any SystemVerilog-compatible simulator can be used:

- ModelSim / QuestaSim
- Xilinx Vivado Simulator (xsim)
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

**Xilinx Vivado**

1. Create a new RTL project.
2. Add all processor modules, including `RV_32_TOP.sv`, as design sources.
3. Add the instruction and data memory implementations.
4. Add the testbench as a simulation source.
5. Set the appropriate top module for synthesis or simulation.
6. Run Behavioral Simulation and inspect the waveforms.

*Update the source paths and testbench filename according to your repository structure.*

## Loading a Program

Instruction memory can be initialised using `$readmemh`:

```systemverilog
initial begin
    $readmemh("programs/test.hex", mem);
end
```

Replace `test.hex` with your assembled RV32I machine-code program.

The instruction memory must provide the instruction corresponding to the PC generated by `RV_32_TOP`.

## Verification

The processor can be verified using a SystemVerilog testbench.

Important signals to monitor during simulation:

- Program Counter (PC)
- Instruction
- Register file contents
- ALU result
- Branch and jump control signals
- Data memory address
- Memory read/write signals
- Write-back data

Waveforms can be captured and added to the repository under the `docs/` directory.

```markdown
![Processor Simulation Waveform](docs/waveform.png)
```

## Author

**JAWAD KHAN**

[GitHub Profile](https://github.com/JAWADKHAN146)


