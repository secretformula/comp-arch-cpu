module mux32(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire sel,
	output wire [31:0] result
);

assign result = (sel == 1'b1) ? b : a;

endmodule