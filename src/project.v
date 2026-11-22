/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none


module tt_um_tst_verilog (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

//  wire [5:0] MD_AB;  // Code Memory Address Bus 6 bits
//  wire [5:0] MD_DB;  // Code Memory Data Bus 9 bits
  
//  wire [5:0] MC_AB;  // Data Memory Address Bus 6 bits
//  wire [8:0] MC_DB;  // Data Memory Data Bus 6 bits
  
//  wire [5:0] Y1;
//  wire [5:0] Y2;
//  wire [5:0] Y3;
//  wire [5:0] Y5;
 
//  wire [5:0] DV, DR, DPC, QV, QA, QR, QPC;
//  wire DC, DZ, QC, QZ;
//  wire EnA, EnV, EnR, EnC, EnZ, WR_n, RD_n, JMP, JZ, JC;
//  wire [1:0] A_V_MUX;
//  wire SJCZ;
  
  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out[5:0] = 6'b000000;
  assign uio_out[7:6] = 2'b00;
  assign uio_oe  = 0;
//  assign SJCZ = (JZ & QZ) + (JC & QC);
  
//  Mux2T1 PC_MUX1(.A(6'b000001), .B(MC_DB[5:0]), .S(JMP), .Y(Y1));
//  Adder PC_ADDER(.A(Y1), .B(MC_AB), .Y(Y2));
//  Mux2T1 PC_MUX2(.A(Y2), .B(MC_DB[5:0]), .S(SJCZ), .Y(DPC));
//  Mux4T1 V_MUX(.A(Y5), .B(MD_DB), .C(QA), .D(MC_DB[5:0]), .S(A_V_MUX), .Y(DV));
//  ALU CPU_ALU(.A(QV), .B(QA), .Y(Y5), .S(MC_DB[8]), .C(DC), .Z(DZ));
//  Control Ctrl_Module(.Opcode(MC_DB[8:5]), .EnA(EnA), .EnV(EnV), .EnR(EnR), .EnC(EnC), .EnZ(EnZ), .WR_n(WR_n), .RD_n(RD_n), .JMP(JMP), .JZ(JZ), .JC(JC), .Ax(A_V_MUX));

    register #(8) RT(.clk(clk), .rst(rst_n), .en(1'b1), .D(ui_in), .Q(uo_out));
//  register V(.clk(clk), .rst(rst_n), .en(EnV), .D(DV), .Q(QV));
//  register A(.clk(clk), .rst(rst_n), .en(EnA), .D(QV), .Q(QA));
//  register R(.clk(clk), .rst(rst_n), .en(EnR), .D(QV), .Q(MD_DB));
//  register PC(.clk(~clk), .rst(rst_n), .en(1'b1), .D(ui_in[5:0]), .Q(MC_AB));
//  register #(1) C(.clk(clk), .rst(rst_n), .en(EnC), .D(DC), .Q(QC));
//  register #(1) Z(.clk(clk), .rst(rst_n), .en(EnZ), .D(DZ), .Q(QZ));

//  Memory_x32 RAM (.Obus(MD_DB), .Ibus(6'b000000), .Adr(MD_DB), .clk(clk), .Read(RD_n));
//  Memory_x32 #(9) ROM (.Obus(MC_DB), .Ibus(9'b000000000), .Adr(MD_DB), .clk(clk), .Read(1'b0));

  // List all unused inputs to prevent warnings
  //wire _unused = &{ena, clk, rst_n, 1'b0};
    wire _unused = &{ena, rst_n, 1'b0};

endmodule

