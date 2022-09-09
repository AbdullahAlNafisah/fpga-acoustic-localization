//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module Controller #(
    parameter clk_freq = 100_000_000
)(
    // System
    input clk, nrst,
    output reg[7:0] LED,
    //
    input nRF_RX_S_rdy,
    output reg nRF_RX_S_en
);
wire test = 1'b0;

localparam states_depth = 8;
localparam [states_depth-1:0]
    IDLE = 0,
    INIT = 1,
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
            if ((cnt < clk_freq-1) & (~test))
            begin
                cnt <= cnt +1;
                cnt_done <= 1'b0;
            end
            else
            begin
                cnt <= 0;
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
            if(cnt_done) nextstate = INIT;
        end
        INIT: begin
            if(nRF_RX_S_rdy) nextstate = OPERATION;
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
            nRF_RX_S_en = 1'b0;
        end
        INIT: begin
            nRF_RX_S_en = 1'b1;
        end
        OPERATION: begin
            nRF_RX_S_en = 1'b1;
        end
        default :begin
            nRF_RX_S_en = 1'b0;
        end
    endcase
    
end
endmodule