`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2026 03:06:30 PM
// Design Name: 
// Module Name: key_expansion_tb
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


module key_expansion_tb;
reg [127:0] key_in;
wire [1407:0] w_out;
key_expansion dut (key_in, w_out);
initial begin
key_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        #10;
        if (w_out[127:0] == 128'hd014f9a8c9ee2589e13f0cc8b6630ca6)
            $display(" PASS: Key Expansion Successful!");
        end
endmodule
