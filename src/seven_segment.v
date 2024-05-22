`default_nettype none
`timescale 1ns/1ns

module seven_segment (

    input wire 		clk,
    input wire  	reset,
    input wire  	load,
    input wire [3:0]    ten_count,
    input wire [3:0] 	unit_count,
    output reg [6:0] 	segments,
    output reg		digit    	// digit selector
);

    reg [3:0] ten_count_reg, unit_count_reg;
    wire [3:0] decode;

    always @(posedge clk) begin
  	if(reset) begin
	    ten_count_reg <= 0;
	    unit_count_reg <= 0;
	    digit <= 0;
	end else begin
	    if(load) begin
		ten_count_reg <= ten_count;
		unit_count_reg <= unit_count;
	    end
	    digit <= !digit;
	end
    end 

    assign decode = digit ? ten_count_reg: unit_count_reg;

    // why is this indented?

	always @(*) begin
	    case(decode)
	    //		     7654321	
	    0: segments = 7'b0111111;
	    1: segments = 7'b0000110;
	    2: segments = 7'b1011011;
	    3: segments = 7'b1001111;
	    4: segments = 7'b1100110;
	    5: segments = 7'b1101101;
	    6: segments = 7'b1111101;
	    7: segments = 7'b0000111;
	    8: segments = 7'b1111111;
	    9: segments = 7'b1101111; 
	    default: 
               segments = 7'b0000000; 
	    endcase
	end

endmodule
