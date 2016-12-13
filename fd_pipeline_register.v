module fd_pipeline_register(
	input wire clk,
	input wire [31:0] pc_value_next,
	input wire [31:0] next_instruction,
	output reg [31:0] pc_value,
	output reg [31:0] instruction
);

always @ (posedge clk) begin
	pc_value <= pc_value_next;
	instruction <= next_instruction;
end

endmodule