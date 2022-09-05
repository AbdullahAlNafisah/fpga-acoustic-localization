//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module pwm #(
    parameter clk_freq = 12_288_000,
    parameter samp_freq = 48_000,
    parameter amp_bits = 8,
    parameter sample_depth = 6
    )
    (
    input clk,
    input en,
    input [amp_bits-1:0] pwm_dc,
    output reg [sample_depth-1:0] index,
    output AUD_PWM,
    output AUD_SD
    );
    
    localparam freq_divider = (clk_freq/(2*samp_freq));
    
    reg [amp_bits+1:0] cnt = 0;
    reg [3:0] increment = 1;
    integer timer = 0;
    
    // Register
    always@(posedge clk) begin
        if(~en) begin
            index <= 0;
            cnt <= 0;
            timer <= 0;
            increment <= 0;
         end
        else begin
        
            if (cnt > freq_divider-1) begin
                cnt <= 0;
                index <= index + increment;
            end
            else begin
                cnt <= cnt + 1;
                index <= index;
            end
            
            if (timer > clk_freq-1) begin
                timer <= 0;
                increment <= increment + 1;
            end
            else begin
                timer <= timer +1;
            end
            
        end
    end
    // Logic
    assign AUD_PWM = (pwm_dc > cnt);
    assign AUD_SD = (en);
    
endmodule
