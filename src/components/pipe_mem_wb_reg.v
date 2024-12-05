`include "../include/common.vh"

module pipe_mem_wb_reg(
    input clk,
    input rst,
    input flush,
    input mem_wb_en,

    input [`DATA_WIDTH-1:0] mem_data_mem_out,

    input mem_reg_file_we,
    input [4:0] mem_reg_file_rd,
    input [1:0] mem_reg_file_sel,

    input [`ARCH_WIDTH-1:0] mem_alu_res,
    input [`ARCH_WIDTH-1:0] mem_pc_out,

    input [2:0] mem_csr_src,
    input [11:0] mem_csr_addr,
    input mem_csr_we,
    input [31:0] mem_csr_data_out,

    input [4:0] mem_rs1,
    output reg [4:0] wb_rs1,

    output reg wb_reg_file_we,
    output reg [4:0] wb_reg_file_rd,
    output reg [1:0] wb_reg_file_sel,
    output reg [`DATA_WIDTH-1:0] wb_data_mem_out,
    output reg [`ARCH_WIDTH-1:0] wb_alu_res,
    output reg [`ARCH_WIDTH-1:0] wb_pc_out,

    output reg [2:0] wb_csr_src,
    output reg [11:0] wb_csr_addr,
    output reg wb_csr_we,
    output reg [31:0] wb_csr_data_out,

    input mem_stall,
    output reg wb_stall,
    input [31:0] debug_mem_instr,
    output reg [31:0] debug_wb_instr
);
    always @(posedge clk) begin
        if (rst) begin
            wb_rs1 <= 5'b0;
            wb_reg_file_we <= 1'b0;
            wb_reg_file_rd <= 5'b0;
            wb_reg_file_sel <= 2'b0;
            wb_data_mem_out <= `DATA_WIDTH-1'h0;
            wb_alu_res <= `ARCH_WIDTH-1'h0;
            wb_pc_out <= `ARCH_WIDTH-1'h0;
            wb_csr_addr <= 12'h0;
            wb_csr_we <= 1'b0;
            wb_csr_data_out <= 32'h0;
            
            wb_stall <= 1'b0;
            debug_wb_instr <= 32'h13;
        end else if (mem_wb_en) begin
            wb_rs1 <= mem_rs1;
            wb_reg_file_we <= mem_reg_file_we;
            wb_reg_file_rd <= mem_reg_file_rd;
            wb_reg_file_sel <= mem_reg_file_sel;
            wb_data_mem_out <= mem_data_mem_out;
            wb_alu_res <= mem_alu_res;
            wb_pc_out <= mem_pc_out;
            wb_csr_addr <= mem_csr_addr;
            wb_csr_we <= mem_csr_we;
            wb_csr_data_out <= mem_csr_data_out;

            wb_stall <= mem_stall;
            debug_wb_instr <= debug_mem_instr;
        end
    end
endmodule