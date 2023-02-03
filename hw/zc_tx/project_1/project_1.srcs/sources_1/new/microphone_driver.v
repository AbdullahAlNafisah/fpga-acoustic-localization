// Company: Digilent Inc.
// Engineer: Tudor Roxana-Ioana
// 
// Create Date: 19/07/2021 
// Design Name: XADCdemo
// Module Name: XADCdemo 
// Target Devices: Nexys-A7-100T
// Tool Versions: Vivado 2021.1
// Description: Top level design for reading and interpreting values from the XADC Pmod port of Nexys FPGA
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//MIT License

//Copyright (c) 2017 Digilent

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//////////////////////////////////////////////////////////////////////////////////
//
// Purpose: This project is a Vivado demo used for reading voltage levels between 0 and 1 Volt are read of the JXADC header
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module microphone_driver(
    input CLK100MHZ,
    input [15:0] data,
    input ready,
    output [11:0] data_reg,
    output fifo_wr,
//    input data_ready,
//    output data_valid,
    output reg [15:0] LED,
    output [7:0] an,
    output dp,
    output [6:0] seg
);

    reg [32:0] decimal;
    reg [11:0] decimal_reg_in;
    reg [3:0] dig0;
    reg [3:0] dig1;
    reg [3:0] dig2;
    reg [3:0] dig3;
    reg [3:0] dig4;
    reg [3:0] dig5;
    reg [3:0] dig6;
    parameter COUNTER_WIDTH = 32;
    reg [COUNTER_WIDTH-1:0] count = {COUNTER_WIDTH{1'b0}};


    assign data_reg = data[15:4];
    assign fifo_wr = ready;
//    assign data_valid = data_ready;
    
    //Process for counter that creates a period of 10ms ( f =100MHz /10000000  T = 1/f) until my data is computed
    always @(posedge(CLK100MHZ))
    begin
        if (count == 10000000)
            count <= {COUNTER_WIDTH{1'b0}};
        else
            count <= count + 1'b1;
    end

    // Led visual DMM             
    always @( posedge(CLK100MHZ))
    begin
        if(ready == 1'b1) // When ready is active high this means that data is ready for output
        begin
            case (data[15:12])
                1:  LED <= 16'b11;
                2:  LED <= 16'b111;
                3:  LED <= 16'b1111;
                4:  LED <= 16'b11111;
                5:  LED <= 16'b111111;
                6:  LED <= 16'b1111111;
                7:  LED <= 16'b11111111;
                8:  LED <= 16'b111111111;
                9:  LED <= 16'b1111111111;
                10: LED <= 16'b11111111111;
                11: LED <= 16'b111111111111;
                12: LED <= 16'b1111111111111;
                13: LED <= 16'b11111111111111;
                14: LED <= 16'b111111111111111;
                15: LED <= 16'b1111111111111111;
                default: LED <= 16'b1;
            endcase
        end
    end

    // Process for data input register
    always @(posedge (CLK100MHZ))
    begin
        if(count == 10000000)
            decimal_reg_in <= data >> 4;    // The 12 bit data is stored in a register ( to provide the optimization f the multycycle desgin)
    end

    // Process for binary to decimal conversion
    always @ (posedge(CLK100MHZ))
    begin
        if(count == 10000000) begin
            if(decimal_reg_in >= 4093)      // Looks nicer if our max value is 1V instead of .999755
                begin
                    dig0 <= 0;
                    dig1 <= 0;
                    dig2 <= 0;
                    dig3 <= 0;
                    dig4 <= 0;
                    dig5 <= 0;
                    dig6 <= 1;
                end

            else
                begin

                    decimal = decimal_reg_in * 250000;  // The decimal variable is equal to the multiplication of the value stored in register with 250000.
                    decimal = decimal >> 10;            // ADC has an offset of +10 LSBs. In Unipolar mode : The designed code transitions occur at successive integer LSB. The LSB size in volts is equal to  1V/2^12 or 250000/2^10 = 244 ?V 

                    dig0 <= decimal % 10;               //  Take the last digit of the decimal value and store it in register dig0
                    decimal = decimal / 10;             //  Divide the decimal value by 10 to work on the other digits

                    dig1 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig1
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                    dig2 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig2
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                    dig3 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig3
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                    dig4 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig4
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                    dig5 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig5
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                    dig6 <= decimal % 10;               // Take the last digit of the decimal value and store it in register dig6
                    decimal = decimal / 10;             // Divide the decimal value by 10 to work on the other digits

                end // if(decimal >= 4093)
        end // if(count == 10000000)
    end

    DigitToSeg segment1(
        .in1(dig0),         // Value of register dig0 that goes to the 1st digit cell of the seven segment display 1
        .in2(dig1),         // Value of register dig1 that goes to the 2nd digit cell of the seven segment display 1
        .in3(dig2),         // Value of register dig2 that goes to the 3rd digit cell of the seven segment display 1
        .in4(dig3),         // Value of register dig3 that goes to the 4th digit cell of the seven segment display 1
        .in5(dig4),         // Value of register dig4 that goes to the 1st digit cell of the seven segment display 2
        .in6(dig5),         // Value of register dig5 that goes to the 2nd digit cell of the seven segment display 2
        .in7(dig6),         // Value of register dig6 that goes to the 3rd digit cell of the seven segment display 2
        .in8(),
        .mclk(CLK100MHZ),   // System clock of 100Mhz
        .an(an),            // Anode register to select a particular anode
        .dp(dp),            // Decimal point 
        .seg(seg));         // Segment register 

endmodule
