/*******************************************************************************
4-bit Sequential Multiplier Datapath performs various operations based on the 
enable bits and operation bits sent from the controller.

The datapath consists of 4 registers:
    - register A
    - register DEL
    - register SQ
    - register OUT

Inputs:
    clk:        1-bit clock signal
    clr:        1-bit clear signal
    a:          8-bit integer whose square root to be found
    en_a:       enable bit for register A
                    0 - disabled
                    1 - enabled

    en_del:     enable bit for register DEL
                    0 - disabled
                    1 - enabled

    en_sq:      enable bit for register SQ (0 for disabled, 1 for enabled)
                    0 - disabled
                    1 - enabled

    en_out:     enable bit for register OUT
                    0 - disabled
                    1 - enabled
                    
    ld_add:     load-add bit for register DEL and SQ
                    0 - load
                    1 - add

Outputs:
    q_a:   8-bit output of register A
    q_sq:  8-bit output of register SQ
    q_out: 8-bit output of register OUT
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_int_sqrt_finder_datapath(
    input clk,
    input clr,
    input [7:0] a,
    input en_a,
    input en_del,
    input en_sq,
    input en_out,
    input ld_add,
    output reg [7:0] q_a,
    output reg [7:0] q_sq,
    output reg [7:0] q_out
    );
    
    reg [7:0] q_del; // output of register DEL
    
    always @(posedge clk) begin
        if (en_a == 1) begin
            q_a = a;
        end
        
        // register DEL and SQ are synchronous
        if (en_del == 1 && en_sq == 1) begin
            if (ld_add == 0) begin // load op
                q_sq = 1;
                q_del = 3;
            end
            else begin             // add op
                q_sq = q_del + q_sq;
                q_del = q_del + 2;
            end
        end
        
        if (en_out == 1) begin
            q_out = q_del / 2 - 1;
        end
    end
endmodule