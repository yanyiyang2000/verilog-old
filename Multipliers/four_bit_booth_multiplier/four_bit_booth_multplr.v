/*******************************************************************************
4-bit Booth Multiplier multiplies two 4-bit signed binary numbers and outputs 
the product.

The multiplier adopts the Booth algorithm.

Inputs: 
    a:       4-bit multiplier
    b:       4-bit multiplicand

Outputs:
    product: 8-bit product
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_booth_multplr(
    input signed [3:0] a,
    input signed [3:0] b,
    output reg signed [7:0] product
    );

    reg signed [8:0] aq; // intermediate result
    integer n;           // number of bits
    
    always @* begin
        aq = {4'b0000, b, 1'b0};
        n = 4;          
        
        while (n > 0) begin
            if (aq[1:0] == 2'b10) begin
                /**
                 * subtracts multiplicand from higher 4 bits of intermediate 
                 * result 
                 */
                aq[8:5] = aq[8:5] - a; 
            end
            else if (aq[1:0] == 2'b01) begin
                // adds multiplicand to higher 4 bits of intermediate result
                aq[8:5] = aq[8:5] + a; 
            end
            /**
             * saves the MSB, right shifts all the bits by 1 bit, sets MSB to 
             * the old MSB
             */
            aq = {aq[8], aq[8:1]};  
            n = n - 1;
        end
        
        assign product = aq[8:1];
    end
endmodule