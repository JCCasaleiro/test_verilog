module Mux4T1 #(parameter N=6) (
  input [N-1:0] A, 
  input [N-1:0] B,
  input [N-1:0] C,
  input [N-1:0] D,
  input [1:0] S,
  output reg [N-1:0] Y); 
  
  always @(S or A or B or C or D)
    case (S) 
      2'b00: Y = A;
      2'b01: Y = B;
      2'b10: Y = C;
      2'b11: Y = D;
    endcase
endmodule
  
module Mux2T1 #(parameter N=6) (
  input [N-1:0] A, B,
  input S, 
  output reg [N-1:0] Y ); 
   
   // used in procedural statement
  always@(S or A or B)
    case (S) 
       1'b0: Y = A;
       1'b1: Y = B;
     endcase
endmodule
