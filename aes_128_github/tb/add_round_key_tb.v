module add_round_key_tb;
    reg [127:0] state_in;
    reg [127:0] round_key;
    wire [127:0] state_out;

    add_round_key uut (state_in, round_key, state_out);

    initial begin
        state_in = 128'h00112233445566778899aabbccddeeff;
        round_key = 128'hffffffffffffffffffffffffffffffff; 
        #10;
        if (state_out == ~state_in) 
            $display("AddRoundKey Verified");
        else 
            $display("Fail");
        $finish;
    end
endmodule