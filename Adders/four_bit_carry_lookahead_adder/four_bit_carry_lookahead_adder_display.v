/*******************************************************************************
4-bit Carry Lookahead Adder Display displays the two addends, sum and carry out 
in hexadecimal form on a 4-digit Seven-segment Display.
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_carry_lookahead_adder_display(
    input [3:0] a,
    input [3:0] b,
    input clk,
    input clr,
    output [3:0] an,
    output [6:0] ca
    );

    wire c_in = 0;
    wire [3:0] sum;
    wire c_out;
    
    // initializes a 4-bit Carry Lookahead Adder
    four_bit_carry_lookahead_adder adder(.a(a), .b(b), .sum(sum), 
                                         .c_in(c_in), .c_out(c_out));
    
    // intializes a 4-digit Seven-segment Display
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(a), .dig2(b), 
                                     .dig3(sum), .dig4(c_out), 
                                     .an(an), .ca(ca));
endmodule