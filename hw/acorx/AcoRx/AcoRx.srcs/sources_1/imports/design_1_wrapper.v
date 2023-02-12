//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
//Date        : Sun Feb 12 18:59:30 2023
//Host        : abdullah-B450-AORUS-PRO-WIFI running 64-bit Ubuntu 20.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CE,
    CEout,
    CS_N,
    IRQ,
    IRQout,
    LED,
    MISO,
    MOSI,
    SCLK,
    btnC,
    spi_cs,
    spi_data,
    spi_sclk,
    sw,
    sys_clock,
    vauxn6,
    vauxp6);
  output CE;
  output CEout;
  output [0:0]CS_N;
  input IRQ;
  output IRQout;
  output [15:0]LED;
  input MISO;
  output MOSI;
  output SCLK;
  input btnC;
  output spi_cs;
  output spi_data;
  output spi_sclk;
  input [0:0]sw;
  input sys_clock;
  input vauxn6;
  input vauxp6;

  wire CE;
  wire CEout;
  wire [0:0]CS_N;
  wire IRQ;
  wire IRQout;
  wire [15:0]LED;
  wire MISO;
  wire MOSI;
  wire SCLK;
  wire btnC;
  wire spi_cs;
  wire spi_data;
  wire spi_sclk;
  wire [0:0]sw;
  wire sys_clock;
  wire vauxn6;
  wire vauxp6;

  design_1 design_1_i
       (.CE(CE),
        .CEout(CEout),
        .CS_N(CS_N),
        .IRQ(IRQ),
        .IRQout(IRQout),
        .LED(LED),
        .MISO(MISO),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .btnC(btnC),
        .spi_cs(spi_cs),
        .spi_data(spi_data),
        .spi_sclk(spi_sclk),
        .sw(sw),
        .sys_clock(sys_clock),
        .vauxn6(vauxn6),
        .vauxp6(vauxp6));
endmodule
