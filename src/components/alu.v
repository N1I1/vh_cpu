`include "../include/common.vh"

module alu(
    input       [`ARCH_WIDTH-1:0]     a,
    input       [`ARCH_WIDTH-1:0]     b,
    input       [`ALU_OP_WIDTH-1:0]   op,
    input       [2:0]                 data_width,
    output reg  [`ARCH_WIDTH-1:0]     res,
    output wire                       zero
);

    reg [`ARCH_WIDTH-1:0]     alu_res_temp;

    always @(*) begin
        case (op)
            `ALU_ADD: begin
                alu_res_temp = a + b;
            end
            `ALU_SUB: begin
                alu_res_temp = a - b;
            end
            `ALU_AND: begin
                alu_res_temp = a & b;
            end
            `ALU_OR: begin
                alu_res_temp = a | b;
            end
            `ALU_XOR: begin
                alu_res_temp = a ^ b;
            end
            `ALU_SLL: begin
                alu_res_temp = a << b[4:0];
            end
            `ALU_SRL: begin
                alu_res_temp = a >> b[4:0];
            end
            `ALU_SRA: begin
                alu_res_temp = a >>> b[4:0];
            end
            `ALU_SLT: begin
                alu_res_temp = (a < b) ? 1 : 0;
            end
            `ALU_SLTU: begin
                alu_res_temp = (a < b) ? 1 : 0;
            end
            `ALU_COPY1: begin
                alu_res_temp = a;
            end
            `ALU_COPY2: begin
                alu_res_temp = b;
            end
            `ALU_JALR: begin
                alu_res_temp = (a + b) & ~1;
            end
            default: begin
                $display("Invalid ALU operation: %b", op);
            end
        endcase
    end

    always @(*) begin
        res = alu_res_temp;
    end

    assign zero = (res == 0);

endmodule