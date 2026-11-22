/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [5:0] MD_AB;  // Code Memory Address Bus 6 bits
  wire [5:0] MD_DB;  // Code Memory Data Bus 9 bits
  
  wire [5:0] MC_AB;  // Data Memory Address Bus 6 bits
  wire [8:0] MC_DB;  // Data Memory Data Bus 6 bits
  
  wire [5:0] Y1;
  wire [5:0] Y2;
  wire [5:0] Y3;
  wire [5:0] Y5;
 
  wire [5:0] DV, DR, DPC, QV, QA, QR, QPC;
  wire DC, DZ, QC, QZ;
  wire EnA, EnV, EnR, EnC, EnZ, WR_n, RD_n, JMP, JZ, JC;
  wire [1:0] A_V_MUX;
  wire SJCZ;
  
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[5:0] = 6'b000000;
  assign uio_out[7:6] = 2'b00;
  assign uio_oe  = 0;
  assign SJCZ = (JZ & QZ) + (JC & QC);
  
  Mux2T1 PC_MUX1(.A(6'b000001), .B(MC_DB[5:0]), .S(JMP), .Y(Y1));
  Adder PC_ADDER(.A(Y1), .B(MC_AB), .Y(Y2));
  Mux2T1 PC_MUX2(.A(Y2), .B(MC_DB[5:0]), .S(SJCZ), .Y(DPC));
  Mux4T1 V_MUX(.A(Y5), .B(MD_DB), .C(QA), .D(MC_DB[5:0]), .S(A_V_MUX), .Y(DV));
  ALU CPU_ALU(.A(QV), .B(QA), .Y(Y5), .S(MC_DB[8]), .C(DC), .Z(DZ));
  Control Ctrl_Module(.Opcode(MC_DB[8:5]), .EnA(EnA), .EnV(EnV), .EnR(EnR), .EnC(EnC), .EnZ(EnZ), .WR_n(WR_n), .RD_n(RD_n), .JMP(JMP), .JZ(JZ), .JC(JC), .Ax(A_V_MUX));
  
  register V(.clk(clk), .rst(rst_n), .en(EnV), .D(DV), .Q(QV));
  register A(.clk(clk), .rst(rst_n), .en(EnA), .D(QV), .Q(QA));
  register R(.clk(clk), .rst(rst_n), .en(EnR), .D(QV), .Q(MD_DB));
  register PC(.clk(~clk), .rst(rst_n), .en(1'b1), .D(ui_in[5:0]), .Q(MC_AB));
  register #(1) C(.clk(clk), .rst(rst_n), .en(EnC), .D(DC), .Q(QC));
  register #(1) Z(.clk(clk), .rst(rst_n), .en(EnZ), .D(DZ), .Q(QZ));

  Memory_x32 RAM (.Obus(MD_DB), .Ibus(6'b000000), .Adr(MD_DB), .clk(clk), .Read(RD_n));
  Memory_x32 #(9) ROM (.Obus(MC_DB), .Ibus(9'b000000000), .Adr(MD_DB), .clk(clk), .Read(1'b0));

  // List all unused inputs to prevent warnings
  //wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

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

module Control (
  input [3:0] Opcode,
  output reg EnA, EnV, EnR, EnC, EnZ, WR_n, RD_n, JMP, JZ, JC,
  output reg [1:0] Ax);
  
  always @*
  casez (Opcode) 
      4'b000?: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b1;
        Ax = 2'b11;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0010: begin
        EnA = 1'b0;
        EnR = 1'b1;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0011: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b1;
        Ax = 2'b10;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0100: begin
        EnA = 1'b1;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0101: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b1;
        Ax = 2'b01;
        WR_n = 1'b1;
        RD_n = 1'b0;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0110: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b0;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b0111: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b1;
        EnZ = 1'b1;
        EnV = 1'b1;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b1000: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b1;
        EnZ = 1'b1;
        EnV = 1'b1;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b1001: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b0;
      end
      4'b101?: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b0;
        JC = 1'b1;
      end
      4'b110?: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b0;
        JZ = 1'b1;
        JC = 1'b0;
      end
      4'b111?: begin
        EnA = 1'b0;
        EnR = 1'b0;
        EnC = 1'b0;
        EnZ = 1'b0;
        EnV = 1'b0;
        Ax = 2'b00;
        WR_n = 1'b1;
        RD_n = 1'b1;
        JMP = 1'b1;
        JZ = 1'b0;
        JC = 1'b0;
      end
  endcase
endmodule
