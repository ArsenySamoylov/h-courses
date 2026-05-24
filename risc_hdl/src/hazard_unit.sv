`timescale 1ns/1ps
`include "isa.svh"

module hu (
    input logic [4:0] ex_rs1,
    input logic [4:0] ex_rs2,

    input logic [4:0] mem_rd,
    input logic [4:0] wb_rd,

    input logic mem_we,
    input logic wb_we,

    output logic [1:0] fwd_a,
    output logic [1:0] fwd_b
);

    always_comb begin
        fwd_a = 2'b00;
        fwd_b = 2'b00;

        // MEM stage forwarding
        if (mem_we && (mem_rd != 0)) begin
            if (mem_rd == ex_rs1) fwd_a = 2'b01;
            if (mem_rd == ex_rs2) fwd_b = 2'b01;
        end

        // WB stage forwarding
        if (wb_we && (wb_rd != 0)) begin
            if (wb_rd == ex_rs1 && fwd_a == 0) fwd_a = 2'b10;
            if (wb_rd == ex_rs2 && fwd_b == 0) fwd_b = 2'b10;
        end
    end

endmodule