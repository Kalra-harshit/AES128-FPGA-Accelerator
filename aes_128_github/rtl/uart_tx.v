`timescale 1ns / 1ps

module uart_tx #(
    // 100 MHz clock / 115200 baud rate = 868
    parameter CLKS_PER_BIT = 868
)(
    input  wire       clk,
    input  wire [7:0] tx_byte,
    input  wire       tx_valid,
    output reg        tx_serial,
    output reg        tx_busy
);

    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;

    reg [2:0] state      = IDLE;
    reg [9:0] clk_count  = 0;
    reg [2:0] bit_index  = 0;
    reg [7:0] data_reg   = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx_serial <= 1; // Idle line is high
                tx_busy   <= 0;
                clk_count <= 0;
                bit_index <= 0;
                
                if (tx_valid) begin
                    tx_busy  <= 1;
                    data_reg <= tx_byte;
                    state    <= START_BIT;
                end
            end

            START_BIT: begin
                tx_serial <= 0; // Drive start bit
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    state     <= DATA_BITS;
                end
            end

            DATA_BITS: begin
                tx_serial <= data_reg[bit_index];
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state     <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                tx_serial <= 1; // Drive stop bit
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    tx_busy   <= 0;
                    state     <= IDLE;
                end
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule
