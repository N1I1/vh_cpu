`include "../include/common.vh"

module stall_unit(
    input   [4:0] id_rs1,
    input   [4:0] id_rs2,
    input         use_imm,
    input         branch,
    input         jump,

    input   [4:0] ex_rd,
    input   ex_reg_we,
    input   ex_mem_read,
    input   [4:0] mem_rd,
    input   mem_reg_we,
    input   mem_mem_read,
    input   [4:0] wb_rd,
    input   wb_reg_we,
    output  reg stall
);
    // warning: didn't consider the branch stall the next instruction

    // should support special for forward for branch and jump 
    reg stall_temp;
    always @(*) begin
        if (jump) begin
            // jump need to use the value of rs1
            // if the last instruction is load, then stall and two stall cycles
            if (id_rs1 && ex_mem_read && ex_rd == id_rs1) stall_temp = 1'b1;
            else if (id_rs1 && mem_mem_read && mem_rd == id_rs1) stall_temp = 1'b1;
            else stall_temp = 1'b0;
        end 
        else if (branch) begin
            // branch need to use the value of rs1 and rs2
            if (id_rs1 && ex_mem_read && ex_rd == id_rs1) stall_temp = 1'b1;
            else if (id_rs1 && mem_mem_read && mem_rd == id_rs1) stall_temp = 1'b1;
            else if (id_rs2 && ex_reg_we && ex_rd == id_rs1) stall_temp = 1'b1;
            else if (id_rs2 && mem_reg_we && mem_rd == id_rs1) stall_temp = 1'b1;
            else stall_temp = 1'b0;
        end
        else begin
            // for other instructions.
            // if the last instruction is load, then stall and one stall cycles
            if (id_rs1 && ex_mem_read && ex_rd == id_rs1) stall_temp = 1'b1;
            else if (!use_imm) begin
                if (id_rs2 && ex_mem_read && ex_rd == id_rs2) stall_temp = 1'b1;
                else if (id_rs2 && mem_mem_read && mem_rd == id_rs2) stall_temp = 1'b1;
                else stall_temp = 1'b0;
            end
            else stall_temp = 1'b0;
        end
    end
    assign stall = stall_temp;
endmodule