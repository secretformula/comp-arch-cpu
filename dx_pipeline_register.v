module dx_pipeline_register(
	input wire clk,
	input wire [31:0] pc_value_next,
	input wire [31:0] read_data_0,
	input wire [31:0] read_data_1,
	input wire [31:0] immediate,
	output reg [31:0] pc_value,
	output reg [31:0] read_data_buffered_0,
	output reg [31:0] read_data_buffered_1,
	output reg [31:0] immediate_buffered
);

always @ (posedge clk) begin
	pc_value <= pc_value_next;
	read_data_buffered_0 <= read_data_0;
	read_data_buffered_1 <= read_data_1;
	immediate_buffered <= immediate;
end

endmodule
