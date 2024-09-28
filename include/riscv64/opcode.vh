`define OP_R        7'b0110011 // R-type
`define OP_I_IMM    7'b0010011 // I-type
`define OP_I_LOAD   7'b0000011 // I-type Load
`define OP_S        7'b0100011 // S-type Store
`define OP_B        7'b1100011 // B-type
`define OP_I_JAL    7'b1101111 // J-type
`define OP_I_JALR   7'b1100111 // I-type
`define OP_U_LUI    7'b0110111 // U-type
`define OP_U_AUIPC  7'b0010111 // U-type
`define OP_I_SYSTEM 7'b1110011 // I-type System