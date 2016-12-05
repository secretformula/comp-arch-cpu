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
	.data_addr(data_addr),
	.data_in(data_in),
	.data_out(data_out),
	.mem_write(mem_write),
	.mem_read(mem_read)
);

Memory mem(
	.inst_add(instruction_addr),
	.instr(instruction),
	.data_addr(data_addr),
	.data_in(data_in),
	.data_out(data_out),
	.mem_read(mem_read),
	.mem_write(mem_write)
);
