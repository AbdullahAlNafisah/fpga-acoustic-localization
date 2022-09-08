`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2022 08:44:33 PM
// Design Name: 
// Module Name: Testbench
// Project Name: 
// Target Devices:  
// Tool Versions: 
// Description:   
// 
// Dependencies:  
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Testbench();
 
localparam period = 10;

reg sys_clock;
reg CPU_RESETN;
reg IRQ;   
reg MISO;
reg RX_D_IRQ;
reg RX_D_MISO;
reg RX_S_IRQ;
reg RX_S_MISO;
reg TX_IRQ;
reg TX_MISO;
reg UART_TXD_IN;

wire AUD_PWM;
wire AUD_SD;
wire [7:0] LED;
wire RX_D_CE;
wire RX_D_IRQ_out;
wire RX_D_MOSI;
wire RX_D_SCLK;
wire [0:0]RX_D_SS_N;
wire RX_S_CE;
wire RX_S_IRQ_out;
wire RX_S_MOSI;
wire RX_S_SCLK;
wire [0:0]RX_S_SS_N;
wire TX_CE;
wire TX_IRQ_out;
wire TX_MOSI;
wire TX_SCLK;
wire [0:0]TX_SS_N;
wire UART_RXD_OUT;
wire done;

design_1_wrapper design_1_i
(.AUD_PWM(AUD_PWM),
.AUD_SD(AUD_SD),
.CPU_RESETN(CPU_RESETN),
.LED(LED),
.M_CLK(M_CLK),
.M_DATA(M_DATA),
.M_LRSEL(M_LRSEL),
.RX_D_CE(RX_D_CE),
.RX_D_IRQ(RX_D_IRQ),
.RX_D_IRQ_out(RX_D_IRQ_out),
.RX_D_MISO(RX_D_MISO),
.RX_D_MOSI(RX_D_MOSI),
.RX_D_SCLK(RX_D_SCLK),
.RX_D_SS_N(RX_D_SS_N),
.RX_S_CE(RX_S_CE),
.RX_S_IRQ(RX_S_IRQ),
.RX_S_IRQ_out(RX_S_IRQ_out),
.RX_S_MISO(RX_S_MISO),
.RX_S_MOSI(RX_S_MOSI),
.RX_S_SCLK(RX_S_SCLK),
.RX_S_SS_N(RX_S_SS_N),  
.TX_CE(TX_CE),
.TX_CE_out(TX_CE_out),
.TX_IRQ(TX_IRQ),
.TX_IRQ_out(TX_IRQ_out),
.TX_MISO(TX_MISO),
.TX_MOSI(TX_MOSI),
.TX_SCLK(TX_SCLK),
.TX_SS_N(TX_SS_N),
.UART_RXD_OUT(UART_RXD_OUT),
.UART_TXD_IN(UART_TXD_IN),
.sys_clock(sys_clock));

initial sys_clock = 0;
always #(period/2) sys_clock = ~sys_clock;
always begin
    CPU_RESETN = 1'b0;
    #(20*period)
    CPU_RESETN = 1'b1;
    #(10000*period)
    $finish;
end

endmodule
