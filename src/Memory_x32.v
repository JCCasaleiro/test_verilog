module Memory_x32 #(parameter WIDTH=6) (
  output [WIDTH-1:0] Obus,
  input [WIDTH-1:0] Ibus,
  input [5:0] Adr,
  input clk, Read);
    
  reg [WIDTH-1:0] Storage[63:0];
  reg [WIDTH-1:0] ObusReg;

  assign Obus = ObusReg;
  always @(posedge clk) begin
    if (Read==1'b0) Storage[Adr] <= Ibus;
    else ObusReg <= Storage[Adr];
  end
  
endmodule
