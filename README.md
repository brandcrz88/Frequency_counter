# 📟 Frequency Counter

The frequency counter is a project that takes an oscillating signal as input and displays the frequency of the signal as an output.

The design can be used for an ASIC tapeout or FPGA synthesis (/fpga contains the Makefile for synthesis).

This project consists of:

- Writting the Verilog modules.
- Writting the testbenches with cocotb.
- Writting the dump files for simulation.
- Writting the Makefile.
- Synthesizing for FPGA.

## Architecture

The design consists of 3 modules (including the top module), which are the following:

- Edge detector.
- Seven segmenent decoder.
- Frequency counter (top module)

Why do we need an edge detector?

The edge detector handles metastability between the input signal and the internal clock, it also creates a two-bit history of the incoming signal. The two-bit signal is then filtered using an "xor" and "and" gates. As a result, the output of the module is the positive edges of the signal.

The frequency counter requires a finite state machine (FSM). The FSM handles a finite number of states that represent a sequential process on HDL, which is not as straightforward as traditional software code. The FSM does the following:

Counts a number of edges in a time period (the clock cycle). Converts that count into a decimal number. loads that count into the seven-segment module to update the display and return to step 1. Here is a diagram of the FSM:

![Mind Map (3)](https://github.com/brandcrz88/Frequency_counter/assets/140255993/52dedf74-da96-4ca8-82a0-4a1896bad109)

Notes:

there is a toggling register inside of the seven_segment module, it toggles the digit's cathode of the pmode, which alternates the digit at the clock frequency. It makes the illusion that both digits are on at the same time.

The frequency unit is set as 10 KHz; when the PMOD shows the number 01, it means that the incoming signal has a 10 KHz frequency. This unit is defined based on the oscillating frequency of the FPGA, which is 12 MHZ. So, every time that an internal clock_count register reaches 1200 cycles (1200 cycles of 12 MHz each fit into one cycle of 10 KHz), it counts how many signal edges were counted.

The minimum integer number that the pmod can show is 01, and the maximum is 99 (in decimal). So, the frequency counter can detect a frequency range of 10:990 KHz.

## Waveform Simulation

![Screenshot from 2024-05-24 01-54-18](https://github.com/brandcrz88/Frequency_counter/assets/140255993/55cd0ff7-7b07-4a7d-bcf7-b3ab37ae49c6)

Explanation

## The Makefile

The Makefile automates the compilation process that tests the behavior of each module, including the top module. Comprisingly, it takes care of the simulation and verification processes. In the first step, iverilog produces two files, on the second step, Python's module cocotb takes the output files to produce the wave signal simulation and the verification of the designs with vvp that checks for the design's robustness and functionality with a specific testbench written for each of the modules.

![Mind Map (2)](https://github.com/brandcrz88/Frequency_counter/assets/140255993/e81aa33d-302f-443c-88dd-b835e51fd89a)

## Testing on a FPGA

picture.jpg

The process of testing the design on an FPGA consists of:

- Design: The first step is to write the design's functionality using HDL.

- Synthesis: The HDL is converted into a gate-level representation by a synthesis tool such as open source `Yosys`. 

- Mapping: The logic gates and flip-flops can be placed into the FPGA's specific blocks and routing resources.

- Place and route: The mapped design is physically placed into the FPGA's chip space and creates the interconnections.
  
- Bitstream: It generates a bitstream file that contains the configuration data that is loaded into the FPGA, which sets the internal circuit.

- Programming: The bitstream is loaded into the FPGA, more often through a USB or JTAG interface.

The "fpga" directory contains its own Makefile that automates the synthesis process to program the design on an icebreaker FPGA.

## License

This project is part of the Zero to ASIC Course and is licensed with [Apache 2]. (https://github.com/brandcrz88/Frequency_counter/blob/main/LICENSE)
