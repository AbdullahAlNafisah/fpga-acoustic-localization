//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module Controller #(
    parameter integer clk_freq = 100_000_000
)(
    // System
    input clk, nrst,
    output reg[7:0] LED,
    // SPI
    input nRF_TX_rdy,
    input nRF_RX_S_rdy,
    input nRF_RX_D_rdy,
    output reg nRF_TX_en,
    output reg nRF_RX_S_en,
    output reg nRF_RX_D_en,
    output reg PWM_en,
    output reg microphone_en,
    output reg all_ready
);
wire test = 1'b0;

localparam states_depth = 8;
localparam [states_depth-1:0]
    IDLE = 0,
    BUSY = 1,
    OPERATION = 2;
reg [states_depth-1:0] state=IDLE, nextstate=IDLE;

integer cnt = 0;
reg cnt_done;

// State register
always@(posedge clk) begin
    if (~nrst) begin
    
        state <= IDLE;
        cnt <= 0;
        cnt_done <= 1'b0;
        
    end
    else begin
    
        state <= nextstate;
        
        if (state==IDLE)
        begin
            if ((cnt < clk_freq) & (~test))
            begin
                cnt <= cnt +1;
                cnt_done <= 1'b0;
            end
            else
            begin
                cnt <= clk_freq;
                cnt_done <= 1'b1;
            end
        end
        else
        begin
            cnt <= 0;
            cnt_done <= 1'b0;
        end
        
    end
end
//Next state logic
always@(*) begin

    nextstate = state;
    
    case (state)
        IDLE: begin
            if(cnt_done) nextstate = BUSY;
        end
        BUSY: begin
            if(nRF_TX_rdy & nRF_RX_S_rdy & nRF_RX_D_rdy) nextstate = OPERATION;
        end
        OPERATION: begin
            nextstate = OPERATION;
        end
        default: begin
            nextstate = IDLE;
        end
    endcase
    
end
// Output logic
always@(*) begin

    LED = state;
    
    case (state) 
        IDLE : begin
            nRF_TX_en = 1'b0;
            nRF_RX_S_en = 1'b0;
            nRF_RX_D_en = 1'b0;
            PWM_en = 1'b0;
            microphone_en = 1'b0;
            all_ready = 1'b0;
        end
        BUSY: begin
            nRF_TX_en = 1'b1;
            nRF_RX_S_en = 1'b1;
            nRF_RX_D_en = 1'b1;
            PWM_en = 1'b1;
            microphone_en = 1'b1;
            all_ready = 1'b0;
        end
        OPERATION: begin
            nRF_TX_en = 1'b1;
            nRF_RX_S_en = 1'b1;
            nRF_RX_D_en = 1'b1;
            PWM_en = 1'b1;
            microphone_en = 1'b1;
            all_ready = 1'b1;
        end
        default :begin
            nRF_TX_en = 1'b0;
            nRF_RX_S_en = 1'b0;
            nRF_RX_D_en = 1'b0;
            PWM_en = 1'b0;
            microphone_en = 1'b0;
            all_ready = 1'b0;
        end
    endcase
    
end
endmodule