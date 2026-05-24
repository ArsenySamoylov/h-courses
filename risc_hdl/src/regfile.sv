`timescale 1ns/1ps

module regfile (
    input logic clk,

    input logic [4:0] A1,
    input logic [4:0] A2,

    output logic [31:0] D1,
    output logic [31:0] D2,

    input logic WB_WE,       // Write enable
    input logic [4:0] WB_A,  // Register to write
    input logic [31:0] WB_D  // Value to write
);

    logic [31:0] regs [31:0];

    always_ff @(posedge clk) begin
        if (WB_WE && (WB_A != 5'd0))
            regs[WB_A] <= WB_D;

        regs[0] <= 32'b0;
    end

    assign D1 = (A1 == 5'd0) ? 32'b0 : regs[A1];
    assign D2 = (A2 == 5'd0) ? 32'b0 : regs[A2];

endmodule