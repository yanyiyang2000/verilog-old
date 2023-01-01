/*******************************************************************************
8-bit Integer Square Root Finder Display displays an 8-bit integer and its 
square root in decimal form on a 4-digit Seven-segment Display.

An 8-bit integer will be displayed on the two seven-segment displays on the 
LEFT.

The 8-bit square root will be displayed on the two seven-segment displays on the
RIGHT.
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_int_sqrt_finder_display(
    input clk,
    input clr,
    input start, 
    input [7:0] a,
    output [3:0] an,
    output [6:0] ca
    );
    
    wire [7:0] sqrt;       // square root
    wire [3:0] sqrt_upper; // upper 4 bits of square root
    wire [3:0] sqrt_lower; // lower 4 bits of square root
    
    // initializes an 8-bit Integer Square Root Finder Controller
    eight_bit_int_sqrt_finder_cntlr cntlr(.clk(clk), .clr(clr), .start(start), 
                                          .a(a), .sqrt(sqrt));
    
    // initializes an 8-bit Binary-to-BCD Converter
    eight_bit_bin_to_bcd_cnvrt cnvrt(.bin(sqrt), .upper(sqrt_upper), 
                                     .lower(sqrt_lower));
    
    // initializes a 4-digit Seven-segment Display
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(a[7:4]), .dig2(a[3:0]),
                                     .dig3(sqrt_upper), .dig4(sqrt_lower),
                                     .an(an), .ca(ca));
endmodule