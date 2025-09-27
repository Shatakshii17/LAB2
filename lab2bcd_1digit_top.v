//Clock divider
module simpleDivider(clk100Mhz, slowClk, CLR);
    input clk100Mhz; //fast clock
    output slowClk; //slow clock
	input CLR;
    reg [27:0] counter;
    
    assign slowClk = counter[27]; //(2^27 / 100E6) = 1.34seconds
       
    always @ (posedge clk100Mhz or negedge CLR)
    begin
	    if (~CLR) begin
		    counter <= 0;
		end else begin
            counter <= counter + 1; //increment the counter every 10ns (1/100 Mhz) cycle.
		end
    end
endmodule

//Problem 3
module lab2bcd_1digit_top(D, ENABLE, LOAD, UP, CLK100MHZ, CLR, Q, CO);
	input [3:0] D;
    input ENABLE, LOAD, UP, CLK100MHZ, CLR;
    
	output [3:0] Q;
    output CO;
    
    wire CLK;
    
    //module instantiation
	simpleDivider clkdiv(CLK100MHZ, CLK, CLR); //Read the simpleDivider module to see what it takes as an input
    lab2bcd_1digit BCD1(
		.D(D),
		.ENABLE(ENABLE),
		.LOAD(LOAD),
		.UP(UP),
		.CLK(CLK),
		.CLR(CLR),
		.Q(Q),
		.CO(CO)
	);
endmodule