module inst_decoder(
input [31:0] instruction,
output reg_write,
output reg_dst,
output [15:0] immediate_constant,
output ALUSrc1,
output ALUSrc2,
output [2:0] ALUOp,
output mem_write,
output mem_read,
output mem_to_reg,
output [4:0] rs_addr,
output [4:0] rt_addr,
output [4:0] rd_addr
    );
    
wire [31:0] instruction;
reg [5:0] opcode;
reg [5:0] funct;
reg [5:0] padding; 
reg [15:0] immediate_constant;

reg reg_write;
reg reg_dst;
reg ALUSrc1;
reg ALUSrc2;
reg [2:0] ALUOp;
reg mem_write;
reg mem_to_reg;
wire [4:0] rs_addr;
wire [4:0] rt_addr;
wire [4:0] rd_addr;

assign rs_addr = instruction[25:21];
assign rt_addr = instruction[20:16];
assign rd_addr = instruction[15:11];

always @(*)
begin
ALUSrc1 = 1'b0;
mem_write = 1'b0;
mem_to_reg = 1'b0;
reg_dst = 1'b0;
opcode = instruction[31:26];
funct = instruction[5:0];
reg_write = 1'b1;
ALUSrc2 = 1'b0;
case(opcode)

    //Branch Instructions
    6'd 4: //beq
    begin
    immediate_constant = instruction [15:0];
    ALUOp = 3'b110;
    reg_write = 0;
    end
     
     //R-Type Instructions -- opcode is 0, will check funct
     6'd 0:
      case(funct)

       6'h 20: //add
            begin
              ALUOp = 3'b000;
              reg_dst = 1'b1;
              end
       6'h 2A:
            begin
              ALUOp = 3'b 100;
              reg_dst = 1'b1;
            end
     
     // I-Type Instructions:        
     6'h 23: //lw
          begin
       immediate_constant = instruction [15:0];
       ALUOp = 3'b000;
       mem_to_reg = 1'b1;
       mem_read = 1'b1;
       ALUSrc2 = 1'b1;
     end
     
     6'h 2b: //sw
          begin
       immediate_constant = instruction [15:0];
       ALUOp = 3'b000;
       mem_write = 1'b1;
       reg_write = 1'b0;
       ALUSrc2 = 1'b1;
     end
     6'd 8: //addi
          begin
       immediate_constant = instruction [15:0];
       ALUOp = 3'b000;
       ALUSrc2 = 1'b1;
     end   
     
     
    
endcase
end

endmodule
