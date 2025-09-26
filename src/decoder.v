// 2-to-4 Decoder - CSE 320 LAB 2
// Basic combinational logic decoder

module decoder (
    input [1:0] in,     // 2-bit input
    input enable,       // Enable signal
    output reg [3:0] out // 4-bit decoded output
);

    always @(*) begin
        if (!enable) begin
            out = 4'b0000;
        end else begin
            case (in)
                2'b00: out = 4'b0001;
                2'b01: out = 4'b0010;
                2'b10: out = 4'b0100;
                2'b11: out = 4'b1000;
                default: out = 4'b0000;
            endcase
        end
    end
    
endmodule