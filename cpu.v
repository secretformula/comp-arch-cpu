module cpu(
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

/*
 * Instruction fetch stage
 */
wire [31:0] pc_value;
wire [31:0] next_instr_addr;
wire [31:0] pc_value_next;
wire jump;

mux32 pc_input_mux(
	.a(pc_value_next),
	.b(),
	.sel(jump)
	.result(next_instr_addr)
);

program_counter pc(
	.clk(clk),
	.rst(rst),
	.next_instr_addr(next_instr_addr)
	.counter_value(pc_value)
);

wire [31:0] counter_adder_b;
counter_adder_b = 4;
add32u counter_adder(
	.a(pc_value),
	.b(counter_adder_b),
	.result(pc_value_next)
)

assign instr_addr = pc_value;

wire [31:0] buffered_instruction;
wire [31:0] buffered_next_pc_value;

fd_pipeline_register fd_reg(
	.clk(clk),
	.pc_value_next(pc_value_next),
	.next_instruction(instr),
	.instruction(buffered_instruction),
	.pc_value(buffered_next_pc_value)
);

/*
 * Instruction decode stage
 */
wire [4:0] rs_addr;
wire [4:0] rt_addr;
wire [4:0] rd_addr;
wire [4:0] reg_write_addr;
wire [15:0] immediate;

assign rs_addr = instruction[25:21];
assign rt_addr = instruction[20:16];
assign rd_addr = instruction[15:11];
assign immediate = instruction [15:0];

mux5 write_reg_mux(
	.a(rt_addr),
	.b(rd_addr),
	.sel(),
	.result(reg_write_addr)
);

wire [15:0] reg_read_0;
wire [15:0] reg_read_1;

register_file registers(
	.clk(clk),
	.rst(rst),
	.write_en(),
	.read_addr_0(rs_addr),
	.read_addr_1(rt_addr),
	.write_addr(reg_write_addr),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1)
);

sign_extend1632 immediate_extender(
	.in(immediate),
	.out(immediate_signext)
);

wire [31:0] reg_read_buf_0;
wire [31:0] reg_read_buf_1;
wire [31:0] dx_pc_value;

dx_pipeline_register dx_reg(
	.clk(clk),
	.pc_value_next(buffered_next_pc_value),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1),
	.immediate(immediate_signext)
	.pc_value(dx_pc_value),
	.read_data_buffered_0(reg_read_buf_0),
	.read_data_buffered_1(reg_read_buf_1),
);

/*
 * Execute stage
 */



endmodule