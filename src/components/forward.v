module forward(
    input [4:0] id_rs1,
    input [4:0] id_rs2,
    input branch,
    input jump,
    input [4:0] ex_mem_rd,
    input ex_mem_reg_we,
    input [4:0] mem_wb_rd,
    input mem_ex_reg_we,
    output reg [1:0] forward_a,
    // 2'b00: no forwarding
    // 2'b10: forward from ex_mem latch : mem_alu_res
    // 2'b11: forward from mem_wb latch : reg_file_data_in
    output reg [1:0] forward_b
    // 2'b00: no forwarding
    // 2'b10: forward from ex_mem latch : mem_alu_res
    // 2'b11: forward from mem_wb latch : reg_file_data_in
);

    // forward for branch and jump

    always @(*) begin
        if(jump) begin
            if(id_rs1 && ex_mem_reg_we && ex_mem_rd == id_rs1) forward_a = 2'b10;
            else if(id_rs1 && mem_ex_reg_we && mem_wb_rd == id_rs1) forward_a = 2'b11;
            else forward_a = 2'b00;
        end else if(branch) begin
            if(id_rs1 && ex_mem_reg_we && ex_mem_rd == id_rs1) forward_a = 2'b10;
            else if(id_rs1 && mem_ex_reg_we && mem_wb_rd == id_rs1) forward_a = 2'b11;
            else if(id_rs2 && ex_mem_reg_we && ex_mem_rd == id_rs2) forward_b = 2'b10;
            else if(id_rs2 && mem_ex_reg_we && mem_wb_rd == id_rs2) forward_b = 2'b11;
            else forward_a = 2'b00;
            forward_b = 2'b00;
        end else begin
            if(id_rs1 && ex_mem_reg_we && ex_mem_rd == id_rs1) forward_a = 2'b10;
            else if(id_rs1 && mem_ex_reg_we && mem_wb_rd == id_rs1) forward_a = 2'b11;
            else if(id_rs2 && ex_mem_reg_we && ex_mem_rd == id_rs2) forward_b = 2'b10;
            else if(id_rs2 && mem_ex_reg_we && mem_wb_rd == id_rs2) forward_b = 2'b11;
            else forward_a = 2'b00;
            forward_b = 2'b00;
        end
    end
endmodule