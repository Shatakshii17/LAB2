// Testbench for Register File - CSE 320 LAB 2
`timescale 1ns / 1ps

module register_file_tb;

    // Inputs
    reg clk;
    reg reset;
    reg we;
    reg [1:0] read_addr1;
    reg [1:0] read_addr2;
    reg [1:0] write_addr;
    reg [3:0] write_data;
    
    // Outputs
    wire [3:0] read_data1;
    wire [3:0] read_data2;
    
    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        we = 0;
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        
        // Wait for reset
        #10;
        reset = 0;
        
        $display("Register File Testbench Starting...");
        $display("Time\twe\twr_addr\twr_data\trd_addr1\trd_data1\trd_addr2\trd_data2");
        $display("----\t--\t-------\t-------\t--------\t--------\t--------\t--------");
        
        // Test writing to registers
        we = 1;
        write_addr = 2'b00; write_data = 4'b0001; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        write_addr = 2'b01; write_data = 4'b0010; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        write_addr = 2'b10; write_data = 4'b0100; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        write_addr = 2'b11; write_data = 4'b1000; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        // Test reading from registers
        we = 0;
        read_addr1 = 2'b00; read_addr2 = 2'b01; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        read_addr1 = 2'b10; read_addr2 = 2'b11; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        // Test reset functionality
        reset = 1; #10;
        reset = 0; #10;
        read_addr1 = 2'b00; read_addr2 = 2'b11; #10;
        $display("%0t\t%b\t%b\t%b\t%b\t%b\t%b\t%b (after reset)", $time, we, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
        
        $display("\nRegister File Testbench Completed.");
        $finish;
    end
    
endmodule