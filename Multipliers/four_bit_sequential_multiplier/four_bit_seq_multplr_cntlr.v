/*******************************************************************************
4-bit Sequential Multiplier Controller multiplies two 4-bit binary numbers and 
outputs the product.

The design adopts controller-datapath pattern where the controller manages the 
overall operation and controls the flow of datapath while the datapath performs
the actual data processing operations such as arithmetic, logic and memory
operations.

There are 4 major states:
    1. idle  - when there is no calculation task or the calculation is done
    2. start - when push button associated with start is pressed, marking the 
               start of a new calculation
    3. load  - in this stage, data will be loaded into registers
    4. add   - in this stage, registers will perform operations including 
               addition and shift

Inputs:
    a:     4-bit multiplier. should be assigned to switches
    b:     4-bit multiplicand, should be assigned to switches
    clk:   1-bit clock signal
    clr:   1-bit clear signal, should be assigned to a push button
    start: 1-bit start signal indicating the start of multiplication, should be 
           assigned to a push button

Outputs:
    product: 8-bit product
*******************************************************************************/

`timescale 1ns / 1ps

module four_bit_seq_multplr_cntlr(
    input [3:0] a,
    input [3:0] b,
    input clk,
    input clr,
    input start,
    output [7:0] product
    );

    reg idle = 1;   // idle bit
    reg load = 0;   // load bit
    reg add = 1;    // add bit
    reg en_a;       // register A enable bit (0 for disabled, 1 for enabled)
    reg ld_shift_a; // load-shift bit for register A (0 for load, 1 for shift)
    reg en_b;       // register B enable bit (0 for disabled, 1 for enabled)
    reg ld_shift_b; // load-shift bit for register B (0 for load, 1 for shift)
    reg en_p;       // register P enable bit (0 for disabled, 1 for enabled)
    reg ld_add_p;   // load-add bit for register P (0 for load, 1 for add)
    wire [3:0] q_b; // output of register B 
    wire lsb_b;     // least significant bit (LSB) of the multiplicand ('b')
    
    four_bit_seq_multplr_datapath datapath(.clk(clk), .clr(clr), .a(a), .b(b),
                                           .en_a(en_a), .ld_shift_a(ld_shift_a),
                                           .en_b(en_b), .ld_shift_b(ld_shift_b),
                                           .en_p(en_p), .ld_add_p(ld_add_p),
                                           .q_b(q_b), .lsb_b(lsb_b), 
                                           .q_p(product));
    
    always @(negedge clk) begin
        if (start) begin
            idle = 0;
            load = 1;
        end
        
        if (!idle) begin
            if (load) begin
                // enables all registers
                en_a = 1;
                en_b = 1;
                en_p = 1;
                // switches all registers to load op
                ld_shift_a = 0;
                ld_shift_b = 0;
                ld_add_p   = 0;
                // ends load state after finish loading
                load = 0;
            end else begin
                /**
                 * calculation is done, sets state to idle and disables all 
                 * registers
                 */
                if (q_b == 0) begin 
                    idle = 1;
                    en_a = 0;
                    en_b = 0;
                    en_p = 0;
                end else begin
                    if (lsb_b == 1) begin
                        /**
                         * if LSB of multiplicand is 1, add op will be executed 
                         * before shift ops (these two ops will be executed in 2 
                         * different clock cycles)
                         *
                         * before executing add op, disables register A and B
                         * disables add op after it is executed
                         * before executing shift ops, enables register A and B
                         * enables add op after shift ops are executed
                         */
                        if (add) begin
                            en_a = 0;
                            en_b = 0;
                            en_p = 1;
                            ld_add_p = 1; // switches register P to add op
                            add = 0;
                        end else begin
                            en_a = 1;
                            en_b = 1;
                            en_p = 0;
                            ld_shift_a = 1; // switches register A to shift op
                            ld_shift_b = 1; // switches register B to shift op
                            add = 1;        
                        end
                    end else if (lsb_b == 0) begin
                        en_a = 1;
                        en_b = 1;
                        en_p = 0;
                        ld_shift_a = 1; 
                        ld_shift_b = 1;
                    end
                end
            end            
        end
    end
endmodule