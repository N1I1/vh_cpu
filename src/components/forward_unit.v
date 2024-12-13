module forward_unit(
    input   [4:0] ex_rs1,
    input   [4:0] ex_rs2,
    input         use_imm,
    input   [4:0] mem_rd,
    input   mem_reg_we,
    input   [4:0] wb_rd,
    input   wb_reg_we,
    output  [1:0] forward_a,
    // 2'b00: no forwarding
    // 2'b10: forward from ex_mem latch : mem_alu_res
    // 2'b11: forward from mem_wb latch : reg_file_data_in
    output  [1:0] forward_b
    // 2'b00: no forwarding
    // 2'b10: forward from ex_mem latch : mem_alu_res
    // 2'b11: forward from mem_wb latch : reg_file_data_in
);

    reg [1:0] forward_a_reg;
    reg [1:0] forward_b_reg;

    always @(*) begin
        forward_a_reg = 2'b00;
        forward_b_reg = 2'b00;

        if (ex_rs1 && wb_reg_we && wb_rd == ex_rs1) forward_a_reg = 2'b11;
        else if (ex_rs1 && mem_reg_we && mem_rd == ex_rs1) forward_a_reg = 2'b10;
        else forward_a_reg = 2'b00;

        if (!use_imm) begin 
            if (ex_rs2 && wb_reg_we && wb_rd == ex_rs2) forward_b_reg = 2'b11;
            else if (ex_rs2 && mem_reg_we && mem_rd == ex_rs2) forward_b_reg = 2'b10;
            else forward_b_reg = 2'b00;
        end else forward_b_reg = 2'b00;
    end

    assign forward_a = forward_a_reg;
    assign forward_b = forward_b_reg;

endmodule