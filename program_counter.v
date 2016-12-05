module program_counter(input clk, 
          input rst, 
          input [15:0] immediate_value, 
          input zero, 
          output [15:0] pc_out);
          
  reg [7:0] pc_out;
  
  always@(posedge clk)
    begin
       if(rst)
            begin
                pc_out <= 0;
            end
       else
        begin
            if(zero)
                pc_out <= pc_out + immediate_value;
            else
                pc_out <= pc_out + 1;             
        end 
    end

    
endmodule
