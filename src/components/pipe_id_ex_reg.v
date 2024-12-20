`include "../include/common.vh"

module pipe_id_ex_reg(
    input clk,
    input rst,
    input id_ex_en,
    input flush,

    input [`ARCH_WIDTH-1:0] id_reg_file_data_out1,
    input [`ARCH_WIDTH-1:0] id_reg_file_data_out2,
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input rs2_use_imm,
    input [31:0] id_imm,

    input id_data_mem_we,
    input id_data_mem_re,

    input [4:0] id_reg_file_rd,
    input id_reg_file_we,
    input [1:0] id_reg_file_sel,
    input [`ARCH_WIDTH-1:0] id_pc_out,
    input id_csr_we,
    input [2:0] id_csr_src,
    input [11:0] id_csr_addr,
    input [31:0] id_csr_data_out,
    input [1:0] id_alu_a_src,
    input [1:0] id_alu_b_src,
    input id_alu_b_neg,
    input [`ALU_OP_WIDTH-1:0] id_alu_op,
    input [2:0] id_data_width,


    output reg [1:0] ex_alu_a_src,
    output reg [1:0] ex_alu_b_src,
    output reg ex_alu_b_neg,
    output reg [`ALU_OP_WIDTH-1:0] ex_alu_op,
    output reg [2:0] ex_data_width,
    output reg [31:0] ex_imm,
    output reg [`ARCH_WIDTH-1:0] ex_reg_file_data_out1,
    output reg [`ARCH_WIDTH-1:0] ex_reg_file_data_out2,
    output reg [4:0] ex_rs1,
    output reg [4:0] ex_rs2,
    output reg ex_use_imm,

    output reg [4:0] ex_reg_file_rd,
    output reg ex_reg_file_we,
    output reg [1:0] ex_reg_file_sel,
    output reg [`ARCH_WIDTH-1:0] ex_pc_out,

    output reg ex_data_mem_we,
    output reg ex_data_mem_re,
    output reg [2:0] ex_data_mem_data_width,
    output reg [`DATA_WIDTH-1:0] ex_data_mem_in,
    
    output reg ex_csr_we,
    output reg [2:0] ex_csr_src,
    output reg [11:0] ex_csr_addr,
    output reg [31:0] ex_csr_data_out,

    input id_stall,
    output reg ex_stall,
    input  [31:0] debug_id_instr,
    output reg [31:0] debug_ex_instr
    );
    always @(posedge clk) begin
        if (rst | id_stall|flush) begin
            ex_alu_a_src <= 2'b0;
            ex_alu_b_src <= 2'b0;
            ex_alu_b_neg <= 1'b0;
            ex_alu_op <= `ALU_OP_WIDTH'h0;
            ex_data_width <= 3'b0;
            ex_use_imm <= 1'b0;
            ex_imm <= 32'h0;
            ex_reg_file_data_out1 <= `ARCH_WIDTH'h0;
            ex_reg_file_data_out2 <= `ARCH_WIDTH'h0;
            ex_rs1 <= 5'b0;
            ex_rs2 <= 5'b0;
            ex_reg_file_rd <= 5'b0;
            ex_reg_file_we <= 1'b0;
            ex_reg_file_sel <= 2'b0;
            ex_pc_out <= `ARCH_WIDTH'h0;
            ex_data_mem_we <= 1'b0;
            ex_data_mem_re <= 1'b0;
            ex_data_mem_data_width <= 3'b0;
            ex_data_mem_in <= `DATA_WIDTH'h0;
            ex_csr_we <= 1'b0;
            ex_csr_src <= 3'b0;
            ex_csr_addr <= 12'h0;
            ex_csr_data_out <= 32'h0;

            ex_stall <= 1'h1;
            debug_ex_instr <= 32'h13;
        end else if (id_ex_en) begin
            ex_alu_a_src <= id_alu_a_src;
            ex_alu_b_src <= id_alu_b_src;
            ex_alu_b_neg <= id_alu_b_neg;
            ex_alu_op <= id_alu_op;
            ex_data_width <= id_data_width;
            ex_use_imm <= rs2_use_imm;
            ex_imm <= id_imm;
            ex_reg_file_data_out1 <= id_reg_file_data_out1;
            ex_reg_file_data_out2 <= id_reg_file_data_out2;
            ex_rs1 <= id_rs1;
            ex_rs2 <= id_rs2;
            ex_reg_file_rd <= id_reg_file_rd;
            ex_reg_file_we <= id_reg_file_we;
            ex_reg_file_sel <= id_reg_file_sel;
            ex_pc_out <= id_pc_out;

            ex_data_mem_we <= id_data_mem_we;
            ex_data_mem_re <= id_data_mem_re;
            ex_data_mem_data_width <= id_data_width;
            ex_data_mem_in <= id_reg_file_data_out2;

            ex_csr_src <= id_csr_src;
            ex_csr_addr <= id_csr_addr;
            ex_csr_data_out <= id_csr_data_out;

            ex_stall <= flush | id_stall;
            debug_ex_instr <= debug_id_instr;
        end
    end
endmodule