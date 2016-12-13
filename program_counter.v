module program_counter(
	input wire clk,
	input wire rst,
	input wire [31:0] next_addr,
	output reg [31:0] counter_value
);

// Reset
always @ (posedge rst) begin
	counter_value <= 32'h3000;
end

// Counting
always @ (posedge clk) begin
	counter_value <= jump_addr;
end

endmodule