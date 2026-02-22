`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2026 10:56:16 PM
// Design Name: 
// Module Name: aes_core_tb
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


module aes_core_tb;
reg [127:0] plaintext;
reg [127:0] key;
wire [127:0] ciphertext;
aes_core dut (plaintext, key, ciphertext);
initial begin

plaintext = 128'h7f8383838e9088868c8d8c8c96938c8b;
key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

#100;
end
endmodule
 