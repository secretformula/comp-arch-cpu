module program_counter(
	input wire clk,
	input wire rst,
	output reg [31:0] counter_value
);

// Reset
always @ (posedge rst) begin
	counter_value <= 32'h3000;
end

// Counting
always @ (posedge clk) begin
	counter_value <= counter_value + 4;
end

endmodule