`timescale 1ns / 1ps

module tb;

    reg clk;
    reg reset;
    reg rx;
    wire tx;

    // 100MHz Clock -> 10ns period. 
    // 115200 baud -> 868 clocks per bit -> 8680 ns per bit
    localparam BIT_PERIOD = 8680; 

    // Instantiate the NEW Top Module
    image_encryptor_top UUT (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx(tx)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    // -----------------------------------------------------------------
    // TASK: Simulate a PC sending a byte over UART
    // -----------------------------------------------------------------
    task UART_WRITE_BYTE;
        input [7:0] i_data;
        integer i;
        begin
            // 1. Drive Start Bit (0)
            rx = 0;
            #(BIT_PERIOD);

            // 2. Drive 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = i_data[i];
                #(BIT_PERIOD);
            end

            // 3. Drive Stop Bit (1)
            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // -----------------------------------------------------------------
    // MAIN STIMULUS
    // -----------------------------------------------------------------
    reg [7:0] image_memory [0:63]; 
    integer block, byte_idx;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        rx = 1; // UART Idle state is HIGH
        
        $readmemh("image.mem", image_memory);
        
        #100; 
        reset = 0; 
        #100;
        
        $display("--- Starting Serial Image Transfer (115200 baud) ---");

        // Send all 64 bytes using the UART task
        for (block = 0; block < 4; block = block + 1) begin            
            for (byte_idx = 0; byte_idx < 16; byte_idx = byte_idx + 1) begin
                UART_WRITE_BYTE(image_memory[(block * 16) + byte_idx]);
                // Add a small delay between bytes (simulating PC processing time)
                #(BIT_PERIOD * 2); 
            end            
        end 
        
        $display("--- PC Finished Sending. Hardware is encrypting... ---");
        
        // The simulation will naturally keep running to allow the 
        // FPGA to send the encrypted data back over the TX line.
    end

endmodule
