# Spartan-6-FPGA-DSP48A1-Slice
This project Implements and tests the DSP48A1 slice in Spartan-3A FPGAs. Features include an 18-bit pre-adder, 18x18 multiplier, 48-bit adder/accumulator, and configurable pipelining. Verilog code supports arithmetic operations and cascading, with a testbench validating functionality.

## Design Specifications
### Parameters and Attributes
Pipeline Registers: Parameters such as A0REG, A1REG, B0REG, B1REG, CREG, DREG, MREG, PREG, CARRYINREG, CARRYOUTREG, and OPMODEREG define the number of pipeline stages, typically defaulting to 1 (registered) excepting A0REG,B0REG defaulting to 0 (not registered).

Carry Cascade: The CARRYINSEL attribute determines the source of the carry-in, defaulting to OPMODE5.

Input Routing: B_INPUT controls whether the B input is directly from the port or cascaded from an adjacent slice.

Reset Type: The RSTTYPE attribute selects synchronous or asynchronous resets, defaulting to synchronous.
### Data Ports
A, B, D (18-bit): Input ports for multiplication and addition/subtraction operations.

C (48-bit): Input for the post-adder/subtracter.

CARRYIN: Provides carry-in to the adder/subtracter.

M (36-bit): Output from the multiplier, which is buffered.

P (48-bit): The primary output from the adder/subtracter.

CARRYOUT, CARRYOUTF: Cascade and logic carry-out signals.
### Control and Clock Input Ports
CLK: Clock signal driving the DSP48A1 slice.

OPMODE: Controls the arithmetic operation performed by the slice.

Clock Enable Inputs: CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP control the enablement of respective registers.
### Reset Input Ports
RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP: Active-high reset signals, which can be synchronous or asynchronous, depending on RSTTYPE.
### Cascade Ports
BCOUT: Provides the B output for cascading to adjacent slices.

PCIN, PCOUT: Allow cascading of the 48-bit P result between adjacent DSP48A1 slices.

## Block diagram


## Used tools 
Questasim

Xilinix Vivado

This comprehensive specification ensures the DSP48A1 slice is optimally configured for high-performance digital signal processing applications within the Spartan-6 FPGA. For more info, refer to the original doc Spartan-6 FPGA DSP484A1 Slice (User Guide)

The overall block diagram with the hierarchy of testing anotated below
Block Diagram
