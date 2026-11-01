`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2026 11:03:14 AM
// Design Name: 
// Module Name: PCnewEx_stage
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


module PCnewEx_stage(input logic [6:0]opcode,
input logic [31:0]pc,imm,
output logic [31:0]pc_new 
);
always_comb
begin
if(opcode==1101111)
pc_new=pc+imm;
else
pc_new=pc+32'd4;
end
endmodule
