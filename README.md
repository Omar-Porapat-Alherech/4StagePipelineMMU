# Four-Stage Pipelined MMU
The goal of this was to develop a Four-Stage piplined MMU using VHDL/Verilog to develop the four stages consisting of:
* Instruction Fetch - fetches the instruction an dincrements the program counter
* Instruction Decode - Decodes the instruction parsing out register addresses and type-bits (opcode, li_sa_hl bits, ldi, write, format).
* Instruction Decode + Execute  - Takes the output of the previous stage and fowards it into the ALU, where commands are executed, and certain values detailing writeback or bit-fowarding occurs
* Execute + Writeback - Inputs are taken from the ALU output, allowing the MMU to complete any fowarding or writeback logic back through stage 2 or 3.

The assembler is written with the use of python, taking an input file of commands written in MIPS format the assembler converts MIPS into machine code into the R3 or R4 instruction format.
