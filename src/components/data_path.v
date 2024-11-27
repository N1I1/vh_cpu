`include "../include/common.vh"

module data_path(
    input                          clk,
    input                          rst,
    output  [31:0]                 data_out0,
    output  [31:0]                 data_out1,
    output  [31:0]                 data_out2,
    output  [31:0]                 data_out3,
    output  [31:0]                 data_out4,
    output  [31:0]                 data_out5,
    output  [31:0]                 data_out6,
    output  [31:0]                 data_out7
    // input                          mem_read,
    // input                          mem_write,
    // input                          reg_write,
    // input  [1:0]                   mem_to_reg,

    // input  [1:0]                   alu_a_src,
    // // 0: rs1, 1: pc, 2: csr
    // input  [1:0]                   alu_b_src,
    // // 0: rs2, 1: imm, 2: rs1, 3: zimm
    // input                          alu_b_neg,
    // // 0: positive, 1: negative
    // input  [`ALU_OP_WIDTH-1:0]     alu_op,
    
    // input  csr_we,
    // input  [2:0]                   csr_src,
    // // 0: alu_res, 1: rs1 2: zimm, 3: 0
    // input  [1:0]                   trap,

    // input  [2:0]                   pc_src,  
    // // 0 : (pc + 4), 
    // // 1: branch eq/ge(tar_addr | pc + 4), 2: branch ne/lt (tar_addr | pc + 4), 
    // // 3: jal(tar_addr), 4: jalr(alu_res)
    // // 5: csr

    // input  [2:0]                   data_width  
    // // 0: 8-bit, 1: 16-bit, 2: 32-bit, 3: 64-bit
);

wire [31:0] debug_ex_instr;
wire [31:0] debug_mem_instr;
wire [31:0] debug_wb_instr;


/* ------------------ */
/* Alu                */
/* ------------------ */


wire [1:0] ex_alu_a_src;
wire [1:0] ex_alu_b_src;
wire ex_alu_b_neg;
wire [`ALU_OP_WIDTH-1:0] ex_alu_op;

wire [`DATA_WIDTH-1:0] ex_alu_res;
wire ex_alu_zero;

wire [2:0] ex_data_mem_data_width;
wire [`DATA_MEM_WIDTH-1:0] ex_data_addr;
wire [31:0] ex_imm;
wire [`ARCH_WIDTH-1:0] ex_reg_file_data_out1;
wire [`ARCH_WIDTH-1:0] ex_reg_file_data_out2;
wire [4:0] ex_rs1;
wire [4:0] ex_rs2;
wire [2:0] ex_csr_src;
wire [11:0] ex_csr_addr;
wire ex_csr_we;
wire [31:0] ex_csr_data_out;

wire [2:0] ex_mem_data_width;
wire ex_data_mem_we;
wire ex_data_mem_re;
wire [`DATA_WIDTH-1:0] ex_data_mem_in;

wire ex_reg_file_we;
wire [4:0] ex_reg_file_rd;
wire [1:0] ex_reg_file_sel;
wire [`ARCH_WIDTH-1:0] ex_pc_out;

pipe_id_ex_reg pipe_id_ex_reg(
    .clk(clk),
    .rst(rst),
    .id_ex_en(1'b1),
    .id_ex_stall(1'b0),
    .flush(1'b0),

    .id_reg_file_data_out1(reg_file_data_out1), // not for sure data or addr
    .id_reg_file_data_out2(reg_file_data_out2),
    .id_rs1(instr_decode_rs1),
    .id_rs2(instr_decode_rs2),
    .id_imm(instr_decode_imm),

    .id_data_mem_we(mem_read),
    .id_data_mem_re(mem_write),
    // .id_data_mem_in(id_ex_data_mem_in), // duplicate with reg_file_data_out

    .id_reg_file_rd(instr_decode_rd),
    .id_reg_file_we(reg_write),
    .id_reg_file_sel(mem_to_reg),
    .id_pc_out(id_pc_out),
    .id_csr_src(csr_src),
    .id_csr_we(csr_we),
    .id_csr_addr(instr_decode_csr_addr), // not used yet
    .id_csr_data_out(csr_data_out),


    .id_alu_a_src(alu_a_src),
    .id_alu_b_src(alu_b_src),
    .id_alu_b_neg(alu_b_neg),
    .id_alu_op(alu_op),
    .id_data_width(data_width),
    
    // for ex stage
    .ex_alu_a_src(ex_alu_a_src),
    .ex_alu_b_src(ex_alu_b_src),
    .ex_alu_b_neg(ex_alu_b_neg),
    .ex_alu_op(ex_alu_op),
    .ex_data_width(ex_data_mem_data_width),
    .ex_imm(ex_imm),
    .ex_reg_file_data_out1(ex_reg_file_data_out1),
    .ex_reg_file_data_out2(ex_reg_file_data_out2),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),

    // after ex stage
    .ex_data_mem_data_width(ex_mem_data_width),
    .ex_data_mem_we(ex_data_mem_we),
    .ex_data_mem_re(ex_data_mem_re),
    .ex_data_mem_in(ex_data_mem_in),

    .ex_reg_file_we(ex_reg_file_we),
    .ex_reg_file_rd(ex_reg_file_rd),
    .ex_reg_file_sel(ex_reg_file_sel),
    .ex_pc_out(ex_pc_out),

    .ex_csr_src(ex_csr_src), // need to add in next stage
    .ex_csr_addr(ex_csr_addr),
    .ex_csr_we(ex_csr_we),
    .ex_csr_data_out(ex_csr_data_out),

    .debug_id_instr(id_instr),
    .debug_ex_instr(debug_ex_instr)
);
wire [`DATA_WIDTH-1:0] alu_a;
wire [`DATA_WIDTH-1:0] alu_b;
wire [`ALU_OP_WIDTH-1:0] alu_op;

alu alu0(
    .a(alu_a),
    .b(alu_b),
    .op(ex_alu_op),
    .data_width(ex_data_mem_data_width),

    .res(ex_alu_res),
    .zero(ex_alu_zero)
);

mux4_1 mux_alu0_a(
    .sel(ex_alu_a_src),
    .a(ex_reg_file_data_out1),
    .b(ex_pc_out),
    .c(ex_csr_data_out),
    .d(64'h0),
    .out(alu_a)
);

wire [`ARCH_WIDTH-1:0] instr_decode_ext_imm;
wire [`ARCH_WIDTH-1:0] ex_ext_imm;
assign ex_ext_imm = $signed(ex_imm);
wire [`ARCH_WIDTH-1:0] zimm_alu_b;
mux4_1 mux_alu0_b(
    .sel(ex_alu_b_src),
    .a(ex_reg_file_data_out2),
    .b(ex_ext_imm),
    .c(ex_reg_file_data_out1),
    .d(zimm_alu_b),
    
    .out(alu_b)
);
assign zimm_alu_b = ex_alu_b_neg? ~ex_rs1 : ex_rs1;







/* ------------------ */
/* Data Memory        */
/* ------------------ */
wire [4:0] mem_rs1;
wire [4:0] mem_rs2;

wire [31:0] mem_imm;
wire mem_data_mem_we;
wire mem_data_mem_re;
wire [`DATA_WIDTH-1:0] mem_data_mem_in;
wire [`DATA_MEM_WIDTH-1:0] mem_data_mem_addr;
wire [2:0] mem_data_mem_data_width;

wire mem_reg_file_we;
wire [4:0] mem_reg_file_rd;
wire [1:0] mem_reg_file_sel;
wire [`ARCH_WIDTH-1:0] mem_alu_res;
wire [`ARCH_WIDTH-1:0] mem_pc_out;

wire [2:0] mem_csr_src;
wire [11:0] mem_csr_addr;
wire mem_csr_we;
wire [31:0] mem_csr_data_out;

// need to modify the following
pipe_ex_mem_reg pipe_ex_mem_reg(
    .clk(clk),
    .rst(rst),
    .ex_mem_en(1'b1),
    .ex_mem_stall(1'b0),
    .flush(1'b0),
    
    // read from alu
    .ex_alu_res(ex_alu_res),
    .ex_alu_zero(ex_alu_zero),

    // read from id_ex
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .ex_imm(ex_imm),
    .ex_data_width(ex_data_mem_data_width),
    .ex_data_addr(ex_data_addr),
    .ex_data_we(ex_data_mem_we),
    .ex_data_re(ex_data_mem_re),
    .ex_data_in(ex_data_mem_in),
    
    .ex_reg_file_we(ex_reg_file_we),
    .ex_reg_file_rd(ex_reg_file_rd),
    .ex_reg_file_sel(ex_reg_file_sel),
    
    .ex_pc_out(ex_pc_out),
    
    .ex_csr_addr(ex_csr_addr),
    .ex_csr_we(ex_csr_we),
    .ex_csr_src(ex_csr_src),
    .ex_csr_data_out(ex_csr_data_out),
    

    // for mem access stage
    .mem_rs1(mem_rs1),
    .mem_rs2(mem_rs2),
    .mem_imm(mem_imm),
    .mem_data_mem_data_width(mem_data_mem_data_width),
    .mem_data_mem_addr(mem_data_mem_addr),
    .mem_data_mem_we(mem_data_mem_we),
    .mem_data_mem_re(mem_data_mem_re),
    .mem_data_mem_in(mem_data_mem_in),
    
    .mem_reg_file_we(mem_reg_file_we),
    .mem_reg_file_rd(mem_reg_file_rd),
    .mem_reg_file_sel(mem_reg_file_sel),
    .mem_alu_res(mem_alu_res),
    .mem_pc_out(mem_pc_out),

    .mem_csr_src(mem_csr_src),
    .mem_csr_addr(mem_csr_addr),
    .mem_csr_we(mem_csr_we),
    .mem_csr_data_out(mem_csr_data_out),

    .debug_ex_instr(debug_ex_instr),
    .debug_mem_instr(debug_mem_instr)
);
wire [`DATA_WIDTH-1:0] data_memory_data_out;
data_memory data_memory0(
    .clk(clk),
    .rst(rst),
    .data_width(mem_data_mem_data_width),
    .we(mem_data_mem_we),
    .re(mem_data_mem_re),
    .addr(mem_data_mem_addr),
    .data_in(mem_data_mem_in),

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
wire [11:0] instr_decode_csr_addr;

assign instr_decode_ext_imm = $signed(instr_decode_imm);

instr_decode instr_decode0(
    .ins(id_instr),

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
    .sel(wb_reg_file_sel),
    .a(wb_alu_res),
    .b(wb_data_mem_out),
    .c(wb_pc_out+4),
    .d(wb_csr_data_out),

    .out(reg_file_data_in)
);



// need to be modify
wire [4:0] wb_rs1;
wire wb_reg_file_we;
wire [4:0] wb_reg_file_rd;
wire [1:0] wb_reg_file_sel;
wire [`ARCH_WIDTH-1:0] wb_data_mem_out;
wire [`ARCH_WIDTH-1:0] wb_alu_res;
wire [`ARCH_WIDTH-1:0] wb_pc_out;
wire [2:0] wb_csr_src;
wire [11:0] wb_csr_addr;
wire wb_csr_we;
wire [31:0] wb_csr_data_out;

pipe_mem_wb_reg pipe_mem_wb_reg(
    .clk(clk),
    .rst(rst),
    .flush(1'b0),
    .mem_wb_en(1'b1),
    .mem_wb_stall(1'b0),

    // read from data memory
    .mem_data_mem_out(data_memory_data_out),

    // read from ex_mem
    .mem_reg_file_we(mem_reg_file_we),
    .mem_reg_file_rd(mem_reg_file_rd),
    .mem_reg_file_sel(mem_reg_file_sel),
    .mem_alu_res(mem_alu_res),
    .mem_pc_out(mem_pc_out),

    .mem_csr_src(mem_csr_src),
    .mem_csr_addr(mem_csr_addr),
    .mem_csr_we(mem_csr_we),
    .mem_csr_data_out(mem_csr_data_out),

    .mem_rs1(mem_rs1),

    // for write back
    .wb_rs1(wb_rs1),
    .wb_reg_file_we(wb_reg_file_we),
    .wb_reg_file_rd(wb_reg_file_rd),
    .wb_reg_file_sel(wb_reg_file_sel),
    
    .wb_data_mem_out(wb_data_mem_out),
    .wb_alu_res(wb_alu_res),
    .wb_pc_out(wb_pc_out),
    
    .wb_csr_src(wb_csr_src),
    .wb_csr_addr(wb_csr_addr),
    .wb_csr_we(wb_csr_we),
    .wb_csr_data_out(wb_csr_data_out),

    .debug_mem_instr(debug_mem_instr),
    .debug_wb_instr(debug_wb_instr)
);

reg_file reg_file0(
    .clk(clk),
    .rst(rst),
    .we(wb_reg_file_we),
    .rs1(instr_decode_rs1),
    .rs2(instr_decode_rs2),
    .rd(wb_reg_file_rd),
    .data_in(reg_file_data_in),

    .data_out1(reg_file_data_out1),
    .data_out2(reg_file_data_out2),

    .instr(debug_wb_instr),
    .pc_out(wb_pc_out)
);






/* ------------------ */
/* Instruction Memory */
/* ------------------ */
wire [`INSTR_MEM_WIDTH-1:0] id_pc_out;
wire [`INSTR_WIDTH-1:0] id_instr;

pipe_if_id_reg pipe_if_id_reg(
    .clk(clk),
    .rst(rst),
    .if_id_en(1'b1),
    .if_id_stall(1'b0),
    .if_instr(instr_memory_instr),
    .if_pc_out(pc_out),
    .id_pc_out(id_pc_out),
    .id_instr(id_instr)
);

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
wire csr_we;
wire [2:0] csr_src;
wire [1:0] trap;

wire [2:0] data_width;
wire [3:0] branch_type;


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
    .alu_b_neg(alu_b_neg),
    .alu_op(alu_op),

    .csr_we(csr_we),
    .csr_src(csr_src),
    .trap(trap),

    .data_width(data_width),
    
    .branch_type(branch_type)
);





// ################
// need to modify branch calculation unit and pc
// because I use alu to calculate branch target address in some cases
// (jalr branch)

/* ------------------ */
/* Pc                 */
/* ------------------ */


wire [`ARCH_WIDTH-1:0] branch_target;
wire branch_taken;
branch_cal_unit branch_cal_unit0(
    .id_pc_out(id_pc_out),
    .reg_file_data_out1(reg_file_data_out1),
    .reg_file_data_out2(reg_file_data_out2),
    .imm(instr_decode_imm),
    .branch_type(branch_type),
    .branch_target(branch_target),
    .branch_taken(branch_taken)
);

wire [`INSTR_MEM_WIDTH-1:0] pc_out;

pc pc0(
    .clk(clk),
    .rst(rst),
    
    .branch_taken(branch_taken),
    .branch_target(branch_target),

    .pc_out(pc_out)
);


// ! need to modify
wire [`CSR_WIDTH-1:0] csr_data_out;
wire [`CSR_WIDTH-1:0] csr_data_in;

wire [`CSR_WIDTH-1:0] wb_zimm;
assign wb_zimm = {12'h0, wb_rs1};

mux8_1 mux_csr_data_in(
    .sel(wb_csr_src),
    .a(wb_alu_res),
    .b(wb_reg_file_data_out1),
    .c(wb_zimm),
    .d(32'h0),

    .out(csr_data_in)
);
csrs csrs0(
    .clk(clk),
    .rst(rst),
    .we(wb_csr_we),
    .trap(wb_trap),
    .pc(wb_pc_out),
    .csr_write_addr(wb_csr_addr),
    .csr_write_data(csr_data_in),
    .csr_read_addr(wb_csr_addr),
    .csr_read_data(csr_data_out)
);

assign data_out0 = pc_out[31:0];
assign data_out1 = reg_file_data_out1[31:0];
assign data_out2 = reg_file_data_out2[31:0];
assign data_out3 = ex_alu_res[31:0];
assign data_out4 = alu_a[31:0];
assign data_out5 = alu_a[63:32];
assign data_out6 = alu_b[31:0];
assign data_out7 = alu_b[63:32];

endmodule