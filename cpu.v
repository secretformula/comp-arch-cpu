`timescale 1ns/100ps

module Cpu(
	clk,
	rst,
	instr_addr,
	instr,
	data_addr,
	data_in,
	data_out,
	mem_read,
	mem_write
);

input wire clk;
input wire rst;
output wire [31:0] instr_addr;
input wire [31:0] instr;
output reg [31:0] data_addr;
output reg [31:0] data_out;
input wire [31:0] data_in;
output wire mem_write;
output wire mem_read;

wire [2:0] aluOp;
wire [15:0] constant;
wire [4:0] rs_addr;
wire [4:0] rt_addr;
wire [4:0] rd_addr;
wire reg_write;

wire [31:0] rs_data;
wire [31:0] rt_data;
wire [31:0] rd_data;
wire ovf;
wire zero;
wire alusrc1;
wire alusrc2;
wire memtoreg;
wire reg_dst;

wire aluin2;

program_counter pc(
	.clk(clk),
	.rst(rst),
	.immediate_value(constant),
	.zero(zero),
	.pc_out(instr_addr)
);

reg_file regfile(
	.clk(clk),
	.rst(rst),
	.wr_en(reg_write),
	.rd0_addr(rs_addr),
	.rd1_addr(rt_addr),
	.rd0_data(rs_data),
	.rd1_data(rt_data),
	.wr_addr(rd_addr),
	.wr_data(rd_data)
);

inst_decoder decoder(
	.mem_write(mem_write),
	.instruction(instr),
	.mem_read(mem_read),
	.ALUOp(aluOp),
	.immediate_constant(constant),
	.reg_write(reg_write),
	.read_reg1_addr(rs_addr),
	.read_reg2_addr(rt_addr),
	.write_reg_addr(rd_addr),
	.ALUSrc1(alusrc1),
	.ALUSrc2(alusrc2),
	.mem_to_reg(memtoreg),
	.reg_dst(reg_dst)
);

alu alu(
	.a(rs_data),
	.b(aluin2),
	.sel(aluOp),
	.f(rd_data),
	.ovf(ovf),
	.zero(zero)
);

mux alu_src_mux(
	.a(rt_data),
	.b(constant),
	.sel(alusrc2),
	.out(aluin2)
);

endmodule
