`ifndef ISA_DEFS_SVH
`define ISA_DEFS_SVH

// OPCODES
localparam logic [6:0] OP_R      = 7'b0110011;
localparam logic [6:0] OP_I      = 7'b0010011;
localparam logic [6:0] OP_LOAD   = 7'b0000011;
localparam logic [6:0] OP_STORE  = 7'b0100011;
localparam logic [6:0] OP_BRANCH = 7'b1100011;
localparam logic [6:0] OP_LUI    = 7'b0110111;

// FUNCT3
localparam logic [2:0] F3_ADD_SUB = 3'b000;
localparam logic [2:0] F3_AND     = 3'b111;
localparam logic [2:0] F3_OR      = 3'b110;
localparam logic [2:0] F3_XOR     = 3'b100;
localparam logic [2:0] F3_SLT     = 3'b010;
localparam logic [2:0] F3_SLL     = 3'b001;
localparam logic [2:0] F3_SRL_SRA = 3'b101;

// ALU OPS
localparam logic [3:0] ALU_ADD = 4'd0;
localparam logic [3:0] ALU_SUB = 4'd1;
localparam logic [3:0] ALU_AND = 4'd2;
localparam logic [3:0] ALU_OR  = 4'd3;
localparam logic [3:0] ALU_XOR = 4'd4;
localparam logic [3:0] ALU_SLT = 4'd5;
localparam logic [3:0] ALU_SLL = 4'd6;
localparam logic [3:0] ALU_SRL = 4'd7;
localparam logic [3:0] ALU_SRA = 4'd8;

// BRANCH TYPES
localparam logic [2:0] BR_NONE = 3'd0;
localparam logic [2:0] BR_BEQ  = 3'd1;
localparam logic [2:0] BR_BNE  = 3'd2;
localparam logic [2:0] BR_BLT  = 3'd3;
localparam logic [2:0] BR_BGE  = 3'd4;

// IMM TYPES
localparam logic [1:0] IMM_I = 2'd0;
localparam logic [1:0] IMM_S = 2'd1;
localparam logic [1:0] IMM_B = 2'd2;
localparam logic [1:0] IMM_U = 2'd3;

`endif