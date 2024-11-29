module debug(
    input clk,
    input rst,
    input [31:0] debug_data0,
    input [31:0] debug_data1,
    input [31:0] debug_data2,
    input [31:0] debug_data3,
    input [31:0] debug_data4,
    input [31:0] debug_data5,
    input [31:0] debug_data6,
    input [31:0] debug_data7,
    input [15:0] switchs,
    output [7:0] seg_cs,
    output [7:0] seg_data1,
    output [7:0] seg_data2,
    output flip_rst,
    output div_clk
    );

    // div_clk  flip_rst
    reg [15:0] cnt;
    reg div_clk;
    parameter max_cnt = 50000;
    wire tmp_rst;

    assign tmp_rst = ~rst;
    assign flip_rst = tmp_rst;
    always @(posedge clk) begin
        if (flip_rst)
            cnt <= 16'h0;
        else if (cnt == max_cnt) begin
            cnt <= 16'h0;
            div_clk <= ~div_clk;
        end
        else
            cnt <= cnt + 16'h1;
    end

    reg [31:0] tube_data_in;
    always @(*) begin
        case (switchs[14:12])
            3'b000: tube_data_in = debug_data0;
            3'b001: tube_data_in = debug_data1;
            3'b010: tube_data_in = debug_data2;
            3'b011: tube_data_in = debug_data3;
            3'b100: tube_data_in = debug_data4;
            3'b101: tube_data_in = debug_data5;
            3'b110: tube_data_in = debug_data6;
            3'b111: tube_data_in = debug_data7;
            default: tube_data_in = 32'h0;
        endcase
    end

    tube tube0(.clk(div_clk), .rst(tmp_rst), .data_in(tube_data_in),.seg_cs(seg_cs), .seg_data1(seg_data1), .seg_data2(seg_data2));
    

    initial begin
        div_clk = 1'b0;
        cnt = 16'h0;
    end
endmodule
