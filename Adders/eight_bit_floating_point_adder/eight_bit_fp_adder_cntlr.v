/*******************************************************************************
8-bit Floating Point Adder Controller adds two 8-bit floating point binary 
number together and outputs the sum.

The design adopts controller-datapath pattern where the controller manages the 
overall operation and controls the flow of datapath while the datapath performs
the actual data processing operations such as arithmetic, logic and memory
operations.

Inputs:
    clk:   clock signal
    clr:   clear signal
    start: start signal
    a:     8-bit addend
    b:     8-bit addend

Outputs:
    sum: 8-bit sum
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_fp_adder_cntlr(
    input clk,
    input clr,
    input start,
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum
    );
    
    reg idle = 1;
    reg load = 0;
    reg compare = 0;
    reg add = 0;
    reg normalize = 0;
    
    wire [6:0] a_without_sign;
    wire [6:0] b_without_sign;
    wire sign_gt;
    wire sign_ls;
    wire [1:0] bits;
    
    reg en_a = 0;
    reg en_b = 0;
    
    reg en_sign_gt = 0;
    reg en_exp_gt = 0;
    reg en_mant_gt = 0;
    
    reg en_sign_ls = 0;
    reg en_exp_ls = 0;
    reg en_mant_ls = 0;
    
    reg en_sign_sum = 0;
    reg en_exp_sum = 0;
    reg en_mant_sum = 0;
    
    reg ld_sign_gt = 0;
    reg ld_exp_gt = 0;
    reg ld_mant_gt = 0;
    
    reg ld_sign_ls = 0;
    reg ld_exp_ls = 0;
    reg [1:0] ld_shift_mant_ls = 0;
    
    reg [2:0] add_sub_shift_rnd_mant_sum = 0;
    reg [1:0] ld_add_sub_exp_sum = 0;
    
    
    eight_bit_fp_adder_datapath datapath(.clk(clk), .clr(clr),
                                         .a(a), .b(b),
                                         .a_without_sign(a_without_sign), 
                                         .b_without_sign(b_without_sign),
                                         .en_a(en_a), .en_b(en_b),
                                         .en_sign_gt(en_sign_gt), 
                                         .en_exp_gt(en_exp_gt), 
                                         .en_mant_gt(en_mant_gt),
                                         .en_sign_ls(en_sign_ls), 
                                         .en_exp_ls(en_exp_ls), 
                                         .en_mant_ls(en_mant_ls),
                                         .en_sign_sum(en_sign_sum), 
                                         .en_exp_sum(en_exp_sum), 
                                         .en_mant_sum(en_mant_sum),
                                         .ld_sign_gt(ld_sign_gt), 
                                         .ld_exp_gt(ld_exp_gt), 
                                         .ld_mant_gt(ld_mant_gt),
                                         .ld_sign_ls(ld_sign_ls), 
                                         .ld_exp_ls(ld_exp_ls), 
                                         .ld_shift_mant_ls(ld_shift_mant_ls),
                                         .add_sub_shift_rnd_mant_sum(add_sub_shift_rnd_mant_sum), 
                                         .ld_add_sub_exp_sum(ld_add_sub_exp_sum),
                                         .sign_gt(sign_gt), 
                                         .sign_ls(sign_ls), .bits(bits),
                                         .sum(sum));
                       
    always @(negedge clk) begin
        if (start) begin
            load = 1;
            idle = 0;
        end
        
        if (!idle) begin
            if (load) begin
                en_a = 1;
                en_b = 1;
                
                load = 0;
                compare = 1;
            end
            
            else if (compare) begin
                en_a = 0;
                en_b = 0;
                
                en_sign_gt = 1;
                en_exp_gt = 1;
                en_mant_gt = 1;
                en_sign_ls = 1;
                en_exp_ls = 1;
                en_mant_ls = 1;
                
                if (a_without_sign > b_without_sign) begin
                    ld_sign_gt = 0;  // load a
                    ld_exp_gt = 0;
                    ld_mant_gt = 0;
                    ld_sign_ls = 1;  // load b
                    ld_exp_ls = 1;
                    ld_shift_mant_ls = 1;
                end
                else begin
                    ld_sign_gt = 1;  // load b
                    ld_exp_gt = 1;
                    ld_mant_gt = 1;
                    ld_sign_ls = 0;  // load a
                    ld_exp_ls = 0;
                    ld_shift_mant_ls = 0;
                end
                
                compare = 0;
                add = 1;
            end
            
            else if (add) begin
                en_sign_gt = 0;
                en_exp_gt = 0;
                en_mant_gt = 0;
                en_sign_ls = 0;
                en_exp_ls = 0;
                
                en_sign_sum = 1;
                en_exp_sum = 1;
                en_mant_sum = 1;
                
                ld_add_sub_exp_sum = 0;             // load op
                ld_shift_mant_ls = 2;               // shift op
                
                if (sign_gt == sign_ls) begin
                    add_sub_shift_rnd_mant_sum = 0; // add op
                end
                else begin
                    add_sub_shift_rnd_mant_sum = 1; // subtract op
                end
                
                add = 0;
                normalize = 1;
            end
            
            else if (normalize) begin
                en_mant_ls = 0;
                en_sign_sum = 0;
                
                if (bits == 2'b00) begin
                    add_sub_shift_rnd_mant_sum = 2;       // shift left op
                    ld_add_sub_exp_sum = 2;               // subtract op
                end
                else if (bits == 2'b10 || bits == 2'b11) begin
                    add_sub_shift_rnd_mant_sum = 3;      // shift right op
                    ld_add_sub_exp_sum = 1;              // add op
                end
                else if (bits == 2'b01) begin
                    en_exp_sum = 0;
                        
                    if (sum[0] == 1'b1) begin
                        add_sub_shift_rnd_mant_sum = 4;  // round op
                    end
                    else begin                           // calculation is done
                        en_mant_sum = 0;
                        normalize = 0;
                        idle = 1;
                    end
                end
            end
        end
    end
endmodule