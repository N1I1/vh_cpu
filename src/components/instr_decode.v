`include "../include/common.vh"

module instr_decode (
    input       [31:0]  ins,
    output      [6:0]   opcode,
    output      [2:0]   funct3,
    output      [6:0]   funct7,
    output      [4:0]   rs1,
    output      [4:0]   rs2,
    output      [4:0]   rd,
    output      [31:0]  imm,
    output      [11:0]  csr_addr
);
    
    wire I_type;
    wire U_type;
    wire J_type;
    wire B_type;
    wire S_type;
    wire SYSTEM_type;
    
    wire [31:0] I_imm;
    wire [31:0] U_imm;
    wire [31:0] J_imm;
    wire [31:0] B_imm;
    wire [31:0] S_imm;
    wire [31:0] SYSTEM_imm;
    wire [11:0] csr_addr;
    
    
    assign opcode   = ins[6:0];
    assign funct3    = ins[14:12];
    assign funct7    = ins[31:25];
    assign rs1      = ins[19:15];
    assign rs2      = ins[24:20];
    assign rd       = ins[11:7];
    assign csr_addr = ins[31:20];
    
    assign I_type = (ins[6:0] == `OP_I_JALR) | (ins[6:0] == `OP_I_LOAD) | (ins[6:0] == `OP_I_IMM) | (ins[6:0] == `OP_I_IMM32);
    assign U_type = (ins[6:0] == `OP_U_LUI) | (ins[6:0] == `OP_U_AUIPC);
    assign J_type = (ins[6:0] == `OP_I_JAL);
    assign B_type = (ins[6:0] == `OP_B);
    assign S_type = (ins[6:0] == `OP_S);
    assign SYSTEM_type = (ins[6:0] == `OP_I_SYSTEM);
    
    
    assign I_imm = {{(32-12){ins[31]}}, ins[31:20]}; 
    assign U_imm = {ins[31:12], {(32-20){1'b0}}};
    assign J_imm = {{(32-20){ins[31]}}, ins[19:12], ins[20], ins[30:21],1'b0};   
    assign B_imm = {{(32-12){ins[31]}}, ins[7], ins[30:25], ins[11:8],1'b0};
    assign S_imm = {{(32-12){ins[31]}}, ins[31:25], ins[11:7]}; 
    assign SYSTEM_imm = {{(32-12){1'b0}}, ins[31:20]};
    
    assign imm= I_type ? I_imm :
                 U_type ? U_imm :
                 J_type ? J_imm :
                 B_type ? B_imm :
                 S_type ? S_imm : 
                 SYSTEM_type ? SYSTEM_imm : 32'd0;
endmodule