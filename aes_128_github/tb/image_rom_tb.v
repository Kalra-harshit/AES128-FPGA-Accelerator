`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2026 03:28:06 PM
// Design Name: 
// Module Name: image_rom_tb
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


module image_rom_tb;
reg [5:0] address;
wire [7:0] pixel_out;
image_rom dut (address, pixel_out);
initial begin
for (address=0; address<63; address=address+1)
#10
$display("address=%d |data=%h", address,pixel_out);
end
endmodule
