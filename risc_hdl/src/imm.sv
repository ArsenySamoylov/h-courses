`timescale 1ns/1ps

module imm (
    input  logic [31:0] instr,
    input  logic [1:0]  de_fmt,
    
    output logic [31:0] imm
);

    logic [31:0] imm_i;
    logic [31:0] imm_s;
    logic [31:0] imm_b;
    logic [31:0] imm_u;

    always_comb begin
        imm_i = {{20{instr[31]}}, instr[31:20]};

        imm_s = {{20{instr[31]}},
                instr[31:25],
                instr[11:7]};

        imm_b = {{19{instr[31]}},
                instr[31],
                instr[7],
                instr[30:25],
                instr[11:8],
                1'b0};

        imm_u = {instr[31:12], 12'b0};

         case (de_fmt)
            2'd0: imm = imm_i;
            2'd1: imm = imm_s;
            2'd2: imm = imm_b;
            2'd3: imm = imm_u;
            default: imm = 32'b0;
        endcase
    end

endmodule