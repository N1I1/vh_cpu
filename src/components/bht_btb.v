`include "../include/common.vh"

module bht_btb #(
    parameter ADDR_WIDTH = 10,
    parameter BHT_ENTRIES = 256,
    parameter BTB_ENTRIES = 256
) (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire branch_taken,
    input wire [ADDR_WIDTH-1:0] branch_pc,
    input wire [ADDR_WIDTH-1:0] target_addr,
    input wire [ADDR_WIDTH-1:0] cur_pc,
    output reg [1:0] prediction,
    output reg [ADDR_WIDTH-1:0] addr_predicted
);

    reg [1:0] bht [0:BHT_ENTRIES-1];
    reg [ADDR_WIDTH-1:0] btb [0:BTB_ENTRIES-1];

    wire [ADDR_WIDTH-1:0] bht_index = branch_pc[ADDR_WIDTH-1:0] % BHT_ENTRIES;
    wire [ADDR_WIDTH-1:0] btb_index = branch_pc[ADDR_WIDTH-1:0] % BTB_ENTRIES;

    always @(posedge clk or posedge rst) begin
        $display("curpc = %x, mod 256 = %x, addr_predicted = %x",cur_pc, cur_pc%BHT_ENTRIES, addr_predicted);
        if (rst) begin
            integer i;
            for (i = 0; i < BHT_ENTRIES; i = i + 1) begin
                bht[i] <= 2'b01;
            end
            for (i = 0; i < BTB_ENTRIES; i = i + 1) begin
                btb[i] <= 0;
            end
        end else if (enable) begin
            if (branch_taken) begin
                if (bht[bht_index] < 2'b11) begin
                    bht[bht_index] <= bht[bht_index] + 1;
                end
            end else begin
                if (bht[bht_index] > 2'b00) begin
                    bht[bht_index] <= bht[bht_index] - 1;
                end
            end

            if (branch_taken) begin
                btb[btb_index] <= target_addr;
                $display("branch_taken: bht_index = %x, target_addr = %x", bht_index, target_addr);
                $display("btb[btb_index] = %x", btb[btb_index]);
            end
        end
    end

    always @(*) begin
        prediction = bht[cur_pc % BHT_ENTRIES];
        addr_predicted = (bht[cur_pc % BHT_ENTRIES] >= 2'b10) ? btb[cur_pc % BTB_ENTRIES] : cur_pc + 4;
    end

endmodule