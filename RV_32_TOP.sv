`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: RV_32_TOP
// Description: Single-cycle RV32 top level. Connects IF_stage, ID_Top, EX_Top
//              and WB_Stage. Instruction memory and data memory are external
//              and are reached through the ports below.
//////////////////////////////////////////////////////////////////////////////////

module RV_32_TOP (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,

    // Instruction memory interface
    output logic [31:0] pc,            // instruction address
    input  logic [31:0] instruction,   // instruction fetched at pc

    // Data memory interface
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    output logic        mem_read,
    output logic        mem_write,
    input  logic [31:0] mem_rdata
);

    // -------------------------------------------------------------------------
    // Internal signals
    // -------------------------------------------------------------------------

    // Instruction fields needed outside ID_Top
    logic [6:0]  opcode;
    logic [4:0]  rd;

    // ID stage outputs
    logic [31:0] rs1_data, rs2_data, imm_out;
    logic [1:0]  memtoreg;
    logic        branch, mux_inp, memread, memwrite, alusrc, reg_write;
    logic [2:0]  aluop;
    logic [4:0]  alu_control_out;

    // EX stage outputs
    logic [31:0] alu_out, rs2_selected, pc_new;
    logic        zero;

    // IF stage control
    logic        and_out;
    logic        is_jal;
    logic [31:0] jalr_target;
    logic [31:0] pc_signed_offset;

    // WB stage
    logic [31:0] return_address;
    logic [31:0] mux1_out;
    logic [31:0] wb_data;

    // -------------------------------------------------------------------------
    // Fields taken straight from the instruction word
    // -------------------------------------------------------------------------
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];

    // -------------------------------------------------------------------------
    // PC control
    //   IF_stage always computes  pc_next = and_out ? pc + pc_signed_offset : pc + 4
    //   branch : taken when branch & zero, offset = B-type immediate
    //   jal    : always taken,             offset = J-type immediate
    //   jalr   : always taken (mux_inp),   target = (rs1 + imm) & ~1, so the
    //            offset fed to IF_stage is (target - pc), which gives pc + offset = target
    // -------------------------------------------------------------------------
    assign is_jal           = (opcode == 7'b1101111);
    assign jalr_target      = alu_out & ~32'd1;
    assign pc_signed_offset = mux_inp ? (jalr_target - pc) : imm_out;
    assign and_out          = (branch & zero) | is_jal | mux_inp;

    assign return_address   = pc + 32'd4;

    // -------------------------------------------------------------------------
    // IF stage
    // -------------------------------------------------------------------------
    IF_stage IF (
        .clk              (clk),
        .reset            (reset),
        .stall            (stall),
        .and_out          (and_out),
        .pc_signed_offset (pc_signed_offset),
        .address          (pc)
    );

    // -------------------------------------------------------------------------
    // ID stage
    // -------------------------------------------------------------------------
    ID_Top ID (
        .instruction     (instruction),
        .clk             (clk),
        .reset           (reset),

        // write-back into the register file
        .rd_wb           (rd),
        .wb_data         (wb_data),
        .reg_write_wb    (reg_write),

        .rs1_data        (rs1_data),
        .rs2_data        (rs2_data),
        .imm_out         (imm_out),

        .memtoreg        (memtoreg),
        .branch          (branch),
        .mux_inp         (mux_inp),
        .memread         (memread),
        .memwrite        (memwrite),
        .alusrc          (alusrc),
        .reg_write       (reg_write),
        .aluop           (aluop),
        .alu_control_out (alu_control_out)
    );

    // -------------------------------------------------------------------------
    // EX stage
    // -------------------------------------------------------------------------
    EX_Top EX (
        .rs1_data     (rs1_data),
        .rs2_data     (rs2_data),
        .imm          (imm_out),
        .pc           (pc),
        .opcode       (opcode),

        .alu_src      (alusrc),
        .alu_control  (alu_control_out),

        .alu_out      (alu_out),
        .rs2_selected (rs2_selected),
        .pc_new       (pc_new),
        .zero         (zero)
    );

    // -------------------------------------------------------------------------
    // Data memory interface
    // -------------------------------------------------------------------------
    assign mem_addr  = alu_out;
    assign mem_wdata = rs2_data;      // store data is the original rs2 value
    assign mem_read  = memread;
    assign mem_write = memwrite;

    // -------------------------------------------------------------------------
    // WB stage
    // -------------------------------------------------------------------------
    WB_Stage WB (
        .alu_out        (alu_out),
        .return_address (return_address),
        .imm_out        (imm_out),
        .pc_exe         (pc_new),
        .read_data      (mem_rdata),
        .mux1_in        (32'b0),          // not used inside WB_Stage
        .mux1_out       (mux1_out),
        .opcode         (opcode),
        .memtoreg       (memtoreg),
        .wb_data        (wb_data)
    );

endmodule