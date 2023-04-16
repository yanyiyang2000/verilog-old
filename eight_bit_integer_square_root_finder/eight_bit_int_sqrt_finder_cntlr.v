/*******************************************************************************
8-bit Integer Square Root Finder Controller generates the square root of the 
input.

The design adopts controller-datapath pattern where the controller manages the 
overall operation and controls the flow of datapath while the datapath performs
the actual data processing operations such as arithmetic, logic and memory
operations.

Inputs:
    clk:   1-bit clock signal
    clr:   1-bit clear signal
    start: 1-bit start signal   
    a:     8-bit integer whose square root to be found

Outputs:
    sqrt: 8-bit square root
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_int_sqrt_finder_cntlr(
    input clk,
    input clr,
    input start,
    input [7:0] a,
    output [7:0] sqrt
    );
    
    reg idle = 1;    // idle state
    reg load = 0;    // load state
    reg add = 1;     // add state
    reg en_a;        // enable bit for register A
    reg en_del;      // enable bit for register DEL
    reg en_sq;       // enable bit for register SQ
    reg en_out;      // enable bit for output
    reg ld_add;      // load/add select bit for register DEL and SQ
    wire [7:0] q_sq; // output of register SQ
    wire [7:0] q_a;  // output of register A
    
    eight_bit_int_sqrt_finder_datapath datapath(.clk(clk), .clr(clr), .a(a), 
                                                .en_a(en_a), .en_del(en_del), 
                                                .en_sq(en_sq), .en_out(en_out), 
                                                .ld_add(ld_add), .q_a(q_a), 
                                                .q_sq(q_sq), .q_out(sqrt));
    
    always @(negedge clk) begin
        if (start) begin
            load = 1;
            idle = 0;
        end
        
        if (!idle) begin
            if (load) begin
                // enables all registers
                en_a = 1;
                en_del = 1;
                en_sq = 1;
                en_out = 1;
                
                // switches DEL and SQ registers to load op
                ld_add = 0;

                // ends load state after finish loading
                load = 0;
            end
            else begin
                // calculation is done, sets state to idle and disables all 
                // registers
                if (q_sq > q_a) begin 
                    idle = 1;
                    en_a = 0;
                    en_del = 0;
                    en_sq = 0;
                    en_out = 0;
                end
                else begin
                    // switches DEL and SQ registers to add op
                    ld_add = 1;
                    en_a = 0;
                end
            end
        end
    end
endmodule
