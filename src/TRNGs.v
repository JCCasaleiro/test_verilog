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
(* keep_hierarchy *)
module TRNGs(
    input wire en,
    input wire clk,
    output reg [31:0] out
);

    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin : ROs

            RO #(.NG(15)) RO1(.en(en), .sample_clk(clk), .sampled_out(out[k]));
        end
    endgenerate
    
endmodule


(* keep_hierarchy *)
module not_cell (
    input wire in,
    output wire out
    );

    assign out = !in;
endmodule

(* keep_hierarchy *)
module nand_cell (
    input wire A,
    input wire B,
    output wire OUT
    );

    assign OUT = ~(A & B);
endmodule

(* keep_hierarchy *)
module RO #(parameter NG = 7)
(
    input  wire en,
    input  wire sample_clk,
    output reg  sampled_out
);

    (* keep = 1 *) wire [NG-1:0] N;

    // NAND gate
    nand_cell nand1(.A(en),.B(N[NG-1]), .OUT(N[0]));

    genvar i;
    generate
        for (i = 1; i < NG; i = i + 1) begin : inv_chain
            
            // NOT gate
            not_cell inv(.in(N[i-1]), .out(N[i]));
            
        end
    endgenerate

    // D flip-flop samples the ring oscillator
    always @(posedge sample_clk) begin
        sampled_out <= N[NG-1];
    end

endmodule
