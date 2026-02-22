`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2026 04:03:55 PM
// Design Name: 
// Module Name: sub_bytes_tb
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


module sub_bytes_tb;
 reg [7:0] in;
 wire [7:0] out;

sub_bytes dut (in,out);
initial begin 
in=8'h20;#10;
in=8'h24;#10;
in=8'h48;#10;
end

endmodule
