`include "opcode.vh"
`include "alu.vh"
`include "../Color.vh"
`include "func.vh"

`define ARCH_WIDTH 64
`define ALU_OP_WIDTH 4
`define ARCH "riscv64"

`define INSTR_WIDTH 32
`define INSTR_MEM_SIZE 1024
`define INSTR_MEM_WIDTH 10

`define DATA_WIDTH 64
`define DATA_MEM_SIZE 1024
`define DATA_MEM_WIDTH 10