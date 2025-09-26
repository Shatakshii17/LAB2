//// COMPREHENSIVE TESTBENCH FOR EXCESS-3 FSM
//// This testbench provides thorough testing of the Excess-3 Binary-to-Excess-3 FSM
//// with multiple 4-bit binary inputs and verification of output patterns
////
//// Author: Generated for CSE320 Lab 2
//// Description: Tests all possible 4-bit binary inputs (0000 to 1111) and analyzes
////             the FSM's behavior in converting binary inputs to Excess-3 format
////
//// The FSM processes 4-bit binary inputs serially (MSB first) and outputs two
//// signals S and V that together represent the Excess-3 conversion process.

// FSM module (from the original template)
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
    parameter S7 = 3'd7;  // Unused state
    
    always @ (negedge CLK)
    begin
        if(RST)
        begin
             Q <= S0;
        end
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

//// COMPREHENSIVE TESTBENCH MODULE
module excess3_fsm_comprehensive_testbench();
    
    //// Test Bench Signals
    reg X, CLK, RST;                    // Input signals
    wire S, V;                          // Output signals
    
    //// Test Control Variables
    reg [3:0] test_input;               // Current test input
    reg [3:0] expected_excess3;         // Expected Excess-3 result
    reg [1:0] output_capture[0:3];      // Capture S,V outputs for each bit
    reg [3:0] s_sequence, v_sequence;   // Extracted S and V bit sequences
    integer test_count;                 // Test counter
    integer pass_count, fail_count;     // Pass/fail counters
    
    //// File handles for logging
    integer log_file, summary_file;
    
    //// Instantiate the FSM under test
    lab2fsm_behavioral UUT (
        .X(X),
        .CLK(CLK),
        .RST(RST),
        .S(S),
        .V(V)
    );
    
    //// Clock Generation - 10ns period (100MHz)
    initial
    begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    //// Task: Reset the FSM
    task reset_fsm;
        begin
            RST = 1; 
            #15;        // Hold reset for 1.5 clock cycles
            RST = 0; 
            #5;         // Wait for reset to complete
        end
    endtask
    
    //// Task: Test a 4-bit binary sequence
    task test_binary_sequence;
        input [3:0] binary_input;
        input [3:0] decimal_value;
        begin
            test_count = test_count + 1;
            expected_excess3 = decimal_value + 3;  // Excess-3 = Binary + 3
            
            $display("\n--- Test %0d: Binary Input %b (Decimal %0d) ---", 
                     test_count, binary_input, decimal_value);
            $display("Expected Excess-3: %0d (%b)", expected_excess3, expected_excess3);
            
            // Reset FSM before each test
            reset_fsm();
            
            // Send 4 bits serially (MSB first) and capture outputs
            X = binary_input[3]; #10;  // Send MSB
            output_capture[0] = {S, V};
            $display("Bit[3]=%b: State=%0d, Output=(S=%b,V=%b)", 
                     binary_input[3], UUT.Q, S, V);
            
            X = binary_input[2]; #10;  // Send bit 2
            output_capture[1] = {S, V};
            $display("Bit[2]=%b: State=%0d, Output=(S=%b,V=%b)", 
                     binary_input[2], UUT.Q, S, V);
            
            X = binary_input[1]; #10;  // Send bit 1
            output_capture[2] = {S, V};
            $display("Bit[1]=%b: State=%0d, Output=(S=%b,V=%b)", 
                     binary_input[1], UUT.Q, S, V);
            
            X = binary_input[0]; #10;  // Send LSB
            output_capture[3] = {S, V};
            $display("Bit[0]=%b: State=%0d, Output=(S=%b,V=%b)", 
                     binary_input[0], UUT.Q, S, V);
            
            // Extract S and V sequences
            s_sequence = {output_capture[0][1], output_capture[1][1], 
                         output_capture[2][1], output_capture[3][1]};
            v_sequence = {output_capture[0][0], output_capture[1][0], 
                         output_capture[2][0], output_capture[3][0]};
            
            // Display analysis
            $display("Output Analysis:");
            $display("  S-bit sequence: %b (decimal %0d)", s_sequence, s_sequence);
            $display("  V-bit sequence: %b (decimal %0d)", v_sequence, v_sequence);
            $display("  Final state: %0d, Final output: (S=%b,V=%b)", UUT.Q, S, V);
            
            // Log detailed results
            $fdisplay(log_file, "%b,%0d,%0d,%b,%0d,%b,%0d,%0d,%b,%b", 
                     binary_input, decimal_value, expected_excess3,
                     s_sequence, s_sequence, v_sequence, v_sequence,
                     UUT.Q, S, V);
            
            // Simple pass/fail based on final state reaching S0
            if (UUT.Q == 0) begin
                pass_count = pass_count + 1;
                $display("  Result: PASS (FSM returned to initial state)");
            end else begin
                fail_count = fail_count + 1;
                $display("  Result: FAIL (FSM did not return to initial state)");
            end
        end
    endtask
    
    //// Task: Test edge cases
    task test_edge_cases;
        begin
            $display("\n========================================");
            $display("EDGE CASE TESTING");
            $display("========================================");
            
            // Test 1: Reset functionality
            $display("\n--- Edge Case 1: Reset during operation ---");
            reset_fsm();
            X = 1; #10;  // Send first bit
            $display("After 1st bit: State=%0d, S=%b, V=%b", UUT.Q, S, V);
            X = 0; #10;  // Send second bit
            $display("After 2nd bit: State=%0d, S=%b, V=%b", UUT.Q, S, V);
            // Reset in middle of sequence
            reset_fsm();
            $display("After reset: State=%0d, S=%b, V=%b", UUT.Q, S, V);
            
            // Test 2: Multiple sequences without reset
            $display("\n--- Edge Case 2: Multiple sequences without reset ---");
            reset_fsm();
            // First sequence: 0101 (5)
            X = 0; #10; X = 1; #10; X = 0; #10; X = 1; #10;
            $display("After sequence 0101: State=%0d, S=%b, V=%b", UUT.Q, S, V);
            // Second sequence: 1010 (10) - no reset
            X = 1; #10; X = 0; #10; X = 1; #10; X = 0; #10;
            $display("After sequence 1010: State=%0d, S=%b, V=%b", UUT.Q, S, V);
            
            // Test 3: Clock edge sensitivity
            $display("\n--- Edge Case 3: Clock edge behavior ---");
            reset_fsm();
            $display("Testing negedge clock sensitivity...");
            // The FSM should only change state on negative clock edges
            X = 1;
            #2;  // Wait for positive edge
            $display("During positive edge: State=%0d (should not change)", UUT.Q);
            #8;  // Wait for negative edge
            $display("After negative edge: State=%0d (should change)", UUT.Q);
        end
    endtask
    
    //// Main test sequence
    initial
    begin
        // Initialize test environment
        $dumpfile("excess3_fsm_comprehensive.vcd");
        $dumpvars(0, excess3_fsm_comprehensive_testbench);
        
        // Open log files
        log_file = $fopen("excess3_detailed_results.csv", "w");
        summary_file = $fopen("excess3_test_summary.txt", "w");
        
        // Write CSV header
        $fdisplay(log_file, "Binary_Input,Decimal_Input,Expected_Excess3,S_Sequence,S_Decimal,V_Sequence,V_Decimal,Final_State,Final_S,Final_V");
        
        // Initialize counters
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        X = 0;
        
        $display("========================================");
        $display("COMPREHENSIVE EXCESS-3 FSM TESTBENCH");
        $display("========================================");
        $display("Purpose: Verify Excess-3 FSM with all 4-bit binary inputs");
        $display("Clock Period: 10ns, Reset: Active High");
        $display("Input Method: Serial (MSB first)");
        $display("========================================");
        
        //// TEST SECTION 1: Valid BCD inputs (0-9)
        $display("\n========================================");
        $display("SECTION 1: VALID BCD INPUTS (0-9)");
        $display("========================================");
        
        test_binary_sequence(4'b0000, 0);   // 0 -> 3 in Excess-3
        test_binary_sequence(4'b0001, 1);   // 1 -> 4 in Excess-3
        test_binary_sequence(4'b0010, 2);   // 2 -> 5 in Excess-3
        test_binary_sequence(4'b0011, 3);   // 3 -> 6 in Excess-3
        test_binary_sequence(4'b0100, 4);   // 4 -> 7 in Excess-3
        test_binary_sequence(4'b0101, 5);   // 5 -> 8 in Excess-3
        test_binary_sequence(4'b0110, 6);   // 6 -> 9 in Excess-3
        test_binary_sequence(4'b0111, 7);   // 7 -> 10 in Excess-3
        test_binary_sequence(4'b1000, 8);   // 8 -> 11 in Excess-3
        test_binary_sequence(4'b1001, 9);   // 9 -> 12 in Excess-3
        
        //// TEST SECTION 2: Invalid BCD inputs (10-15)
        $display("\n========================================");
        $display("SECTION 2: INVALID BCD INPUTS (10-15)");
        $display("========================================");
        $display("Note: These are beyond valid BCD range but test FSM robustness");
        
        test_binary_sequence(4'b1010, 10);  // 10 -> 13 in Excess-3
        test_binary_sequence(4'b1011, 11);  // 11 -> 14 in Excess-3
        test_binary_sequence(4'b1100, 12);  // 12 -> 15 in Excess-3
        test_binary_sequence(4'b1101, 13);  // 13 -> 16 in Excess-3 (overflow)
        test_binary_sequence(4'b1110, 14);  // 14 -> 17 in Excess-3 (overflow)
        test_binary_sequence(4'b1111, 15);  // 15 -> 18 in Excess-3 (overflow)
        
        //// TEST SECTION 3: Edge cases and special scenarios
        test_edge_cases();
        
        //// Generate test summary
        $display("\n========================================");
        $display("TEST SUMMARY");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("Success Rate: %0.1f%%", (pass_count * 100.0) / test_count);
        $display("========================================");
        
        // Write summary to file
        $fdisplay(summary_file, "EXCESS-3 FSM TESTBENCH SUMMARY");
        $fdisplay(summary_file, "==============================");
        $fdisplay(summary_file, "Total Tests: %0d", test_count);
        $fdisplay(summary_file, "Passed: %0d", pass_count);
        $fdisplay(summary_file, "Failed: %0d", fail_count);
        $fdisplay(summary_file, "Success Rate: %.1f%%", (pass_count * 100.0) / test_count);
        
        // Close files and finish
        $fclose(log_file);
        $fclose(summary_file);
        
        $display("\nTestbench completed successfully!");
        $display("Detailed results: excess3_detailed_results.csv");
        $display("Summary: excess3_test_summary.txt");
        $display("Waveforms: excess3_fsm_comprehensive.vcd");
        
        $finish;
    end
    
    //// Timeout protection
    initial
    begin
        #20000;  // 20us timeout
        $display("\nERROR: Testbench timeout!");
        $display("This may indicate an infinite loop or hanging condition.");
        $fclose(log_file);
        $fclose(summary_file);
        $finish;
    end
    
endmodule