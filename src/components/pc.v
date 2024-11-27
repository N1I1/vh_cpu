`include "../include/common.vh"

module pc(
    input                               clk,
    input                               rst,

    input                               branch_taken,
    input  [`INSTR_MEM_WIDTH-1:0]       branch_target,

    output reg [`INSTR_MEM_WIDTH-1:0]       pc_out
);


always @(posedge clk) begin
    if (rst) begin
        // to adapt to spike, pc start from 0x1000. More details in spike/build/spike.log
        pc_out <= `INSTR_MEM_WIDTH'h0000;
    end else if (branch_taken) begin
        pc_out <= branch_target;
    end else begin
        pc_out <= pc_out + 4;
    end
end
endmodule