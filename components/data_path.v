`include "../include/riscv64/common.vh"

module data_path(
    input wire clk,
    input wire rst
);


/* ------------------ */
/* Alu                */
/* ------------------ */

wire [`DATA_WIDTH-1:0] alu_a;
wire [`DATA_WIDTH-1:0] alu_b;
wire [`ALU_OP_WIDTH-1:0] alu_op;
wire [`DATA_WIDTH-1:0] alu_res;
wire alu_zero;

alu alu0(
    .a(alu_a),
    .b(alu_b),
    .op(alu_op),
    .data_width(data_width),

    .res(alu_res),
    .zero(alu_zero)
);

mux4_1 mux_alu0_a(
    .sel(alu_a_src),
    .a(reg_file_data_out1),
    .b(pc_out),
    // .c(csr_data_out),

    .out(alu_a)
);

mux4_1 mux_alu0_b(
    .sel(alu_b_src),
    .a(reg_file_data_out2),
    .b(instr_decode_ext_imm),
    .c(reg_file_data_out1),
    // .d(zimm),
    
    .out(alu_b)
);







/* ------------------ */
/* Data Memory        */
/* ------------------ */
wire [`DATA_WIDTH-1:0] data_memory_data_out;
data_memory data_memory0(
    .clk(clk),
    .rst(rst),
    .data_width(data_width),
    .we(mem_write),
    .re(mem_read),
    .addr(alu_res[`DATA_MEM_WIDTH-1:0]),
    .data_in(reg_file_data_out2),

    .data_out(data_memory_data_out)
);







/* ------------------ */
/* Instr Decoder      */
/* ------------------ */
wire [6:0] instr_decode_opcode;
wire [2:0] instr_decode_funct3;
wire [6:0] instr_decode_funct7;
wire [4:0] instr_decode_rs1;
wire [4:0] instr_decode_rs2;
wire [4:0] instr_decode_rd;
wire [31:0] instr_decode_imm;
wire [`ARCH_WIDTH-1:0] instr_decode_ext_imm;
wire [11:0] instr_decode_csr_addr;

assign instr_decode_ext_imm = $signed(instr_decode_imm);

instr_decode instr_decode0(
    .ins(instr_memory_instr),

    .opcode(instr_decode_opcode),
    .funct3(instr_decode_funct3),
    .funct7(instr_decode_funct7),
    .rs1(instr_decode_rs1),
    .rs2(instr_decode_rs2),
    .rd(instr_decode_rd),
    .imm(instr_decode_imm),
    .csr_addr(instr_decode_csr_addr)
);







/* ------------------ */
/* Reg File           */
/* ------------------ */

wire [`DATA_WIDTH-1:0] reg_file_data_in;
wire [`DATA_WIDTH-1:0] reg_file_data_out1;
wire [`DATA_WIDTH-1:0] reg_file_data_out2;

mux4_1 mux_reg_file_data_in(
    .sel(mem_to_reg),
    .a(alu_res),
    .b(data_memory_data_out),
    .c(pc_out+4),

    // .d(reg_file_data_out2),
    .out(reg_file_data_in)
);



reg_file reg_file0(
    .clk(clk),
    .rst(rst),
    .we(reg_write),
    .rs1(instr_decode_rs1),
    .rs2(instr_decode_rs2),
    .rd(instr_decode_rd),
    .data_in(reg_file_data_in),

    .data_out1(reg_file_data_out1),
    .data_out2(reg_file_data_out2),
    .instr(instr_memory_instr),
    .pc_out(pc_out)
);






/* ------------------ */
/* Instruction Memory */
/* ------------------ */

wire [`INSTR_WIDTH-1:0] instr_memory_instr;

assign instr_memory_re = rst?1'b0: 1'b1;

instr_memory instr_memory0(
    .clk(clk),
    .re(instr_memory_re),
    .instr_addr(pc_out),

    .instr(instr_memory_instr)
);






/* ------------------ */
/* Control Unit       */
/* ------------------ */

wire mem_read;
wire mem_write;
wire reg_write;
wire [1:0] mem_to_reg;

wire [1:0] alu_a_src;
wire [1:0] alu_b_src;

wire [2:0] data_width;
wire [2:0] pc_src;


control_unit control_unit0(
    .opcode(instr_decode_opcode),
    .funct3(instr_decode_funct3),
    .funct7(instr_decode_funct7),

    .mem_read(mem_read),
    .mem_write(mem_write),
    .reg_write(reg_write),
    .mem_to_reg(mem_to_reg),

    .alu_a_src(alu_a_src),
    .alu_b_src(alu_b_src),
    .alu_op(alu_op),

    .data_width(data_width),
    
    .pc_src(pc_src)
);






/* ------------------ */
/* Branch Target Addr */
/* ------------------ */

wire [`INSTR_MEM_WIDTH-1:0] tar_addr;
assign tar_addr = pc_out + instr_decode_ext_imm;



/* ------------------ */
/* Pc                 */
/* ------------------ */


wire [`INSTR_MEM_WIDTH-1:0] pc_in;
wire [`INSTR_MEM_WIDTH-1:0] pc_out;

pc pc0(
    .clk(clk),
    .rst(rst),
    .pc_src(pc_src),
    
    .tar_addr(tar_addr),
    .alu_res(alu_res),
    .alu_zero(alu_zero),

    .pc_out(pc_out)
);



endmodule