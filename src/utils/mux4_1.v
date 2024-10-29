`include "../include/common.vh"

module mux4_1(
    input   wire    [1:0]   sel,
    input   wire    [`ARCH_WIDTH-1:0]  a,
    input   wire    [`ARCH_WIDTH-1:0]  b,
    input   wire    [`ARCH_WIDTH-1:0]  c,
    input   wire    [`ARCH_WIDTH-1:0]  d,
    output  reg     [`ARCH_WIDTH-1:0]  out
);


    always @(*) begin
        case(sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
        endcase
    end

endmodule