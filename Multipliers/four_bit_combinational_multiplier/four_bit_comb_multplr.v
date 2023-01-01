/*******************************************************************************
4-bit Combinational Multiplier multiplies two 4-bit binary numbers and outputs
the product.

Inputs: 
    a:       4-bit multiplier
    b:       4-bit multiplicand

Outputs:
    product: 8-bit product
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_comb_multplr(
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
    );

    // sum bits of each bit position
    wire s1, s2, s3, s4, s5, s6;

    // carry bits of each bit position                     
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;
    
    // calculates sum and carry bits for each bit position
    and(product[0], a[0], b[0]);
    half_adder ha1(.a(a[0] & b[1]), .b(a[1] & b[0]), .sum(product[1]), .c_out(c1));
    half_adder ha2(.a(a[1] & b[1]), .b(a[0] & b[2]), .sum(s1), .c_out(c2));
    full_adder fa1(.a(a[2] & b[0]), .b(s1), .c_in(c1), .sum(product[2]), .c_out(c3));
    half_adder ha3(.a(a[1] & b[2]), .b(a[0] & b[3]), .sum(s2), .c_out(c4));
    full_adder fa2(.a(a[2] & b[1]), .b(s2), .c_in(c2), .sum(s3), .c_out(c5));
    full_adder fa3(.a(a[3] & b[0]), .b(s3), .c_in(c3), .sum(product[3]), .c_out(c6));
    full_adder fa4(.a(a[2] & b[2]), .b(a[1] & b[3]), .c_in(c4), .sum(s4), .c_out(c7));
    full_adder fa5(.a(a[3] & b[1]), .b(s4), .c_in(c5), .sum(s5), .c_out(c8));
    half_adder ha4(.a(s5), .b(c6), .sum(product[4]), .c_out(c9));
    full_adder fa6(.a(a[3] & b[2]), .b(a[2] & b[3]), .c_in(c7), .sum(s6), .c_out(c10));
    full_adder fa7(.a(s6), .b(c8), .c_in(c9), .sum(product[5]), .c_out(c11));
    full_adder fa8(.a(a[3] & b[3]), .b(c10), .c_in(c11), .sum(product[6]), .c_out(product[7]));
endmodule