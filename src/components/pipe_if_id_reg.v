`include "../include/common.vh"
module pipe_if_id_reg(
    input clk,
    input rst,
    input if_id_en,
    input if_stall,
    input flush,
    input [`INSTR_WIDTH-1:0] if_instr,
    input [`INSTR_MEM_WIDTH-1:0] if_pc_out,
    output reg [`INSTR_MEM_WIDTH-1:0] id_pc_out,
    output reg [`INSTR_WIDTH-1:0] id_instr,
    output reg id_stall,
    output reg id_flush
);
    
    always @(posedge clk) begin
        if (rst) begin
            id_pc_out <= `ARCH_WIDTH'h0;
            id_instr <= `INSTR_WIDTH'h13;
        end else if (if_id_en) begin
            if (if_stall) begin
                id_pc_out <= id_pc_out;
                id_instr <= id_instr;
                id_stall <= if_stall;
                id_flush <= 1'b0;
            end else if (flush) begin
                id_pc_out <= `ARCH_WIDTH'h0;
                id_instr <= `INSTR_WIDTH'h13; // nop instr
                id_stall <= 1'b1;
                id_flush <= 1'b1;
            end else begin
                id_pc_out <= if_pc_out;
                id_instr <= if_instr;
                id_stall <= 1'b0;
                id_flush <= 1'b0;
            end
        end else begin
            id_pc_out <= id_pc_out;
            id_instr <= id_instr;
            id_flush <= id_flush;
        end
    end
endmodule