module alu_regfile(
    input clk,
    input rst,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input [32:0] write_data,
    input reg_write,
    input reg_read,
    input [15:0] instr,
    input ALUSrc1,
    input ALUSrc2,
    input [2:0] ALUOp,
    output [32:0] read_data1,
    output [32:0] read_data2,
    output [31:0] alu_input1,
    output [31:0] alu_input2,
    output [31:0] alu_result,
    output ovf,
    output zero
    );

wire clk;
wire rst;
wire [4:0] read_addr1;
wire [4:0] read_addr2;
wire [4:0] write_addr;
wire [32:0] write_data;
wire reg_write;
wire reg_read;
//reg read_data1;
//reg read_data2;

 wire [31:0] alu_input1;
 wire [31:0] alu_input2;
 wire [32:0] read_data1;
 wire [32:0] read_data2; 
    
//Set up reg file
reg_file register(
.clk(clk),
.rst(rst),
.rd0_addr(read_addr1),
.rd1_addr(read_addr2),
.wr_addr(write_addr),
.wr_data(write_data),
.wr_en(reg_write),
.rd0_data(read_data1),
.rd1_data(read_data2)
);

//Set up muxes
wire ALUSrc1;
//reg alu_input1;

mux mux1(
.a(read_data1),
.b(0),
.sel(ALUSrc1),
.out(alu_input1)
);

wire [15:0] instr;
wire ALUSrc2;
//reg alu_input2;

mux mux2(
.a(read_data2),
.b(instr),
.sel(ALUSrc2),
.out(alu_input2)
);


wire [2:0] ALUOp;
wire [31:0] alu_result;
wire ovf;
wire zero;

//Set up alu
alu alu1(
.a(alu_input1),
.b(alu_input2),
.sel(ALUOp),
.f(alu_result),
.ovf(ovf),
.zero(zero)
);

endmodule