/*******************************************************************************
8-bit Floating Point Adder Display displays two 8-bit floating point numbers and
the sum in hexadecimal form on a 4-digit Seven-segment Display.

When 'show_sum' signal is 1:
    - 0 will be displayed on the two seven-segment displays on the LEFT
    - sum will be displayed on the two seven-segment displays on the RIGHT

When 'show_sum' signal is 0:
    - Addend 'a' will be displayed on the two seven-segment displays on the LEFT
    - Addend 'b' will be displayed on the two seven-segment displays on the 
      RIGHT
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_fp_adder_display(
    input clk,       // clock signal
    input clr,       // clear signal, to be assigned to a push button
    input start,     // start signal, to be assigned to a push button
    input show_sum,  // show sum signal, to be assigned to a push button
    input [7:0] a,   // 8-bit addend
    input [7:0] b,   // 8-bit addend
    output [3:0] an, // 4-bit anode control signal (which seven-segment display 
                     // to turn on)
    output [6:0] ca  // 7-bit cathode control signal (which decimal number to 
                     // display)
    );
    
    wire [7:0] sum;
    reg [3:0] dig1;  // number to be displayed on the leftmost display
    reg [3:0] dig2;
    reg [3:0] dig3;
    reg [3:0] dig4;  // number to be displayed on the rightmost display
    
    // initializes an 8-bit Floating Point Adder Controller
    eight_bit_fp_adder_cntlr cntlr(.clk(clk), .clr(clr), .start(start), 
                                   .a(a), .b(b), .sum(sum));
    
    // initializes a 4-digit Seven-segment Display
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(dig1), .dig2(dig2), 
                                     .dig3(dig3), .dig4(dig4),
                                     .an(an), .ca(ca));
    
    always @* begin                    
        if (show_sum) begin
            dig1 = 4'b0000;
            dig2 = 4'b0000;
            dig3 = sum[7:4];
            dig4 = sum[3:0];
        end
        else begin
            dig1 = a[7:4];
            dig2 = a[3:0];
            dig3 = b[7:4];
            dig4 = b[3:0];
        end
    end
endmodule