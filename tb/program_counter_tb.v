module program_counter_tb(
);

reg clk;
reg rst;
reg [31:0] next_addr;
wire [31:0] counter_value;

program_counter pc(
	.clk(clk),
	.rst(rst),
	.next_addr(next_addr),
	.counter_value(counter_value)
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
#5
rst = 1;
#2
rst = 0;
end

endmodule