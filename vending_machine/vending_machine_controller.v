/*******************************************************************************
Vending Machine Controller processes user request and displays:
    - total amount paid on the two LEFTMOST seven-segment displays
    - cost or amount to be returned on the two RIGHTMOST seven-segment displays.
    - item selected by turning on respective LED when payment is done

This design adopts the Finite State Machine (FSM) design pattern.

Inputs:
    in:     3-bit signal representing amount paid
                in[2] - 25 cents (a quarter)
                in[1] - 10 cents (a dime)
                in[0] - 5 cents (a nickel)
                (e.g. 100 represents a quarter is paid)
    
    choice: 4-bit signal representing item selected
                choice[3] - item priced 30 cents
                choice[2] - item priced 25 cents
                choice[1] - item priced 20 cents
                choice[0] - item priced 15 cents

    clk:    1-bit clock signal
    clr:    1-bit clear signal

Outputs:
    item:   4-bit signal controlling 4 LEDs indicating payment is done for a 
            specific item
                item[3] - item priced 30 cents
                item[2] - item priced 25 cents
                item[1] - item priced 20 cents
                item[0] - item priced 15 cents

    an:     4-bit anode control signal (which seven-segment display to turn on)
    ca:     7-bit cathode control signal (which decimal number to display)
*******************************************************************************/

`timescale 1ns / 1ps

module vending_machine_controller(
    input [2:0] in,
    input [3:0] choice,
    input clk,
    input clr,
    output [3:0] item,
    output [3:0] an,
    output [6:0] ca
    );
    
    wire [7:0] total;       // total amount paid
    wire [7:0] cost_or_ret; // cost or amount to be returned 
    
    vending_machine machine(.in(in), .choice(choice), 
                            .clk(clk), .clr(clr), 
                            .item(item), .total(total),
                            .cost_or_ret(cost_or_ret));
    
    four_dig_svn_seg_display display(.clk(clk), .clr(clr), 
                                     .dig1(total[7:4]), 
                                     .dig2(total[3:0]), 
                                     .dig3(cost_or_ret[7:4]), 
                                     .dig4(cost_or_ret[3:0]), 
                                     .an(an), .ca(ca));
endmodule