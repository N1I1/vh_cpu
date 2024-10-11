`define FUNCT3_ADD_SUB  3'b000
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL_SRA  3'b101
`define FUNCT3_OR       3'b110
`define FUNCT3_AND      3'b111

`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000
`define FUNCT7_SRL  7'b0000000
`define FUNCT7_SRA  7'b0100000

`define FUNCT3_BEQ  3'b000
`define FUNCT3_BNE  3'b001
`define FUNCT3_BLT  3'b100
`define FUNCT3_BGE  3'b101
`define FUNCT3_BLTU 3'b110
`define FUNCT3_BGEU 3'b111

`define FUNCT3_LB  3'b000
`define FUNCT3_LH  3'b001
`define FUNCT3_LW  3'b010
`define FUNCT3_LD  3'b011
`define FUNCT3_LBU 3'b100
`define FUNCT3_LHU 3'b101
`define FUNCT3_LWU 3'b110

`define FUNCT3_SB  3'b000
`define FUNCT3_SH  3'b001
`define FUNCT3_SW  3'b010
`define FUNCT3_SD  3'b011

`define FUNCT3_ADDI         3'b000
`define FUNCT3_SLLI         3'b001
`define FUNCT3_SLTI         3'b010
`define FUNCT3_SLTIU        3'b011
`define FUNCT3_XORI         3'b100
`define FUNCT3_SRLI_SRAI    3'b101
`define FUNCT3_ORI          3'b110
`define FUNCT3_ANDI         3'b111

/* actually `srli` and `srai` ins has no funct7,
the high 7(6 actually according to the manual) bit is useless, here  use it
to distinguish `srli` and `srai`
*/
`define FUNCT7_SRAI         7'b0100000
`define FUNCT7_SRLI         7'b0000000


`define FUNCT3_CSRRW  3'b001
`define FUNCT3_CSRRS  3'b010
`define FUNCT3_CSRRC  3'b011
`define FUNCT3_CSRRWI 3'b101
`define FUNCT3_CSRRSI 3'b110
`define FUNCT3_CSRRCI 3'b111