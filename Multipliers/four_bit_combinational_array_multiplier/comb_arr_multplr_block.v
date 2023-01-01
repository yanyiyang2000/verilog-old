/*******************************************************************************
Combinational Array Multiplier Block is the building block of a Combinational 
Array Multiplier, it adds up four 1-bit inputs and outputs the sum and carry out.

Inputs: 
    a:       1-bit addend
    b:       1-bit addend
    sum_in:  1-bit sum in
    c_in:    1-bit carry in

Outputs:
    sum_out: 1-bit sum out
    c_out:   1-bit carry out
*******************************************************************************/

`timescale 1ns / 1ps

module comb_arr_multplr_block(
    input a,
    input b,
    input sum_in,
    input c_in,
    output sum_out,
    output c_out
    );
    
    full_adder fa(.a(sum_in), .b(a & b), .c_in(c_in), .sum(sum_out), .c_out(c_out));
endmodule