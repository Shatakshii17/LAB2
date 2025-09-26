// Top-level module combining all components - CSE 320 LAB 2
// Simple processor-like system with ALU, register file, counter, and decoder

module cpu_top (
    input clk,              // System clock
    input reset,            // System reset
    input enable,           // System enable
    input [2:0] alu_op,     // ALU operation
    input [1:0] reg_src1,   // Register source 1 address
    input [1:0] reg_src2,   // Register source 2 address
    input [1:0] reg_dest,   // Register destination address
    input reg_write_en,     // Register write enable
    input counter_en,       // Counter enable
    input decoder_en,       // Decoder enable
    output [3:0] alu_result, // ALU result
    output alu_zero,        // ALU zero flag
    output alu_carry,       // ALU carry flag
    output [3:0] counter_out, // Counter output
    output [3:0] decoder_out  // Decoder output
);

    // Internal wires
    wire [3:0] reg_data1, reg_data2;
    
    // Register file instance
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .we(reg_write_en),
        .read_addr1(reg_src1),
        .read_addr2(reg_src2),
        .write_addr(reg_dest),
        .write_data(alu_result),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );
    
    // ALU instance
    alu alu_unit (
        .a(reg_data1),
        .b(reg_data2),
        .op(alu_op),
        .result(alu_result),
        .zero(alu_zero),
        .carry(alu_carry)
    );
    
    // Counter instance
    counter cnt (
        .clk(clk),
        .reset(reset),
        .enable(counter_en),
        .count(counter_out)
    );
    
    // Decoder instance (uses counter output as input)
    decoder dec (
        .in(counter_out[1:0]),
        .enable(decoder_en),
        .out(decoder_out)
    );
    
endmodule