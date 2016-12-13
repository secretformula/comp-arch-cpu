module mw_pipeline_register(
	input wire clk,
	input wire [31:0] mem_read_data,
	input wire [31:0] alu_result,
	input wire [4:0] write_reg_addr,
	input wire reg_write,
	input wire mem_reg,
	output reg [31:0] mem_read_data_buffered,
	output reg [31:0] alu_result_buffered,
	output reg [4:0] write_reg_addr_buffered,
	output reg reg_write_buffered,
	output reg mem_reg_buffered
);

always @ (posedge clk) begin
	mem_read_data_buffered <= mem_read_data;
	alu_result_buffered <= alu_result;
	write_reg_addr_buffered <= write_reg_addr_buffered;
	reg_write_buffered <= reg_write;
	mem_reg_buffered <= mem_reg;
end

endmodule