//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
//Date        : Thu Feb  2 14:47:57 2023
//Host        : abdullah-B450-AORUS-PRO-WIFI running 64-bit Ubuntu 20.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (AUD_PWM,
    AUD_SD,
    CPU_RESETN,
    LED,
    RX_D_CE,
    RX_D_IRQ,
    RX_D_IRQ_out,
    RX_D_MISO,
    RX_D_MOSI,
    RX_D_SCLK,
    RX_D_SS_N,
    RX_S_CE,
    RX_S_IRQ,
    RX_S_IRQ_out,
    RX_S_MISO,
    RX_S_MOSI,
    RX_S_SCLK,
    RX_S_SS_N,
    TX_CE,
    TX_CE_out,
    TX_IRQ,
    TX_IRQ_out,
    TX_MISO,
    TX_MOSI,
    TX_SCLK,
    TX_SS_N,
    an,
    dp,
    seg,
    spi_cs,
    spi_data,
    spi_sclk,
    sw,
    sys_clock,
    vsoundn,
    vsoundp);
  output AUD_PWM;
  output AUD_SD;
  input CPU_RESETN;
  output [15:0]LED;
  output RX_D_CE;
  input RX_D_IRQ;
  output RX_D_IRQ_out;
  input RX_D_MISO;
  output RX_D_MOSI;
  output RX_D_SCLK;
  output [0:0]RX_D_SS_N;
  output RX_S_CE;
  input RX_S_IRQ;
  output RX_S_IRQ_out;
  input RX_S_MISO;
  output RX_S_MOSI;
  output RX_S_SCLK;
  output [0:0]RX_S_SS_N;
  output TX_CE;
  output TX_CE_out;
  input TX_IRQ;
  output TX_IRQ_out;
  input TX_MISO;
  output TX_MOSI;
  output TX_SCLK;
  output [0:0]TX_SS_N;
  output [7:0]an;
  output dp;
  output [6:0]seg;
  output spi_cs;
  output spi_data;
  output spi_sclk;
  input sw;
  input sys_clock;
  input vsoundn;
  input vsoundp;

  wire AUD_PWM;
  wire AUD_SD;
  wire CPU_RESETN;
  wire [15:0]LED;
  wire RX_D_CE;
  wire RX_D_IRQ;
  wire RX_D_IRQ_out;
  wire RX_D_MISO;
  wire RX_D_MOSI;
  wire RX_D_SCLK;
  wire [0:0]RX_D_SS_N;
  wire RX_S_CE;
  wire RX_S_IRQ;
  wire RX_S_IRQ_out;
  wire RX_S_MISO;
  wire RX_S_MOSI;
  wire RX_S_SCLK;
  wire [0:0]RX_S_SS_N;
  wire TX_CE;
  wire TX_CE_out;
  wire TX_IRQ;
  wire TX_IRQ_out;
  wire TX_MISO;
  wire TX_MOSI;
  wire TX_SCLK;
  wire [0:0]TX_SS_N;
  wire [7:0]an;
  wire dp;
  wire [6:0]seg;
  wire spi_cs;
  wire spi_data;
  wire spi_sclk;
  wire sw;
  wire sys_clock;
  wire vsoundn;
  wire vsoundp;

  design_1 design_1_i
       (.AUD_PWM(AUD_PWM),
        .AUD_SD(AUD_SD),
        .CPU_RESETN(CPU_RESETN),
        .LED(LED),
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
        .an(an),
        .dp(dp),
        .seg(seg),
        .spi_cs(spi_cs),
        .spi_data(spi_data),
        .spi_sclk(spi_sclk),
        .sw(sw),
        .sys_clock(sys_clock),
        .vsoundn(vsoundn),
        .vsoundp(vsoundp));
endmodule
