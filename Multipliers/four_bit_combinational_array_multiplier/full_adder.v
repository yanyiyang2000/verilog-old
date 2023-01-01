/*******************************************************************************
Full Adder adds two 1-bit binary numbers and carry in together and outputs the 
sum and carry out.

Inputs: 
    a:    1-bit addend
    b:    1-bit addend
    c_in: 1-bit carry in

Outputs:
    sum:   1-bit sum
    c_out: 1-bit carry out
*******************************************************************************/

`timescale 1ns / 1ps

module full_adder(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
    );

    wire s1, c1, c2;
    
    half_adder ha1 (.a(a), .b(b), .sum(s1), .c_out(c1));
    half_adder ha2 (.a(s1), .b(c_in), .sum(sum), .c_out(c2));
    
    or (c_out, c1, c2);
endmodule