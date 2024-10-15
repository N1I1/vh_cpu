`include "../include/riscv64/common.vh"

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
            string msg;
            msg = $sformatf("Invalid pc_src: %h", pc_src);
            lg.log_wrong(msg);
            msg = $sformatf("current pc_out: %h", pc_out);
            lg.log_wrong(msg);
            pc_next = pc_out;
        end
    endcase
end

endmodule