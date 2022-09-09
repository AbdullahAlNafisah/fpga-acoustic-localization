`timescale 1ns / 1ps
module sine_sound #(
    parameter amp_bits = 8,
    parameter sample_depth = 6)(
    input clk,
    input [sample_depth-1:0] index,
    output reg [amp_bits-1:0] pwm_dc
    );
    (* rom_style = "block"*)
    reg [sample_depth-1:0] reg_index;
    always@(posedge clk) begin
        reg_index <= index;
    end
always@(*) begin
case (reg_index)
0  : pwm_dc <= 'b01111111;
1  : pwm_dc <= 'b10001010;
2  : pwm_dc <= 'b10010101;
3  : pwm_dc <= 'b10011111;
4  : pwm_dc <= 'b10101010;
5  : pwm_dc <= 'b10110100;
6  : pwm_dc <= 'b10111110;
7  : pwm_dc <= 'b11000111;
8  : pwm_dc <= 'b11010000;
9  : pwm_dc <= 'b11011000;
10 : pwm_dc <= 'b11100000;
11 : pwm_dc <= 'b11100111;
12 : pwm_dc <= 'b11101100;
13 : pwm_dc <= 'b11110010;
14 : pwm_dc <= 'b11110110;
15 : pwm_dc <= 'b11111001;
16 : pwm_dc <= 'b11111100;
17 : pwm_dc <= 'b11111101;
18 : pwm_dc <= 'b11111110;
19 : pwm_dc <= 'b11111101;
20 : pwm_dc <= 'b11111100;
21 : pwm_dc <= 'b11111001;
22 : pwm_dc <= 'b11110110;
23 : pwm_dc <= 'b11110010;
24 : pwm_dc <= 'b11101100;
25 : pwm_dc <= 'b11100111;
26 : pwm_dc <= 'b11100000;
27 : pwm_dc <= 'b11011000;
28 : pwm_dc <= 'b11010000;
29 : pwm_dc <= 'b11000111;
30 : pwm_dc <= 'b10111110;
31 : pwm_dc <= 'b10110100;
32 : pwm_dc <= 'b10101010;
33 : pwm_dc <= 'b10011111;
34 : pwm_dc <= 'b10010101;
35 : pwm_dc <= 'b10001010;
36 : pwm_dc <= 'b01111111;
37 : pwm_dc <= 'b01110011;
38 : pwm_dc <= 'b01101000;
39 : pwm_dc <= 'b01011110;
40 : pwm_dc <= 'b01010011;
41 : pwm_dc <= 'b01001001;
42 : pwm_dc <= 'b00111111;
43 : pwm_dc <= 'b00110110;
44 : pwm_dc <= 'b00101101;
45 : pwm_dc <= 'b00100101;
46 : pwm_dc <= 'b00011101;
47 : pwm_dc <= 'b00010110;
48 : pwm_dc <= 'b00010001;
49 : pwm_dc <= 'b00001011;
50 : pwm_dc <= 'b00000111;
51 : pwm_dc <= 'b00000100;
52 : pwm_dc <= 'b00000001;
53 : pwm_dc <= 'b00000000;
54 : pwm_dc <= 'b00000000;
55 : pwm_dc <= 'b00000000;
56 : pwm_dc <= 'b00000001;
57 : pwm_dc <= 'b00000100;
58 : pwm_dc <= 'b00000111;
59 : pwm_dc <= 'b00001011;
60 : pwm_dc <= 'b00010001;
61 : pwm_dc <= 'b00010110;
62 : pwm_dc <= 'b00011101;
63 : pwm_dc <= 'b00100101;
default: pwm_dc = 0;
endcase
end
endmodule
