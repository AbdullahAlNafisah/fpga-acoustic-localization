//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module pwm #(
    parameter clk_freq = 20_000_000,
    parameter samp_freq = 200_000,
    parameter amp_bits =12,
    parameter sample_depth = 12
    )
    (
    input clk,
    input en,
    output reg [sample_depth-1:0] da_index,
    output reg tick_sample
    );
    
    localparam freq_divider = (clk_freq/(samp_freq));
    localparam zclength = 4049;
    reg [31:0] cnt = 0;
    
    // Register
    always@(posedge clk) begin
        if(~en) begin
            da_index <= 0;
            cnt <= 0;
            tick_sample <= 0;
         end
        else begin
        
            if (cnt > freq_divider-1) begin
                cnt <= 0;
                
                if (da_index == zclength)
                    da_index <= 0;
                else
                    da_index <= da_index + 1;
                    
                tick_sample <= 1;
            end
            else begin
                cnt <= cnt + 1;
                da_index <= da_index;
                tick_sample <= 0;
            end
            
        end
    end
    
endmodule
