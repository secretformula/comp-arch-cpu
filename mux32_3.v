module mux32_3(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [31:0] c,
	input wire [1:0] sel,
	output reg [31:0] result
);

always @ (*) begin
	case(sel)
	0: result = a;
	1: result = b;
	2: result = c;
	default: result = a;
	endcase
end

endmodule