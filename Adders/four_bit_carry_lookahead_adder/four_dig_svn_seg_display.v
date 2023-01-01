/*******************************************************************************
4-digit Seven-segment Display can display up to 4 hexadecimal numbers.

Inputs:
    clk:  1-bit clock signal
    clr:  1-bit clear signal
    dig1: 4-bit binary number to be displayed on the LEFTMOST display
    dig2: 4-bit binary number to be displayed
    dig3: 4-bit binary number to be displayed
    dig4: 4-bit binary number to be displayed on the RIGHTMOST display

Outputs:
    an:   4-bit anode control signal (which seven-segment display to turn on)
    ca:   7-bit cathode control signal (which decimal number to display)
*******************************************************************************/

`timescale 1ns / 1ps

module four_dig_svn_seg_display(
    input clk,
    input clr,
    input [3:0] dig1,
    input [3:0] dig2,
    input [3:0] dig3,
    input [3:0] dig4,
    output [3:0] an, 
    output [6:0] ca
    );

    wire clk_en;
    wire [1:0] dspl; // which seven-segment display to turn on
    reg [3:0] x;     // number to display at certain time
    
    // initializes a Clock Enabler
    clock_enabler enabler(.clk(clk), .clr(clr), .clk_en(clk_en));
    
    // initializes an Anode Driver
    anode_driver driver(.clk(clk), .clk_en(clk_en), .clr(clr), .an(an), .dspl(dspl));
    
    // initializes a Hex-to-seven-segment Decoder
    hex_to_svn_seg_dcdr decoder(.x(x), .ca(ca));
    
    always @* begin
        case (dspl)
            0 : x = dig1; // displays on the leftmost seven-segment display
            1 : x = dig2;
            2 : x = dig3;
            3 : x = dig4; // displays on the rightmost seven-segment display
        endcase
    end
endmodule