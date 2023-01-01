/*******************************************************************************
8-bit Floating Point Adder Datapath performs various operations based on the 
enable bits and operation bits sent from the controller.

The datapath consists of 11 registers:
    - register A_WITHOUT_SIGN
    - register B_WITHOUT_SIGN
    - register SIGN_GT
    - register EXPONENT_GT
    - register MANTISSA_GT
    - register SIGN_LS
    - register EXPONENT_LS
    - register MANTISSA_LS
    - register SIGN_SUM
    - register EXPONENT_SUM
    - register MANTISSA_SUM

Inputs:
    clk:         1-bit clock signal
    clr:         1-bit clear signal
    a:           8-bit floating point addend
    b:           8-bit floating point addend
    
    en_a:        enable bit for register A
                    0 - disabled
                    1 - enabled

    en_b:        enable bit for register B
                    0 - disabled
                    1 - enabled

    en_sign_gt:  enable bit for register SIGN_GT
                    0 - disabled
                    1 - enabled

    en_exp_gt:   enable bit for register EXPONENT_GT
                    0 - disabled
                    1 - enabled

    en_mant_gt:  enable bit for register MANTISSA_GT
                    0 - disabled
                    1 - enabled

    en_sign_ls:  enable bit for register SIGN_LS
                    0 - disabled
                    1 - enabled

    en_exp_ls:   enable bit for register EXPONENT_LS
                    0 - disabled
                    1 - enabled

    en_mant_ls:  enable bit for register MANTISSA_LS
                    0 - disabled
                    1 - enabled

    en_sign_sum: enable bit for register SIGN_SUM
                    0 - disabled
                    1 - enabled

    en_exp_sum:  enable bit for register EXPONENT_SUM
                    0 - disabled
                    1 - enabled

    en_mant_sum: enable bit for register MANTISSA_SUM
                    0 - disabled
                    1 - enabled

    ld_sign_gt:                 operation bit for register SIGN_GT
                                    0 - load exponent of a
                                    1 - load exponent of b

    ld_exp_gt:                  operation bit for register EXPONENT_GT
                                    0 - load exponent of a
                                    1 - load exponent of b

    ld_mant_gt:                 operation bit for register MANTISSA_GT
                                    0 - load mantissa of a
                                    1 - load mantissa of b
                                    
    ld_sign_ls:                 operation bit for register SIGN_LS
                                    0 - load sign of a
                                    1 - load sign of b

    ld_exp_ls:                  operation bit for register EXPONENT_LS
                                    0 - load exponent of a
                                    1 - load exponent of b
                                    
    ld_shift_mant_ls:           operation bits for register MANTISSA_LS
                                    0 - load mantissa of a
                                    1 - load mantissa of b
                                    2 - shift right

    ld_add_sub_exp_sum:         operation bits for register EXPONENT_SUM
                                    0 - load
                                    1 - add
                                    2 - subtract
     
    add_sub_shift_rnd_mant_sum: operation bits for register MANT_SUM
                                    0 - add 
                                    1 - subtract
                                    2 - shift left
                                    3 - shift right
                                    4 - round up

Outputs:
    a_without_sign: addend 'a' without sign
    b_without_sign: addend 'b' without sign
    sign_gt:        sign bit of the smaller addend
    sign_ls:        sign bit of the greater addend
    bits:           upper 2 bits of the mantissa of sum
    sum:            sum of the addends 'a' and 'b'
*******************************************************************************/

`timescale 1ns / 1ps

module eight_bit_fp_adder_datapath(
    input clk,
    input clr,
    input [7:0] a,
    input [7:0] b,
    
    input en_a,
    input en_b,
    
    input en_sign_gt,
    input en_exp_gt,
    input en_mant_gt,
    
    input en_sign_ls,
    input en_exp_ls,
    input en_mant_ls,
    
    input en_sign_sum,
    input en_exp_sum,
    input en_mant_sum,
    
    input ld_sign_gt,
    input ld_exp_gt,
    input ld_mant_gt,
    
    input ld_sign_ls,
    input ld_exp_ls,     
    input [1:0] ld_shift_mant_ls,
    
    input [1:0] ld_add_sub_exp_sum,
    input [2:0] add_sub_shift_rnd_mant_sum,
    
    output reg [6:0] a_without_sign,
    output reg [6:0] b_without_sign,
    output reg sign_gt,
    output reg sign_ls,
    output reg [1:0] bits,
    output reg [7:0] sum
    );
    
    reg [3:0] exponent_gt;
    reg [4:0] mantissa_gt;
    
    reg [3:0] exponent_ls;
    reg [4:0] mantissa_ls;
    
    reg sign_sum;
    reg [3:0] exponent_sum;
    reg [4:0] mantissa_sum;
    
    always @(posedge clk) begin
        if (clr) begin
            a_without_sign = 7'bX;
            b_without_sign = 7'bX;
            sign_gt = 1'bX;
            sign_ls = 1'bX;
            bits = 2'bX;
            sum = 8'bX;
            
            exponent_gt = 4'bX;
            mantissa_gt = 5'bX;
            exponent_ls = 4'bX;
            mantissa_ls = 5'bX;
            
            sign_sum = 1'bX;
            exponent_sum = 4'bX;
            mantissa_sum = 5'bX;
        end
    
        if (en_a == 1) begin
            a_without_sign = a[6:0];
        end
        
        if (en_b == 1) begin
            b_without_sign = b[6:0];
        end
        
        if (en_sign_gt) begin
            if (ld_sign_gt == 0) begin // load a
                sign_gt = a[7];
            end
            else begin                 // load b
                sign_gt = b[7];
            end
        end
        
        if (en_exp_gt) begin
            if (ld_exp_gt == 0) begin // load a
                exponent_gt = a[6:3];
            end
            else begin                // load b
                exponent_gt = b[6:3];
            end
        end
        
        if (en_mant_gt) begin
            if (ld_mant_gt == 0) begin  // load a
                mantissa_gt = {2'b01, a[2:0]};
            end
            else begin                 // load b
                mantissa_gt = {2'b01, b[2:0]};
            end
        end
        
        if (en_sign_ls) begin
            if (ld_sign_ls == 0) begin // load a
                sign_ls = a[7];
            end
            else begin                 // load b
                sign_ls = b[7];
            end 
        end
        
        if (en_exp_ls) begin
            if (ld_exp_ls == 0) begin  // load a
                exponent_ls = a[6:3];
            end 
            else begin                 // load b
                exponent_ls = b[6:3];
            end
        end
       
        if (en_mant_ls) begin
            if (ld_shift_mant_ls == 0) begin      // load a
                mantissa_ls = {2'b01, a[2:0]};
            end
            else if (ld_shift_mant_ls == 1) begin // load a
                mantissa_ls = {2'b01, b[2:0]};
            end
            else if (ld_shift_mant_ls == 2) begin // shift op
                mantissa_ls = mantissa_ls >> (exponent_gt - exponent_ls);
            end
            
            // rounds mantissa_ls if its LSB is 1
            if (mantissa_ls[0] == 1'b1) begin
                mantissa_ls = mantissa_ls + 1;
            end
        end    
        
        if (en_mant_sum) begin
            if (add_sub_shift_rnd_mant_sum == 0) begin       // add op
                mantissa_sum = mantissa_gt + mantissa_ls;
            end
            else if (add_sub_shift_rnd_mant_sum == 1) begin  // subtract op
                mantissa_sum = mantissa_gt - mantissa_ls;
            end
            else if (add_sub_shift_rnd_mant_sum == 2) begin  // shift left op
                mantissa_sum = mantissa_sum << 1;
            end
            else if (add_sub_shift_rnd_mant_sum == 3) begin  // shift right op
                mantissa_sum = mantissa_sum >> 1;
            end
            else if (add_sub_shift_rnd_mant_sum == 4) begin  // round op
                mantissa_sum = mantissa_sum + 1;
            end
        end
        
        if (en_exp_sum) begin
            if (ld_add_sub_exp_sum == 0) begin       // load op
                exponent_sum = exponent_gt;
            end
            else if (ld_add_sub_exp_sum == 1) begin  // add op
                exponent_sum = exponent_sum + 1;
            end
            else if (ld_add_sub_exp_sum == 2) begin  // sub op
                exponent_sum = exponent_sum - 1;
            end
        end
        
        if (en_sign_sum) begin
            sign_sum = sign_gt;
        end
        
        bits = mantissa_sum[4:3];
        sum = {sign_sum, exponent_sum, mantissa_sum[2:0]};
    end
endmodule