/*******************************************************************************
Hex-to-seven-segment Decoder converts a 4-bit binary number 'x' into a 
7-bit binary number 'ca'.

'ca' represents the states of 7 cathodes connected to the seven-segment 
display. 0 is on, 1 is off.

For Digilent BASYS 3 Artix 7 FPGA Trainer Board: 
 - ca[6] = CA (pin W7)
 - ca[5] = CB (pin W6)
 - ca[4] = CC (pin U8)
 - ca[3] = CD (pin V8)
 - ca[2] = CE (pin U5) 
 - ca[1] = CF (pin V5)
 - ca[0] = CG (pin U7)

Input:
    x:  4-bit binary (2-bit hexadecimal) number to display

Output:
    ca: 7-bit cathode control signal           
*******************************************************************************/

`timescale 1ns / 1ps

module hex_to_svn_seg_dcdr(
    input [3:0] x,
    output reg [6:0] ca
    );
    
    always @* begin
        case (x)
            0 : ca  = 7'b0000001; // '0'
            1 : ca  = 7'b1001111; // '1'
            2 : ca  = 7'b0010010; // '2'
            3 : ca  = 7'b0000110; // '3'
            4 : ca  = 7'b1001100; // '4'
            5 : ca  = 7'b0100100; // '5'
            6 : ca  = 7'b0100000; // '6'
            7 : ca  = 7'b0001111; // '7'
            8 : ca  = 7'b0000000; // '8'
            9 : ca  = 7'b0000100; // '9'
            10 : ca = 7'b0001000; // 'A'
            11 : ca = 7'b1100000; // 'B'
            12 : ca = 7'b0110001; // 'C'
            13 : ca = 7'b1000010; // 'D'
            14 : ca = 7'b0110000; // 'E'
            15 : ca = 7'b0111000; // 'F'
        endcase
    end
endmodule