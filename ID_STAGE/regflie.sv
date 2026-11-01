`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2026 01:36:46 PM
// Design Name: 
// Module Name: regflie
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


module regflie(logic[4:0] rs1_sel,rs2_sel,rd_sel,
logic[31:0] wb_data,
logic reg_write,clk,reset,
output logic[31:0] rs1_data,rs2_data);
logic [31:0] register[31:0];
//read
assign rs1_data=~rs1_sel?32'b0:register[rs1_sel];
assign rs_data=~rs2_sel?32'b0:register[rs2_sel];
//write
always_ff @(posedge clk or posedge reset)
 begin
if(reset==1)
begin
register <='{default:0};
end
else if((rd_sel !=0) & reg_write)
begin
register[rd_sel]<= wb_data;
end
end
endmodule
