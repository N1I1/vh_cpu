`include "../include/common.vh"

module pc(
    input                               clk,
    input                               rst,
    input                               stall,
    input                               branch_taken,
    input  [`INSTR_MEM_WIDTH-1:0]       branch_target,
    input  [1:0]                        prediction,
    input  [`INSTR_MEM_WIDTH-1:0]       addr_predicted,

    output reg [`INSTR_MEM_WIDTH-1:0]       pc_out
);


always @(posedge clk) begin
    if (rst) begin
        // to adapt to spike, pc start from 0x1000. More details in spike/build/spike.log
        pc_out <= `INSTR_MEM_WIDTH'h0000;
    end else if (branch_taken && pc_out != branch_target) begin
        pc_out <= branch_target;
    end else if (stall) begin
        pc_out <= pc_out;
    end else if (prediction>1)begin
        pc_out <= addr_predicted;
    end else begin
        pc_out <= pc_out + 4;
    end
end
endmodule