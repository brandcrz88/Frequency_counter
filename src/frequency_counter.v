`default_nettype none	
`timescale 1ns/1ps

module frequency_counter #(
	parameter UPDATE_PERIOD = 1200 - 1,
	parameter BITS = 12
)
(
	input wire 				clk,
	input wire 				reset,
	input wire 				signal,

	input wire [BITS-1:0] 	period,
	input wire 				period_load,

	output wire [6:0] 		segments,
	output wire 			digit, 

	// debug wires
	output wire [1:0] 		dbg_state,		// state machine 
	output wire [2:0] 		dbg_clk_count, 	// top 3 bits of clk counter
	output wire [2:0] 		dbg_edge_count
);
	
	// debug assigns
	assign dbg_state = state;
	assign dbg_clk_count = clk_counter[BITS-1:BITS-3];
	assign dbg_edge_count = edge_counter[6:4];

	reg [BITS-1:0] update_period; // holds the number of edges for frequency measurement

	reg [6:0] edge_counter; // 2^7 is 128, can count up to 99

	reg [BITS-1:0] clk_counter; // keeps track of clocks in the counting period

	reg [3:0] unit_count, ten_count;

	reg update_digits; // toggles the loading signal for the seven pmod display

	wire leading_edge_detect;

	edge_detect edge_detect0(.signal(signal), .clk(clk), .leading_edge_detect(leading_edge_detect));

	always @(posedge clk) begin
		if (reset) 
			update_period <= UPDATE_PERIOD;
		else if (period_load) 
			update_period <= period; // sets a new period when period_load is high
	end

	// STATE machine register, holds 3 states
	reg [1:0] state;

	localparam STATE_COUNT	= 0;
	localparam STATE_TENS 	= 1;
	localparam STATE_UNITS 	= 2;

	always @(posedge clk) begin
		if (reset) begin
			clk_counter 	<= 0;
			edge_counter 	<= 0;
			unit_count	 	<= 0;
			ten_count 		<= 0;
			update_digits 	<= 0;
			state 			<= STATE_COUNT;

		end else begin
			case(state)
				STATE_COUNT : begin
					update_digits 	<= 0;
					clk_counter 	<= clk_counter + 1'b1;

					if(leading_edge_detect) 
						edge_counter <= edge_counter + 1'b1;

					if(clk_counter >= update_period) begin
						clk_counter <= 0; 
						unit_count 	<= 0; 
						ten_count	<= 0; 
						state 		<= STATE_TENS; 
					end
				end

				STATE_TENS : begin
					if (edge_counter < 7'd10)
						state <= STATE_UNITS;
					else begin
						edge_counter <= edge_counter - 7'd10;
						ten_count <= ten_count + 1'b1;
					end
				end

				STATE_UNITS : begin
					unit_count 		<= edge_counter;
					update_digits	<= 1'b1;
					edge_counter 	<= 0;
					state 			<= STATE_COUNT;
				end

				default : state <= STATE_COUNT;
				
			endcase			
		end
	end

	seven_segment seven_segment0(.clk(clk), .reset(reset), .ten_count(ten_count), .unit_count(unit_count), .load(update_digits), .segments(segments), .digit(digit));

endmodule
