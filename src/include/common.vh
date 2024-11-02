`include "opcode.vh"
`include "alu.vh"
`include "Color.vh"
`include "func.vh"

`define ARCH_WIDTH 64
`define ALU_OP_WIDTH 4
`define ARCH "riscv64"

`define INSTR_WIDTH 32
`define INSTR_MEM_SIZE 8000
`define INSTR_MEM_WIDTH 64

`define DATA_WIDTH 64
`define DATA_MEM_SIZE 8000
`define DATA_MEM_WIDTH 64

`define DATA_WIDTH_8 3'd0
`define DATA_WIDTH_16 3'd1
`define DATA_WIDTH_32 3'd2
`define DATA_WIDTH_64 3'd3

`define CSR_WIDTH 32
`define CSR_ADDR_WIDTH 12

`define CSR_MSTATUS 12'h300
`define CSR_MEPC 12'h341
`define CSR_MCAUSE 12'h342
`define CSR_MTVEC 12'h305