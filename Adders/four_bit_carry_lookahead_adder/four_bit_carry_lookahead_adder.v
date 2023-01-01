/*******************************************************************************
4-bit Carry Lookahead Adder (CLA) adds two 4-bit binary numbers and carry in 
together and outputs the sum and carry out.

In a Carry Lookahead Adder, the carry bits are calculated in parallel for each 
bit position in the addition, rather than being propagated from one bit position 
to the next as in a Ripple Carry Adder. This allows the Carry Lookahead Adder to 
perform the addition much faster, especially for large numbers with many bits.

N 4-bit Carry Lookahead Adders can be cascaded to form a 4N-bit Carry Lookahead 
Adder (e.g., two 4-bit Carry Lookahead Adders can be cascaded to form an 8-bit 
Carry Lookahead Adder).

Inputs: 
      a:     4-bit addend
      b:     4-bit addend
      c_in:  1-bit carry in

Outputs:
      sum:   4-bit sum
      c_out: 1-bit carry out
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_carry_lookahead_adder(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] sum,
    output c_out
    );

    wire g0, g1, g2, g3; // carry generate signals of each bit position
    wire p0, p1, p2, p3; // carry propogate signals of each bit position
    wire c1, c2, c3;     // carry bits of each bit position
    
    // initializes four Half Adders to calculate carry generate and carry 
    // propogate signals for each bit position
    half_adder ha1(.a(a[0]), .b(b[0]), .sum(p0), .c_out(g0));
    half_adder ha2(.a(a[1]), .b(b[1]), .sum(p1), .c_out(g1));
    half_adder ha3(.a(a[2]), .b(b[2]), .sum(p2), .c_out(g2));
    half_adder ha4(.a(a[3]), .b(b[3]), .sum(p3), .c_out(g3));
    
    // calculates carry bits for each bit position
    assign c1    = g0 ^ (p0 & c_in);
    assign c2    = g1 ^ (p1 & g0) ^ (p1 & p0 & c_in);
    assign c3    = g2 ^ (p2 & g1) ^ (p2 & p1 & g0) ^ (p2 & p1 & p0 & c_in);
    assign c_out = g3 ^ (p3 & g2) ^ (p3 & p2 & g1) ^ (p3 & p2 & p1 & g0) ^ (p3 & p2 & p1 & p0 & c_in);
    
    // calculates sum bits for each bit position
    xor(sum[0], c_in, p0);
    xor(sum[1], c1, p1);
    xor(sum[2], c2, p2);
    xor(sum[3], c3, p3);
endmodule