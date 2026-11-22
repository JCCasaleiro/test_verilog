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

  wire [7:0] data_bus;
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = data_bus;
  assign uio_oe  = 0;
  

    register #(6) V(.clk(clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));
    register #(6) A(.clk(clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));
    register #(6) R(.clk(clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));
    register #(6) PC(.clk(~clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));
    register #(1) C(.clk(clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));
    register #(1) Z(.clk(clk), .rst(rst_n), .en(ena), .D(ui_in), .Q(data_bus));

  // List all unused inputs to prevent warnings
  //wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

module register #(parameter WIDTH=8) (
    input clk, rst, en,
    input [WIDTH-1:0] D, 
    output reg [WIDTH-1:0] Q); 
     
    always@(posedge clk) begin 
        if(!rst)   Q <= 0; 
        else begin 
            if(en==1) Q <= D; 
            else Q <= D; 
        end 
    end 
endmodule

module Memory #(parameter WIDTH=8, LEN=4) (
    output [WIDTH-1:0] Obus,
    input [WIDTH-1:0] Ibus,
    input [LEN-1:0] Adr,
    input Clk, Read);
    
    reg [WIDTH-1:0] Storage[LEN:0];
    reg [WIDTH-1:0] ObusReg;

    assign Obus = ObusReg;
    always @(posedge Clk)
        begin
            if (Read==1’b0) Storage[Adr] = Ibus;
            else ObusReg = Storage[Adr];
        end
endmodule

module counter (
    input rst, clock, jmp,
    input [7:0] jump,
    output reg [7:0] count);
    
    always@(posedge clock)
        begin
        if (rst) count = 8’h00;
            else if (jmp) count = jump + count;
            else count = count + 8’h1;
        end
endmodule
