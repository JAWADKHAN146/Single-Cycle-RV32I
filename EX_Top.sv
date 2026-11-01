`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2026 11:33:09 AM
// Design Name: 
// Module Name: EX_Top
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


`timescale 1ns / 1ps

module EX_Top(
    // Inputs from ID stage
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,
    input logic [31:0] pc,
    input logic [6:0] opcode,

    // Control inputs
    input logic alu_src,
    input logic [4:0] alu_control,

    // Outputs
    output logic [31:0] alu_out,
    output logic [31:0] rs2_selected,
    output logic [31:0] pc_new,
    output logic zero
);

    // RS2 MUX
    rs2_mux MUX_RS2 (
        .rs2_data(rs2_data),
        .imm(imm),
        .alu_src(alu_src),
        .opcode(opcode),
        .rs2(rs2_selected)
    );

    // ALU
    EX_stage ALU (
        .rs1(rs1_data),
        .rs2(rs2_selected),
        .control_unit(alu_control),
        .alu_out(alu_out),
        .zero(zero)
    );

    // New PC calculation
    PCnewEx_stage PC_EX (
        .opcode(opcode),
        .pc(pc),
        .imm(imm),
        .pc_new(pc_new)
    );

endmodule
