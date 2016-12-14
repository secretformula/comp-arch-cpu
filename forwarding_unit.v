module forwarding_unit(
	input wire rst,
	input wire [4:0] rs_addr_dx,
	input wire [4:0] rt_addr_dx,
	input wire [4:0] write_reg_addr_xm,
	input wire write_reg_xm,
	input wire [4:0] write_reg_addr_mw,
	input wire write_reg_mw,
	output reg [1:0] alu_a_mux_sel,
	output reg [1:0] alu_b_mux_sel
);

always @ (posedge rst) begin
	alu_a_mux_sel <= 2'b0;
	alu_b_mux_sel <= 2'b0;
end

always @ (*) begin
	if(write_reg_xm && (write_reg_addr_xm != 0) && (write_reg_addr_xm == rs_addr_dx)) begin
		alu_a_mux_sel <= 2'b10;
	end else if(write_reg_mw && (write_reg_addr_mw != 0) && (write_reg_addr_mw == rs_addr_dx)) begin
		alu_a_mux_sel <= 2'b01;
	end else begin
		alu_a_mux_sel <= 2'b00;
	end
	if(write_reg_xm && (write_reg_addr_xm != 0) && (write_reg_addr_xm == rt_addr_dx)) begin
		alu_b_mux_sel <= 2'b10;
	end else if(write_reg_mw && (write_reg_addr_mw != 0) && (write_reg_addr_mw == rt_addr_dx)) begin
		alu_b_mux_sel <= 2'b01;
	end else begin
		alu_b_mux_sel <= 2'b00;
	end
end

endmodule