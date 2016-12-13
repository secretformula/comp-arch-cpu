`timescale 1ns / 1ps
module mips_computer_tb(
);

reg clk;
reg rst;

wire [31:0] instruction_addr;
wire [31:0] instruction;
wire [31:0] data_addr;
wire [31:0] data_in;
wire [31:0] data_out;

wire mem_read;
wire mem_write;

cpu cpu_dut(
	.clk(clk),
	.rst(rst),
	.instr_addr(instruction_addr),
	.instr(instruction),
	.data_addr(data_addr),
	.mem_read_data(data_in),
	.mem_write_data(data_out),
	.mem_write_en(mem_write),
	.mem_read_en(mem_read)
);

Memory mem(
	.inst_addr(instruction_addr),
	.instr(instruction),
	.data_addr(data_addr),
	.data_in(data_out),
	.data_out(data_in),
	.mem_read(mem_read),
	.mem_write(mem_write)
);

// Set up clock
initial begin
clk = 0;
#15 clk = 1;
forever
#5 clk = ~clk;
end

// Set up reset
initial begin
rst = 0;
#5
rst = 1;
#2
rst = 0; 
end

endmodule