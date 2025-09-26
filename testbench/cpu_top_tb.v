// Top-level system testbench - CSE 320 LAB 2
`timescale 1ns / 1ps

module cpu_top_tb;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg [2:0] alu_op;
    reg [1:0] reg_src1;
    reg [1:0] reg_src2;
    reg [1:0] reg_dest;
    reg reg_write_en;
    reg counter_en;
    reg decoder_en;
    
    // Outputs
    wire [3:0] alu_result;
    wire alu_zero;
    wire alu_carry;
    wire [3:0] counter_out;
    wire [3:0] decoder_out;
    
    // Instantiate the Unit Under Test (UUT)
    cpu_top uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .alu_op(alu_op),
        .reg_src1(reg_src1),
        .reg_src2(reg_src2),
        .reg_dest(reg_dest),
        .reg_write_en(reg_write_en),
        .counter_en(counter_en),
        .decoder_en(decoder_en),
        .alu_result(alu_result),
        .alu_zero(alu_zero),
        .alu_carry(alu_carry),
        .counter_out(counter_out),
        .decoder_out(decoder_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;
        alu_op = 0;
        reg_src1 = 0;
        reg_src2 = 0;
        reg_dest = 0;
        reg_write_en = 0;
        counter_en = 0;
        decoder_en = 0;
        
        // Wait for reset
        #10;
        reset = 0;
        enable = 1;
        
        $display("CPU Top-level Testbench Starting...");
        $display("=== Initializing registers with test values ===");
        
        // Initialize registers with some test values
        // Write 5 to register 0
        reg_dest = 2'b00; reg_write_en = 1; 
        reg_src1 = 2'b00; reg_src2 = 2'b00; alu_op = 3'b000; // Will be ignored since we need initial values
        #10;
        
        // Manually set initial register values by using immediate ALU operations
        $display("Setting up initial register values...");
        
        // Enable counter and decoder for system operation
        counter_en = 1;
        decoder_en = 1;
        
        $display("\n=== Running system operations ===");
        $display("Time\tCounter\tDecoder\tALU_Result\tZero\tCarry");
        $display("----\t-------\t-------\t----------\t----\t-----");
        
        // Run some operations while counter and decoder are active
        reg_src1 = 2'b00; reg_src2 = 2'b01; alu_op = 3'b000; reg_dest = 2'b10; reg_write_en = 1; // ADD
        repeat (5) begin
            #10;
            $display("%0t\t%b\t%b\t%b\t%b\t%b", $time, counter_out, decoder_out, alu_result, alu_zero, alu_carry);
        end
        
        // Change ALU operation to XOR
        alu_op = 3'b100; reg_dest = 2'b11;
        repeat (5) begin
            #10;
            $display("%0t\t%b\t%b\t%b\t%b\t%b", $time, counter_out, decoder_out, alu_result, alu_zero, alu_carry);
        end
        
        // Test counter reset
        $display("\n=== Testing counter reset ===");
        reset = 1;
        #10;
        reset = 0;
        
        repeat (8) begin
            #10;
            $display("%0t\t%b\t%b\t%b\t%b\t%b", $time, counter_out, decoder_out, alu_result, alu_zero, alu_carry);
        end
        
        // Disable decoder
        $display("\n=== Testing decoder disable ===");
        decoder_en = 0;
        repeat (4) begin
            #10;
            $display("%0t\t%b\t%b\t%b\t%b\t%b", $time, counter_out, decoder_out, alu_result, alu_zero, alu_carry);
        end
        
        $display("\nCPU Top-level Testbench Completed.");
        $finish;
    end
    
    // Monitor important signals
    initial begin
        $monitor("At time %t: Counter=%d, Decoder=%b, ALU_Result=%d", 
                 $time, counter_out, decoder_out, alu_result);
    end
    
endmodule