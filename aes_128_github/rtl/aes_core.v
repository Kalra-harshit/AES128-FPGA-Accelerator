`timescale 1ns / 1ps

module aes_core(
    input  wire clk,               // NEW: Clock signal for pipeline
    input  wire valid_in,          // NEW: Handshake signal to track data
    input  wire [127:0] plaintext,
    input  wire [127:0] key,
    output reg  [127:0] ciphertext, // CHANGED: Output is now registered
    output reg  valid_out           // NEW: Handshake signal for output
);

    // --- KEY EXPANSION (Remains Combinational) ---
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

    // --- PIPELINE REGISTERS ---
    reg [127:0] pipe_state [0:9];
    reg         pipe_valid [0:9];

    // --- ROUND 0: Initial AddRoundKey ---
    wire [127:0] state_after_start;
    add_round_key ARK_0 (
        .state_in(plaintext),
        .round_key(round_key[0]),
        .state_out(state_after_start)
    );

    always @(posedge clk) begin
        pipe_state[0] <= state_after_start;
        pipe_valid[0] <= valid_in;
    end

    // --- ROUNDS 1 to 9 ---
    genvar r;
    generate 
        for (r = 1; r < 10; r = r + 1) begin : aes_rounds
            wire [127:0] sb_out, sr_out, mc_out, round_out;
            
            sub_bytes SB (
                .state_in(pipe_state[r-1]), // Pull from previous pipeline stage
                .state_out(sb_out)
            );
            shift_rows SR (
                .state_in(sb_out),
                .state_out(sr_out)
            );
            mix_columns MC (
                .state_in(sr_out),
                .state_out(mc_out)
            );
            add_round_key ARK (
                .state_in(mc_out),
                .round_key(round_key[r]),
                .state_out(round_out)
            );

            // Register the output of the round
            always @(posedge clk) begin
                pipe_state[r] <= round_out;
                pipe_valid[r] <= pipe_valid[r-1];
            end
        end
    endgenerate
                    
    // --- ROUND 10: Final Round ---
    wire [127:0] sb_out_10, sr_out_10, final_out;
    
    sub_bytes SB_Last (
        .state_in(pipe_state[9]),
        .state_out(sb_out_10)
    );
    shift_rows SR_Last (
        .state_in(sb_out_10),
        .state_out(sr_out_10)
    );
    add_round_key ARK_Last (
        .state_in(sr_out_10),
        .round_key(round_key[10]),
        .state_out(final_out)
    );

    // Final Stage Register maps directly to the module output
    always @(posedge clk) begin
        ciphertext <= final_out;
        valid_out  <= pipe_valid[9];
    end

endmodule
