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

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

    register V(clk, rst_n, ena, ui_in, uo_out);
    register A(clk, rst_n, ena, ui_in, uo_out);
    register R(clk, rst_n, ena, ui_in, uo_out);
    register PC(clk, rst_n, ena, ui_in, uo_out);
    register C(clk, rst_n, ena, ui_in, uo_out);
    register Z(clk, rst_n, ena, ui_in, uo_out);

  // List all unused inputs to prevent warnings
  //wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

module register #(parameter WIDTH=8) (
    input clk, rst, en,
    input [WIDTH-1:0] D, 
    output [WIDTH-1:0] Q); 
    reg [WIDTH-1:0] block; 
 
    always@(posedge clk) begin 
        if(!rst)   block <= 0; 
        else begin 
            if(en==1) block <= D; 
            else Q <= block; 
        end 
    end 
endmodule
