//Problem 2a
module lab2bcd_1digit(D, ENABLE, LOAD, UP, CLK, CLR, Q, CO);
	input [3:0] D;
    input ENABLE, LOAD, UP, CLK, CLR;
    
	output reg [3:0] Q;
    output reg CO;
    
    //Synchronous counter
    //This implementation assumes it will be used in a 2-digit BCD
    //Additional logic will be implemented in the top-level module (2-digit BCD) to prevent it from going below 0 or above 99
	always @(posedge CLK)
    begin
        //Asynchronous active-low clear
        if(~CLR)
        begin
            Q <= 4'd0;
        end
        //Implement the behavioral requirements for Q here
        else if(ENABLE)
        begin
			if (LOAD) 
			begin
				Q <= D;
			end
			else if(UP)
			begin
				case(Q)
					4'd9: Q <= 4'd0;
					default: Q <= Q + 4'd1;
				endcase
			end
			else
			begin
				case(Q)
					4'd0: Q <= 4'd9;
					default: Q <= Q - 4'd1;
				endcase
			end
        end
    end
    
    //To model correct behavior for 2-digit BCD, CO can be asynchronous with respect to clock
    //This is just one way to do it, there's other ways to implement the CO logic
    always @(*)
    begin    
        //Asynchronous active-low clear
        if(~CLR)
        begin
            CO = 1'b0;
        end
        //Implement the behavioral requirements for CO here
        else if(ENABLE)
        begin
			if(UP && (Q == 4'd9))	// about to roll over 9->0
				CO = 1'b1;
			else if(!UP && (Q == 4'd0)) 	// about to roll over 0->9
				CO = 1'b1;
			else
				CO = 1'b0;
        end
		else
		begin
			CO = 1'b0;
		end
    end
endmodule
