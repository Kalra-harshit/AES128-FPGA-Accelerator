`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2026 04:38:52 PM
// Design Name: 
// Module Name: mix_columns
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


module mix_columns(
input [127:0] state_in,
output [127:0] state_out
    );
function [7:0] mb2;
input [7:0] x;
begin
mb2 = (x[7] == 1) ? ((x << 1) ^ 8'h1b) : (x << 1);
end
endfunction
function [7:0] mb3;
input [7:0] x;
begin
mb3= mb2(x)^x;
end
endfunction 

    // COLUMN 0   
    assign state_out[127:120] = mb2(state_in[127:120]) ^ mb3(state_in[119:112]) ^ state_in[111:104]    ^ state_in[103:96];
    assign state_out[119:112] = state_in[127:120]      ^ mb2(state_in[119:112]) ^ mb3(state_in[111:104]) ^ state_in[103:96];
    assign state_out[111:104] = state_in[127:120]      ^ state_in[119:112]      ^ mb2(state_in[111:104]) ^ mb3(state_in[103:96]);    
    assign state_out[103:96]  = mb3(state_in[127:120]) ^ state_in[119:112]      ^ state_in[111:104]      ^ mb2(state_in[103:96]);
    // COLUMN 1    
    assign state_out[95:88] = mb2(state_in[95:88]) ^ mb3(state_in[87:80]) ^ state_in[79:72]    ^ state_in[71:64];
    assign state_out[87:80] = state_in[95:88]      ^ mb2(state_in[87:80]) ^ mb3(state_in[79:72]) ^ state_in[71:64];
    assign state_out[79:72] = state_in[95:88]      ^ state_in[87:80]      ^ mb2(state_in[79:72]) ^ mb3(state_in[71:64]);
    assign state_out[71:64] = mb3(state_in[95:88]) ^ state_in[87:80]      ^ state_in[79:72]      ^ mb2(state_in[71:64]);
   // COLUMN 2 
    assign state_out[63:56] = mb2(state_in[63:56]) ^ mb3(state_in[55:48]) ^ state_in[47:40]    ^ state_in[39:32];   
    assign state_out[55:48] = state_in[63:56]      ^ mb2(state_in[55:48]) ^ mb3(state_in[47:40]) ^ state_in[39:32];
    assign state_out[47:40] = state_in[63:56]      ^ state_in[55:48]      ^ mb2(state_in[47:40]) ^ mb3(state_in[39:32]);
    assign state_out[39:32] = mb3(state_in[63:56]) ^ state_in[55:48]      ^ state_in[47:40]      ^ mb2(state_in[39:32]);
    // COLUMN 3 
    assign state_out[31:24] = mb2(state_in[31:24]) ^ mb3(state_in[23:16]) ^ state_in[15:8]     ^ state_in[7:0];
    assign state_out[23:16] = state_in[31:24]      ^ mb2(state_in[23:16]) ^ mb3(state_in[15:8])  ^ state_in[7:0];
    assign state_out[15:8]  = state_in[31:24]      ^ state_in[23:16]      ^ mb2(state_in[15:8])  ^ mb3(state_in[7:0]);
    assign state_out[7:0]   = mb3(state_in[31:24]) ^ state_in[23:16]      ^ state_in[15:8]       ^ mb2(state_in[7:0]);

endmodule
