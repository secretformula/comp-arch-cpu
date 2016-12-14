module fd_pipeline_register(
	input wire clk,
	input wire flush,
	input wire rst,
    input wire load_enable,
	input wire [31:0] pc_value_next,
	input wire [31:0] next_instruction,
	output reg [31:0] pc_value,
	output reg [31:0] instruction
);

always @ (posedge clk) begin
	if(flush) begin
		instruction <= 32'h20000000; // Noop instruction (addi $0, $0, 0)
	end else begin
		if(!load_enable) begin
    		pc_value <= pc_value;
    		instruction <= instruction;
	  	end else begin
			pc_value <= pc_value_next;
			instruction <= next_instruction;
		end
	end
end

endmodule