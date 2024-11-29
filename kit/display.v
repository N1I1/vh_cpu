module display(
    input clk, // need div clk
    input rst,
    input [31:0] data_in,
    output [7:0] seg_cs,
    output [7:0] seg_data1,
    output [7:0] seg_data2
);
    wire [63:0] tube_datas;
    digital_tube tube0(.data(data_in[3:0]), .seg(tube_datas[7:0]));
    digital_tube tube1(.data(data_in[7:4]), .seg(tube_datas[15:8]));
    digital_tube tube2(.data(data_in[11:8]), .seg(tube_datas[23:16]));
    digital_tube tube3(.data(data_in[15:12]), .seg(tube_datas[31:24]));
    digital_tube tube4(.data(data_in[19:16]), .seg(tube_datas[39:32]));
    digital_tube tube5(.data(data_in[23:20]), .seg(tube_datas[47:40]));
    digital_tube tube6(.data(data_in[27:24]), .seg(tube_datas[55:48]));
    digital_tube tube7(.data(data_in[31:28]), .seg(tube_datas[63:56]));
    segnums segnums0(.clk(clk), .rst(rst), .datas(tube_datas), .seg_cs(seg_cs), .seg_data1(seg_data1), .seg_data2(seg_data2));
endmodule

module segnums(
    input clk,
    input rst,
    input [63:0] datas,
    output reg [7:0] seg_cs,
    output reg [7:0] seg_data1,
    output reg [7:0] seg_data2
  );

  reg [1:0] displace;
  initial begin
      displace = 2'b00;
  end

  always @(posedge clk) begin
      case (displace)
          2'b00:
              begin
                  seg_cs <= 8'b00010001;
                  seg_data2 <= datas[7:0];
                  seg_data1 <= datas[39:32];
                  displace <= 2'b01;
              end
          2'b01:
              begin
                  seg_cs <= 8'b00100010;
                  seg_data2 <= datas[15:8];
                  seg_data1 <= datas[47:40];
                  displace <= 2'b10;
              end
          2'b10:
              begin
                  seg_cs <= 8'b01000100;
                  seg_data2 <= datas[23:16];
                  seg_data1 <= datas[55:48];
                  displace <= 2'b11;
              end
          2'b11:
              begin
                  seg_cs <= 8'b10001000;
                  seg_data2 <= datas[31:24];
                  seg_data1 <= datas[63:56];
                  displace <= 2'b00;
              end
          default:
              begin
                  seg_cs <= 8'b00000000;
                  seg_data2 <= 8'b00000000;
                  seg_data1 <= 8'b00000000;
                  displace <= 2'b00;
              end
      endcase
  end

endmodule

module digital_tube(
    input [3:0] data,
    output reg [7:0] seg
  );
  always @(*)
  begin
    case (data)
      4'b0000:
        seg = 8'hfc; // 0
      4'b0001:
        seg = 8'h60; // 1
      4'b0010:
        seg = 8'hda; // 2
      4'b0011:
        seg = 8'hf2; // 3
      4'b0100:
        seg = 8'h66; // 4
      4'b0101:
        seg = 8'hb6; // 5
      4'b0110:
        seg = 8'hbe; // 6
      4'b0111:
        seg = 8'he0; // 7
      4'b1000:
        seg = 8'hfe; // 8
      4'b1001:
        seg = 8'hf6; // 9
      4'b1010:
        seg = 8'hee; // A
      4'b1011:
        seg = 8'h3e; // B
      4'b1100:
        seg = 8'h9c; // C
      4'b1101:
        seg = 8'h7a; // D
      4'b1110:
        seg = 8'h9e; // E
      4'b1111:
        seg = 8'h8e; // F
    endcase
  end
endmodule