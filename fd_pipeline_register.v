module fd_pipeline_register(
	input wire clk,
	input wire rst,
  input wire load_enable,
	input wire [31:0] pc_value_next,
	input wire [31:0] next_instruction,
	output reg [31:0] pc_value,
	output reg [31:0] instruction
);

always @ (posedge rst) begin
	
end

always @ (posedge clk) begin
  if(!load_enable) begin
    pc_value <= pc_value;
    instruction <= instruction;
  end
else begin
	pc_value <= pc_value_next;
	instruction <= next_instruction;
end

endmodule