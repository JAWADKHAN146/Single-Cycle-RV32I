`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2026 09:37:48 AM
// Design Name: 
// Module Name: EX_stage
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


module EX_stage(input logic [31:0] rs1,rs2,
input logic [4:0]control_unit,
output logic [31:0] alu_out,
output logic zero);
always_comb
begin
alu_out=32'b0;
zero=0;
case(control_unit)
 5'b00000:begin
 alu_out=rs1+rs2;
 end
 5'b00001:begin
 alu_out=rs1-rs2;
 end
 5'b00101:begin
 alu_out=rs1<<rs2;
 end
 5'b01000:begin
    alu_out = ($signed(rs1) < $signed(rs2)) ? 1 : 0;
end
5'b01001:begin
alu_out=(rs1<rs2)?1:0;
end
5'b00010:begin
alu_out=rs1^rs2;
end
5'b00110,5'b00110:begin
alu_out=rs1>>rs2;
end
5'b00111,5'b00111:begin
alu_out= $signed(rs1) >>> rs2;
end
5'b00011:begin
alu_out=rs1|rs2;
end
5'b00100:begin
alu_out=rs1&rs2;
end
5'b01010:begin
zero=(rs1==rs2)?1:0;
end
5'b01011:begin
zero=(rs1!=rs2)?1:0;
end
5'b01100:begin
zero=($signed(rs1)<$signed(rs2))?1:0;
end
5'b01101:begin
zero=($signed(rs1)>=$signed(rs2))?1:0;
end
5'b01110:begin
zero=(rs1<rs2)?1:0;
end
5'b01111:begin
zero=(rs1>=rs2)?1:0;
end
endcase
end
endmodule
