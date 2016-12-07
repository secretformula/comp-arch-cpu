module program_counter(input clk, 
          input rst, 
          input [31:0] immediate_value, 
          input zero,
          input jump,
          input [25:0] jump_immediate, 
          output [31:0] pc_out);
          
  reg [31:0] pc_out;
  
  always@(posedge clk or posedge rst)
    begin
       if(rst)
            begin
                pc_out <= 32'h3000 - 4;
            end
       else
        begin
            if(zero)
                pc_out <= pc_out + immediate_value * 4;
            else if(jump)
                pc_out <= {(pc_out + 4)[31:28], jump_immediate, 2'b00};
            else
                pc_out <= pc_out + 4;             
        end 
    end

    
endmodule
