/*******************************************************************************
Half Adder adds two 1-bit binary numbers together and outputs the sum and carry 
out.

Inputs: 
    a:    1-bit addend
    b:    1-bit addend

Outputs:
    sum:   1-bit sum
    c_out: 1-bit carry out
*******************************************************************************/

`timescale 1ns / 1ps

module half_adder(
    input a,
    input b,
    output sum,
    output c_out
    );
    
    xor(sum, a, b);
    and(c_out, a, b);
endmodule