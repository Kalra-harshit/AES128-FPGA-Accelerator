`timescale 1ns / 1ps

module aes_controller(
    input wire clk,
    input wire reset, 

    // --- STREAMING INPUT (From Testbench/UART) ---
    input wire [7:0] rx_data,     // 8-bit byte arriving
    input wire       rx_valid,    // Signal that data is valid
    output reg       rx_ready,    // "I am ready to receive more data"

    // --- AES HANDSHAKE (To AES Core) ---
    output reg [127:0] aes_state_in, // Renamed from 'aes_in' to match Top Module
    output reg [127:0] aes_key,      // The Key
    output reg         aes_start,    // "Start Encryption" signal
    input wire [127:0] aes_out,      // Result from Core

    // --- STREAMING OUTPUT (Result) ---
    output reg [127:0] tx_data,      // The encrypted result
    output reg         tx_valid      // "Result is ready"
    );

    // --- INTERNAL STORAGE ---
    reg [127:0] buffer;      // Accumulates the 16 bytes
    reg [3:0]   byte_count;  // Counter 0 to 15
    reg [4:0]   wait_timer;  // Timer to wait for AES Core

    // --- STATE MACHINE ---
    localparam STATE_IDLE      = 2'b00;
    localparam STATE_COLLECT   = 2'b01; 
    localparam STATE_CALCULATE = 2'b10; 
    localparam STATE_DONE      = 2'b11; 

    reg [1:0] state;
    
    // Hardcoded Key (Can be changed later)
    always @(*) aes_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    
    always @(posedge clk) begin
        if (reset) begin
            state        <= STATE_IDLE;
            byte_count   <= 0;
            buffer       <= 0;
            rx_ready     <= 0;
            aes_start    <= 0;
            tx_valid     <= 0;
            tx_data      <= 0;
            wait_timer   <= 0;
            aes_state_in <= 0;
            aes_key      <= 128'h2b7e151628aed2a6abf7158809cf4f3c;
        end else begin
            case (state)
            
                // 1. IDLE: Reset everything and get ready
                STATE_IDLE: begin
                    byte_count <= 0;
                    tx_valid   <= 0;
                    rx_ready   <= 1; 
                    state      <= STATE_COLLECT;
                end
                
                // 2. COLLECT: Gather 16 bytes into the 128-bit buffer
                STATE_COLLECT: begin
                    if (rx_valid) begin
                        buffer <= {buffer[119:0], rx_data};                      
                        if (byte_count == 15) begin
                            rx_ready <= 0; 
                            state    <= STATE_CALCULATE;
                        end else begin
                            byte_count <= byte_count + 1;
                        end
                    end
                end
                
                // 3. CALCULATE: Send to AES Core and wait
                STATE_CALCULATE: begin
                    aes_state_in <= buffer; 
                    aes_start    <= 1;                      
                    // Wait for 20 clock cycles for AES to finish
                    if (wait_timer == 20) begin
                        aes_start  <= 0;
                        wait_timer <= 0;
                        tx_data    <= aes_out; 
                        state      <= STATE_DONE;
                    end else begin
                        wait_timer <= wait_timer + 1;
                    end
                end
                
                // 4. DONE: Output the result flag
                STATE_DONE: begin
                    tx_valid <= 1;
                    state    <= STATE_IDLE; 
                end
                
            endcase
        end
    end

endmodule