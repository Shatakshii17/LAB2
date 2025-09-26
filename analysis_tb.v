//Analysis testbench to understand the FSM behavior
//This will help us understand what the FSM is actually supposed to output

module analysis_tb();
    reg X, CLK, RST;
    wire S, V;
    reg [3:0] input_sequence;
    integer i;
    
    lab2fsm_behavioral UUT (
        .X(X),
        .CLK(CLK),
        .RST(RST),
        .S(S),
        .V(V)
    );
    
    // Clock generation
    initial
    begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    
    // Task to send 4-bit input and track states
    task analyze_sequence;
        input [3:0] data;
        input [3:0] decimal_val;
        begin
            $display("\n--- Analyzing input %b (decimal %d) ---", data, decimal_val);
            $display("Excess-3 would be: %d (%b)", decimal_val + 3, decimal_val + 3);
            
            // Reset
            RST = 1; #15; RST = 0; #5;
            $display("After reset: State=%d, S=%b, V=%b", UUT.Q, S, V);
            
            // Send each bit
            X = data[3]; #10;
            $display("After bit[3]=%b: State=%d, S=%b, V=%b", data[3], UUT.Q, S, V);
            X = data[2]; #10;
            $display("After bit[2]=%b: State=%d, S=%b, V=%b", data[2], UUT.Q, S, V);
            X = data[1]; #10;
            $display("After bit[1]=%b: State=%d, S=%b, V=%b", data[1], UUT.Q, S, V);
            X = data[0]; #10;
            $display("After bit[0]=%b: State=%d, S=%b, V=%b", data[0], UUT.Q, S, V);
            
            $display("Final output: S=%b, V=%b (binary: %b%b)", S, V, S, V);
        end
    endtask
    
    initial
    begin
        $display("========================================");
        $display("FSM Analysis - Understanding the Logic");
        $display("========================================");
        
        // Analyze a few key sequences to understand the pattern
        analyze_sequence(4'b0000, 0);   // 0 -> 3 in excess-3
        analyze_sequence(4'b0001, 1);   // 1 -> 4 in excess-3
        analyze_sequence(4'b0010, 2);   // 2 -> 5 in excess-3
        analyze_sequence(4'b0011, 3);   // 3 -> 6 in excess-3
        analyze_sequence(4'b1000, 8);   // 8 -> 11 in excess-3
        analyze_sequence(4'b1001, 9);   // 9 -> 12 in excess-3
        analyze_sequence(4'b1010, 10);  // 10 -> 13 in excess-3
        analyze_sequence(4'b1011, 11);  // 11 -> 14 in excess-3
        analyze_sequence(4'b1100, 12);  // 12 -> 15 in excess-3
        analyze_sequence(4'b1101, 13);  // 13 -> 16 in excess-3 (invalid)
        analyze_sequence(4'b1111, 15);  // 15 -> 18 in excess-3 (invalid)
        
        $display("\n========================================");
        $display("State Machine Analysis Complete");
        $display("========================================");
        
        $finish;
    end
    
endmodule