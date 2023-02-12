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

module microphone_driver #(
    parameter integer clk_freq = 100_000_000
)(
    input CLK100MHZ,
    input nrst,
    input [15:0] data,
    input drdy_out,
    input wr_ack,
    input full,
    output reg wr_en,
    output reg fifo_rst,
    output [11:0] data_reg,
//    input data_ready,
//    output data_valid,
    output reg pwm_en,
    output reg [15:0] LED
);
    
    parameter states_depth = 1;
    reg [states_depth-1:0] rx_st = 0, rx_nst = 0;
//    reg [states_depth-1:0] tx_st = 0, tx_nst = 0;
    // States
    localparam [states_depth-1:0]
        idle = 0,
        fifo_wr = 1;
//        fifo_rd = 2,
//        uart_send = 3;

    localparam  fifo_rst_delay = clk_freq/1000; // 1ms delay
    
    
    // Registers
    reg prev_drdy_out = 0;
    reg data_rdy = 0;
    reg [31:0] cnt = 0;
    
    // Led visual DMM             
    always @( posedge(CLK100MHZ))
    begin
        if(drdy_out == 1'b1) // When ready is active high this means that data is ready for output
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
    
    // State Register
    always@(posedge CLK100MHZ)
    begin
        if (~nrst)
        begin
            rx_st <= idle;
            data_rdy <= 1'b0;
            fifo_rst <= 1'b1;
            pwm_en <= 1'b0;
            cnt <= 0;
//            tx_st <= idle;
//            prev_rx_busy <= 1'b0;
        end else
        begin
            rx_st <= rx_nst;
            prev_drdy_out <= drdy_out;
            fifo_rst <= 1'b0;
            pwm_en <= 1'b0;
            data_rdy <= 1'b0;
            
            
            
            
            
            if (cnt < 10) begin
                fifo_rst <= 1'b1;
                cnt <= cnt +1;
            end
            else if (cnt < fifo_rst_delay) begin
                cnt <= cnt +1;
            end
            else begin
                pwm_en <= 1'b1;
                cnt <= fifo_rst_delay;
            end
            
            
            
            
            
            if ((prev_drdy_out) && (~drdy_out) && (pwm_en))
                data_rdy <= 1'b1;
                
//            tx_st <= tx_nst;
        end
    end
    
    // Next State Logic
    always@(*)
    begin
        rx_nst <= rx_st;
//        tx_nst <= tx_st;
        case(rx_st)
            idle: 
                if(data_rdy) rx_nst <= fifo_wr;
            fifo_wr: 
                if(wr_ack) rx_nst <= idle;
            default:
                rx_nst <= idle;
        endcase
//        case(tx_st)
//            idle: 
//                if((~empty) && (~rd_rst_busy) && (~tx_busy)) tx_nst <= fifo_rd;
//            fifo_rd: 
//                if(valid) tx_nst <= uart_send;
//            uart_send:
//                if(tx_busy) tx_nst <= idle;
//            default:
//                tx_nst <= idle;
//        endcase
    end
    
    // Output Logic
    always@(*)
    begin
        wr_en <= 1'b0;
//        rd_en <= 1'b0;
//        tx_ena = 1'b0;
        case(rx_st)
            idle: begin
            
            end
            
            fifo_wr: begin
                if (~full)
                    wr_en <= 1'b1;
            end
            
            default: begin
                
            end
            
        endcase
//        case(tx_st)
//            idle:;
//            fifo_rd:
//                rd_en <= 1'b1;
//            uart_send:
//                if(~tx_busy) tx_ena = 1'b1;
//            default:;
//        endcase
    end
    
    assign data_reg = data[15:4];
    
endmodule
