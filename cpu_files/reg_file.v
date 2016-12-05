module reg_file(

  input clk,

  input rst,

  input wr_en,

  input [4:0] rd0_addr,

  input [4:0] rd1_addr,

  input [4:0] wr_addr,

  input [32:0] wr_data,

  output [32:0] rd0_data,

  output [32:0] rd1_data

);


  reg [32:0] mem [0:31];
  wire [32:0] rd1_data;
  wire [32:0] rd0_data;

  integer i;


  always @ (posedge clk) //Rising Edge
    begin
        if(rst) //If we are resetting our memory
            begin
               for(i = 0; i < 32; i = i+1)
                  mem[i] <= 0;       
            end
        else
            begin
                if (wr_en) //If we are writing to our memory
                      mem[wr_addr] <= wr_data;                               
            end
    end    



       
 assign rd0_data = mem[rd0_addr];
 assign rd1_data = mem[rd1_addr];
      

  

endmodule