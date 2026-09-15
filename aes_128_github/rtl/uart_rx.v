`timescale 1ns / 1ps

module uart_rx #(
    // 100 MHz clock / 115200 baud rate = 868
    parameter CLKS_PER_BIT = 868
)(
    input  wire       clk,
    input  wire       rx_serial,
    output reg  [7:0] rx_byte,
    output reg        rx_valid
);

    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;
    localparam CLEANUP      = 3'b100;

    reg [2:0]  state      = IDLE;
    reg [9:0]  clk_count  = 0;
    reg [2:0]  bit_index  = 0;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                rx_valid <= 0;
                clk_count <= 0;
                bit_index <= 0;
                if (rx_serial == 0) // Start bit detected
                    state <= START_BIT;
            end

            START_BIT: begin
                if (clk_count == (CLKS_PER_BIT-1)/2) begin // Sample at middle of bit
                    if (rx_serial == 0) begin
                        clk_count <= 0;
                        state     <= DATA_BITS;
                    end else begin
                        state     <= IDLE;
                    end
                end else begin
                    clk_count <= clk_count + 1;
                end
            end

            DATA_BITS: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count          <= 0;
                    rx_byte[bit_index] <= rx_serial;
                    
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state     <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    rx_valid  <= 1;
                    clk_count <= 0;
                    state     <= CLEANUP;
                end
            end

            CLEANUP: begin
                rx_valid <= 0;
                state    <= IDLE;
            end
            
            default: state <= IDLE;
        endcase
    end
endmodule
