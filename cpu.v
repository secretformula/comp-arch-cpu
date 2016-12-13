module cpu(
	input wire clk,
	input wire rst,
	output wire [31:0] instr_addr,
	input wire [31:0] instr,
	output wire [31:0] data_addr,
	input wire [31:0] mem_read_data,
	output wire [31:0] mem_write_data,
	output wire mem_read_en,
	output wire mem_write_en
);

/*
 * Instruction fetch stage
 */

wire [31:0] next_instr_addr;
wire [31:0] pc_value_next;
wire pc_src_xm;
wire [31:0] jump_result_xm;

mux32 pc_input_mux(
	.a(pc_value_next),
	.b(jump_result_xm),
	.sel(pc_src_xm),
	.result(next_instr_addr)
);

wire [31:0] pc_value;
program_counter pc(
	.clk(clk),
	.rst(rst),
	.next_instr_addr(next_instr_addr),
	.counter_value(pc_value)
);

wire [31:0] counter_adder_b;
assign counter_adder_b = 4;
add32u counter_adder(
	.a(pc_value),
	.b(counter_adder_b),
	.result(pc_value_next)
);

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
wire alu_src;
wire branch;

controller cpu_controller(
	.instruction(buffered_instruction),
	.alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.jump(jump),
	.reg_write(reg_write),
	.mem_reg(mem_reg),
	.reg_dst(reg_dst),
	.alu_src(alu_src),
	.branch(branch)
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
wire alu_src_dx;
wire branch_dx;

dx_pipeline_register dx_reg(
	.clk(clk),
	.pc_value_next(buffered_next_pc_value),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1),
	.immediate(immediate_signext),
	.alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.jump(jump),
	.reg_write(reg_write),
	.mem_reg(mem_reg),
	.reg_dst(reg_dst),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.alu_src(alu_src),
	.branch(branch),
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
	.rd_addr_buffered(rd_addr_dx),
	.alu_src_buffered(alu_src_dx),
	.branch_buffered(branch_dx)
);

/*
 * Execute stage
 */

wire [31:0] shifted_immediate;
sll2_32 jump_shifter(
	.in(immediate_dx),
	.out(shifted_immediate)
);

wire [31:0] jump_adder_result;
add32u jump_adder(
	.a(dx_pc_value),
	.b(shifted_immediate),
	.result(jump_adder_result)
);

wire [4:0] reg_write_addr_dx;

mux5 write_reg_mux(
	.a(rt_addr_dx),
	.b(rd_addr_dx),
	.sel(reg_dst_dx),
	.result(reg_write_addr_dx)
);

wire [31:0] alu_b_data;

mux32 alu_src_mux(
	.a(reg_read_1_dx),
	.b(immediate_dx),
	.sel(alu_src_dx),
	.result(alu_b_data)
);

wire [31:0] alu_result;
wire alu_zero;

alu cpu_alu(
	.a(reg_read_0_dx),
	.b(alu_b_data),
	.op(alu_op_dx),
	.result(alu_result),
	.zero(alu_zero)
);

wire [31:0] alu_result_xm;
wire alu_zero_xm;
wire [4:0] write_reg_addr_xm;
wire mem_read_xm;
wire mem_write_xm;
wire mem_reg_xm;
wire branch_xm;

xm_pipeline_register xm_reg(
	.clk(clk),
	.alu_result(alu_result),
	.alu_zero(alu_zero),
	.jump_result(jump_adder_result),
	.write_reg_addr(reg_write_addr_dx),
	.mem_read(mem_read_dx),
	.mem_write(mem_write_dx),
	.mem_reg(mem_reg_dx),
	.branch(branch_dx),
	.alu_result_buffered(alu_result_xm),
	.alu_zero_buffered(alu_zero_xm),
	.jump_result_buffered(jump_result_xm),
	.write_reg_addr_buffered(write_reg_addr_xm),
	.mem_read_buffered(mem_read_xm),
	.mem_write_buffered(mem_write_xm),
	.mem_reg_buffered(mem_reg_xm),
	.branch_buffered(branch_xm)
);

/*
 * Memory Stage
 */

assign data_addr = alu_result_xm;
assign mem_read_en = mem_read_xm;
assign mem_write_en = mem_write_xm;

assign pc_src_xm = branch_xm && alu_zero_xm;

endmodule