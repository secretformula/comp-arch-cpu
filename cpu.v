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
wire [4:0] reg_write_addr_mw;
wire [15:0] immediate;

assign rs_addr = buffered_instruction[25:21];
assign rt_addr = buffered_instruction[20:16];
assign rd_addr = buffered_instruction[15:11];
assign immediate = buffered_instruction [15:0];

wire [15:0] reg_read_0;
wire [15:0] reg_read_1;

register_file registers(
	.clk(clk),
	.rst(rst),
	.write_en(),
	.read_addr_0(rs_addr),
	.read_addr_1(rt_addr),
	.write_addr(reg_write_addr_mw),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1)
);

sign_extend1632 immediate_extender(
	.in(immediate),
	.out(immediate_signext)
);

wire [2:0] alu_op;
wire mem_read;
wire mem_write;
wire jump;
wire reg_write;
wire mem_reg;
wire reg_dst;

controller cpu_controller(
	.instruction(buffered_instruction),
	.alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.jump(jump),
	.reg_write(reg_write),
	.mem_reg(mem_reg),
	.reg_dst(reg_dst)
);

wire [31:0] reg_read_0_dx;
wire [31:0] reg_read_1_dx;
wire [31:0] dx_pc_value_dx;
wire [31:0] immediate_dx;
wire [2:0] alu_op_dx;
wire [4:0] rt_addr_dx;
wire [4:0] rd_addr_dx;
wire mem_read_dx;
wire mem_write_dx;
wire jump_dx;
wire reg_write_dx;
wire mem_reg_dx;
wire reg_dst_dx;

dx_pipeline_register dx_reg(
	.clk(clk),
	.pc_value_next(buffered_next_pc_value),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1),
	.immediate(immediate_signext)
	.alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.jump(jump),
	.reg_write(reg_write),
	.mem_reg(mem_reg),
	.reg_dst(reg_dst),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.pc_value(dx_pc_value),
	.read_data_buffered_0(reg_read_0_dx),
	.read_data_buffered_1(reg_read_1_dx),
	.immediate_buffered(immediate_dx),
	.alu_op_buffered(alu_op_dx),
	.mem_read_buffered(mem_read_dx),
	.mem_write_buffered(mem_write_dx),
	.jump_buffered(jump_dx),
	.reg_write_buffered(reg_write_dx),
	.mem_reg_buffered(mem_reg_dx),
	.reg_dst_buffered(reg_dst_dx),
	.rt_addr_buffered(rt_addr_dx),
	.rd_addr_buffered(rd_addr_dx)
);

/*
 * Execute stage
 */

wire [4:0] reg_write_addr_dx;

mux5 write_reg_mux(
	.a(rt_addr_dx),
	.b(rd_addr_dx),
	.sel(reg_dst_dx),
	.result(reg_write_addr_dx)
);

alu cpu_alu(
	
);

endmodule