## Frequency Counter

Why do we need an edge detector?

The Modules are a seven segment decoder, a leading edge detector, and the frequency counter.

The frequency counter requires a FSM. The finite state machine handles a finit number of states that represent a sequential process on HDL, which is not straightforward as traditional software code. The FSM does the following:

- Counts a number of edges in a time period (the clock cycle).
- Converts that count into a decimal number. 
- Update a display and return to step 1. 

Comment: There are two toggling registers, one that updates the seven segment display, it toggles the load signal of the seven_segment module, this goes high at the STATE_UNITS. 

The other toggling register is inside of the seven_segment module, it toggles the digit's cathode of the pmode, which alternates the digit at the clock frequency. 

The main things to do are

- Writting the verilog modules
- Writting the testbenches with cocotb
- Writting the dump files for simulation
- Writting the Makefile
- Synthesizing for FPGA
