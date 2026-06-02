`timescale 1ns/1ps
`include "isa.svh"

module tb_cpu_branch;

    // =========================================================
    // CLOCK / RESET
    // =========================================================

    logic clk;
    logic rst;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =========================================================
    // DUT
    // =========================================================

    logic [31:0] imem_addr;
    logic [31:0] imem_data;

    logic        dmem_we;
    logic        dmem_re;
    logic [31:0] dmem_addr;
    logic [31:0] dmem_wdata;
    logic [31:0] dmem_rdata;

    cpu DUT (
        .clk(clk),
        .rst(rst),

        .imem_addr(imem_addr),
        .imem_data(imem_data),

        .dmem_we(dmem_we),
        .dmem_re(dmem_re),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_rdata(dmem_rdata)
    );

    logic [31:0] imem [0:255];
    logic [31:0] dmem [0:255];

    assign imem_data = imem[imem_addr[31:2]];
    assign dmem_rdata = dmem[dmem_addr[31:2]];

    always_ff @(posedge clk) begin
        if (dmem_we)
            dmem[dmem_addr[31:2]] <= dmem_wdata;
    end

    task automatic check_reg(input int idx, input int expected);
        int actual;
    begin
        actual = DUT.RF.regs[idx];

        assert(actual == expected)
        else $fatal(1, "REG x%0d got=%0d expected=%0d", idx, actual, expected);

        $display("PASS x%0d = %0d", idx, actual);
    end
    endtask

    initial begin

        integer i;

        // init memories
        for (i = 0; i < 256; i++) begin
            imem[i] = 32'h00000013; // nop
            dmem[i] = 0;
        end

        // TEST PROGRAM

        // fetch:  pc = 0
        // decode: pc = 4
        // exec:   pc = 8
        // mem:    pc = 12
        // wb:     pc = 16
        // 
        // x1 = 5
        // addi x1, x0, 5
        imem[0] = 32'h00500093;

        // fetch:  pc = 4
        // decode: pc = 8
        // exec:   pc = 12
        // mem:    pc = 16
        // wb:     pc = 20
        //
        // x2 = 5
        // addi x2, x0, 5
        imem[1] = 32'h00500113;

        // fetch:  pc = 8
        // decode: pc = 12 
        // exec:   pc = 16 (branch resolved TAKEN)
        // mem:    pc = 20
        // wb:     pc = 24
        //
        // beq x1, x2, 8
        imem[2] = 32'h00208463;

        // fetch:  pc = 12
        // decode: pc = 16 // invalidate instruction
        // exec:   pc = 20
        // mem:    pc = 24
        // wb:     pc = 28
        //
        // x3 = 1 (should be skipped)
        imem[3] = 32'h00100193;

        // fetch:  pc = 16
        // decode: pc = 20
        // exec:   pc = 24
        // mem:    pc = 28
        // wb:     pc = 32
        // addi x3, x3, 1
        // Note: branch target of previous BEQ
        // x3 = x3 + 1
        imem[4] = 32'h00118193;

        // fetch:  pc = 20
        // decode: pc = 24 (branch resolved NOT taken)
        // exec:   pc = 28
        // mem:    pc = 32
        // wb:     pc = 36
        // bne x1, x2, +8
        // Note: branch not taken -> pipeline continues normally
        imem[5] = 32'h00209463;

        // fetch:  pc = 24
        // decode: pc = 28
        // exec:   pc = 32
        // mem:    pc = 36
        // wb:     pc = 40
        // addi x4, x0, 10
        imem[6] = 32'h00A00213;

        // fetch:  pc = 28
        // decode: pc = 32 (branch resolved TAKEN)
        // exec:   pc = 36
        // mem:    pc = 40
        // wb:     pc = 44
        // beq x4, x4, +8
        // Note: branch taken -> squash next instruction
        imem[7] = 32'h00420463;

        // fetch:  pc = 32  valid = 0
        // decode: pc = 36  valid = 0
        // exec:   pc = 40  valid = 0
        // mem:    pc = 44  valid = 0
        // wb:     pc = 48  valid = 0
        // addi x5, x0, 99
        // Note: skipped because previous branch is taken
        imem[8] = 32'h06300293;

        // fetch:  pc = 36
        // decode: pc = 40
        // exec:   pc = 44
        // mem:    pc = 48
        // wb:     pc = 52
        // addi x6, x0, 7
        // Note: branch target of previous BEQ
        imem[9] = 32'h00700313;

    end

    initial begin

        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;

        repeat (30) @(posedge clk);

        $display("\n==== BRANCH TEST RESULTS ====\n");

        check_reg(1, 5);
        check_reg(2, 5);
        check_reg(3, 2);
        check_reg(4, 10);
        check_reg(5, 0);
        check_reg(6, 7);

        $display("\n==== ALL BRANCH TESTS PASSED ====\n");

        $finish;
    end

    initial begin
        $dumpfile("branch_tb.vcd");
        $dumpvars(0, tb_cpu_branch);
    end

endmodule