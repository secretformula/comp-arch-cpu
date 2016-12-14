module hazard_detection_unit(
  input wire rst,
  input wire [31:0] instruction,
  input wire [4:0] dx_rt,
  input wire jump,
  input wire branch,
  input wire equals_result,
  input wire dx_mem_read,
  output reg load_enable,
  output reg flush
);


wire [4:0] fd_rt_reg; 
wire [4:0] fd_rs_reg; 

assign fd_rt_reg = instruction[20:16];
assign fd_rs_reg = instruction[25:21];

always @ (posedge rst) begin
  load_enable <= 1'b1;
  flush <= 1'b0;
end

//Load-use Hazard detection
always @ (*) begin
  if(dx_mem_read && (dx_rt == fd_rs_reg) ||
    (dx_rt == fd_rt_reg)) begin
        load_enable <= 1'b0;
    end
  else begin
    load_enable <= 1'b1;
  end

  //Control Hazard detection
  //Branch
  if(branch && equals_result) begin
    flush <= 1'b1;
  end else begin
    flush <= 1'b0;
  end

  //Jump
  if(jump) begin
    flush <= 1'b1;
  end else begin
    flush <= 1'b0;
  end
end
endmodule