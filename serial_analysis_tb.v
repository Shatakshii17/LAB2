//Serial Excess-3 Output Analysis Testbench
//This testbench captures all S,V outputs during the 4-bit input sequence
//The FSM likely outputs Excess-3 bits serially, not as a final 2-bit value

module serial_analysis_tb();
    reg X, CLK, RST;
    wire S, V;
    reg [1:0] output_sequence[3:0]; // Store 4 output pairs
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
    
    // Task to send 4-bit input and capture serial S,V outputs
    task analyze_serial_output;
        input [3:0] data;
        input [3:0] decimal_val;
        reg [3:0] expected_excess3;
        begin
            expected_excess3 = decimal_val + 3;
            
            $display("\n--- Serial Analysis: Input %b (decimal %d) ---", data, decimal_val);
            $display("Expected Excess-3: %d (%b)", expected_excess3, expected_excess3);
            
            // Reset
            RST = 1; #15; RST = 0; #5;
            
            // Send each bit and capture the output after each clock
            X = data[3]; #10;  // MSB first
            output_sequence[0] = {S, V};
            $display("After bit[3]=%b: Output[0] = %b%b (%d)", data[3], S, V, {S,V});
            
            X = data[2]; #10;
            output_sequence[1] = {S, V};
            $display("After bit[2]=%b: Output[1] = %b%b (%d)", data[2], S, V, {S,V});
            
            X = data[1]; #10;
            output_sequence[2] = {S, V};
            $display("After bit[1]=%b: Output[2] = %b%b (%d)", data[1], S, V, {S,V});
            
            X = data[0]; #10;  // LSB last
            output_sequence[3] = {S, V};
            $display("After bit[0]=%b: Output[3] = %b%b (%d)", data[0], S, V, {S,V});
            
            // Try to interpret the output sequence as Excess-3 bits
            $display("Output sequence: %b%b %b%b %b%b %b%b", 
                     output_sequence[0][1], output_sequence[0][0],
                     output_sequence[1][1], output_sequence[1][0], 
                     output_sequence[2][1], output_sequence[2][0],
                     output_sequence[3][1], output_sequence[3][0]);
            
            // Try different interpretations
            $display("If S bits form output: %b%b%b%b = %d", 
                     output_sequence[0][1], output_sequence[1][1], 
                     output_sequence[2][1], output_sequence[3][1],
                     {output_sequence[0][1], output_sequence[1][1], 
                      output_sequence[2][1], output_sequence[3][1]});
                      
            $display("If V bits form output: %b%b%b%b = %d", 
                     output_sequence[0][0], output_sequence[1][0], 
                     output_sequence[2][0], output_sequence[3][0],
                     {output_sequence[0][0], output_sequence[1][0], 
                      output_sequence[2][0], output_sequence[3][0]});
                      
            // Check if final {S,V} matches any interpretation
            $display("Final {S,V} = %b%b = %d", S, V, {S,V});
        end
    endtask
    
    initial
    begin
        $display("================================================");
        $display("Serial Output Analysis - Excess-3 FSM");
        $display("================================================");
        
        // Test all possible BCD inputs (0-9) and some invalid ones
        analyze_serial_output(4'b0000, 0);   // 0 -> 3
        analyze_serial_output(4'b0001, 1);   // 1 -> 4
        analyze_serial_output(4'b0010, 2);   // 2 -> 5
        analyze_serial_output(4'b0011, 3);   // 3 -> 6
        analyze_serial_output(4'b0100, 4);   // 4 -> 7
        analyze_serial_output(4'b0101, 5);   // 5 -> 8
        analyze_serial_output(4'b0110, 6);   // 6 -> 9
        analyze_serial_output(4'b0111, 7);   // 7 -> 10
        analyze_serial_output(4'b1000, 8);   // 8 -> 11
        analyze_serial_output(4'b1001, 9);   // 9 -> 12
        
        $display("\n--- Testing sequences from original testbench ---");
        analyze_serial_output(4'b1010, 10);  // 10 -> 13
        analyze_serial_output(4'b1011, 11);  // 11 -> 14
        analyze_serial_output(4'b1100, 12);  // 12 -> 15
        analyze_serial_output(4'b1101, 13);  // 13 -> 16 (invalid)
        
        $display("\n================================================");
        $display("Serial Analysis Complete");
        $display("================================================");
        
        $finish;
    end
    
endmodule