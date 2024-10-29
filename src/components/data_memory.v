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

    reg [`DATA_WIDTH-1:0] ram [0:`DATA_MEM_SIZE-1];

    initial begin
        $readmemh("assets/data_memory.hex", ram);
    end

    always @(posedge clk) begin
        if (rst)
            for (i = 0; i < 1024; i = i + 1) begin
                ram[i] = 0;
            end
        else if (we) begin
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