// ALU (Arithmetic Logic Unit) - CSE 320 LAB 2
// 4-bit ALU with basic arithmetic and logic operations

module alu (
    input [3:0] a,          // First operand
    input [3:0] b,          // Second operand
    input [2:0] op,         // Operation selector
    output reg [3:0] result, // Result output
    output zero,            // Zero flag
    output carry            // Carry flag
);

    reg carry_out;
    
    // Operation codes
    parameter ADD  = 3'b000;
    parameter SUB  = 3'b001;
    parameter AND  = 3'b010;
    parameter OR   = 3'b011;
    parameter XOR  = 3'b100;
    parameter SLL  = 3'b101;  // Shift left logical
    parameter SRL  = 3'b110;  // Shift right logical
    parameter NOR  = 3'b111;
    
    always @(*) begin
        carry_out = 1'b0;
        case (op)
            ADD: {carry_out, result} = a + b;
            SUB: {carry_out, result} = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;
            SLL: result = a << 1;
            SRL: result = a >> 1;
            NOR: result = ~(a | b);
            default: result = 4'b0000;
        endcase
    end
    
    assign zero = (result == 4'b0000);
    assign carry = carry_out;
    
endmodule