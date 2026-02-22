`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2026 06:31:34 PM
// Design Name: 
// Module Name: mix_columns_tb
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


module mix_columns_tb;
reg [127:0] state_in;
wire [127:0] state_out;
mix_columns dut (state_in, state_out);
initial begin
state_in = 128'h7f8383838e9088868c8d8c8c96938c8b;
#10;
end
endmodule
