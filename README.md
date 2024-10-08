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

This comprehensive specification ensures the DSP48A1 slice is optimally configured for high-performance digital signal processing applications within the Spartan-6 FPGA. For more info, you can check the user guide attached above or use this link https://docs.amd.com/v/u/en-US/ug389
## Block diagram
![image](https://github.com/user-attachments/assets/66bbc947-05d8-4f77-84ef-4067c79ec7ad)


## Used tools 
Questasim

Xilinix Vivado

## Results 
In the main branch, a folder named results has been created. This folder contains snippets of waveforms from all testbench modules, generated using QuestaSim. Additionally, it includes screenshots from the elaboration, implementation, and synthesis stages, as well as some useful reports generated with Vivado.

