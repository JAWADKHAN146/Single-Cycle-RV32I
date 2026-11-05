`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2026 02:17:18 PM
// Design Name: 
// Module Name: WB_Stage
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


module WB_Stage(input logic[31:0] alu_out,return_address,imm_out,pc_exe,read_data,
input logic [31:0] mux1_in,
output logic [31:0]mux1_out,
input logic [6:0] opcode,
input logic[1:0] memtoreg,
output logic [31:0]wb_data);
always_comb
begin
case(opcode)
7'b0110011,7'b0010011,7'b0000011,7'b0100011,7'b1100011,7'b0110111:begin
mux1_out=alu_out;
end
7'b1100111:begin
mux1_out=return_address;
end
7'b1101111:begin
mux1_out=imm_out;
end
7'b0010111:begin
mux1_out=pc_exe;
end
endcase
case(memtoreg)
2'b00:begin
wb_data=alu_out;
end
2'b01:begin
wb_data=mux1_out;
end
2'b10:begin
wb_data=read_data;
end 
endcase
end
endmodule
