module mux5(
	input wire [4:0] a,
	input wire [4:0] b,
	input wire sel,
	output wire [4:0] result
);

assign result = (sel == 1'b1) ? b : a;

endmodule