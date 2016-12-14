module dx_pipeline_register(
	input wire clk,
	input wire rst,
	input wire stall_b,
	input wire [31:0] pc_value_next,
	input wire [31:0] read_data_0,
	input wire [31:0] read_data_1,
	input wire [31:0] immediate,
	input wire [2:0] alu_op,
	input wire mem_read,
	input wire mem_write,
	input wire reg_write,
	input wire mem_reg,
	input wire reg_dst,
	input wire [4:0] rt_addr,
	input wire [4:0] rd_addr,
	input wire [4:0] rs_addr,
	input wire alu_src,
	input wire branch,
	output reg [31:0] pc_value,
	output reg [31:0] read_data_buffered_0,
	output reg [31:0] read_data_buffered_1,
	output reg [31:0] immediate_buffered,
	output reg [2:0] alu_op_buffered,
	output reg mem_read_buffered,
	output reg mem_write_buffered,
	output reg reg_write_buffered,
	output reg mem_reg_buffered,
	output reg reg_dst_buffered,
	output reg [4:0] rt_addr_buffered,
	output reg [4:0] rd_addr_buffered,
	output reg [4:0] rs_addr_buffered,
	output reg alu_src_buffered,
	output reg branch_buffered
);

always @ (posedge rst) begin
	branch_buffered = 1'b0;
	alu_op_buffered = 3'h1; // Noop
end

always @ (posedge clk) begin
	if(!stall_b) begin
		rt_addr_buffered <= 5'h0;
		rd_addr_buffered <= 5'h0;
		rs_addr_buffered <= 5'h0;
	end else begin
		rt_addr_buffered <= rt_addr;
		rd_addr_buffered <= rd_addr;
		rs_addr_buffered <= rs_addr;
	end
	pc_value <= pc_value_next;
	read_data_buffered_0 <= read_data_0;
	read_data_buffered_1 <= read_data_1;
	immediate_buffered <= immediate;
	alu_op_buffered <= alu_op;
	mem_read_buffered <= mem_read;
	mem_write_buffered <= mem_write;
	reg_write_buffered <= reg_write;
	mem_reg_buffered <= mem_reg;
	reg_dst_buffered <= reg_dst;
	alu_src_buffered <= alu_src;
	branch_buffered <= branch;
	
end

endmodule
