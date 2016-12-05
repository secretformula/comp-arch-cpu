module cpu_tb(
);

wire clk;
wire rst;

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
	.instruction_addr(instruction_addr),
	.instruction(instruction),
	
);

