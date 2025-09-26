// Register File - CSE 320 LAB 2
// Simple 4-register file with 4-bit data width

module register_file (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input we,               // Write enable
    input [1:0] read_addr1, // Read address 1
    input [1:0] read_addr2, // Read address 2
    input [1:0] write_addr, // Write address
    input [3:0] write_data, // Write data
    output [3:0] read_data1, // Read data 1
    output [3:0] read_data2  // Read data 2
);

    // 4 registers, each 4 bits wide
    reg [3:0] registers [0:3];
    
    // Read operations (combinational)
    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];
    
    // Write operation (synchronous)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 4'b0000;
            registers[1] <= 4'b0000;
            registers[2] <= 4'b0000;
            registers[3] <= 4'b0000;
        end else if (we) begin
            registers[write_addr] <= write_data;
        end
    end
    
endmodule