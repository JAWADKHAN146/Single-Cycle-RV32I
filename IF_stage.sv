`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2026 02:31:53 PM
// Design Name: 
// Module Name: IF_stage
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


module IF_stage(input logic clk,reset,stall,and_out,
input logic[31:0] pc_signed_offset,
output logic[31:0] address,pc_new 
);
assign pc_newt=address+32'd4;
assign pc_next=and_out?address+pc_signed_offset:pc_newt;
always_ff @(posedge clk or posedge reset)

begin
if(reset)
address <= 32'h0000_0000;
else if(!stall)
address <= pc_next;
end

endmodule
