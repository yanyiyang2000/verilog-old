/*******************************************************************************
Vending Machine processes requests from Vending Machine Controller.

Inputs:
    in:     3-bit signal representing amount of money paid
                in[2] - 25 cents (a quarter)
                in[1] - 10 cents (a dime)
                in[0] - 5 cents (a nickel)
                (e.g. 100 represents a quarter is paid)
    
    choice: 4-bit signal representing item selected
                choice[3] - item priced 30 cents
                choice[2] - item priced 25 cents
                choice[1] - item priced 20 cents
                choice[0] - item priced 15 cents

    clk:    1-bit clock signal
    clr:    1-bit clear signal

Outputs:
    item:   4-bit signal controlling 4 LEDs to indicate which item is selected
                item[3] - item priced 30 cents
                item[2] - item priced 25 cents
                item[1] - item priced 20 cents
                item[0] - item priced 15 cents

    total:       8-bit signal representing total amount paid 
    cost_or_ret: 8-bit signal representing cost or amount to return
                    when cost > total, set to cost
                    when cost <= total, set to amount to return
*******************************************************************************/

`timescale 1ns / 1ps

module vending_machine(
    input [2:0] in,
    input [3:0] choice,
    input clk,
    input clr,
    output reg [3:0] item,
    output reg [7:0] total,
    output reg [7:0] cost_or_ret
    );

    parameter [2:0] none    = 3'b000;
    parameter [2:0] nickel  = 3'b001;
    parameter [2:0] dime    = 3'b010;
    parameter [2:0] quarter = 3'b100;
    
    reg clk_en;
    integer count = 0;
    
    // initializes a 1 Hz clock
    // clock enable signal is activated once every 100000000 periods of input clock 
    // (e.g., 100 MHz -> 1 Hz)
    always @(posedge clk) begin
        if (count == 99999999) begin 
            count <= 0;
            clk_en <= 1;
        end 
        else begin
            count <= count + 1;
            clk_en <= 0;
        end
    end
    
    initial begin
        item = 0;
        total = 0;
    end
    
    always @(posedge clk_en) begin
        if (choice == 4'b0001) begin // item priced 15 cents selected
            case (total)
                0 : begin 
                        cost_or_ret <= 15;
                        item <= 4'b0000;
                    end
                5 : begin
                        cost_or_ret <= 15;
                        item <= 4'b0000;
                    end
                10 : begin
                        cost_or_ret <= 15;
                        item <= 4'b0000;
                     end
                
                15 : begin 
                        total <= 0;
                        cost_or_ret <= 0;
                        item <= 4'b0001;
                     end
                
                20 : begin
                        total <= 0;
                        cost_or_ret <= 5;
                        item <= 4'b0001;
                     end
                
                25 : begin
                        total <= 0; 
                        cost_or_ret <= 10;
                        item <= 4'b0001;
                     end
                
                30 : begin
                        total <= 0; 
                        cost_or_ret <= 15;
                        item <= 4'b0001;
                     end
                
                35 : begin 
                        total <= 0; 
                        cost_or_ret <= 20;
                        item <= 4'b0001;
                     end
                default : begin
                            total <= 0; 
                            cost_or_ret <= 20;
                            item <= 4'b0001;
                          end
            endcase
            
            case (in)
                none    : ;
                nickel  : total = total + 5;
                dime    : total = total + 10;
                quarter : total = total + 25;
            endcase
        end
        else if (choice == 4'b0010) begin // item priced 20 cents selected
            case (total)
                0 : begin 
                        cost_or_ret = 20;
                        item = 4'b0000;
                    end
                5 : begin
                        cost_or_ret = 20;
                        item = 4'b0000;
                    end
                10 : begin
                       cost_or_ret = 20;
                       item = 4'b0000;
                     end
                
                15 : begin
                      cost_or_ret = 20;
                      item = 4'b0000;
                     end
                
                20 : begin
                         total = 0;
                         cost_or_ret = 0;
                         item = 4'b0010;
                     end
                
                25 : begin
                         total = 0; 
                         cost_or_ret = 5;
                         item = 4'b0010;
                     end
                
                30 : begin
                         total = 0; 
                         cost_or_ret = 10;
                         item = 4'b0010;
                     end
                
                35 : begin 
                         total = 0; 
                         cost_or_ret = 15;
                         item = 4'b0010;
                     end
                default : begin
                             total = 0; 
                             cost_or_ret = 20;
                             item = 4'b0001;
                          end
            endcase
            
            case (in)
                none    : ;
                nickel  :  total = total + 5;
                dime    :  total = total + 10;
                quarter :  total = total + 25;
            endcase
        end
        else if (choice == 4'b0100) begin // item priced 25 cents selected
            case (total)
                0 : begin 
                         cost_or_ret = 25;
                        item = 4'b0000;
                    end
                5 : begin
                         cost_or_ret = 25;
                         item = 4'b0000;
                    end
                10 : begin
                        cost_or_ret = 25;
                        item = 4'b0000;
                     end
                
                15 : begin
                        cost_or_ret = 25;
                        item = 4'b0000;
                     end
                
                20 : begin
                         cost_or_ret = 25;
                        item = 4'b0000;
                     end
                
                25 : begin
                         total = 0; 
                        cost_or_ret = 0;
                         item = 4'b0100;
                     end
                
                30 : begin
                        total = 0; 
                         cost_or_ret = 5;
                         item = 4'b0100;
                     end
                
                35 : begin 
                        total = 0; 
                         cost_or_ret = 10;
                         item = 4'b0100;
                     end
                default : begin
                             total = 0; 
                             cost_or_ret = 20;
                            item = 4'b0001;
                          end
            endcase
            
            case (in)
                none    : ;
                nickel  : total = total + 5;
                dime    :  total = total + 10;
                quarter :  total = total + 25;
            endcase
        end
        else if (choice == 4'b1000) begin // item priced 30 cents selected
            case (total)
                0 : begin 
                         cost_or_ret = 30;
                         item = 4'b0000;
                    end
                5 : begin
                         cost_or_ret = 30;
                         item = 4'b0000;
                    end
                10 : begin
                        cost_or_ret = 30;
                         item = 4'b0000;
                     end
                
                15 : begin
                         cost_or_ret = 30;
                         item = 4'b0000;
                     end
                
                20 : begin
                        cost_or_ret = 30;
                        item = 4'b0000;
                     end
                
                25 : begin
                         cost_or_ret = 30;
                         item = 4'b0000;
                     end
                
                30 : begin
                         total = 0; 
                         cost_or_ret = 0;
                         item = 4'b1000;
                     end
                
                35 : begin 
                        total = 0; 
                        cost_or_ret = 5;
                       item = 4'b1000;
                     end
                default : begin
                            total = 0; 
                             cost_or_ret = 20;
                            item = 4'b0001;
                          end
            endcase
            
            case (in)
                none    : ;
                nickel  : total = total + 5;
                dime    : total = total + 10;
                quarter : total = total + 25;
            endcase
        end
    end
endmodule