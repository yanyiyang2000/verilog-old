// Testbench for 4-bit Carry Lookahead Adder Display.

`timescale 1ns / 1ps

module four_bit_carry_lookahead_adder_display_tb(
    );
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg clr = 0;
    wire [3:0] an;
    wire [6:0] ca;
    
    // initializes Unit Under Test (UUT)
    four_bit_carry_lookahead_adder_display UUT(.a(a), .b(b), .clk(clk), .clr(clr), .an(an), .ca(ca));
    
    // initializes a 100 MHz clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end
    
    always begin
        a = 4'b0000;
        b = 4'b0000;
        #4000000;
        
        a = 4'b0001;
        b = 4'b0010;
        #4000000;
        
        a = 4'b0011;
        b = 4'b0011;
        #4000000;
        
        a = 4'b1111;
        b = 4'b0001;
        #4000000;
    end
endmodule