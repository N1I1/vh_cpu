`include "../include/common.vh"

module control_unit (
    input   wire    [6:0]                   opcode,
    input   wire    [2:0]                   funct3,
    input   wire    [6:0]                   funct7,

    output  reg                             mem_read,
    output  reg                             mem_write,
    output  reg                             reg_write,
    output  reg     [1:0]                   mem_to_reg,

    output  reg     [1:0]                   alu_a_src,
    // 0: rs1, 1: pc, 2: csr
    output  reg     [1:0]                   alu_b_src,
    // 0: rs2, 1: imm, 2: rs1, 3: zimm
    output  reg                             alu_b_neg,
    // 0: positive, 1: negative
    output  reg     [`ALU_OP_WIDTH-1:0]     alu_op,
    
    output  reg                             csr_we,
    output  reg     [2:0]                   csr_src,
    // 0: alu_res, 1: rs1 2: zimm, 3: 0
    output  reg     [1:0]                   trap,

    output  reg     [3:0]                   branch_type,

    output  reg     [2:0]                   data_width  
    // 0: 8-bit, 1: 16-bit, 2: 32-bit, 3: 64-bit
    );

    always @(*) begin
        case (opcode)
            `OP_R: begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b00;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0000;
                data_width  = 3'b11;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_ADD_SUB: begin
                        case (funct7)
                            `FUNCT7_ADD: begin
                                alu_op = `ALU_ADD;
                            end
                            `FUNCT7_SUB: begin
                                alu_op = `ALU_SUB;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7 (OP_R): %b", funct7);
                            end
                        endcase
                    end
                    `FUNCT3_SLL: begin
                        alu_op = `ALU_SLL;
                    end
                    `FUNCT3_SLT: begin
                        alu_op = `ALU_SLT;
                    end
                    `FUNCT3_SLTU: begin
                        alu_op = `ALU_SLTU;
                    end
                    `FUNCT3_XOR: begin
                        alu_op = `ALU_XOR;
                    end
                    `FUNCT3_SRL_SRA: begin
                        case (funct7)
                            `FUNCT7_SRL: begin
                                alu_op = `ALU_SRL;
                            end
                            `FUNCT7_SRA: begin
                                alu_op = `ALU_SRA;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7 (OP_R): %b", funct7);
                            end
                        endcase
                    end
                    `FUNCT3_OR: begin
                        alu_op = `ALU_OR;
                    end
                    `FUNCT3_AND: begin
                        alu_op = `ALU_AND;
                    end
                endcase
            end
            
            `OP_R32: begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b00;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0000;
                data_width  = 3'b10;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_ADD_SUB: begin
                        case (funct7)
                            `FUNCT7_ADD: begin
                                alu_op = `ALU_ADD;
                            end
                            `FUNCT7_SUB: begin
                                alu_op = `ALU_SUB;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7 (OP_R): %b", funct7);
                            end
                        endcase
                    end
                    `FUNCT3_SLL: begin
                        alu_op = `ALU_SLL;
                    end
                    `FUNCT3_SLT: begin
                        alu_op = `ALU_SLT;
                    end
                    `FUNCT3_SLTU: begin
                        alu_op = `ALU_SLTU;
                    end
                    `FUNCT3_SRL_SRA: begin
                        case (funct7)
                            `FUNCT7_SRL: begin
                                alu_op = `ALU_SRL;
                            end
                            `FUNCT7_SRA: begin
                                alu_op = `ALU_SRA;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7 (OP_R): %b", funct7);
                            end
                        endcase
                    end
                endcase
                
            end

            `OP_I_IMM:    begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0000;
                data_width  = 3'b11;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_ADDI: begin
                        alu_op = `ALU_ADD;
                    end
                    `FUNCT3_SLTI: begin
                        alu_op = `ALU_SLT;
                    end
                    `FUNCT3_SLTIU: begin
                        alu_op = `ALU_SLTU;
                    end
                    `FUNCT3_XORI: begin
                        alu_op = `ALU_XOR;
                    end
                    `FUNCT3_ORI: begin
                        alu_op = `ALU_OR;
                    end
                    `FUNCT3_ANDI: begin
                        alu_op = `ALU_AND;
                    end
                    `FUNCT3_SLLI: begin
                        alu_op = `ALU_SLL;
                    end
                    `FUNCT3_SRLI_SRAI: begin
                        case (funct7)
                            `FUNCT7_SRLI: begin
                                alu_op = `ALU_SRL;
                            end
                            `FUNCT7_SRAI: begin
                                alu_op = `ALU_SRA;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7: %b(OP_I_IMM)", funct7);
                            end
                        endcase
                    end
                endcase
            end
            
            `OP_I_IMM32:  begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0000;
                data_width  = 3'b10;
                csr_we      = 1'b0;
                csr_src     = 3'b000;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_ADDI: begin
                        alu_op = `ALU_ADD;
                    end
                    `FUNCT3_SLTI: begin
                        alu_op = `ALU_SLT;
                    end
                    `FUNCT3_SLTIU: begin
                        alu_op = `ALU_SLTU;
                    end
                    `FUNCT3_SLLI: begin
                        alu_op = `ALU_SLL;
                    end
                    `FUNCT3_SRLI_SRAI: begin
                        case (funct7)
                            `FUNCT7_SRLI: begin
                                alu_op = `ALU_SRL;
                            end
                            `FUNCT7_SRAI: begin
                                alu_op = `ALU_SRA;
                            end
                            default: begin
                                $display("Control unit: Unknown funct7: %b(OP_I_IMM32)", funct7);
                            end
                        endcase
                    end
                endcase
            end

            `OP_I_LOAD:   begin
                mem_read    = 1'b1;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b1;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0000;
                alu_op      = `ALU_ADD;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_LB: begin
                        data_width = 3'b00;
                    end
                    `FUNCT3_LH: begin
                        data_width = 3'b01;
                    end
                    `FUNCT3_LW: begin
                        data_width = 3'b10;
                    end
                    `FUNCT3_LD: begin
                        data_width = 3'b11;
                    end
                    `FUNCT3_LBU: begin
                        data_width = 3'b00;
                    end
                    `FUNCT3_LHU: begin
                        data_width = 3'b01;
                    end
                    `FUNCT3_LWU: begin
                        data_width = 3'b10;
                    end
                    default: begin
                        $display("Control unit: Unknown funct3 (OP_I_LOAD): %b", funct3);
                    end
                endcase
            end
            
            `OP_S:        begin
                mem_read    = 1'b0;
                mem_write   = 1'b1;
                reg_write   = 1'b0;
                mem_to_reg  = 1'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                alu_op      = `ALU_ADD;
                branch_type = 4'b0000;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                case (funct3)
                    `FUNCT3_SB: begin
                        data_width = 3'b00;
                    end
                    `FUNCT3_SH: begin
                        data_width = 3'b01;
                    end
                    `FUNCT3_SW: begin
                        data_width = 3'b10;
                    end
                    `FUNCT3_SD: begin
                        data_width = 3'b11;
                    end
                    default: begin
                        $display("Control unit: Unknown funct3 (OP_S): %b", funct3);
                    end
                endcase
            end
            
            `OP_B:        begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b0;
                mem_to_reg  = 1'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b00;
                alu_b_neg   = 1'b0;
                data_width  = 3'b11;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
                alu_op      = `ALU_ADD;
                case (funct3)
                    `FUNCT3_BEQ: branch_type = 4'b0011;
                    `FUNCT3_BNE: branch_type = 4'b0100;
                    `FUNCT3_BLT: branch_type = 4'b0101;
                    `FUNCT3_BGE: branch_type = 4'b0110;
                    `FUNCT3_BLTU: branch_type = 4'b0111;
                    `FUNCT3_BGEU: branch_type = 4'b1000;
                    default: begin
                        $display("Control unit: Unknown funct3 (OP_B): %b", funct3);
                    end
                endcase
            end
            
            `OP_I_JAL:    begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b10;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b00;
                alu_op      = `ALU_ADD;
                alu_b_neg   = 1'b0;
                branch_type = 4'b0001;
                data_width  = 3'b11;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
            end
            
            `OP_I_JALR:   begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b10;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                alu_op      = `ALU_JALR;
                data_width  = 3'b11;
                branch_type = 4'b0010;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
            end
            
            `OP_U_LUI:    begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b00;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                data_width  = 3'b11;
                branch_type = 4'b0000;
                alu_op      = `ALU_COPY2;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
            end
            
            `OP_U_AUIPC:  begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                reg_write   = 1'b1;
                mem_to_reg  = 2'b0;
                alu_a_src   = 2'b01;
                alu_b_src   = 2'b01;
                alu_b_neg   = 1'b0;
                data_width  = 3'b11;
                branch_type = 4'b0000;
                alu_op      = `ALU_ADD;
                csr_src     = 3'b000;
                csr_we      = 1'b0;
                trap        = 2'b00;
            end

            `OP_I_SYSTEM: begin
                mem_read    = 1'b0;
                mem_write   = 1'b0;
                mem_to_reg  = 2'b0;
                data_width  = 3'b10;
                branch_type = 4'b0000;
                reg_write = 1'b1;
                mem_to_reg = 2'b11;
                
                case (funct3)
                    `FUNCT3_ECALL_EBREAK_MRET: begin
                        case (funct7)
                            `FUNCT7_MRET: begin
                                trap = 2'b11;
                                branch_type = 4'b0000; // may be a little problem
                            end
                            // `FUNCT7_WFI: begin
                                
                            // end
                            default:
                                trap = 2'b01;
                        endcase
                    end
                    `FUNCT3_CSRRW: begin
                        csr_we = 1'b1;
                        csr_src = 3'b010;
                        alu_op = `ALU_ADD;
                        alu_a_src = 2'b00;
                        alu_b_src = 2'b10;
                        alu_b_neg = 1'b0;
                        trap = 2'b00;
                    end
                    `FUNCT3_CSRRS: begin
                        csr_we = 1'b1;
                        csr_src = 3'b000;
                        alu_op = `ALU_OR;
                        alu_a_src = 2'b10;
                        alu_b_src = 2'b10;
                        alu_b_neg = 1'b0;
                        trap = 2'b00;
                    end
                    `FUNCT3_CSRRC: begin
                        csr_we = 1'b1;
                        csr_src = 3'b000;
                        alu_op = `ALU_AND;
                        alu_a_src = 2'b10;
                        alu_b_src = 2'b10;
                        alu_b_neg = 1'b1;
                        trap = 2'b00;
                    end
                    `FUNCT3_CSRRWI: begin
                        csr_we = 1'b1;
                        csr_src = 3'b010;
                        alu_op = `ALU_ADD;
                        alu_a_src = 2'b00;
                        alu_b_src = 2'b00;
                        alu_b_neg = 1'b0;
                        trap = 2'b00;
                    end
                    `FUNCT3_CSRRSI: begin
                        csr_we = 1'b1;
                        csr_src = 3'b000;
                        alu_op = `ALU_OR;
                        alu_a_src = 2'b10;
                        alu_b_src = 2'b11;
                        alu_b_neg = 1'b0;
                        trap = 2'b00;
                    end
                    `FUNCT3_CSRRCI: begin
                        csr_we = 1'b1;
                        csr_src = 3'b000;
                        alu_op = `ALU_AND;
                        alu_a_src = 2'b10;
                        alu_b_src = 2'b11;
                        alu_b_neg = 1'b1;
                        trap = 2'b00;
                    end
                endcase
            end

            default: begin
                $display("Control unit: Unknown opcode: %b", opcode);
            end
        endcase
    end
endmodule