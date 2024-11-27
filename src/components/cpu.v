`include "../include/common.vh"

module cpu(
    input   clk,
    input   rst,

    output  [31:0]                 data_out0,
    output  [31:0]                 data_out1,
    output  [31:0]                 data_out2,
    output  [31:0]                 data_out3,
    output  [31:0]                 data_out4,
    output  [31:0]                 data_out5,
    output  [31:0]                 data_out6,
    output  [31:0]                 data_out7
    );
    data_path dp(
        .clk(clk),
        .rst(rst),
        .data_out0(data_out0),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .data_out3(data_out3),
        .data_out4(data_out4),
        .data_out5(data_out5),
        .data_out6(data_out6),
        .data_out7(data_out7)
    );

endmodule