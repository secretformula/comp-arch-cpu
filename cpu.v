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

wire [31:0] branch_addr;
wire [31:0] pc_value_next;
wire pc_src_branch_d;
wire [31:0] branch_adder_result;

mux32 branch_mux(
	.a(pc_value_next),
	.b(branch_adder_result),
	.sel(pc_src_branch_d),
	.result(branch_addr)
);

wire [31:0] jump_addr;
wire [31:0] next_instr_addr;
wire jump;
mux32 jump_mux(
	.a(branch_addr),
	.b(jump_addr),
	.sel(jump),
	.result(next_instr_addr)
);

wire [31:0] pc_value;
wire load_enable;
program_counter pc(
	.clk(clk),
	.rst(rst),
	.load_enable(load_enable),
	.next_addr(next_instr_addr),
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

wire flush;
fd_pipeline_register fd_reg(
	.clk(clk),
	.flush(flush),
	.write_en(load_enable),
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
wire [4:0] write_reg_addr_mw;
wire [15:0] immediate;
wire [25:0] jump_offset;

assign rs_addr = buffered_instruction[25:21];
assign rt_addr = buffered_instruction[20:16];
assign rd_addr = buffered_instruction[15:11];
assign immediate = buffered_instruction [15:0];
assign jump_offset = buffered_instruction [25:0];

wire [27:0] jump_offset_shifted;
assign jump_offset_shifted = jump_offset << 2;
assign jump_addr = {pc_value_next[31:28], jump_offset_shifted};

wire [31:0] reg_read_0;
wire [31:0] reg_read_1;
wire reg_write_mw;
wire [31:0] reg_write_data_mw;

register_file registers(
	.clk(clk),
	.rst(rst),
	.write_en(reg_write_mw),
	.read_addr_0(rs_addr),
	.read_addr_1(rt_addr),
	.write_addr(write_reg_addr_mw),
	.write_data(reg_write_data_mw),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1)
);

wire branch_eq;
assign branch_eq = reg_read_0 == reg_read_1;

wire [31:0] immediate_signext;

sign_extend1632 immediate_extender(
	.in(immediate),
	.out(immediate_signext)
);

wire branch;
wire [4:0] rt_addr_dx;
wire mem_read_dx;
hazard_detection_unit hazard_detection(
	.rst(rst),
	.instruction(buffered_instruction),
	.dx_rt(rt_addr_dx),
	.jump(jump),
	.branch(branch),
	.equals_result(branch_eq),
	.dx_mem_read(mem_read_dx),
	.load_enable(load_enable),
	.flush(flush)
);

wire [2:0] alu_op;
wire mem_read;
wire mem_write;
wire reg_write;
wire mem_reg;
wire reg_dst;
wire alu_src;

controller cpu_controller(
	.rst(rst),
	.stall_b(load_enable),
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

wire [31:0] shifted_immediate;
sll2_32 jump_shifter(
	.in(immediate_signext),
	.out(shifted_immediate)
);

add32u branch_adder(
	.a(buffered_next_pc_value),
	.b(shifted_immediate),
	.result(branch_adder_result)
);

assign pc_src_branch_d = branch && branch_eq;

wire [31:0] reg_read_0_dx;
wire [31:0] reg_read_1_dx;
wire [31:0] immediate_dx;
wire [2:0] alu_op_dx;
wire [4:0] rd_addr_dx;
wire [4:0] rs_addr_dx;
wire mem_write_dx;
wire jump_dx;
wire reg_write_dx;
wire mem_reg_dx;
wire reg_dst_dx;
wire alu_src_dx;

dx_pipeline_register dx_reg(
	.clk(clk),
	.rst(rst),
	.stall_b(load_enable),
	.read_data_0(reg_read_0),
	.read_data_1(reg_read_1),
	.immediate(immediate_signext),
	.alu_op(alu_op),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.reg_write(reg_write),
	.mem_reg(mem_reg),
	.reg_dst(reg_dst),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.rs_addr(rs_addr),
	.alu_src(alu_src),
	.read_data_buffered_0(reg_read_0_dx),
	.read_data_buffered_1(reg_read_1_dx),
	.immediate_buffered(immediate_dx),
	.alu_op_buffered(alu_op_dx),
	.mem_read_buffered(mem_read_dx),
	.mem_write_buffered(mem_write_dx),
	.reg_write_buffered(reg_write_dx),
	.mem_reg_buffered(mem_reg_dx),
	.reg_dst_buffered(reg_dst_dx),
	.rt_addr_buffered(rt_addr_dx),
	.rd_addr_buffered(rd_addr_dx),
	.rs_addr_buffered(rs_addr_dx),
	.alu_src_buffered(alu_src_dx)
);

/*
 * Execute stage
 */

wire [31:0] alu_result_xm;
wire [4:0] write_reg_addr_xm;
wire reg_write_xm;
wire [1:0] alu_a_mux_sel;
wire [1:0] alu_b_mux_sel;

forwarding_unit forwarding_unit(
	.rst(rst),
	.rs_addr_dx(rs_addr_dx),
	.rt_addr_dx(rt_addr_dx),
	.write_reg_addr_xm(write_reg_addr_xm),
	.write_reg_xm(reg_write_xm),
	.write_reg_addr_mw(write_reg_addr_mw),
	.write_reg_mw(reg_write_mw),
	.alu_a_mux_sel(alu_a_mux_sel),
	.alu_b_mux_sel(alu_b_mux_sel)
);

wire [4:0] reg_write_addr_dx;

mux5 write_reg_mux(
	.a(rt_addr_dx),
	.b(rd_addr_dx),
	.sel(reg_dst_dx),
	.result(reg_write_addr_dx)
);

wire [31:0] alu_a_forwarded_data;
wire [31:0] alu_b_forwarded_data;

mux32_3 alu_forwarding_mux_0(
	.a(reg_read_0_dx),
	.b(reg_write_data_mw),
	.c(alu_result_xm),
	.sel(alu_a_mux_sel),
	.result(alu_a_forwarded_data)
);

mux32_3 alu_forwarding_mux_1(
	.a(reg_read_1_dx),
	.b(reg_write_data_mw),
	.c(alu_result_xm),
	.sel(alu_b_mux_sel),
	.result(alu_b_forwarded_data)
);

wire [31:0] alu_b_data;

mux32 alu_src_mux(
	.a(alu_b_forwarded_data),
	.b(immediate_dx),
	.sel(alu_src_dx),
	.result(alu_b_data)
);

wire [31:0] alu_result;
wire alu_zero;

alu cpu_alu(
	.a(alu_a_forwarded_data),
	.b(alu_b_data),
	.op(alu_op_dx),
	.result(alu_result),
	.zero(alu_zero)
);


wire [31:0] mem_write_data_xm;
wire alu_zero_xm;
wire mem_read_xm;
wire mem_write_xm;
wire mem_reg_xm;

xm_pipeline_register xm_reg(
	.clk(clk),
	.rst(rst),
	.alu_result(alu_result),
	.alu_zero(alu_zero),
	.write_reg_addr(reg_write_addr_dx),
	.mem_read(mem_read_dx),
	.mem_write(mem_write_dx),
	.mem_reg(mem_reg_dx),
	.reg_write(reg_write_dx),
	.mem_write_data(reg_read_1_dx),
	.alu_result_buffered(alu_result_xm),
	.alu_zero_buffered(alu_zero_xm),
	.write_reg_addr_buffered(write_reg_addr_xm),
	.mem_read_buffered(mem_read_xm),
	.mem_write_buffered(mem_write_xm),
	.mem_reg_buffered(mem_reg_xm),
	.reg_write_buffered(reg_write_xm),
	.mem_write_data_buffered(mem_write_data_xm)
);

/*
 * Memory Stage
 */

// Some explict assigns for structure
assign mem_write_data = mem_write_data_xm;
assign data_addr = alu_result_xm;
assign mem_read_en = mem_read_xm;
assign mem_write_en = mem_write_xm;

wire [31:0] mem_read_data_mw;
wire [31:0] alu_result_mw;
wire mem_reg_mw;

mw_pipeline_register mw_reg(
	.clk(clk),
	.rst(rst),
	.mem_read_data(mem_read_data),
	.alu_result(alu_result_xm),
	.write_reg_addr(write_reg_addr_xm),
	.reg_write(reg_write_xm),
	.mem_reg(mem_reg_xm),
	.mem_read_data_buffered(mem_read_data_mw),
	.alu_result_buffered(alu_result_mw),
	.write_reg_addr_buffered(write_reg_addr_mw),
	.reg_write_buffered(reg_write_mw),
	.mem_reg_buffered(mem_reg_mw)
);

/*
 * Writeback Stage
 */

mux32 write_content_mux( // Mux is opposite polarity of the drawing
	.a(alu_result_mw),
	.b(mem_read_data_mw),
	.sel(mem_reg_mw),
	.result(reg_write_data_mw)
);

endmodule