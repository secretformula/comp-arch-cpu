module register_file_tb(
);

reg clk;
reg rst;
reg write_en;
reg [4:0] read_addr_0;
reg [4:0] read_addr_1;
reg [31:0] data_to_write;
reg [31:0] write_addr;
wire [31:0] read_data_0;
wire [31:0] read_data_1;

register_file register_dut(
	.clk(clk),
	.rst(rst),
	.write_en(write_en),
	.read_addr_0(read_addr_0),
	.read_addr_1(read_addr_1),
	.write_addr(write_addr),
	.write_data(data_to_write),
	.read_data_0(read_data_0),
	.read_data_1(read_data_1)
);

// Start clock
initial begin
clk = 0;
#15 clk = 1;
forever
#5 clk = ~clk;
end

// Program rest of simulation
initial begin
rst = 0;
write_en = 0;
read_addr_0 = 0;
read_addr_1 = 0;
data_to_write = 1;
#5
rst = 1;
#2
rst = 0;
#8
write_en = 1;
write_addr = 5;
data_to_write = 32'hAA;
#5
write_en = 0;
read_addr_1 = 5;

end

endmodule
