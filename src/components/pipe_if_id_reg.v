`include "../include/common.vh"
module pipe_if_id_reg(
    input clk,
    input rst,
    input if_id_en,
    input if_id_stall,
    input flush,
    input [`INSTR_WIDTH-1:0] if_instr,
    input [`INSTR_MEM_WIDTH-1:0] if_pc_out,
    output reg [`INSTR_MEM_WIDTH-1:0] id_pc_out,
    output reg [`INSTR_WIDTH-1:0] id_instr
);
    
    always @(posedge clk) begin
        if (rst) begin
            id_pc_out <= `ARCH_WIDTH'h0; // need to modify;
            id_instr <= `INSTR_WIDTH'h13;
        end else if (if_id_en) begin
            if (if_id_stall) begin
                id_pc_out <= id_pc_out;
                id_instr <= id_instr;
            end else if (flush) begin
                id_pc_out <= `ARCH_WIDTH'h0;
                id_instr <= `INSTR_WIDTH'h13; // nop instr
            end else begin
                id_pc_out <= if_pc_out;
                id_instr <= if_instr;
            end
        end else begin
            id_pc_out <= id_pc_out;
            id_instr <= id_instr;
        end
    end
endmodule