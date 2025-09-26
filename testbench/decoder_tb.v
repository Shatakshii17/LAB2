// Testbench for Decoder - CSE 320 LAB 2
`timescale 1ns / 1ps

module decoder_tb;

    // Inputs
    reg [1:0] in;
    reg enable;
    
    // Outputs
    wire [3:0] out;
    
    // Instantiate the Unit Under Test (UUT)
    decoder uut (
        .in(in),
        .enable(enable),
        .out(out)
    );
    
    initial begin
        // Initialize Inputs
        in = 0;
        enable = 0;
        
        $display("Decoder Testbench Starting...");
        $display("Time\tin\tenable\tout");
        $display("----\t--\t------\t----");
        
        // Test with enable = 0
        enable = 0;
        in = 2'b00; #10;
        $display("%0t\t%b\t%b\t%b (disabled)", $time, in, enable, out);
        
        in = 2'b01; #10;
        $display("%0t\t%b\t%b\t%b (disabled)", $time, in, enable, out);
        
        // Test with enable = 1
        enable = 1;
        in = 2'b00; #10;
        $display("%0t\t%b\t%b\t%b", $time, in, enable, out);
        
        in = 2'b01; #10;
        $display("%0t\t%b\t%b\t%b", $time, in, enable, out);
        
        in = 2'b10; #10;
        $display("%0t\t%b\t%b\t%b", $time, in, enable, out);
        
        in = 2'b11; #10;
        $display("%0t\t%b\t%b\t%b", $time, in, enable, out);
        
        // Test disable again
        enable = 0;
        in = 2'b11; #10;
        $display("%0t\t%b\t%b\t%b (disabled)", $time, in, enable, out);
        
        $display("\nDecoder Testbench Completed.");
        $finish;
    end
    
endmodule