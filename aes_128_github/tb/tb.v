`timescale 1ns / 1ps

module tb;

    reg clk;
    reg reset;
    reg [7:0] uart_byte_in;   
    reg       uart_valid_in;  

    wire [127:0] tx_data;     
    wire         tx_valid;    

    reg [7:0] image_memory [0:63]; 
    integer i;
    integer block;
    
    image_encryptor_top UUT (
        .clk(clk), 
        .reset(reset), 
        .uart_byte_in(uart_byte_in), 
        .uart_valid_in(uart_valid_in), 
        .tx_data(tx_data), 
        .tx_valid(tx_valid)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        uart_byte_in = 0;
        uart_valid_in = 0;
        $readmemh("image.mem", image_memory);       
        #100;
        reset = 0;
        #100;
        for (block = 0; block < 4; block = block + 1) begin            
            for (i = 0; i < 16; i = i + 1) begin
                uart_byte_in = image_memory[(block * 16) + i];                 
                uart_valid_in = 1;
                #10; 
                uart_valid_in = 0;                
                #100; 
            end            
            wait(tx_valid == 1);           
           #500;             
        end       
        #1000;
        $finish;
    end
      
endmodule