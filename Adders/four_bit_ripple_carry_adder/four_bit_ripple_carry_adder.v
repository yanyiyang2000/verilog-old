/*******************************************************************************
4-bit Ripple Carry Adder adds two 4-bit binary numbers together and outputs the 
sum and carry.

It is called a "ripple carry" adder because the carry bits are propagated from 
one bit position to the next, like a ripple effect.

N 4-bit Ripple Carry Adders can be cascaded to form a 4N-bit Ripple Carry Adder 
(e.g., two 4-bit Ripple Carry Adders can be cascaded to form an 8-bit Ripple 
Carry Adder).

Inputs:
    a:     4-bit addend
    b:     4-bit addend

Outputs:
    sum:   4-bit sum
    c_out: 1-bit carry out
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_ripple_carry_adder(
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output c_out
    );

    // carry outs of the half and full adders
    wire c0, c1, c2;
    
    half_adder ha1 (.a(a[0]), .b(b[0]), .sum(sum[0]), .c_out(c0));
    full_adder fa1 (.a(a[1]), .b(b[1]), .c_in(c0), .sum(sum[1]), .c_out(c1));
    full_adder fa2 (.a(a[2]), .b(b[2]), .c_in(c1), .sum(sum[2]), .c_out(c2));
    full_adder fa3 (.a(a[3]), .b(b[3]), .c_in(c2), .sum(sum[3]), .c_out(c_out));
endmodule