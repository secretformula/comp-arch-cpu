module fd_pipeline_register_tb(
);

reg clk;
reg [31:0] pc_value_next;
reg [31:0] next_instruction;
wire [31:0] pc_value;
wire [31:0] instruction;

fd_pipeline_register reg_dut(
	.clk(clk),
	.pc_value_next(pc_value_next),
	.next_instruction(next_instruction),
	.pc_value(pc_value),
	.instruction(instruction)
);

// Start clock
initial begin
clk = 0;
#5 clk = 1;
forever
#5 clk = ~clk;
end

// Program rest of simulation
initial begin
#15
next_instruction = 32'hAABBAABB;
pc_value_next = 32'h1;
#10
next_instruction = 32'hCCCCCCCC;
pc_value_next = 32'hDD;
end

endmodule