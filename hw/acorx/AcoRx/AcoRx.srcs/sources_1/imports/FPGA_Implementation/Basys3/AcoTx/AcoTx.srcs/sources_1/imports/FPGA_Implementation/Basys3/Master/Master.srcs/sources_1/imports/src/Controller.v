//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module Controller #(
    parameter integer clk_freq = 100_000_000
)(
    // System
    input clk, nrst, sw,
    output reg[7:0] LED,
    // SPI
    input nRF_RX_rdy,
    output reg nRF_RX_en
);
wire test = 1'b0;

localparam states_depth = 8;
localparam [states_depth-1:0]
    IDLE = 0,
    BUSY = 1,
    OPERATION = 2,
    OFF = 3;
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
            if(cnt_done)
            begin
                nextstate = BUSY;
            end
        end
        BUSY: begin
            if(nRF_RX_rdy) nextstate = OPERATION;
        end
        OPERATION: begin
            
        end
        OFF: begin
            if (sw) nextstate = IDLE;
        end
        default: begin
            nextstate = IDLE;
        end
    endcase
    
    if (~sw) nextstate = OFF;
    
end
// Output logic
always@(*) begin

    LED = state;
    
    case (state) 
        IDLE : begin
            nRF_RX_en = 1'b0;
        end
        BUSY: begin
            nRF_RX_en = 1'b1;
        end
        OPERATION: begin
            nRF_RX_en = 1'b1;
        end
        OFF: begin
            nRF_RX_en = 1'b0;
        end
        default :begin
            nRF_RX_en = 1'b0;
        end
    endcase
    
end
endmodule