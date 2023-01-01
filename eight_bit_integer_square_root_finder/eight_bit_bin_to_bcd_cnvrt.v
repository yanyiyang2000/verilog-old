/*******************************************************************************
8-bit Binary-to-BCD Converter converts an 8-bit binary number into a BDC number.

Inputs:
    bin: 8-bit binary number to be converted

Outputs:
    upper: upper 4 bits of BCD number
    lower: lower 4 bits of BCD number
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_bin_to_bcd_cnvrt(
    input [7:0] bin,
    output reg [3:0] upper,
    output reg [3:0] lower
    );
    
    always @* begin
        upper = 0;
        
        case(bin)
            0 : lower = 0;
            1 : lower = 1;
            2 : lower = 2;
            3 : lower = 3;
            4 : lower = 4;
            5 : lower = 5;
            6 : lower = 6;
            7 : lower = 7;
            8 : lower = 8;
            9 : lower = 9;
            10 : begin
                    upper = 1;
                    lower = 0;
                 end
            11 : begin
                    upper = 1;
                    lower = 1;
                 end
            12 : begin
                    upper = 1;
                    lower = 2;
                 end
            13 : begin
                    upper = 1;
                    lower = 3;
                 end
            14 : begin
                    upper = 1;
                    lower = 4;
                 end
            15 : begin
                    upper = 1;
                    lower = 5;
                 end         
        endcase
    end
endmodule