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
output reg [31:0] instr_addr;
input wire [31:0] instr;
output reg [31:0] data_addr;
output reg [31:0] data_out;
input wire [31:0] data_in;
output reg mem_write;
output reg mem_read;

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
	.rs_addr(rs_addr),
	.rt_addr(rt_addr),
	.rd_addr(rd_addr),
	.ALUSrc1(alusrc1),
	.ALUSrc2(alusrc2),
	.mem_to_reg(memtoreg)
);

alu alu(
	.a(rs_data),
	.b(rt_data),
	.sel(aluOp),
	.c(rd_data),
	.ovf(ovf),
	.zero(zero)
);

endmodule