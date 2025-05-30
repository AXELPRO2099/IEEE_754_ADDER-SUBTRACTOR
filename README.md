# IEEE 754 Adder-Subtractor

## Overview

This repository contains a Verilog implementation of a single-precision (32-bit) floating-point adder-subtractor compliant with the IEEE 754 standard. The design performs both addition and subtraction operations on 32-bit floating-point numbers.

## Features

- Supports both addition and subtraction operations
- Handles all IEEE 754 special cases:
  - Normalized numbers
  - Denormalized numbers
  - Zero values
  - Infinity
  - NaN (Not a Number)
- Proper rounding (round to nearest even)
- Synthesizable Verilog code

## Files

- `top.v`: Main module implementing the floating-point adder-subtractor
- `tb.v`: Testbench for verifying the functionality of the design

## Usage

### Simulation

1. Open the project in Vivado
2. Add both `top.v` and `tb.v` to your project
3. Run behavioral simulation

### Synthesis

1. Set `top.v` as the top module
2. Run synthesis and implementation for your target device

## Implementation Details

The design uses a 23-bit mantissa path (plus hidden bit and guard bits) to maintain precision during arithmetic operations. The implementation follows these main steps:

1. Exponent comparison and alignment
2. Mantissa addition/subtraction
3. Normalization
4. Rounding
5. Special case handling

## Testing

The testbench (`tb.v`) includes test cases for:
- Normal number addition/subtraction
- Operations with zero
- Overflow/underflow scenarios
- NaN propagation
- Infinity arithmetic

## Acknowledgments

- IEEE 754 Floating-Point Arithmetic Standard
- Vivado Design Suite for simulation and synthesis
