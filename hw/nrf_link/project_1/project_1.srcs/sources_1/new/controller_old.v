//--------------------------------------------------
// By: Abdullah Al-Nafisah
//--------------------------------------------------
`timescale 1ns / 1ps
module controller_old #(
    parameter data_depth = 12
)(
    // System
    input clk, rst,
    // SPI
    output spi_en,
    // PWM
    input sound,
    output reg [data_depth-1:0] index,
    output pwm_en,
    input pwm_done
);

localparam last_data = (2**data_depth)-1;

localparam [1:0]
    IDLE = 2'b00,
    LOAD = 2'b01,
    RELOAD = 2'b11;

reg [1:0] st=0, nxt_st=0;
reg [data_depth-1:0] index_i = 0;

// State register
always@(posedge clk) begin
    if (rst) begin
        st <= IDLE;
        index <= 0;
    end
    else begin
        st <= nxt_st;
        index <= index_i;
    end
end

//Next state logic
always@(*) begin
    nxt_st <= st;
    case (st)
        IDLE: begin
            if(sound) nxt_st <= LOAD;
        end
        LOAD : begin
            if (index == last_data) 
                nxt_st <= IDLE;
            else if(pwm_done) 
                nxt_st <= RELOAD;
        end
        RELOAD: begin
            nxt_st <= LOAD;
        end
        default: begin
            nxt_st <= IDLE;
        end
    endcase
end

// Output logic
always@(*) begin
    index_i <= index;
    case (st)
        IDLE : begin
            index_i <= 0;
        end
        LOAD : begin
            if (sound) begin
                index_i <= 0;
            end
        end
        RELOAD : begin
            if (sound) begin
                index_i <= 0;
            end
            else
                index_i <= index +1;
        end
        default :begin
            index_i <= 0;
        end
    endcase
end

assign pwm_en = (st != IDLE);
assign spi_en = (st != IDLE);

endmodule