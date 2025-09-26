// Testbench for Counter - CSE 320 LAB 2
`timescale 1ns / 1ps

module counter_tb;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    
    // Outputs
    wire [3:0] count;
    
    // Instantiate the Unit Under Test (UUT)
    counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;
        
        // Wait for reset
        #10;
        reset = 0;
        
        $display("Counter Testbench Starting...");
        $display("Time\treset\tenable\tcount");
        $display("----\t-----\t------\t-----");
        
        // Test counting with enable
        enable = 1;
        repeat (20) begin
            #10;
            $display("%0t\t%b\t%b\t%b", $time, reset, enable, count);
        end
        
        // Test disable counting
        enable = 0;
        repeat (5) begin
            #10;
            $display("%0t\t%b\t%b\t%b (disabled)", $time, reset, enable, count);
        end
        
        // Test reset during counting
        enable = 1;
        #30;
        reset = 1;
        #10;
        $display("%0t\t%b\t%b\t%b (reset)", $time, reset, enable, count);
        
        reset = 0;
        #10;
        $display("%0t\t%b\t%b\t%b (after reset)", $time, reset, enable, count);
        
        // Continue counting
        repeat (10) begin
            #10;
            $display("%0t\t%b\t%b\t%b", $time, reset, enable, count);
        end
        
        $display("\nCounter Testbench Completed.");
        $finish;
    end
    
endmodule