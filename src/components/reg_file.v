`include "../include/common.vh"

module reg_file(
    input                       clk,
    input                       rst,
    input                       we,
    input   [4:0]               rs1,
    input   [4:0]               rs2,
    input   [4:0]               rd,
    input   [`ARCH_WIDTH-1:0]   data_in,
    output  [`ARCH_WIDTH-1:0]   data_out1,
    output  [`ARCH_WIDTH-1:0]   data_out2,

    input   [`INSTR_WIDTH-1:0] instr,
    input   [`INSTR_MEM_WIDTH-1:0] pc_out
);
    integer i;
    reg [`ARCH_WIDTH-1:0]         regs [31:0];

    assign data_out1 = regs[rs1];
    assign data_out2 = regs[rs2];

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 0;
        end

    end

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] = 0;
            end
        end else if (we) begin
            if (rd != 0)
                regs[rd] <= data_in;
        end
    end




    // When use vivado to simulate, the following code will should be deleted or commented
    Logger lg();
    always @(negedge clk) begin
        string msg;
        msg = $sformatf("0x%016h (0x%08h)\n", pc_out, instr);
        lg.write_log(msg);

        for (integer i = 0; i < 32; i = i + 1) begin
            if (we && i == rd && i > 0) begin
                if (i < 10)
                    msg = $sformatf("x%01d:0x%016h", i, data_in);
                else
                    msg = $sformatf("x%02d:0x%016h", i, data_in);
            end else if (i < 10) begin
                msg = $sformatf("x%01d:0x%016h", i, regs[i]);
            end else begin
                msg = $sformatf("x%02d:0x%016h", i, regs[i]);
            end
            lg.write_log(msg);

            if (i % 4 == 3) begin
                msg = $sformatf("\n");
            end else begin
                msg = $sformatf(" ");
            end

            lg.write_log(msg);
        end
        msg = $sformatf("\n");
        lg.write_log(msg);
    end

endmodule