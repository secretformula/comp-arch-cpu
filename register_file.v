module register_file(
  	input clk,
  	input rst,
  	input write_en,
	input [4:0] read_addr_0,
  	input [4:0] read_addr_1,
  	input [4:0] write_addr,
  	input [31:0] write_data,
  	output [31:0] read_data_0,
  	output [31:0] read_data_1
);

reg [31:0] register_data [1:31];
integer i;

// Register reading
assign read_data_0 = (read_addr_0 != 0) ? register_data[read_addr_0] : 32'b0;
assign read_data_1 = (read_addr_1 != 0) ? register_data[read_addr_1] : 32'b0;

// Register writing
always @ (posedge clk) begin
	if(write_en && write_addr != 0) begin
		register_data[write_addr] <= write_data;
	end
end

// Reset
always @ (posedge rst) begin
	for(i = 1; i < 32; i = i+1) begin
		register_data[i] = 32'b0;
	end
end

endmodule