`include "../include/common.vh"
module pipe_if_id_reg(
    input clk,
    input rst,
    input if_id_en,
    input if_id_stall,
    input [`INSTR_WIDTH-1:0] instr,
    input [`INSTR_MEM_WIDTH-1:0] pc_out,
    output reg [`INSTR_MEM_WIDTH-1:0] if_id_pc_out,
    output reg [`INSTR_WIDTH-1:0] if_id_instr
);
    
    always @(posedge clk) begin
        if (rst) begin
            if_id_pc_out <= `ARCH_WIDTH-1'h0; // need to modify;
            if_id_instr <= `INSTR_WIDTH-1'h0;
        end else if (if_id_en) begin
            if (if_id_stall) begin
                if_id_pc_out <= if_id_pc_out;
                if_id_instr <= if_id_instr;
            end else if (flush) begin
                if_id_pc_out <= `ARCH-1'h0;
                if_id_instr <= `INSTR_WIDTH-1'h13; // nop instr
            end else begin
                if_id_pc_out <= pc_out;
                if_id_instr <= instr;
            end
        end else begin
            if_id_pc_out <= if_id_pc_out;
            if_id_instr <= if_id_instr;
        end
    end
endmodule