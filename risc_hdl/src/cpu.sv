`timescale 1ns/1ps
`include "isa.svh"


// PIPELINE REGISTERS
typedef struct packed {
    logic        valid;
    logic [31:0] pc;
    logic [31:0] instr;
} IF_t;

typedef struct packed {
    logic valid;

    logic [31:0] pc;

    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] imm;

    logic [4:0]  rs1_idx;
    logic [4:0]  rs2_idx;
    logic [4:0]  rd;

    logic [3:0]  alu_op;
    logic [2:0]  br_type;
    logic [1:0]  de_fmt;

    logic reg_we;
    logic mem_we;
    logic mem_rd;
    logic mem2reg;

    logic alu_src2;
} DE_t;

typedef struct packed {
    logic valid;

    logic [31:0] mem_alu;
    logic [31:0] rs2;
    logic [4:0]  rd;

    logic reg_we;
    logic mem_we;
    logic mem_rd;
    logic mem2reg;
} EX_t;

typedef struct packed {
    logic valid;

    logic [31:0] mem_data;
    logic [31:0] alu_res;
    logic [4:0]  rd;

    logic reg_we;
    logic mem2reg;
} MEM_t;

module cpu (
    input  logic clk,
    input  logic rst,

    output logic [31:0] imem_addr,
    input  logic [31:0] imem_data,

    output logic        dmem_we,
    output logic        dmem_re,
    output logic [31:0] dmem_addr,
    output logic [31:0] dmem_wdata,
    input  logic [31:0] dmem_rdata
);
    // STATE
    logic [31:0] pc;

    IF_t  fetch_state;
    DE_t  decode_state;
    EX_t  exec_state;
    MEM_t mem_state;

    // INSTRUCTION FIELDS (for debuging)
    logic [6:0] opcode = fetch_state.instr[6:0];
    logic [2:0] funct3 = fetch_state.instr[14:12];
    logic [6:0] funct7 = fetch_state.instr[31:25];

    // CONTROL UNIT
    logic        reg_we, mem_we, mem_rd, mem2reg, alusrc;
    logic [3:0]  alu_op;
    logic [2:0]  br_type;
    logic [1:0]  de_fmt;

    cu CU (
        .instr(fetch_state.instr),

        .reg_we(reg_we),
        .mem_we(mem_we),
        .mem_rd(mem_rd),
        .mem2reg(mem2reg),
        .alusrc(alusrc),

        .alu_op(alu_op),
        .br_type(br_type),
        .de_fmt(de_fmt)
    );

    // REGISTER FILE
    logic [31:0] rf_d1, rf_d2;

    regfile RF (
        .clk(clk),

        .A1(fetch_state.instr[19:15]),
        .A2(fetch_state.instr[24:20]),

        .D1(rf_d1),
        .D2(rf_d2),

        .WB_A(mem_state.rd),
        .WB_D(mem_state.mem2reg ? mem_state.mem_data : mem_state.alu_res),
        .WB_WE(mem_state.reg_we && mem_state.valid)
    );

    // IMMEDIATE GENERATOR
    logic [31:0] imm;

    imm IMM (
        .instr(fetch_state.instr),
        .de_fmt(de_fmt),
        .imm(imm)
    );

    // HAZARD UNIT
    logic [1:0] fwd_a, fwd_b;

    hu HU (
        .ex_rs1(decode_state.rs1_idx),
        .ex_rs2(decode_state.rs2_idx),

        .mem_rd(exec_state.rd),
        .wb_rd(mem_state.rd),

        .mem_we(exec_state.reg_we),
        .wb_we(mem_state.reg_we),

        .fwd_a(fwd_a),
        .fwd_b(fwd_b)
    );

    // FORWARDING MUXES
    logic [31:0] rs1v, rs2v;
    logic [31:0] alu_res, alu_b;

    logic decode_state_alu_src2;
    assign decode_state_alu_src2 = decode_state.alu_src2;

    always_comb begin
        // RS1 forwarding
         case (fwd_a)
            2'b01: rs1v = exec_state.mem2reg ? dmem_rdata : exec_state.mem_alu;
            2'b10: rs1v = mem_state.mem2reg ? mem_state.mem_data : mem_state.alu_res;
            default: rs1v = decode_state.rs1;
        endcase

        // RS2 forwarding
         case (fwd_b)
            2'b01: rs2v = exec_state.mem2reg ? dmem_rdata : exec_state.mem_alu;
            2'b10: rs2v = mem_state.mem2reg ? mem_state.mem_data : mem_state.alu_res;
            default: rs2v = decode_state.rs2;
        endcase

        alu_b = decode_state.alu_src2 ? decode_state.imm : rs2v;
    end

    // ALU MODULE
    alu ALU (
        .a(rs1v),
        .b(alu_b),
        .op(decode_state.alu_op),
        .y(alu_res)
    );

    // BRANCH LOGIC (EX STAGE)
    logic take_branch;
    logic [31:0] branch_target;

    always_comb begin
        take_branch = 0;

         case (decode_state.br_type)
            BR_BEQ: take_branch = (rs1v == rs2v);
            BR_BNE: take_branch = (rs1v != rs2v);
            BR_BLT: take_branch = ($signed(rs1v) < $signed(rs2v));
            BR_BGE: take_branch = ($signed(rs1v) >= $signed(rs2v));
        endcase

        branch_target = decode_state.pc + decode_state.imm;
    end

    // PC LOGIC
    assign imem_addr = pc;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else begin
            if (decode_state.valid && take_branch)
                pc <= branch_target;
            else
                pc <= pc + 32'd4;
        end
    end

    // IF/DE STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            fetch_state <= '0;
        else begin
            fetch_state.pc    <= pc;
            fetch_state.instr <= imem_data;
            fetch_state.valid <= 1'b1;
        end
    end

    // DE/EX STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            decode_state <= '0;
        else begin
            decode_state.valid <= fetch_state.valid;

            decode_state.pc    <= fetch_state.pc;

            decode_state.rs1   <= rf_d1;
            decode_state.rs2   <= rf_d2;
            decode_state.imm   <= imm;

            decode_state.rs1_idx <= fetch_state.instr[19:15];
            decode_state.rs2_idx <= fetch_state.instr[24:20];
            decode_state.rd      <= fetch_state.instr[11:7];

            decode_state.alu_op  <= alu_op;
            decode_state.br_type <= br_type;
            decode_state.de_fmt <= de_fmt;

            decode_state.reg_we   <= reg_we;
            decode_state.mem_we   <= mem_we;
            decode_state.mem_rd   <= mem_rd;
            decode_state.mem2reg  <= mem2reg;
            decode_state.alu_src2 <= alusrc;
        end
    end

    // EX/MEM STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            exec_state <= '0;
        else begin
            exec_state.valid   <= decode_state.valid;

            exec_state.mem_alu <= alu_res;
            exec_state.rs2     <= rs2v;
            exec_state.rd      <= decode_state.rd;

            exec_state.reg_we  <= decode_state.reg_we;
            exec_state.mem_we  <= decode_state.mem_we;
            exec_state.mem_rd  <= decode_state.mem_rd;
            exec_state.mem2reg <= decode_state.mem2reg;
        end
    end

    // MEMORY
    assign dmem_addr  = exec_state.mem_alu;
    assign dmem_we    = exec_state.mem_we && exec_state.valid;
    assign dmem_re    = exec_state.mem_rd;
    assign dmem_wdata = exec_state.rs2;

    // MEM/WB STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            mem_state <= '0;
        else begin
            mem_state.valid    <= exec_state.valid;

            mem_state.mem_data <= dmem_rdata;
            mem_state.alu_res  <= exec_state.mem_alu;
            mem_state.rd       <= exec_state.rd;

            mem_state.reg_we   <= exec_state.reg_we;
            mem_state.mem2reg  <= exec_state.mem2reg;
        end
    end

endmodule