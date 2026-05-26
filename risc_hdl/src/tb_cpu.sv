`timescale 1ns/1ps

module tb_cpu;

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
    // DUT CONNECTIONS
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

    // =========================================================
    // SIMPLE MEMORIES
    // =========================================================

    logic [31:0] imem [0:255];
    logic [31:0] dmem [0:255];

    // instruction memory (word addressed)
    assign imem_data = imem[imem_addr[31:2]];

    // data memory
    assign dmem_rdata = dmem[dmem_addr[31:2]];

    always_ff @(posedge clk) begin
        if (dmem_we)
            dmem[dmem_addr[31:2]] <= dmem_wdata;
    end

    // =========================================================
    // PROGRAM
    // =========================================================
    //
    // addi x1, x0, 5
    // addi x2, x0, 10
    // add  x3, x1, x2
    // sub  x4, x3, x1
    // sw   x4, 0(x0)
    // lw   x5, 0(x0)
    // add  x6, x5, x1
    //
    // Expected:
    // x1 = 5
    // x2 = 10
    // x3 = 15
    // x4 = 10
    // mem[0] = 10
    // x5 = 10
    // x6 = 15
    //
    // =========================================================

    initial begin

        integer i;

        for (i = 0; i < 256; i++) begin
            imem[i] = 32'h00000013; // nop = addi x0,x0,0
            dmem[i] = 0;
        end

        // addi x1, x0, 5
        imem[0] = 32'h00500093;

        // addi x2, x0, 10
        imem[1] = 32'h00A00113;

        // add x3, x1, x2
        imem[2] = 32'h002081B3;

        // sub x4, x3, x1
        // Note: here we must forward x3 value from previous instruction
        imem[3] = 32'h40118233;

        // sw x4, 0(x0)
        imem[4] = 32'h00402023;

        // lw x5, 0(x0)
        imem[5] = 32'h00002283;

        // add x6, x5, x1
        imem[6] = 32'h00128333;

    end

    // =========================================================
    // TEST SEQUENCE
    // =========================================================

    initial begin

        rst = 1'b1;

        repeat (1)
            @(posedge clk);

        rst = 1'b0;

        // enough cycles for pipeline to retire everything
        repeat (30)
            @(posedge clk);

        $display("Checking register state...");

        check_reg(1, 5);
        check_reg(2, 10);
        check_reg(3, 15);
        check_reg(4, 10);
        check_reg(5, 10);
        check_reg(6, 15);

        assert(dmem[0] == 10)
        else begin
            $fatal(1,
                "DMEM[0] FAIL got=%0d expected=10",
                dmem[0]
            );
        end

        $display("=================================");
        $display("ALL TESTS PASSED");
        $display("=================================");

        $finish;
    end

    // =========================================================
    // REGISTER CHECK TASK
    // =========================================================

    task automatic check_reg(
        input int idx,
        input int expected
    );
        int actual;
    begin

        actual = DUT.RF.regs[idx];

        assert(actual == expected)
        else begin
            $fatal(1,
                "REG FAIL x%0d got=%0d expected=%0d",
                idx,
                actual,
                expected
            );
        end

        $display(
            "PASS x%0d = %0d",
            idx,
            actual
        );
    end
    endtask

    // =========================================================
    // WAVEFORM
    // =========================================================

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb_cpu);
    end

endmodule