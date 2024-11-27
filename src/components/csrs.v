`include "../include/common.vh"

module csrs(
    input                               clk,
    input                               rst,
    input                               we,
    input       [1:0]                   trap,
    input       [`INSTR_MEM_WIDTH-1:0]  pc,
    input       [`CSR_ADDR_WIDTH-1:0]   csr_write_addr,
    input       [`CSR_WIDTH-1:0]        csr_write_data,
    input       [`CSR_ADDR_WIDTH-1:0]   csr_read_addr,
    output  reg [`CSR_WIDTH-1:0]        csr_read_data
);
    reg [`CSR_WIDTH-1:0] mstatus, mepc, mcause, mtvec;

    initial begin
        mstatus = 0;
        mepc = 0;
        mcause = 0;
        mtvec = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            mstatus <= 0;
            mepc <= 0;
            mcause <= 0;
            mtvec <= 0;
        end
        else if (we) begin
            case (csr_write_addr)
                `CSR_MSTATUS: mstatus <= csr_write_data;
                `CSR_MEPC: mepc <= csr_write_data;
                `CSR_MCAUSE: mcause <= csr_write_data;
                `CSR_MTVEC: mtvec <= csr_write_data;
            endcase
        end
        else if (trap != 2'b00) begin
            if (trap == 2'b01) begin
                mepc <= pc;
                mcause <= 11;
            end else if (trap == 2'b10) begin
                mepc <= pc;
                mcause <= 2;
            end else if (trap == 2'b11) begin
                // mret
                mstatus[31] <= mstatus[30];
                mstatus[30] <= 1;
                // mstatus[12:11] <= 0;
            end

        end
    end

    always @(*) begin
        case (csr_read_addr)
            `CSR_MSTATUS: csr_read_data = mstatus;
            `CSR_MEPC: csr_read_data = mepc;
            `CSR_MCAUSE: csr_read_data = mcause;
            `CSR_MTVEC: csr_read_data = mtvec;
            default: csr_read_data = 0;
        endcase
    end

endmodule
