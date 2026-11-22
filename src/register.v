module register #(parameter WIDTH=6) (
    input clk, rst, en,
    input [WIDTH-1:0] D, 
    output reg [WIDTH-1:0] Q); 
     
  always@(negedge clk) begin 
        if(!rst)   Q <= 0; 
        else begin 
            if(en==1) Q <= D; 
            else Q <= D; 
        end 
    end 
endmodule
