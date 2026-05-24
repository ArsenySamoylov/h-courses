`timescale 1ns/1ps
`include "isa.svh"


// PIPELINE REGISTERS
typedef struct packed {
    logic        valid;
    logic [31:0] pc;
    logic [31:0] instr;
} IF_DE_t;

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
    logic alusrc;
} DE_EX_t;

typedef struct packed {
    logic valid;

    logic [31:0] alu_res;
    logic [31:0] rs2;
    logic [4:0]  rd;

    logic reg_we;
    logic mem_we;
    logic mem_rd;
    logic mem2reg;
} EX_MEM_t;

typedef struct packed {
    logic valid;

    logic [31:0] mem_data;
    logic [31:0] alu_res;
    logic [4:0]  rd;

    logic reg_we;
    logic mem2reg;
} MEM_WB_t;

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
    logic [31:0] pc, pc_next;

    IF_DE_t  if_de;
    DE_EX_t  de_ex;
    EX_MEM_t ex_mem;
    MEM_WB_t mem_wb;

    // INSTRUCTION FIELDS (for debuging)
    logic [6:0] opcode = if_de.instr[6:0];
    logic [2:0] funct3 = if_de.instr[14:12];
    logic [6:0] funct7 = if_de.instr[31:25];

    // CONTROL UNIT
    logic        reg_we, mem_we, mem_rd, mem2reg, alusrc;
    logic [3:0]  alu_op;
    logic [2:0]  br_type;
    logic [1:0]  de_fmt;

    cu CU (
        .instr(if_de.instr),

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

        .A1(if_de.instr[19:15]),
        .A2(if_de.instr[24:20]),

        .D1(rf_d1),
        .D2(rf_d2),

        .WB_A(mem_wb.rd),
        .WB_D(mem_wb.mem2reg ? mem_wb.mem_data : mem_wb.alu_res),
        .WB_WE(mem_wb.reg_we && mem_wb.valid)
    );

    // IMMEDIATE GENERATOR
    logic [31:0] imm;

    imm IMM (
        .instr(if_de.instr),
        .de_fmt(de_fmt),
        .imm(imm)
    );

    // HAZARD UNIT
    logic [1:0] fwd_a, fwd_b;

    hu HU (
        .ex_rs1(de_ex.rs1_idx),
        .ex_rs2(de_ex.rs2_idx),

        .mem_rd(ex_mem.rd),
        .wb_rd(mem_wb.rd),

        .mem_we(ex_mem.reg_we),
        .wb_we(mem_wb.reg_we),

        .fwd_a(fwd_a),
        .fwd_b(fwd_b)
    );

    // FORWARDING MUXES
    logic [31:0] op_a, op_b;
    logic [31:0] alu_y;

    always_comb begin
        // RS1 forwarding
         case (fwd_a)
            2'b01: op_a = ex_mem.alu_res;
            2'b10: op_a = mem_wb.mem2reg ? mem_wb.mem_data : mem_wb.alu_res;
            default: op_a = de_ex.rs1;
        endcase

        // RS2 forwarding
         case (fwd_b)
            2'b01: op_b = ex_mem.alu_res;
            2'b10: op_b = mem_wb.mem2reg ? mem_wb.mem_data : mem_wb.alu_res;
            default: op_b = de_ex.rs2;
        endcase

        // ALU input B selection
        if (de_ex.alusrc)
            op_b = de_ex.imm;
    end

    // ALU MODULE
    alu ALU (
        .a(op_a),
        .b(op_b),
        .op(de_ex.alu_op),
        .y(alu_y)
    );

    // BRANCH LOGIC (EX STAGE)
    logic take_branch;
    logic [31:0] branch_target;

    always_comb begin
        take_branch = 0;

         case (de_ex.br_type)
            BR_BEQ: take_branch = (op_a == op_b);
            BR_BNE: take_branch = (op_a != op_b);
            BR_BLT: take_branch = ($signed(op_a) < $signed(op_b));
            BR_BGE: take_branch = ($signed(op_a) >= $signed(op_b));
        endcase

        branch_target = de_ex.pc + de_ex.imm;
    end

    // PC LOGIC
    assign pc_next = (de_ex.valid && take_branch)
                    ? branch_target
                    : (pc + 4);

    assign imem_addr = pc;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else
            pc <= pc_next;
    end

    // IF/DE STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            if_de <= '0;
        else begin
            if_de.pc    <= pc;
            if_de.instr <= imem_data;
            if_de.valid <= 1'b1;
        end
    end

    // DE/EX STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            de_ex <= '0;
        else begin
            de_ex.valid <= if_de.valid;

            de_ex.pc    <= if_de.pc;

            de_ex.rs1   <= rf_d1;
            de_ex.rs2   <= rf_d2;
            de_ex.imm   <= imm;

            de_ex.rs1_idx <= if_de.instr[19:15];
            de_ex.rs2_idx <= if_de.instr[24:20];
            de_ex.rd      <= if_de.instr[11:7];

            de_ex.alu_op  <= alu_op;
            de_ex.br_type <= br_type;
            de_ex.de_fmt <= de_fmt;

            de_ex.reg_we  <= reg_we;
            de_ex.mem_we  <= mem_we;
            de_ex.mem_rd  <= mem_rd;
            de_ex.mem2reg <= mem2reg;
            de_ex.alusrc  <= alusrc;
        end
    end

    // EX/MEM STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            ex_mem <= '0;
        else begin
            ex_mem.valid   <= de_ex.valid;

            ex_mem.alu_res <= alu_y;
            ex_mem.rs2     <= op_b;
            ex_mem.rd      <= de_ex.rd;

            ex_mem.reg_we  <= de_ex.reg_we;
            ex_mem.mem_we  <= de_ex.mem_we;
            ex_mem.mem_rd  <= de_ex.mem_rd;
            ex_mem.mem2reg <= de_ex.mem2reg;
        end
    end

    // MEMORY
    assign dmem_addr  = ex_mem.alu_res;
    assign dmem_we    = ex_mem.mem_we && ex_mem.valid;
    assign dmem_re    = ex_mem.mem_rd;
    assign dmem_wdata = ex_mem.rs2;

    // MEM/WB STAGE
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            mem_wb <= '0;
        else begin
            mem_wb.valid    <= ex_mem.valid;

            mem_wb.mem_data <= dmem_rdata;
            mem_wb.alu_res  <= ex_mem.alu_res;
            mem_wb.rd       <= ex_mem.rd;

            mem_wb.reg_we   <= ex_mem.reg_we;
            mem_wb.mem2reg  <= ex_mem.mem2reg;
        end
    end

endmodule