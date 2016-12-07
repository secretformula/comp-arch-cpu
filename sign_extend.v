//sign_extend.v
//A module used to sign extend a value
//Author: Nathan Casale and Nigil Lee

module sign_extend(in, out);
	input [15:0] in;
	output reg [31:0] out;

	always @ (in)
	begin
		//If sign Most significant bit is a 1, then we'll populate
		//first 16 bits with ones
		if(in[15] == 1) begin
			out <= 32'hFFFF0000 | in;
		end else begin
			out <= in;
		end
	end

endmodule