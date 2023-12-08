# MSD-final-Project

# Description:

# The project implements a System Verilog for the simulation for a schedular portion of a memory controller for a DDR5 serving 12-core 4.8 GHz processor employing a single 16GB PC5-38400 DIMM.

Overview:
Language			: SystemVerilog
Tool				: Questasim
Policy				: Closed Page Policy
Execution of input requests: In Order Execution

Code Implementation:
Main module starts with initial block
First open files (both input and output) and read a line from input file
Call all the functions required inside while loop in the following order checking the return parameters to proceed with execution or stop processing or hold giving DRAM commands during burst
Check if DRAM is eligible to issue commands based on current command issued and if all timing parameters are met. Required functions are called here.
Pop queue and Update timing counters even if DRAM command is processed or not.
Check CPU clock and push into queue.
Close files if queue is empty, end of input file is reached and no more pending requests are there to be queued. Then set the done bit.
Increment clock if processing is still to be done. Jump to next time if no more commands to be processed and end of file not reached.



Test Plan: 
Approach to generate input file addresses: SV module
Testmodule which displays the formatted 34 bit hex address from the provided combination of address components. Used it to update the excel spreadsheet with the required combination of testcases.
