`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:18:09 07/19/2016
// Design Name:
// Module Name:    wr_ping
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module wr_ping(
    input rst_n,
    input clk,
    input [7:0] opcode,
    input en,
    output [7:0] tx_data,
    output tx_en,
    input tx_busy
    );

    parameter S_Wait = 0;//等待cmd
    parameter S_Send = 1;//发送数据
    parameter S_Finish = 2;//等待数据发送完成

    reg [7:0]data;
    reg t_en = 0;
    reg [1:0]state = S_Wait;

    assign tx_data = data;
    assign tx_en = t_en;

    always @ (posedge clk) begin
      if(!rst_n) begin
        t_en <= 0;
        state <= S_Wait;
      end else begin
        case(state)
          S_Wait:begin//等待到cmd后，立刻讲数据存储起来，并准备下一步的发送工作
            if(en && opcode[7:4] == 4'b0001) begin
              data <= opcode;
              t_en <= 0;
              state <= S_Send;
            end
          end

          S_Send:begin //尽快发出数据
            if(tx_busy == 0)begin
              t_en <= 1;
              state <= S_Finish;
            end
          end

          S_Finish:begin
            t_en <= 0;
            state <= S_Wait;
          end

          default:state <= S_Wait;

        endcase
      end
    end

endmodule
