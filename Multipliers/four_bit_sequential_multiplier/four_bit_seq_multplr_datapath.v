/*******************************************************************************
4-bit Sequential Multiplier Datapath performs various operations based on the 
enable bits and operation bits sent from the controller.

Inputs:
    clk:        1-bit clock signal
    clr:        1-bit clear signal
    a:          4-bit multiplier
    b:          4-bit multiplicand
    en_a:       register A enable bit (0 for disabled, 1 for enabled)
    ld_shift_a: load-shift bit for register A (0 for load, 1 for shift)
    en_b:       register B enable bit (0 for disabled, 1 for enabled)
    ld_shift_b: load-shift bit for register B (0 for load, 1 for shift)
    en_p:       register P enable bit (0 for disabled, 1 for enabled)
    ld_add_p:   load-add bit for register P (0 for load, 1 for add)

Outputs:
    q_b:   4-bit output of register B
    lsb_b: least significant bit (LSB) of multiplicand ('b')
    q_p:   8-bit output of register P, represents the product
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_seq_multplr_datapath(
    input clk,
    input clr,
    input [3:0] a,
    input [3:0] b,
    input en_a,
    input ld_shift_a,
    input en_b,
    input ld_shift_b,
    input en_p,
    input ld_add_p,
    output reg [3:0] q_b,
    output reg lsb_b,
    output reg [7:0] q_p 
    );
    
    reg [7:0] q_a; // output of register A
    
    always @(posedge clk) begin
        if (en_a == 1) begin
            if (ld_shift_a == 1) begin // shift op
                q_a = q_a << 1;
            end 
            else begin                // load op
                q_a = multiplier;     // loads multiplier into register A
            end
        end
        
        if (en_b == 1) begin
            if (ld_shift_b == 1) begin // shift op
                q_b = q_b >> 1;
            end
            else begin                 // load op
                q_b = multiplicand;    // loads multiplicand into register B
            end
            
            lsb_b = q_b[0];
        end
        
        if (en_p == 1) begin
            if (ld_add_p == 1) begin // add op
                q_p = q_a + q_p;
            end
            else begin               // load op
                q_p = 0;
            end
        end 
    end
    
    always @(posedge clr) begin
        q_a = 0;
        q_b = 0;
        q_p = 0;
    end
endmodule