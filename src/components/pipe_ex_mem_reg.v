`include "../include/common.vh"

module pipe_ex_mem_reg(
    input clk,
    input rst,
    input ex_mem_en,
    input flush,
    
    input [`ARCH_WIDTH-1:0] ex_alu_res,
    input ex_alu_zero,


    // read from id_ex_reg
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,
    input [31:0] ex_imm,
    input [2:0] ex_data_width,
    input [`DATA_MEM_WIDTH-1:0] ex_data_addr,
    input ex_data_we,
    input ex_data_re,
    input [`DATA_WIDTH-1:0] ex_data_in,

    input ex_reg_file_we,
    input [4:0] ex_reg_file_rd,
    input [1:0] ex_reg_file_sel, 

    input [`ARCH_WIDTH-1:0] ex_pc_out,

    input [2:0] ex_csr_src,
    input [11:0] ex_csr_addr,
    input ex_csr_we,
    input [31:0] ex_csr_data_out,

    // for mem access stage
    output reg [4:0] mem_rs1,
    output reg [4:0] mem_rs2,
    output reg [31:0] mem_imm,
    output reg [2:0] mem_data_mem_data_width,
    output reg [`DATA_MEM_WIDTH-1:0] mem_data_mem_addr,
    output reg mem_data_mem_we,
    output reg mem_data_mem_re,
    output reg [`DATA_WIDTH-1:0] mem_data_mem_in,

    output reg mem_reg_file_we,
    output reg [4:0] mem_reg_file_rd,
    output reg [1:0] mem_reg_file_sel,
    output reg [`ARCH_WIDTH-1:0] mem_alu_res,
    output reg [`ARCH_WIDTH-1:0] mem_pc_out,

    // to be added:
    output reg [2:0] mem_csr_src,
    output reg [11:0] mem_csr_addr,
    output reg mem_csr_we,
    output reg [31:0] mem_csr_data_out,

    input ex_stall,
    output reg mem_stall,
    input [31:0] debug_ex_instr,
    output reg [31:0] debug_mem_instr
    );
    always @(posedge clk) begin
        if (rst) begin
            mem_rs1 <= 5'h0;
            mem_rs2 <= 5'h0;
            mem_imm <= 32'h0;
            mem_data_mem_data_width <= 3'b0;
            mem_data_mem_addr <= `DATA_MEM_WIDTH'h0;
            mem_data_mem_we <= 1'b0;
            mem_data_mem_re <= 1'b0;
            mem_data_mem_in <= `DATA_WIDTH'h0;

            mem_reg_file_we <= 1'b0;
            mem_reg_file_rd <= 5'b0;
            mem_reg_file_sel <= 2'b0;
            mem_alu_res <= `ARCH_WIDTH'h0;
            mem_pc_out <= `ARCH_WIDTH'h0;

            mem_csr_src <= 3'b0;
            mem_csr_addr <= 12'h0;
            mem_csr_we <= 1'b0;
            mem_csr_data_out <= 32'h0;

            mem_stall <= 1'b0;
            debug_mem_instr <= 32'h13;
        end else if (ex_mem_en) begin
            mem_rs1 <= ex_rs1;
            mem_rs2 <= ex_rs2;
            mem_imm <= ex_imm;
            mem_data_mem_data_width <= ex_data_width;
            mem_data_mem_addr <= ex_data_addr;
            mem_data_mem_we <= ex_data_we;
            mem_data_mem_re <= ex_data_re;
            mem_data_mem_in <= ex_data_in;

            mem_reg_file_we <= ex_reg_file_we;
            mem_reg_file_rd <= ex_reg_file_rd;
            mem_reg_file_sel <= ex_reg_file_sel;
            mem_alu_res <= ex_alu_res;
            mem_pc_out <= ex_pc_out;

            mem_csr_src <= ex_csr_src;
            mem_csr_addr <= ex_csr_addr;
            mem_csr_we <= ex_csr_we;
            mem_csr_data_out <= ex_csr_data_out;

            mem_stall <= ex_stall;
            debug_mem_instr <= debug_ex_instr;
        end
    end
endmodule