`include "../include/common.vh"

module pc(
    input                               clk,
    input                               rst,
    input      [2:0]                    pc_src,
    input      [`INSTR_MEM_WIDTH-1:0]   tar_addr,
    input      [`INSTR_MEM_WIDTH-1:0]   alu_res,
    input                               alu_zero,

    output reg [`INSTR_MEM_WIDTH-1:0]       pc_out
);

Logger lg();

reg [31:0] pc_next;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // to adapt to spike, pc start from 0x1000. More details in spike/build/spike.log
        pc_out <= 32'h1000;
        pc_next <= 32'h1000;
    end
    else 
        pc_out <= pc_next;
end

always @(*) begin
    case (pc_src)
        3'b000: pc_next = pc_out + 4;
        3'b001: begin
            if (alu_zero)
                pc_next = tar_addr;
            else
                pc_next = pc_out + 4;
        end
        3'b010: begin
            if (!alu_zero)
                pc_next = tar_addr;
            else
                pc_next = pc_out + 4;
        end
        3'b011: pc_next = tar_addr;
        3'b100: pc_next = alu_res;
        default: begin
            $display("Invalid pc_src: %h", pc_src);
            $display("current pc_out: %h", pc_out);
            pc_next = pc_out;
        end
    endcase
end

endmodule