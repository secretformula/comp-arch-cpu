module program_counter(
	input wire clk,
	input wire rst,
  	input wire load_enable,
	input wire [31:0] next_addr,
	output reg [31:0] counter_value
);

// Reset
always @ (posedge rst) begin
	counter_value <= 32'h3000 - 32'd4;
end

// Counting
always @ (posedge clk) begin
  if(!load_enable) begin
    counter_value <= counter_value;
  end
  else begin
	  counter_value <= next_addr;
  end
end

endmodule