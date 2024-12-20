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
    
    // Parameters for data width
    localparam BYTE = 3'b000;
    localparam HALF = 3'b001;
    localparam WORD = 3'b010;
    localparam DWORD = 3'b011;
    
    integer i;
    reg [7:0] ram [0:1024];

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1)
                ram[i] <= 8'h0;
        end
    end

    always @(posedge clk) begin
        if (!rst && we) begin
            case (data_width)
                BYTE: ram[addr] <= data_in[7:0];
                HALF: begin
                    ram[addr]   <= data_in[7:0];
                    ram[addr+1] <= data_in[15:8];
                end
                WORD: begin
                    ram[addr]   <= data_in[7:0];
                    ram[addr+1] <= data_in[15:8];
                    ram[addr+2] <= data_in[23:16];
                    ram[addr+3] <= data_in[31:24];
                end
                DWORD: begin
                    ram[addr]   <= data_in[7:0];
                    ram[addr+1] <= data_in[15:8];
                    ram[addr+2] <= data_in[23:16];
                    ram[addr+3] <= data_in[31:24];
                    ram[addr+4] <= data_in[39:32];
                    ram[addr+5] <= data_in[47:40];
                    ram[addr+6] <= data_in[55:48];
                    ram[addr+7] <= data_in[63:56];
                end
            endcase
        end
    end

    always @(*) begin
        if (!rst && re) begin
            case (data_width)
                BYTE:   data_out = {56'h0, ram[addr]};
                HALF:   data_out = {48'h0, ram[addr+1], ram[addr]};
                WORD:   data_out = {32'h0, ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
                DWORD:  data_out = {ram[addr+7], ram[addr+6], ram[addr+5], ram[addr+4], 
                                  ram[addr+3], ram[addr+2], ram[addr+1], ram[addr]};
                default: data_out = 64'h0;
            endcase
        end else begin
            data_out = 64'h0;
        end
    end
endmodule