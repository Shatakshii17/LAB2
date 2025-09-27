`timescale 1ns / 1ps

// Problem 1 testbench
module lab2fsm_tb();
    // inputs
    reg X, CLK, RST;

    // outputs
    wire S, V;

    // instantiate module under test
    lab2fsm_behavioral UUT (
        .X   (X),
        .CLK (CLK),
        .RST (RST),
        .S   (S),
        .V   (V)
    );

    // clock generation, provided from lecture slides
    initial begin
        CLK = 0;
        forever begin
        #5 CLK = ~CLK; // Clock period is 10 ns, so it "flips" every 5 ns
        end
    end

    // initialization/reset and perform test cases
    initial begin
        // simple monitor
        $monitor("t=%0t  RST=%b  X=%b  S=%b  V=%b", $time, RST, X, S, V);

        X = 0;

        // Due to negedge sampling in the DUT, use the given reset with a small padding
        RST = 0; #10; RST = 1; #35; RST = 0; #2.5; // wait a bit so X changes don't land on negedge

        // 1101
        X = 1; #10; X = 1; #10; X = 0; #10; X = 1; #10;

        // 1100
        X = 1; #10; X = 1; #10; X = 0; #10; X = 0; #10;

        // 1011
        X = 1; #10; X = 0; #10; X = 1; #10; X = 1; #10;

        #50;
        $finish;
    end

endmodule
