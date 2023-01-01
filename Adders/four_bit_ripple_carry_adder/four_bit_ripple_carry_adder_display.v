/*******************************************************************************
4-bit Ripple Carry Adder Display displays the two addends, sum and carry out in 
hexadecimal form on a 4-digit Seven-segment Display.
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_ripple_carry_adder_display(
    input [3:0] a,   // 4-bit addend
    input [3:0] b,   // 4-bit addend
    input clk,       // 1-bit clock signal
    input clr,       // 1-bit clear signal
    output [3:0] an, // 4-bit anode control signal
    output [6:0] ca  // 7-bit cathode control signal
    );

    wire [3:0] sum;  // 4-bit sum
    wire c_out;      // 1-bit carry out
    
    // initializes a 4-bit Ripple Carry Adder
    four_bit_ripple_carry_adder adder(.a(a), .b(b), .sum(sum), .c_out(c_out));
    
    // intializes a 4-digit Seven-segment Display
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(a), .dig2(b), 
                                     .dig3(sum), .dig4(c_out), 
                                     .an(an), .ca(ca));
endmodule