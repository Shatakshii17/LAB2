// 4-bit Counter - CSE 320 LAB 2
// Synchronous counter with enable and reset

module counter (
    input clk,          // Clock signal
    input reset,        // Asynchronous reset
    input enable,       // Count enable
    output reg [3:0] count // Counter output
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000;
        else if (enable)
            count <= count + 1;
    end
    
endmodule