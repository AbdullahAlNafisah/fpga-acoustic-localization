`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/18/2023 03:36:00 PM
// Design Name:
// Module Name: DEMOD_FFT_MULT
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


module DEMOD_FFT_MULT (
    input         clk            ,
    input         rst_n          ,
    input  [11:0] mod_data       ,
    input         mod_data_tvalid,
    output        mod_data_tready,
    output [32:0] sqrd_out       ,
    output        sqrd_out_tvalid,
    output        sqrd_out_tlast
);
//////////////////////////////////////////////////////////////////////////////////
    wire [23:0] demod_data       ;
    wire        demod_data_tvalid;

    wire        ifft_m_axis_data_tvalid;
    wire        ifft_m_axis_data_tlast ;
    wire [31:0] ifft_m_axis_data_tdata ;

    wire signed [15:0] A_real;
    wire signed [15:0] B_real;
    wire        [31:0] P_real;

    wire signed [15:0] A_imag;
    wire signed [15:0] B_imag;
    wire        [31:0] P_imag;

    reg ifft_m_axis_data_tlast_reg  = 1'b0;
    reg ifft_m_axis_data_tvalid_reg = 1'b0;

//////////////////////////////////////////////////////////////////////////////////
    assign A_real = ifft_m_axis_data_tdata[15:0];
    assign B_real = ifft_m_axis_data_tdata[15:0];

    assign A_imag = ifft_m_axis_data_tdata[31:16];
    assign B_imag = ifft_m_axis_data_tdata[31:16];

    assign sqrd_out        = P_real + P_imag;
    assign sqrd_out_tvalid = ifft_m_axis_data_tvalid_reg;
    assign sqrd_out_tlast  = ifft_m_axis_data_tlast_reg;
//////////////////////////////////////////////////////////////////////////////////

    always @(posedge clk or negedge rst_n) begin : proc_ifft_m_axis_data_tlast_reg
        if(~rst_n) begin
            ifft_m_axis_data_tlast_reg  <= 0;
            ifft_m_axis_data_tvalid_reg <= 0;
        end else begin
            ifft_m_axis_data_tlast_reg  <= ifft_m_axis_data_tlast;
            ifft_m_axis_data_tvalid_reg <= ifft_m_axis_data_tvalid;
        end
    end
//////////////////////////////////////////////////////////////////////////////////

    DEMOD i_DEMOD (
        .clk              (clk              ),
        .rst_n            (rst_n            ),
        .mod_data         (mod_data         ),
        .mod_data_tvalid  (mod_data_tvalid  ),
        .mod_data_tready  (mod_data_tready  ),
        .demod_data       (demod_data       ),
        .demod_data_tvalid(demod_data_tvalid)
    );
//////////////////////////////////////////////////////////////////////////////////

    FFT_MULT i_FFT_MULT (
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        .demod_data             (demod_data             ),
        .demod_data_tvalid      (demod_data_tvalid      ),
        .ifft_m_axis_data_tvalid(ifft_m_axis_data_tvalid),
        .ifft_m_axis_data_tlast (ifft_m_axis_data_tlast ),
        .ifft_m_axis_data_tdata (ifft_m_axis_data_tdata )
    );

//////////////////////////////////////////////////////////////////////////////////

    mult_gen_1 mult_gen_real (
        .CLK(clk   ), // input wire CLK
        .A  (A_real), // input wire [39 : 0] A_real
        .B  (B_real), // input wire [39 : 0] B_real
        .P  (P_real)  // output wire [79 : 0] P_real
    );
    mult_gen_1 mult_gen_imag (
        .CLK(clk   ), // input wire CLK
        .A  (A_imag), // input wire [39 : 0] A_imag
        .B  (B_imag), // input wire [39 : 0] B_imag
        .P  (P_imag)  // output wire [79 : 0] P_imag
    );


//////////////////////////////////////////////////////////////////////////////////

endmodule
