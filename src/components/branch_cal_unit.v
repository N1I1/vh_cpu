`include "../include/common.vh"

module branch_cal_unit(
    input [`ARCH_WIDTH-1:0] id_pc_out,
    input [`ARCH_WIDTH-1:0] reg_file_data_out1,
    input [`ARCH_WIDTH-1:0] reg_file_data_out2,
    input [`ARCH_WIDTH-1:0] imm,
    input [3:0] branch_type,
    // 0: no jump // 1: jal // 2: jalr // 3: beq
    // 4: bne // 5: blt // 6: bge // 7: bltu // 8: bgeu
    output reg [`ARCH_WIDTH-1:0] branch_target,
    output reg branch_taken
);
    always @(*) begin
        branch_target = `ARCH_WIDTH'h0;
        branch_taken = 1'b0;

        case (branch_type)
            4'b0000: begin
                branch_taken = 1'b0;
            end
            4'b0001: begin
                branch_target = id_pc_out + imm;
                branch_taken = 1'b1;
            end
            4'b0010: begin
                branch_target = (reg_file_data_out1 + imm) & `ARCH_WIDTH'hfffffffe;
                branch_taken = 1'b1;
            end
            4'b0011: begin
                    branch_taken = (reg_file_data_out1 == reg_file_data_out2);
                    branch_target = id_pc_out + imm;
            end
            4'b0100: begin
                    branch_taken = (reg_file_data_out1 != reg_file_data_out2);
                    branch_target = id_pc_out + imm;
            end
            4'b0101: begin
                    branch_taken = ($signed(reg_file_data_out1) < $signed(reg_file_data_out2));
                    branch_target = id_pc_out + imm;
            end
            4'b0110: begin
                    branch_taken = ($signed(reg_file_data_out1) >= $signed(reg_file_data_out2));
                    branch_target = id_pc_out + imm;
            end
            4'b0111: begin
                    branch_taken = (reg_file_data_out1 < reg_file_data_out2);
                    branch_target = id_pc_out + imm;
            end
            4'b1000: begin
                    branch_taken = (reg_file_data_out1 >= reg_file_data_out2);
                    branch_target = id_pc_out + imm;
            end
        endcase
    end
endmodule