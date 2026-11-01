`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2026 11:17:06 AM
// Design Name: 
// Module Name: ID_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module ID_Top(
    input logic [31:0] instruction,
    input logic clk,
    input logic reset,

    // Write-back interface from WB stage
    input logic [4:0] rd_wb,
    input logic [31:0] wb_data,
    input logic reg_write_wb,

    // Outputs
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,

    // Control signals
    output logic [1:0] memtoreg,
    output logic branch,
    output logic mux_inp,
    output logic memread,
    output logic memwrite,
    output logic alusrc,
    output logic reg_write,
    output logic [2:0] aluop
);

    // Internal signals
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, imm11_5;
    logic [2:0] fun3;
    logic [11:0] imm;
    logic fun7_5;
    logic [19:0] imm_uj;

    // ALU control
    logic [4:0] alu_control_out;

    // Instruction Decode
    ID_stage ID (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .imm11_5(imm11_5),
        .fun3(fun3),
        .imm(imm),
        .fun7_5(fun7_5),
        .imm_uj(imm_uj)
    );

    // Main Control Unit
    main_control MC (
        .opcode(opcode),
        .fn3(fun3),
        .memtoreg(memtoreg),
        .branch(branch),
        .mux_inp(mux_inp),
        .memread(memread),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .reg_write(reg_write),
        .aluop(aluop)
    );

    // Immediate Generator
    imm_generator IMM (
        .imm_input(imm),
        .fn3(fun3),
        .opcode(opcode),
        .imm_input_uj(imm_uj),
        .imm_output(imm_out)
    );

    // Register File
    regflie RF (
        .rs1_sel(rs1),
        .rs2_sel(rs2),
        .rd_sel(rd_wb),
        .wb_data(wb_data),
        .reg_write(reg_write_wb),
        .clk(clk),
        .reset(reset),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // ALU Control Unit
    alu_control ALUC (
        .alu_op(aluop),
        .fn3(fun3),
        .fn7_5(fun7_5),
        .imm11_5(imm11_5),
        .control_unit(alu_control_out)
    );

endmodule
