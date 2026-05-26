`timescale 1ns/1ps
`include "isa.svh"

module cu (
    input  logic [31:0] instr,

    output logic        reg_we,
    output logic        mem_we,
    output logic        mem_rd,
    output logic        mem2reg,
    output logic        alusrc,

    output logic [3:0]  alu_op,
    output logic [2:0]  br_type,
    output logic [1:0]  de_fmt
);
    // decode fields
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    always_comb begin
        // defaults
        reg_we   = 0;
        mem_we   = 0;
        mem_rd   = 0;
        mem2reg  = 0;
        alusrc   = 0;
    
        alu_op   = ALU_ADD;
        br_type  = BR_NONE;
        de_fmt = IMM_I;

        case (opcode)
            // ---------------- R-TYPE ----------------
            OP_R: begin
                reg_we = 1'b1;

                 case (funct3)
                    F3_ADD_SUB: alu_op = (funct7[5]) ? ALU_SUB : ALU_ADD;
                    F3_AND:     alu_op = ALU_AND;
                    F3_OR:      alu_op = ALU_OR;
                    F3_XOR:     alu_op = ALU_XOR;
                    F3_SLT:     alu_op = ALU_SLT;
                    F3_SLL:     alu_op = ALU_SLL;
                    F3_SRL_SRA: alu_op = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    default:    alu_op = ALU_ADD;
                endcase
            end

            // ---------------- I-TYPE ALU ----------------
            OP_I: begin
                reg_we  = 1'b1;
                alusrc  = 1'b1;
                de_fmt = IMM_I;

                 case (funct3)
                    F3_ADD_SUB: alu_op = ALU_ADD;
                    F3_AND:     alu_op = ALU_AND;
                    F3_OR:      alu_op = ALU_OR;
                    F3_XOR:     alu_op = ALU_XOR;
                    F3_SLT:     alu_op = ALU_SLT;
                    F3_SLL:     alu_op = ALU_SLL;
                    F3_SRL_SRA: alu_op = (funct7[5]) ? ALU_SRA : ALU_SRL;
                    default:    alu_op = ALU_ADD;
                endcase
            end

            // ---------------- LOAD ----------------
            OP_LOAD: begin
                reg_we  = 1'b1;
                mem_rd  = 1'b1;
                mem2reg = 1'b1;
                alusrc  = 1'b1;
                de_fmt = IMM_I;
                alu_op  = ALU_ADD;
            end

            // ---------------- STORE ----------------
            OP_STORE: begin
                mem_we  = 1'b1;
                alusrc  = 1'b1;
                de_fmt = IMM_S;
                alu_op  = ALU_ADD;
            end

            // ---------------- BRANCH ----------------
            OP_BRANCH: begin
                de_fmt = IMM_B;

                 case (funct3)
                    3'b000: br_type = BR_BEQ;
                    3'b001: br_type = BR_BNE;
                    3'b100: br_type = BR_BLT;
                    3'b101: br_type = BR_BGE;
                    default: br_type = BR_NONE;
                endcase
            end

            // ---------------- LUI ----------------
            OP_LUI: begin
                reg_we  = 1'b1;
                alusrc  = 1'b1;
                de_fmt = IMM_U;
                alu_op  = ALU_ADD; // or pass-through in datapath
            end

        endcase
    end

endmodule