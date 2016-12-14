module controller(
	input wire rst,
	input wire [31:0] instruction,
	input wire stall_b,
	output reg [2:0] alu_op,
	output reg mem_read,
	output reg mem_write,
	output reg jump,
	output reg reg_write,
	output reg reg_dst,
	output reg mem_reg,
	output reg alu_src,
	output reg branch
);

wire [5:0] opcode;
wire [5:0] r_funct;

assign opcode = instruction[31:26];
assign r_funct = instruction[5:0];

always @ (posedge rst) begin
	mem_read <= 1'b0;
	mem_write <= 1'b0;
	mem_reg <= 1'b0;
	reg_dst <= 1'b0;
	reg_write <= 1'b0;
	alu_op <= 3'h1;
	alu_src <= 1'b0;
	branch <= 1'b0;
	jump <= 1'b0;
end

always @ (*) begin
	if(!stall_b) begin
		//Signals for Noop
		reg_write <= 1'b0;
		alu_op <= 3'h1;
		mem_read <= 1'b0;
		mem_write <= 1'b0;
		mem_reg <= 1'b0;
		alu_src <= 1'b0;
		//branch <= 1'b0;
	end else begin
		case(opcode)
		6'h04: // beq
		begin
			mem_read <= 1'b0;
			mem_write <= 1'b0;
			mem_reg <= 1'b0;
			reg_dst <= 1'b0;
			reg_write <= 1'b0;
			alu_op <= 3'h6;
			alu_src <= 1'b0;
			branch <= 1'b1;
		end
		6'h0: // R type instructions
		begin
			mem_read <= 1'b0;
			mem_write <= 1'b0;
			mem_reg <= 1'b0;
			reg_dst <= 1'b1;
			reg_write <= 1'b1;
			alu_src <= 1'b0;
			branch <= 1'b0;
			case(r_funct)
			6'h20: // add
			begin
				alu_op <= 3'h0;
			end
			6'h2a: // slt
			begin
				alu_op <= 3'h4;
			end
			endcase
		end
		6'h23: // lw
		begin
			mem_read <= 1'b1;
			mem_write <= 1'b0;
			mem_reg <= 1'b1;
			reg_dst <= 1'b0;
			reg_write <= 1'b1;
			alu_op <= 3'h0;
			alu_src <= 1'b1;
			branch <= 1'b0;
		end
		6'h2b: // sw
		begin
			mem_read <= 1'b0;
			mem_write <= 1'b1;
			mem_reg <= 1'b1;
			reg_dst <= 1'b0;
			reg_write <= 1'b0;
			alu_op <= 3'h0;
			alu_src <= 1'b1;
			branch <= 1'b0;
		end
		6'h08: // addi
		begin
			mem_read <= 1'b0;
			mem_write <= 1'b0;
			mem_reg <= 1'b0;
			reg_dst <= 1'b0;
			reg_write <= 1'b1;
			alu_op <= 3'h0;
			alu_src <= 1'b1;
			branch <= 1'b0;
		end
		6'h02: // jump
		begin
			jump <= 1'b1;
			branch <= 1'b0;
		end
		6'h3f: // halt
		begin
			
		end
		endcase
	end
end

endmodule
