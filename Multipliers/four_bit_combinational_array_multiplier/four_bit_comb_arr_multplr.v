/*******************************************************************************
4-bit Combinational Array Multiplier multiplies two 4-bit binary numbers and 
outputs the product.

The multiplier delegates the calculation to an array of rudimentary building 
blocks executing addition.

Inputs: 
    a:       1-bit multiplier
    b:       1-bit multiplicand

Outputs:
    product: 8-bit product
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_comb_arr_multplr(
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
    );

    // sum bits of each bit position
    wire s1, s2, s3, s4, s5, s6, s7, s8, s9 ,s10, s11, s12; 

    // carry bits of each bit position
    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, 
         c10, c11, c12, c13, c14, c15, c16, c17;
    
    // calculates sum and carry bits for each bit position
    comb_arr_multplr_block b1 (.a(a[0]), .b(b[0]), .sum_in(0),  .c_in(0),  .sum_out(product[0]), .c_out(c0));
    comb_arr_multplr_block b2 (.a(a[1]), .b(b[0]), .sum_in(0),  .c_in(0),  .sum_out(s1),         .c_out(c1));
    comb_arr_multplr_block b3 (.a(a[2]), .b(b[0]), .sum_in(0),  .c_in(0),  .sum_out(s2),         .c_out(c2));
    comb_arr_multplr_block b4 (.a(a[3]), .b(b[0]), .sum_in(0),  .c_in(0),  .sum_out(s3),         .c_out(c3));
    
    comb_arr_multplr_block b5 (.a(a[0]), .b(b[1]), .sum_in(s1), .c_in(c0), .sum_out(product[1]), .c_out(c4));
    comb_arr_multplr_block b6 (.a(a[1]), .b(b[1]), .sum_in(s2), .c_in(c1), .sum_out(s4),         .c_out(c5));
    comb_arr_multplr_block b7 (.a(a[2]), .b(b[1]), .sum_in(s3), .c_in(c2), .sum_out(s5),         .c_out(c6));
    comb_arr_multplr_block b8 (.a(a[3]), .b(b[1]), .sum_in(0),  .c_in(c3), .sum_out(s6),         .c_out(c7));
    
    comb_arr_multplr_block b9 (.a(a[0]), .b(b[2]), .sum_in(s4), .c_in(c4), .sum_out(product[2]), .c_out(c8));
    comb_arr_multplr_block b10(.a(a[1]), .b(b[2]), .sum_in(s5), .c_in(c5), .sum_out(s7),         .c_out(c9));
    comb_arr_multplr_block b11(.a(a[2]), .b(b[2]), .sum_in(s6), .c_in(c6), .sum_out(s8),         .c_out(c10));
    comb_arr_multplr_block b12(.a(a[3]), .b(b[2]), .sum_in(0),  .c_in(c7), .sum_out(s9),         .c_out(c11));
    
    comb_arr_multplr_block b13(.a(a[0]), .b(b[3]), .sum_in(s7), .c_in(c8), .sum_out(product[3]), .c_out(c12));
    comb_arr_multplr_block b14(.a(a[1]), .b(b[3]), .sum_in(s8), .c_in(c9), .sum_out(s10),        .c_out(c13));
    comb_arr_multplr_block b15(.a(a[2]), .b(b[3]), .sum_in(s9), .c_in(c10), .sum_out(s11),       .c_out(c14));
    comb_arr_multplr_block b16(.a(a[3]), .b(b[3]), .sum_in(0),  .c_in(c11), .sum_out(s12),       .c_out(c15));
    
    full_adder fa1(.a(c12), .b(s10), .c_in(0), .sum(product[4]), .c_out(c16));
    full_adder fa2(.a(c13), .b(s11), .c_in(c16), .sum(product[5]), .c_out(c17));
    full_adder fa3(.a(c14), .b(s12), .c_in(c17), .sum(product[6]), .c_out(product[7]));
endmodule