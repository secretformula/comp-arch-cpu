module mux(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] out
    );
    
    reg [31:0] out;
    
    always @(*)
    case(sel)
    1'b0: out = a;
    1'b1: out = b;
    endcase
    
endmodule