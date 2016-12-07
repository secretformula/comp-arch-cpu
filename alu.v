module alu(
  a,
  b,
  sel,
  f,
  ovf,
  zero
);
 
  //Declare inputs and outputs
 
  input [31:0] a;
 
  input [31:0] b;
 
  input [2:0] sel;
 
  output [31:0] f;
 
  output ovf;
 
  output zero;
 
 
 
  reg [31:0] f;
 
  reg ovf;
 
  reg zero;
 
 
 
  wire [31:0] a;
 
  wire [31:0] b;
 
  wire [2:0] sel;
 
 
 
  always @ (*)
 
  begin
	zero = 0;
	ovf = 0;
	
	case(sel)
 
  	3'b000: //Add
 
    	begin
 
    	f = a + b;
    	ovf = (a[31]~^b[31] && f[31]!=a[31])?1:0;
 
    	end
 
  	3'b001: //Noop
 
    	begin
 
    	f = f;
 
    	end
 
  	3'b010: //And
 
    	begin
 
    	f = a&b;
    	
    	end
 
  	3'b011: //Or
 
        begin
 
    	f = a|b;
 
    	end
 
  	3'b100: // Set Less Than
 
    	begin

        if($signed(a) < $signed(b))
          f <= 32'd1;
        else
          f <= 32'd0;
  
    	end
 
  	3'b101: //Shift left logical
 
    	begin
 
    	f = {a[30:0],1'b0};
    	end
 
  	3'b110: //beq
 
    	begin
 
    	if(a==b)
 
      	zero = 1;
 
    	end
 
  	3'b111: //bne
 
    	begin
    	f = 32'd0;
    	if(a!=b)
 
      	zero = 1;
 
    	end
 
  	default:
    	begin
    	f = 32'd0;   	
    	end
	endcase
  end
endmodule
