`include "../include/riscv64/common.vh"

module instr_memory(
    input   wire                            clk,
    input   wire    [`INSTR_MEM_WIDTH-1:0]  instr_addr,
    input   wire                            re,
    output  reg     [`INSTR_WIDTH-1:0]      instr
);

    reg [`INSTR_WIDTH-1:0] instr_mem[0:`INSTR_MEM_SIZE-1];

    initial begin
        $readmemh("assets/instr_memory.hex", instr_mem);
    end

    assign instr = re ? instr_mem[instr_addr[`INSTR_MEM_WIDTH-1:2]] : 0;
    // always @(posedge clk) begin
    //     if (re)
    //         instr <= instr_mem[instr_addr[`INSTR_MEM_WIDTH-1:2]];
    //     else 
    //         instr <= 0;
    // end



endmodule