`timescale 1ns / 1ps

module image_encryptor_top(
    input  wire clk,
    input  wire reset,
    input  wire rx,  // 1-bit Serial IN from PC
    output wire tx   // 1-bit Serial OUT to PC
);

    // --- INTERNAL WIRES ---
    wire [7:0] w_rx_byte;
    wire       w_rx_valid;
    wire [7:0] w_tx_byte;
    wire       w_tx_valid;
    wire       w_tx_busy;

    wire [127:0] w_plaintext;
    wire [127:0] w_key;
    wire [127:0] w_ciphertext;
    wire         w_start;
    wire         w_done;

    // --- 1. UART RECEIVER ---
    uart_rx #(
        .CLKS_PER_BIT(868)
    ) RX_INST (
        .clk(clk),
        .rx_serial(rx),
        .rx_byte(w_rx_byte),
        .rx_valid(w_rx_valid)
    );

    // --- 2. AES CONTROLLER ---
    aes_controller #(
        .TOTAL_BLOCKS(4)
    ) CTRL (
        .clk(clk),
        .reset(reset),        
        
        .rx_data(w_rx_byte),   
        .rx_valid(w_rx_valid),
        .rx_ready(), // Ignored, UART doesn't stop sending
        
        .tx_data(w_tx_byte),
        .tx_valid(w_tx_valid),
        .tx_busy(w_tx_busy),
        
        .aes_state_in(w_plaintext),
        .aes_key(w_key),
        .aes_start(w_start),
        .aes_out(w_ciphertext),
        .aes_valid_out(w_done) 
    );

    // --- 3. UART TRANSMITTER ---
    uart_tx #(
        .CLKS_PER_BIT(868)
    ) TX_INST (
        .clk(clk),
        .tx_byte(w_tx_byte),
        .tx_valid(w_tx_valid),
        .tx_serial(tx),
        .tx_busy(w_tx_busy)
    );

    // --- 4. AES CORE ---
  
    aes_core CORE (
        .clk(clk),            
        .valid_in(w_start),    
        .plaintext(w_plaintext),
        .key(w_key),
        .ciphertext(w_ciphertext),
        .valid_out(w_done)     
    );

endmodule
