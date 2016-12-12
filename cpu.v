module Cpu(
	input wire clk,
	input wire rst,
	output wire [31:0] instr_addr,
	input wire [31:0] instr,
	output wire [31:0] data_addr,
	input wire [31:0] mem_read_data,
	output wire [31:0] mem_write_data,
	output wire mem_read,
	output wire mem_write
);

endmodule