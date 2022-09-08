`timescale 1ns / 1ps
//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
module microphone #(
    parameter clk_freq = 100_000_000,
    parameter data_freq = 2_000_000
    )(
    input clk, rst_n, en,
    // Microphone signals
    input M_DATA,
    output reg M_CLK,
    output reg M_LRSEL,
    // tx fifo signals
    input wr_ack, full,
    output reg [7:0] wr_data,
    output reg wr_en
    );
    
    localparam divider = (clk_freq/(data_freq));
    integer cnt = 0;
    reg DATA1=1'b0;
    reg [7:0] DATA_1_reg = 8'h00, DATA_2_reg = 8'h00;
    reg [4:0] index = 0;
    localparam states_depth = 2;
    reg [states_depth-1:0] state = 0;
    // States
    localparam [states_depth-1:0]
        idle = 0,
        DATA_1_latch = 1,
        DATA_2_latch = 2;
    
    // State Register
    always@(posedge clk)
    begin
        if (~rst_n)
        begin
            state <= idle;
            cnt <= 0;
            M_LRSEL <= 1'b0;
            M_CLK <= 1'b0;
            DATA1 <= 1'b0;
            DATA_1_reg <= 8'h00;
            DATA_2_reg <= 8'h00;
            index <= 0;
            wr_data <= 8'h00;
            wr_en <= 1'b0;
        end else if (en)
        begin
            M_LRSEL <= 1'b0;
            wr_en <= 1'b0;
            wr_data <= DATA_1_reg;
            if (cnt > divider-1) begin
                M_CLK <= ~M_CLK;
                DATA1 <= ~DATA1;
                cnt <= 0;
                index <= index+1;
            end
            else begin
                M_CLK <= M_CLK;
                DATA1 <= DATA1;
                cnt <= cnt+1;
                if (index > 15) begin
                    if(~full)
                        wr_en <= 1'b1;
                    if (wr_ack)
                        index <= 0;
                    else
                        index <= index;
                end
                else begin
                    index <= index;
                end
            end
            case(state)
                idle: begin
                    DATA_2_reg <= DATA_2_reg;
                    if (DATA1) begin
                        state <= DATA_1_latch;
                        DATA_1_reg <= {DATA_1_reg[6:0], M_DATA};
                    end
                    else begin
                        state <= idle;
                        DATA_1_reg <= DATA_1_reg;
                    end
                end
                DATA_1_latch: begin
                    DATA_1_reg <= DATA_1_reg;
                    if (~DATA1) begin
                        state <= DATA_2_latch;
                        DATA_2_reg <= {DATA_2_reg[6:0], M_DATA};
                    end
                    else begin
                        state <= DATA_1_latch;
                        DATA_2_reg <= DATA_2_reg;
                    end
                end
                DATA_2_latch: begin
                    DATA_2_reg <= DATA_2_reg;
                    if (DATA1) begin
                        state <= DATA_1_latch;
                        DATA_1_reg <= {DATA_1_reg[6:0], M_DATA};
                    end
                    else begin
                        state <= DATA_2_latch;
                        DATA_1_reg <= DATA_1_reg;
                    end
                end
                default: begin
                    state <= idle;
                end
                
            endcase
        end
        else begin
            state <= idle;
            cnt <= 0;
            M_LRSEL <= 1'b0;
            M_CLK <= 1'b0;
            DATA1 <= 1'b0;
            DATA_1_reg <= 8'h00;
            DATA_2_reg <= 8'h00;
            index <= 0;
            wr_data <= 8'h00;
            wr_en <= 1'b0;
        end 
    end
    
endmodule
