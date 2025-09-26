// Testbench for ALU - CSE 320 LAB 2
`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    
    // Outputs
    wire [3:0] result;
    wire zero;
    wire carry;
    
    // Instantiate the Unit Under Test (UUT)
    alu uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );
    
    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        op = 0;
        
        // Wait for reset
        #10;
        
        $display("ALU Testbench Starting...");
        $display("Time\ta\tb\top\tresult\tzero\tcarry\toperation");
        $display("----\t-\t-\t--\t------\t----\t-----\t---------");
        
        // Test ADD operation
        a = 4'b0101; b = 4'b0011; op = 3'b000; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tADD", $time, a, b, op, result, zero, carry);
        
        // Test SUB operation
        a = 4'b0101; b = 4'b0011; op = 3'b001; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tSUB", $time, a, b, op, result, zero, carry);
        
        // Test AND operation
        a = 4'b1100; b = 4'b1010; op = 3'b010; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tAND", $time, a, b, op, result, zero, carry);
        
        // Test OR operation
        a = 4'b1100; b = 4'b1010; op = 3'b011; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tOR", $time, a, b, op, result, zero, carry);
        
        // Test XOR operation
        a = 4'b1100; b = 4'b1010; op = 3'b100; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tXOR", $time, a, b, op, result, zero, carry);
        
        // Test SLL operation
        a = 4'b0101; b = 4'b0000; op = 3'b101; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tSLL", $time, a, b, op, result, zero, carry);
        
        // Test SRL operation
        a = 4'b1010; b = 4'b0000; op = 3'b110; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tSRL", $time, a, b, op, result, zero, carry);
        
        // Test NOR operation
        a = 4'b1100; b = 4'b1010; op = 3'b111; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tNOR", $time, a, b, op, result, zero, carry);
        
        // Test zero flag
        a = 4'b0101; b = 4'b0101; op = 3'b001; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tSUB (zero test)", $time, a, b, op, result, zero, carry);
        
        // Test carry flag
        a = 4'b1111; b = 4'b0001; op = 3'b000; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\tADD (carry test)", $time, a, b, op, result, zero, carry);
        
        $display("\nALU Testbench Completed.");
        $finish;
    end
    
endmodule