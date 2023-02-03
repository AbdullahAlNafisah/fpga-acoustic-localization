`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2023 01:31:07 PM
// Design Name: 
// Module Name: frequencyDetection
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


module frequencyDetection(
input clk,
input [31:0] signal_value,
input [15:0] signal_index,
output reg valid_data,
output reg [31:0] frequency_out
    );
    
reg [31:0] signal_value_buff_next, signal_value_buff_reg;
reg [15:0] signal_index_buff_next, signal_index_buff_reg;
reg [1:0] state_next, state_reg;

localparam [1:0]
    idle_state = 2'b00,
    zero_state = 2'b01,
    one_state = 2'b10;

always @(posedge clk)
begin
//   if(reset)
//    begin
//        state_reg <= 0;
//        signal_value_buff_reg <= 0;
//        signal_index_buff_reg <= 0;
//    end
//   else
//    begin
        state_reg <= state_next;
        signal_value_buff_reg <= signal_value_buff_next;
        signal_index_buff_reg <= signal_index_buff_next;
   
//    end
end

always @*
begin
    state_next = state_reg;
    valid_data = 0;
    frequency_out = frequency_out;
    signal_index_buff_next = signal_index_buff_reg;
    signal_value_buff_next = signal_value_buff_reg;
    case(state_reg)
        idle_state:
            begin
                signal_value_buff_next = 0;
                signal_index_buff_next = 0;
                if(signal_index > 0)
                    state_next = zero_state;
                else
                    state_next = idle_state;
            end
        zero_state:
            begin
                if(signal_index > 0 & signal_index < 16301)
                    begin
                        if(signal_value > signal_value_buff_next)
                        begin
                            signal_value_buff_next = signal_value;
                            signal_index_buff_next = signal_index;
                        end
                    end
                 else if(signal_index == 16301)
                 begin
                    if(signal_index_buff_reg < 8192)
                        frequency_out = (signal_index_buff_reg)*6103;
                    else
                        frequency_out = (6103-signal_index_buff_reg)*6103;
                 end
                 
                 else if(signal_index == 16382)
                 begin
                    state_next = one_state;
                    valid_data = 1;
                 end
            end
         one_state:
            begin
            signal_index_buff_next = 0;
            signal_value_buff_next = 0;
            state_next = idle_state;
            
            end
            
         default:
         state_next = idle_state;
     endcase
     
        
end

endmodule
