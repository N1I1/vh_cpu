`include "../include/common.vh"

module instr_memory(
    input   wire                            clk,
    input   wire    [`INSTR_MEM_WIDTH-1:0]  instr_addr,
    input   wire                            re,
    output  wire     [`INSTR_WIDTH-1:0]      instr
);

    reg [`INSTR_WIDTH-1:0] instr_mem[0:`INSTR_MEM_SIZE-1];

    initial begin
        // $readmemh("assets/instr_memory.hex", instr_mem);
        instr_mem[0] = 32'h0x00003083; // ld x1, 0(x0)
        // instr_mem[0] = 32'h0x00108093; // addi x1, x1, 0x1
        instr_mem[1] = 32'h0x00108093; // addi x1, x1, 0x1
        instr_mem[2] = 32'h0x00000067; // j 0
        instr_mem[3] = 32'h0x00000013; // nop
        // ram[7] = 32'h
        // ram[8] = 32'h
        // ram[9] = 32'h
        // ram[10]
        // ram[11]
    end

    assign instr = re ? instr_mem[instr_addr[`INSTR_MEM_WIDTH-1:2]] : 0;
    // always @(posedge clk) begin
    //     if (re)
    //         instr <= instr_mem[instr_addr[`INSTR_MEM_WIDTH-1:2]];
    //     else 
    //         instr <= 0;
    // end



endmodule