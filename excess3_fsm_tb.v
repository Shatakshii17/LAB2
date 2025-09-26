//Comprehensive testbench for Excess-3 FSM
//Tests all 4-bit binary inputs (0000 to 1111) and verifies Excess-3 output conversion

// FSM module (copied from template for standalone testing)
module lab2fsm_behavioral(X, CLK, RST, S, V);
    input X, CLK, RST;
    output reg S, V;
    
    //intermediate register for states
    reg [2:0] Q;
    
    parameter S0 = 3'd0;  // Initial state
    parameter S1 = 3'd1;  
    parameter S2 = 3'd2;  
    parameter S3 = 3'd3;  
    parameter S4 = 3'd4;  
    parameter S5 = 3'd5; 
    parameter S6 = 3'd6; 
    parameter S7 = 3'd7;  // Received '1011' (valid sequence)
    
    always @ (negedge CLK)
    begin
        if(RST)
        begin
             Q <= S0;
        end
        //finite state machine, can do if/else or switch case
        //both output and state assignment should be done in here, output assignment outside this always block is considered asynchronous
        else
        begin
            case(Q)
                S0: begin  // Present State S0
                    if(X) Q <= S2;  // X=1 -> Next State S2
                    else Q <= S1;   // X=0 -> Next State S1
                end
                
                S1: begin  // Present State S1
                    if(X) Q <= S4;  // X=1 -> Next State S4
                    else Q <= S3;   // X=0 -> Next State S3
                end
                
                S2: begin  // Present State S2
                    if(X) Q <= S4;  // X=1 -> Next State S4
                    else Q <= S4;   // X=0 -> Next State S4
                end
                
                S3: begin  // Present State S3
                    if(X) Q <= S5;  // X=1 -> Next State S5
                    else Q <= S5;   // X=0 -> Next State S5
                end
                
                S4: begin  // Present State S4
                    if(X) Q <= S6;  // X=1 -> Next State S6
                    else Q <= S5;   // X=0 -> Next State S5
                end
                
                S5: begin  // Present State S5
                    if(X) Q <= S0;  // X=1 -> Next State S0
                    else Q <= S0;   // X=0 -> Next State S0
                end
                
                S6: begin  // Present State S6
                    if(X) Q <= S0;  // X=1 -> Next State S0
                    else Q <= S0;   // X=0 -> Next State S0
                end
                
                default: Q <= S0;  // Default case
            endcase
        end
    end
    
    //procedural block for output
    always @ (*)
    begin      
        case(Q)
            S0: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S1: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S2: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S3: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S4: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            S5: begin S = 0; V = 1; end  // Output (S,V) = (0,1)
            S6: begin S = 1; V = 0; end  // Output (S,V) = (1,0)
            default: begin S = 0; V = 0; end
        endcase        
    end  
endmodule

// Comprehensive testbench module
module excess3_fsm_comprehensive_tb();
    // Inputs
    reg X, CLK, RST;
    
    // Outputs
    wire S, V;
    
    // Test variables
    reg [3:0] test_input;
    reg [3:0] expected_excess3;
    reg [1:0] output_bits;
    integer i, j;
    integer pass_count, fail_count;
    
    // Instantiate module under test
    lab2fsm_behavioral UUT (
        .X(X),
        .CLK(CLK),
        .RST(RST),
        .S(S),
        .V(V)
    );
    
    // Clock generation - 10ns period
    initial
    begin
        CLK = 0;
        forever 
        begin
            #5 CLK = ~CLK;
        end
    end
    
    // Task to send 4-bit input serially (MSB first)
    task send_4bit_input;
        input [3:0] data;
        begin
            X = data[3]; #10;  // MSB first
            X = data[2]; #10;
            X = data[1]; #10;
            X = data[0]; #10;  // LSB last
        end
    endtask
    
    // Task to reset FSM
    task reset_fsm;
        begin
            RST = 1; #15; RST = 0; #5;
        end
    endtask
    
    // Task to capture output after 4 bits
    task capture_output;
        output [1:0] captured;
        begin
            captured = {S, V};  // Capture the 2-bit output
        end
    endtask
    
    // Function to calculate expected Excess-3 code
    function [3:0] binary_to_excess3;
        input [3:0] binary_val;
        begin
            binary_to_excess3 = binary_val + 4'd3;  // Add 3 to get Excess-3
        end
    endfunction
    
    // Main test sequence
    initial
    begin
        $dumpfile("excess3_fsm_tb.vcd");
        $dumpvars(0, excess3_fsm_comprehensive_tb);
        
        // Initialize
        pass_count = 0;
        fail_count = 0;
        X = 0;
        
        $display("=====================================");
        $display("Comprehensive Excess-3 FSM Testbench");
        $display("=====================================");
        $display("Time\t\tInput\tExpected\tOutput\tS\tV\tResult");
        $display("-----\t\t-----\t--------\t------\t-\t-\t------");
        
        // Test all 16 possible 4-bit inputs (0000 to 1111)
        for (i = 0; i < 16; i = i + 1)
        begin
            test_input = i;
            expected_excess3 = binary_to_excess3(test_input);
            
            // Reset FSM for each test
            reset_fsm();
            
            // Send the 4-bit input
            send_4bit_input(test_input);
            
            // Wait a bit for outputs to stabilize
            #5;
            
            // Capture the output
            capture_output(output_bits);
            
            // Display results
            $display("%0t\t%b\t%b\t\t%b\t%b\t%b\t%s", 
                     $time, test_input, expected_excess3, output_bits, S, V,
                     (output_bits == expected_excess3[1:0]) ? "PASS" : "FAIL");
            
            // Count pass/fail
            if (output_bits == expected_excess3[1:0])
                pass_count = pass_count + 1;
            else
                fail_count = fail_count + 1;
                
            #20; // Wait between tests
        end
        
        $display("=====================================");
        $display("Test Summary:");
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("Total:  %0d", pass_count + fail_count);
        $display("=====================================");
        
        // Additional specific test cases mentioned in original testbench
        $display("\nTesting specific sequences from original testbench:");
        
        // Test 1011 (11 decimal -> 14 excess-3)
        reset_fsm();
        $display("Testing 1011 (11 decimal):");
        $monitor("Time: %0t, RST: %b, X: %b, State: %d, S: %b, V: %b", 
                 $time, RST, X, UUT.Q, S, V);
        X = 1; #10; X = 0; #10; X = 1; #10; X = 1; #10;
        $display("Final output S=%b, V=%b (Expected: 14 in excess-3)", S, V);
        #10;
        
        // Test 1100 (12 decimal -> 15 excess-3)
        reset_fsm();
        $display("Testing 1100 (12 decimal):");
        X = 1; #10; X = 1; #10; X = 0; #10; X = 0; #10;
        $display("Final output S=%b, V=%b (Expected: 15 in excess-3)", S, V);
        #10;
        
        // Test 1101 (13 decimal -> 16 excess-3, but 16 > 15, so likely invalid)
        reset_fsm();
        $display("Testing 1101 (13 decimal):");
        X = 1; #10; X = 1; #10; X = 0; #10; X = 1; #10;
        $display("Final output S=%b, V=%b (13 decimal input)", S, V);
        #10;
        
        $finish;
    end
    
    // Additional edge case tests
    initial
    begin
        #5000; // Let main tests complete first
        
        $display("\n=====================================");
        $display("Edge Case Tests:");
        $display("=====================================");
        
        // Test: Multiple consecutive inputs without reset
        reset_fsm();
        $display("Testing consecutive inputs without reset:");
        send_4bit_input(4'b0000); // First input: 0000
        #5; $display("After 0000: S=%b, V=%b", S, V);
        
        send_4bit_input(4'b1111); // Second input: 1111
        #5; $display("After 1111: S=%b, V=%b", S, V);
        
        // Test: Reset during input sequence
        $display("Testing reset during input sequence:");
        reset_fsm();
        X = 1; #10; X = 0; #10; // Send first 2 bits
        reset_fsm(); // Reset in middle
        X = 1; #10; X = 1; #10; // Complete with different bits
        #5; $display("After reset during input: S=%b, V=%b", S, V);
        
        $finish;
    end

endmodule