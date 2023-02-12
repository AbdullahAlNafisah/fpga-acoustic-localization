//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
//Date        : Sun Feb 12 21:00:24 2023
//Host        : abdullah-B450-AORUS-PRO-WIFI running 64-bit Ubuntu 20.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CE,
    CEout,
    CPU_RESETN,
    CS_N,
    IRQ,
    IRQout,
    LED,
    MISO,
    MOSI,
    SCLK,
    spi_cs,
    spi_data,
    spi_sclk,
    sw,
    sys_clock,
    vauxn11,
    vauxp11);
  output CE;
  output CEout;
  input CPU_RESETN;
  output [0:0]CS_N;
  input IRQ;
  output IRQout;
  output [15:0]LED;
  input MISO;
  output MOSI;
  output SCLK;
  output spi_cs;
  output spi_data;
  output spi_sclk;
  input [0:0]sw;
  input sys_clock;
  input vauxn11;
  input vauxp11;

  wire CE;
  wire CEout;
  wire CPU_RESETN;
  wire [0:0]CS_N;
  wire IRQ;
  wire IRQout;
  wire [15:0]LED;
  wire MISO;
  wire MOSI;
  wire SCLK;
  wire spi_cs;
  wire spi_data;
  wire spi_sclk;
  wire [0:0]sw;
  wire sys_clock;
  wire vauxn11;
  wire vauxp11;

  design_1 design_1_i
       (.CE(CE),
        .CEout(CEout),
        .CPU_RESETN(CPU_RESETN),
        .CS_N(CS_N),
        .IRQ(IRQ),
        .IRQout(IRQout),
        .LED(LED),
        .MISO(MISO),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .spi_cs(spi_cs),
        .spi_data(spi_data),
        .spi_sclk(spi_sclk),
        .sw(sw),
        .sys_clock(sys_clock),
        .vauxn11(vauxn11),
        .vauxp11(vauxp11));
endmodule
