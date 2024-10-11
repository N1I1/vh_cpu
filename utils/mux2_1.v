`include "../include/riscv64/common.vh"

module mux2_1(
    input   wire    sel,
    input   wire    [`ARCH_WIDTH-1:0] a,
    input   wire    [`ARCH_WIDTH-1:0] b,
    output  wire    [`ARCH_WIDTH-1:0] out
);

    assign out = (sel == 1'b0) ? a : b;

endmodule