module sign_extend1632(
	input wire [15:0] in, 
	output wire [31:0] out
);

assign out = (in[15] == 1'b1) ? (32'hFFFF0000 | in) : in;

endmodule