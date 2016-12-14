module alu(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [2:0] op,
	output reg [31:0] result,
	output wire zero
);

assign zero = result == 32'h0;

always @ (*) begin
	case(op)
	3'h0: result = a + b; // add
	3'h1: result = 32'h0; // noop
	3'h2: result = a & b; // and
	3'h3: result = a | b; // or
	3'h4: result = ($signed(a) < $signed(b)) ? 32'h1 : 32'h0; // slt
	3'h5: result = { a[30:0], 1'b0 }; // sll
	3'h6: result = (a == b) ? 32'h0 : 32'h1; // beq
	3'h7: result = (a != b) ? 32'h0 : 32'h1; // beq
	endcase
end

endmodule
