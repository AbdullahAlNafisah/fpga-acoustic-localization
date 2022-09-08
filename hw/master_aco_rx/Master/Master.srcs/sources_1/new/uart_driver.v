//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps

module uart_driver(
    input clk, rst_n,
    // tx fifo signals
    input valid, empty,
    output reg rd_en,
    // uart signals
    input tx_busy,
    output reg tx_ena
    );
    
    parameter states_depth = 2;
    reg [states_depth-1:0] state = 0;
    // States
    localparam [states_depth-1:0]
        idle = 0,
        fifo_rd = 1,
        uart_send = 2;
    
    // State Register
    always@(posedge clk)
    begin
        if (~rst_n)
        begin
            state <= idle;
        end else
        begin
            rd_en <= 1'b0;
            tx_ena = 1'b0;
            case(state)
                idle: begin
                    if((~empty) && (~tx_busy)) 
                        state <= fifo_rd;
                    else
                        state <= idle;
                end
                fifo_rd: begin
                    rd_en <= 1'b1;
                    if(valid)
                        state <= uart_send;
                    else
                        state <= fifo_rd;
                end
                uart_send: begin
                    tx_ena = 1'b1;
                    if(tx_busy)
                        state <= idle;
                    else
                        state <= uart_send;
                end
                default:
                    state <= idle;
            endcase
        end
    end
    
endmodule
