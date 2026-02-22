`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2026 03:36:16 PM
// Design Name: 
// Module Name: aes_core
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


module aes_core(
input  wire [127:0] plaintext,
input  wire [127:0] key,
output wire [127:0] ciphertext
    );
    
    wire [1407:0] full_keys;
    wire [127:0]  round_key [0:10];
    key_expansion k_exp (
        .key_in(key),
        .w_out(full_keys)
    );
    genvar k;
    generate
        for (k = 0; k < 11; k = k + 1) begin
        assign round_key[k] = full_keys[(1407 - k*128) -: 128];
        end
    endgenerate
    wire [127:0] state_after_start;
    wire [127:0] sb_out [1:10]; // Output of SubBytes
    wire [127:0] sr_out [1:10]; // Output of ShiftRows
    wire [127:0] mc_out [1:9];  // Output of MixColumns (Only rounds 1-9)
    wire [127:0] round_out [1:9]; // Output of AddRoundKey (End of round)
    
    //round 0
   add_round_key ARK_0 (
        .state_in(plaintext),
        .round_key(round_key[0]),
        .state_out(state_after_start)
    );
    
    //round 1 to 9
    genvar r;
    generate 
    for (r=1;r<10;r=r+1) begin
    wire [127:0] round_in;
    assign round_in= (r==1)?state_after_start:round_out[r-1];
    
    sub_bytes SB (
                .state_in(round_in),
                .state_out(sb_out[r])
            ); 
            
    shift_rows SR (
                .state_in(sb_out[r]),
                .state_out(sr_out[r])
            );
    mix_columns MC (
                .state_in(sr_out[r]),
                .state_out(mc_out[r])
            );
    add_round_key ARK (
                .state_in(mc_out[r]),
                .round_key(round_key[r]),
                .state_out(round_out[r])
            );

        end
    endgenerate
                    
    //round 10
    
    sub_bytes SB_Last (
        .state_in(round_out[9]),
        .state_out(sb_out[10])
    );
    
    shift_rows SR_Last (
        .state_in(sb_out[10]),
        .state_out(sr_out[10])
    );
    
    add_round_key ARK_Last (
        .state_in(sr_out[10]),
        .round_key(round_key[10]),
        .state_out(ciphertext)
    );

endmodule
