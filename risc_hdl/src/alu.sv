`timescale 1ns/1ps
`include "isa.svh"

module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [3:0]  op,
    output logic [31:0] y
);

    always_comb begin
        case (op)
            ALU_ADD: y = a + b;
            ALU_SUB: y = a - b;
            ALU_AND: y = a & b;
            ALU_OR : y = a | b;
            ALU_XOR: y = a ^ b;
            ALU_SLT: y = ($signed(a) < $signed(b));
            ALU_SLL: y = a << b[4:0];
            ALU_SRL: y = a >> b[4:0];
            ALU_SRA: y = $signed(a) >>> b[4:0];
            default : y = 0;
        endcase
    end

endmodule