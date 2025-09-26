# CSE 320 LAB 2 - Verilog Digital Design Project

This repository contains a comprehensive Verilog project for CSE 320 LAB 2, implementing fundamental digital logic components commonly used in computer architecture.

## Project Overview

This lab implements several key digital logic components:
- **ALU (Arithmetic Logic Unit)**: 4-bit ALU supporting arithmetic and logic operations
- **Register File**: 4-register file with 4-bit data width
- **Counter**: 4-bit synchronous counter with enable and reset
- **Decoder**: 2-to-4 decoder with enable signal
- **CPU Top**: Top-level module integrating all components

## Directory Structure

```
LAB2/
├── src/                    # Verilog source files
│   ├── alu.v              # ALU implementation
│   ├── register_file.v    # Register file implementation
│   ├── counter.v          # Counter implementation
│   ├── decoder.v          # Decoder implementation
│   └── cpu_top.v          # Top-level integration module
├── testbench/             # Testbench files
│   ├── alu_tb.v           # ALU testbench
│   ├── register_file_tb.v # Register file testbench
│   ├── counter_tb.v       # Counter testbench
│   ├── decoder_tb.v       # Decoder testbench
│   └── cpu_top_tb.v       # Top-level system testbench
├── sim/                   # Simulation output directory
├── Makefile              # Build and simulation makefile
└── README.md             # This file
```

## Components Description

### 1. ALU (alu.v)
- **Inputs**: 4-bit operands a and b, 3-bit operation selector
- **Outputs**: 4-bit result, zero flag, carry flag
- **Operations**: ADD, SUB, AND, OR, XOR, SLL (shift left), SRL (shift right), NOR

### 2. Register File (register_file.v)
- **Features**: 4 registers, each 4-bit wide
- **Inputs**: Clock, reset, write enable, read/write addresses, write data
- **Outputs**: Two read data ports
- **Functionality**: Simultaneous dual-port read, single-port write

### 3. Counter (counter.v)
- **Type**: 4-bit synchronous up-counter
- **Inputs**: Clock, reset, enable
- **Output**: 4-bit count value
- **Features**: Asynchronous reset, enable control

### 4. Decoder (decoder.v)
- **Type**: 2-to-4 binary decoder
- **Inputs**: 2-bit input, enable signal
- **Output**: 4-bit decoded output (one-hot encoding)
- **Features**: Enable control for output activation

### 5. CPU Top (cpu_top.v)
- **Integration**: Combines all components into a simple processor-like system
- **Features**: Register file feeds ALU, counter drives decoder
- **Control**: Multiple control signals for coordinated operation

## Getting Started

### Prerequisites
- Icarus Verilog (iverilog) for simulation
- Optional: GTKWave for waveform viewing

### Installation (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

Or use the Makefile:
```bash
make install_tools
```

### Quick Start
1. Check if tools are installed:
   ```bash
   make check_tools
   ```

2. Compile and simulate all modules:
   ```bash
   make all
   ```

3. Simulate individual modules:
   ```bash
   make alu           # Simulate ALU only
   make counter       # Simulate Counter only
   make cpu_top       # Simulate complete system
   ```

4. Clean simulation files:
   ```bash
   make clean
   ```

## Makefile Targets

| Target | Description |
|--------|-------------|
| `all` | Compile and simulate all modules |
| `alu` | Simulate ALU module |
| `register_file` | Simulate Register File module |
| `counter` | Simulate Counter module |
| `decoder` | Simulate Decoder module |
| `cpu_top` | Simulate top-level CPU module |
| `compile_all` | Compile all modules without simulation |
| `simulate_all` | Run all simulations |
| `clean` | Clean simulation files |
| `check_tools` | Verify required tools are installed |
| `install_tools` | Install Icarus Verilog (Ubuntu/Debian) |
| `help` | Display help information |

## Testing

Each module includes comprehensive testbenches that verify:
- Functional correctness
- Edge cases
- Reset behavior
- Control signal functionality

### Example Test Output
```
ALU Testbench Starting...
Time    a       b       op      result  zero    carry   operation
----    -       -       --      ------  ----    -----   ---------
40      0101    0011    000     1000    0       0       ADD
50      0101    0011    001     0010    0       0       SUB
```

## Learning Objectives

This lab helps students understand:
1. **Combinational Logic**: ALU operations, decoder functionality
2. **Sequential Logic**: Register file, counter with clock and reset
3. **System Integration**: Connecting multiple modules
4. **Verilog HDL**: Module definition, always blocks, wire/reg types
5. **Digital Design**: Timing, control signals, data paths
6. **Verification**: Testbench creation and simulation

## Course Context

This project is designed for CSE 320 (Computer Architecture) and covers:
- Digital logic fundamentals
- Basic computer components
- Verilog hardware description language
- Simulation and verification techniques

## Advanced Features

- **Parameterized Design**: Easy to modify bit widths
- **Comprehensive Testing**: Full coverage testbenches
- **Modular Architecture**: Reusable components
- **Industry Standards**: Following Verilog best practices

## Troubleshooting

### Common Issues
1. **iverilog not found**: Install Icarus Verilog using `make install_tools`
2. **Permission denied**: Ensure execute permissions on Makefile
3. **Compilation errors**: Check Verilog syntax in source files

### Debug Tips
- Use `$display` statements for debugging
- Run individual module tests before system integration
- Check signal timing in waveform viewer

## Future Enhancements

Potential extensions for advanced students:
- Pipelined ALU operations
- Memory interface modules
- Interrupt handling
- More complex instruction set

## License

Educational use for CSE 320 coursework.

---
*Created for CSE 320 Computer Architecture Lab 2*
