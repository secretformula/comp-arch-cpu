module xm_pipeline_register(
	input wire clk,
	input wire [31:0] alu_result,
	input wire alu_zero,
	input wire [31:0] jump_result,
	input wire [4:0] write_reg_addr,
	input wire mem_read,
	input wire mem_write,
	input wire mem_reg,
	input wire branch,
	input wire reg_write,
	output reg [31:0] alu_result_buffered,
	output reg alu_zero_buffered,
	output reg [31:0] jump_result_buffered,
	output reg [4:0] write_reg_addr_buffered,
	output reg mem_read_buffered,
	output reg mem_write_buffered,
	output reg mem_reg_buffered,
	output reg branch_buffered,
	output reg reg_write_buffered
);

always @ (posedge clk) begin
	alu_result_buffered <= alu_result;
	alu_zero_buffered <= alu_zero;
	jump_result_buffered <= jump_result;
	write_reg_addr_buffered <= write_reg_addr;
	mem_read_buffered <= mem_read;
	mem_write_buffered <= mem_write;
	mem_reg_buffered <= mem_reg;
	branch_buffered <= branch;
	reg_write_buffered <= reg_write;
end

endmodule