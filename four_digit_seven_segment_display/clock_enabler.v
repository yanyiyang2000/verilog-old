/*******************************************************************************
Clock Enabler outputs a lower frequnecy compared to the input frequency.

Inputs:
    clk:    1-bit clock signal with higher frequency to lower
    clr:    1-bit clear signal

Output:
    clk_en: 1-bit clock enabler signal
*******************************************************************************/

`timescale 1ns / 1ps

module clock_enabler(
    input clk, 
    input clr,
    output reg clk_en
    );
    
    integer count = 0;
    
    // Clock Enabler is activated once every 100000 periods of the original 
    // clock signal (i.e. 100 MHz -> 1k Hz)
    always @(posedge clk) begin
        if (clr == 1) begin
            count <= 0;
            clk_en <= 0;
        end
        else if (count == 99999) begin
            count <= 0;
            clk_en <= 1;
        end 
        else begin
            count <= count + 1;
            clk_en <= 0;
        end
    end
endmodule