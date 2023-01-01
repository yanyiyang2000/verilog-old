// Testbench for Vending Machine.

`timescale 1ns / 1ps

module vending_machine_tb(

    );
    reg [2:0] in;
    reg [3:0] choice;
    reg clk;
    wire clr = 0;
    wire [3:0] item;
    wire [7:0] total;
    wire [7:0] cost_or_ret;
    
    // initializes Unit Under Test
    vending_machine UUT(.in(in), .choice(choice), .clk(clk), .clr(clr), 
                        .item(item), .total(total), .cost_or_ret(cost_or_ret));
    
    // initialzes a 100 MHz clock
    always begin
        clk = 0; #5; 
        clk = 1; #5; 
    end
    
    initial begin
        assign choice = 4'b0001;      // selects item priced 15 cents
        assign in = 3'b001; #1200000; // puts in 5 cents and wait 1.2 ms
        assign in = 3'b000; #1200000; // resets button to 0 and wait 1.2 ms
        assign in = 3'b001; #1200000; // puts in 5 cents and wait 1.2 ms
        assign in = 3'b000; #1200000; // resets button to 0 and wait 1.2 ms
        assign in = 3'b010; #1200000; // puts in 10 cents can wait 1.2 ms
        assign in = 3'b000; #1200000;
    end
endmodule