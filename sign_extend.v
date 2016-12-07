//sign_extend.v
//A module used to sign extend a value
//Author: Nathan Casale and Nigil Lee

module sign_extend(in, out);
	input [15:0] in;
	output [31:0] out = 0;

	reg add_ones [31:0] = 32'hFFFF0000



	always @ (in)
	begin
		//If sign Most significant bit is a 1, then we'll populate
		//first 16 bits with ones
		if(in[15] == 1)
		{
			out = add_ones + in;
		}
		else 
		{
			out = out + in;
		}
	end

endmodule