`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2026 03:16:19 PM
// Design Name: 
// Module Name: alu_control
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


module alu_control(input logic[2:0] alu_op,
input logic [2:0] fn3,
input logic  fn7_5,
input logic [6:0]imm11_5,
output logic [4:0]control_unit);
always_comb
begin
control_unit=5'b0;
case(alu_op)
3'b000: begin
if(fn3==3'b000 && fn7_5==0)begin
 control_unit=5'b0;
 end
 else if(fn3==3'b0 && fn7_5==1)begin
 control_unit=5'b00001;
end
else if(fn3==3'b001)begin
control_unit=5'b00101;
end
else if(fn3==3'b010)begin
control_unit=5'b01000;
end
else if(fn3==3'b011)begin
control_unit=5'b01001;
end
else if(fn3==3'b100)begin
control_unit=5'b00010;
end
else if(fn3==3'b101 && fn7_5==0)begin
control_unit=5'b00110;
end
else if(fn3==3'b101 && fn7_5==1)begin
control_unit=5'b00111;
end
else if(fn3==3'b110)begin
control_unit=5'b00011;
end
else if(fn3==3'b111)begin
control_unit=5'b00100;
end
end
3'b001:begin
if(fn3==3'b101 && imm11_5==7'b0)begin
control_unit=5'b00110;
end
else if(fn3==3'b101 && imm11_5==7'b0100000)begin
control_unit=5'b00111;
end
end
3'b010,3'b011:begin
control_unit=5'b0;
end
3'b100: begin // Branch instructions
            case (fn3)
                3'b000: control_unit = 5'b01010; // BEQ
                3'b001: control_unit = 5'b01011; // BNE
                3'b100: control_unit= 5'b01100; // BLT
                3'b101: control_unit = 5'b01101; // BGE
                3'b110: control_unit = 5'b01110; // BLTU
                3'b111: control_unit = 5'b01111; // BGEU
                default: control_unit = 5'b00000;
            endcase
        end
        3'b110: begin // JAL, LUI, AUIPC
            control_unit = 5'b00000; // ADD path
        end
endcase
end
endmodule
