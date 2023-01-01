/*******************************************************************************
Anode Driver can only light up ONE display at a time.

It will turn on all four displays one by one in 1 ms (i.e. frequency is 1 kHz) 
to make it look like all displays are on at the same time.

Inputs:
    clk:    1-bit clock signal
    clk_en: 1-bit clock enabler signal
    clr:    1-bit clear signal

Outputs:
    an:     4-bit anode control signal used to control 4 seven-segment displays
            (0 is on, 1 is off)

            For Digilent BASYS 3 Artix 7 FPGA Trainer Board: 
                - an[3] = AN3 (pin W4) leftmost seven-segment display
                - an[2] = AN2 (pin V4)
                - an[1] = AN1 (pin U4)
                - an[0] = AN0 (pin U2) rightmost seven-segment display

    dspl:   2-bit display select signal (which seven-segment display to turn on)
*******************************************************************************/

`timescale 1ns / 1ps

module anode_driver(
    input clk,
    input clk_en,
    input clr,
    output reg [3:0] an = 4'b0111, // 0 is on, 1 is off
    output reg [1:0] dspl = 2'b00
    );
    
    /***************************************************************************
     There are 3 senarios where 'clr' should be handled:

        1. clr is high before and low after the posedge of clk
            i.e. clk: 0 0 0 1 1 1 0 0 0 ... 
                 clr: 0 1 0 0 0 0 0 0 0 ...

        2. clr is high before and after the posedge of clk
            i.e. clk: 0 0 0 1 1 1 0 0 0 ...
                 clr: 0 0 1 0 1 0 0 0 0 ...

        3. clr is low before and high after the posedge of clk
            i.e. clk: 0 0 0 1 1 1 0 0 0 ...
                 clr: 0 0 0 0 1 0 0 0 0 ...
    ***************************************************************************/
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            dspl = 2'b00;
            an = 4'b0111;
        end
        else if (clk_en) begin
            if (dspl == 3) begin
                dspl = 2'b00;
                an = 4'b0111;
            end
            else begin
                dspl = dspl + 1;

                case(dspl)
                    0       : an = 4'b0111; // turns on leftmost display
                    1       : an = 4'b1011;
                    2       : an = 4'b1101;
                    3       : an = 4'b1110; // turns on rightmost display
                    default : an = 4'bxxxx; // for troubleshooting
                endcase
            end
        end
    end
endmodule