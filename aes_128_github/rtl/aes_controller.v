`timescale 1ns / 1ps

module aes_controller #(
    parameter TOTAL_BLOCKS = 4 // Kept at 4 for fast simulation!
)(
    input wire clk,
    input wire reset, 

    // --- UART RX HANDSHAKE ---
    input wire [7:0] rx_data,     
    input wire       rx_valid,    
    output reg       rx_ready,    

    // --- UART TX HANDSHAKE ---
    output reg [7:0] tx_data,     // CHANGED: Now 8-bit
    output reg       tx_valid,    
    input  wire      tx_busy,     // NEW: Tells us if UART is busy

    // --- AES CORE HANDSHAKE ---
    output reg [127:0] aes_state_in, 
    output reg [127:0] aes_key,      
    output reg         aes_start,    
    input wire [127:0] aes_out,      
    input wire         aes_valid_out
);

     reg [127:0] input_bram  [0:TOTAL_BLOCKS-1];
     reg [127:0] output_bram [0:TOTAL_BLOCKS-1];

    localparam STATE_LOAD    = 2'b00;
    localparam STATE_ENCRYPT = 2'b01;
    localparam STATE_SEND    = 2'b10;
    
    reg [1:0] state;

    reg [127:0] buffer;
    reg [3:0]   byte_count;

    // Address trackers
    reg [2:0] load_addr;          
    reg [2:0] encrypt_read_addr;  
    reg [2:0] encrypt_write_addr; 
    reg [2:0] send_addr;          

    // NEW: Variables for the Serializer in STATE_SEND
    reg [127:0] tx_shift_reg;
    reg [4:0]   tx_byte_count;
    reg         tx_active;

    always @(posedge clk) begin
        if (reset) begin
            state              <= STATE_LOAD;
            byte_count         <= 0;
            load_addr          <= 0;
            encrypt_read_addr  <= 0;
            encrypt_write_addr <= 0;
            send_addr          <= 0;
            
            tx_shift_reg  <= 0;
            tx_byte_count <= 0;
            tx_active     <= 0;

            buffer        <= 0;
            aes_start     <= 0;
            tx_valid      <= 0;
            rx_ready      <= 1; 
            aes_key       <= 128'h2b7e151628aed2a6abf7158809cf4f3c;
        end else begin
            
            aes_start <= 0;
            tx_valid  <= 0; // Default off, will pulse when ready

            case (state)
                // --- PHASE 1: LOAD ---
                STATE_LOAD: begin
                    if (rx_valid && rx_ready) begin
                        buffer <= {buffer[119:0], rx_data};                      
                        if (byte_count == 15) begin
                            byte_count <= 0;
                            input_bram[load_addr] <= {buffer[119:0], rx_data};
                            
                            if (load_addr == TOTAL_BLOCKS - 1) begin
                                state <= STATE_ENCRYPT; 
                                rx_ready <= 0; 
                            end else begin
                                load_addr <= load_addr + 1;
                            end
                        end else begin
                            byte_count <= byte_count + 1;
                        end
                    end
                end

                // --- PHASE 2: ENCRYPT ---
                STATE_ENCRYPT: begin
                    if (encrypt_read_addr < TOTAL_BLOCKS) begin
                        aes_state_in <= input_bram[encrypt_read_addr]; 
                        aes_start    <= 1; 
                        encrypt_read_addr <= encrypt_read_addr + 1;
                    end
                    
                    if (aes_valid_out) begin
                        output_bram[encrypt_write_addr] <= aes_out;
                        if (encrypt_write_addr == TOTAL_BLOCKS - 1) begin
                            state <= STATE_SEND; 
                        end else begin
                            encrypt_write_addr <= encrypt_write_addr + 1;
                        end
                    end
                end

                // --- PHASE 3: SEND (Serializer) ---
                STATE_SEND: begin
                    if (send_addr < TOTAL_BLOCKS) begin
                        
                        // 1. Fetch a new 128-bit block from BRAM
                        if (tx_byte_count == 0 && !tx_active) begin
                            tx_shift_reg  <= output_bram[send_addr];
                            tx_byte_count <= 16;
                            tx_active     <= 1;
                        
                        // 2. Transmit the 16 bytes sequentially
                        end else if (tx_byte_count > 0) begin
                            // If UART is ready to accept a new byte
                            if (!tx_busy && !tx_valid) begin
                                tx_data  <= tx_shift_reg[127:120]; // Grab the top byte
                                tx_valid <= 1;                     // Pulse valid
                            // After pulsing valid, shift the register left by 8 bits
                            end else if (tx_valid) begin
                                tx_shift_reg  <= {tx_shift_reg[119:0], 8'h00};
                                tx_byte_count <= tx_byte_count - 1;
                            end
                        
                        // 3. Block is finished, move to next address
                        end else begin
                            tx_active <= 0;
                            send_addr <= send_addr + 1;
                        end
                        
                    end else begin
                        // Done sending all blocks! Reset FSM.
                        state <= STATE_LOAD;
                        load_addr <= 0;
                        encrypt_read_addr <= 0;
                        encrypt_write_addr <= 0;
                        send_addr <= 0;
                        rx_ready <= 1;
                    end
                end
                
            endcase
        end
    end
endmodule
