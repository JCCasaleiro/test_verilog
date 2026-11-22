module Adder #(parameter N=6) (
  input [N-1:0] A, B,
  output reg [N-1:0] Y);
  
  assign Y = A + B;

endmodule

module ALU #(parameter N=6) (
  input [N-1:0] A, B,
  input S,
  output reg [N-1:0] Y,
  output reg C,
  output reg Z);
  
  assign {C, Y} = (S==1'b0) ? (A + B) : (A - B);
  assign Z = (A == B);
 
endmodule
