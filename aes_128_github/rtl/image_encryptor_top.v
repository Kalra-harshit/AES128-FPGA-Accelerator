`timescale 1ns / 1ps

module image_encryptor_top(
    input wire clk,
    input wire reset,
    input wire [7:0] uart_byte_in,  // The 8-bit data
    input wire       uart_valid_in, // Pulse HIGH when data is ready
    
    // --- OUTPUTS ---
    output wire [127:0] tx_data,
    output wire         tx_valid
    );

    // Wires between Controller and AES Core
    wire [127:0] w_plaintext;
    wire [127:0] w_key;
    wire [127:0] w_ciphertext;
    wire         w_start;

    // --- 1. THE CONTROLLER ---
    aes_controller CTRL (
        .clk(clk),
        .reset(reset),        
        // MAPPING: External Input -> Controller Input
        .rx_data(uart_byte_in),   
        .rx_valid(uart_valid_in),
        .rx_ready(), // Output ignored for now
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .aes_state_in(w_plaintext),
        .aes_key(w_key),
        .aes_start(w_start),
        .aes_out(w_ciphertext)
    );

    // --- 2. THE AES CORE ---
    aes_core CORE (
        .plaintext(w_plaintext),
        .key(w_key),
        .ciphertext(w_ciphertext)
    );

endmodule