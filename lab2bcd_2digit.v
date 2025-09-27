//Problem 2b
//Let D2 and Q2 be defined as the ten's place, or 2nd digit, so for 98, D2 = 9
module lab2bcd_2digit(D1, D2, ENABLE, LOAD, UP, CLK, CLR, Q1, Q2, CO);
    input [3:0] D1, D2;
    input ENABLE, LOAD, UP, CLK, CLR;
    
    output [3:0] Q1, Q2;
    output reg CO;
    
    //Intermediate logic variable(s)
    reg ENABLE_1, ENABLE_2, ENABLE_OVERRIDE, UP_2;
    // Internal wires from digit modules
    wire [3:0] q1_w, q2_w;
    wire co1_w, co2_w;
    
    //module instantiations
   lab2bcd_1digit U_DIGIT1 ( // ones digit
        .D(D1),
        .ENABLE(ENABLE_1),
        .LOAD(LOAD),
        .UP(UP),
        .CLK(CLK),
        .CLR(CLR),
        .Q(q1_w),
        .CO(co1_w)
    );

	 lab2bcd_1digit U_DIGIT2 ( // tens digit
        .D(D2),
        .ENABLE(ENABLE_2),
        .LOAD(LOAD),
        .UP(UP_2),
        .CLK(CLK),
        .CLR(CLR),
        .Q(q2_w),
        .CO(co2_w)
    );

	// Drive top-level Qs from internal wires
    assign Q1 = q1_w;
    assign Q2 = q2_w;

    //Intermediate logic procedural block
    //This is just one way to do it, there's other ways to implement the intermediate logic
    //Cases to consider include:
    //Stopping the counter when Q = 0 and UP = 0 or Q = 99 and UP = 1
    //Enabling the 2nd digit counter during load
    //Setting the UP for the 2nd digit depending if its going from 0 -> 9 or 9 -> 0 
    always @(*)
    begin
        if(((Q2 == 4'd0 & Q1 == 4'd0) & UP == 1'd0) || 
		((Q2 == 4'd9 && Q1 == 4'd9) && (UP == 1'd1))) begin
            ENABLE_OVERRIDE = 1'd0;
            CO = 1'd1;
        end		
		else begin
			ENABLE_OVERRIDE = 1'd1;
            CO = 1'd0;
		end

	ENABLE_1 = (ENABLE & ENABLE_OVERRIDE) | (ENABLE & LOAD); //ENABLE for 1st digit
	ENABLE_2 = (( (UP && (Q1 == 4'd9)) || (!UP && (Q1 == 4'd0)) ) & ENABLE_OVERRIDE)
    | (ENABLE & LOAD); //ENABLE for 2nd digit
	UP_2 = (UP && 1'b1); //UP for 2nd digit
    end
    
endmodule
