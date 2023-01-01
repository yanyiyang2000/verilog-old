/*******************************************************************************
4-bit Combinational Array Multiplier Display displays multiplier, multiplicand 
and the product in hexadecimal form on a 4-digit Seven-segment Display.

Multiplier and multiplicand will be displayed on the two seven-segment displays 
on the LEFT.

Product will be displayed on the two seven-segment displays on the RIGHT.
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_comb_arr_multplr_display(
    input [3:0] a,
    input [3:0] b,
    input clk,
    input clr,
    output [3:0] an,
    output [6:0] ca
    );

    wire [7:0] product;
    
    // initializes a 4-bit Combinational Array Multiplier
    four_bit_comb_arr_multplr multiplier(.a(a), .b(b), .product(product));
    
    // intializes a 4-digit Seven-segment Display
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(a), .dig2(b), 
                                     .dig3(product[7:4]), .dig4(product[3:0]), 
                                     .an(an), .ca(ca));
endmodule