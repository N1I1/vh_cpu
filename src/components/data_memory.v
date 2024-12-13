`include "../include/common.vh"

module data_memory (
    input   wire                            clk,
    input   wire                            rst,
    input   wire    [2:0]                   data_width,
    input   wire    [`DATA_MEM_WIDTH-1:0]   addr,
    input   wire                            we,
    input   wire                            re,
    input   wire    [`DATA_WIDTH-1:0]       data_in,
    output  reg     [`DATA_WIDTH-1:0]       data_out
    );
    integer i;

    reg [`DATA_WIDTH-1:0] ram [0:31];

    initial begin
        ram[0] = 64'h1111111111111111;
        ram[1] = 64'h2222222222222222;
        ram[2] = 64'h3333333333333333;
        ram[3] = 64'h4444444444444444;
        ram[4] = 64'h5555555555555555;
        ram[5] = 64'h6666666666666666;
        ram[6] = 64'h7777777777777777;
    end

    always @(posedge clk) begin
        if (we) begin
            if (data_width == 0)
                ram[addr] <= data_in[7:0];
            else if (data_width == 1)
                ram[addr] <= data_in[15:0];
            else if (data_width == 2)
                ram[addr] <= data_in[31:0];
            else if (data_width == 3)
                ram[addr] <= data_in;
        end
    end
    
    always @(*) begin
        if (re) begin
            if (data_width == 0)
                data_out <= ram[addr][7:0];
            else if (data_width == 1)
                data_out <= ram[addr][15:0];
            else if (data_width == 2)
                data_out <= ram[addr][31:0];
            else if (data_width == 3)
                data_out <= ram[addr][63:0];
            else
                data_out <= 0;
        end else data_out <= 0;
    end
endmodule