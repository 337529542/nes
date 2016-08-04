`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:01:59 07/19/2016
// Design Name:
// Module Name:    cy_rx
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//  en使能是有一个时钟周期，是在接收完数据的下一次clk
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module cy_rx(
    input rst_n,
    input clk,
    input rx,
    output [7:0] data,
    output en
    );

    parameter clkdiv = 434;//时钟分频
    parameter clkdiv_offset = 217;//时钟据可能的信号起始点的偏移

    parameter S_PerStart = 0; //检测开始信号的起始点
    parameter S_Start = 1;//检测开始信号
    parameter S_D0 = 2; //以下是读取数据
    parameter S_D1 = 3;
    parameter S_D2 = 4;
    parameter S_D3 = 5;
    parameter S_D4 = 6;
    parameter S_D5 = 7;
    parameter S_D6 = 8;
    parameter S_D7 = 9;
    parameter S_Stop = 10;//检测结束位
    parameter S_ZeroEn = 11;//清除数据到达通知

    reg [9:0]counter = 0;
    reg [3:0]state = S_PerStart;
    reg enr = 0;
    reg [7:0]da;

    assign en = enr;
    assign data = da;

    always @ (posedge clk) begin
      if(!rst_n)begin
        counter <= 0;
        state <= S_PerStart;
        enr <= 0;
      end else begin
        case(state)
          S_PerStart:begin
            if(rx == 0) begin  //数据传输开始
              state <= S_Start;
              counter <= 0;
            end
          end

          S_Start:begin
            if(rx == 1) //读到错误数据
              state <= S_PerStart;
            else begin
              if(counter < clkdiv_offset) //计时到指定偏移
                counter <= counter + 1'b1;
              else begin  //正视开始读取数据
                counter <= 0;
                state <= S_D0;
              end
            end
          end

          ////////////////////////////////////////////////////////////
          S_D0:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D1;
              da[0] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D1:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D2;
              da[1] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D2:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D3;
              da[2] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D3:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D4;
              da[3] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D4:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D5;
              da[4] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D5:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D6;
              da[5] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D6:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_D7;
              da[6] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          S_D7:begin
            if(counter >= clkdiv) begin
              counter <= 0;
              state <= S_Stop;
              da[7] <= rx;
            end else
              counter <= counter + 1'b1;
          end

          /////////////////////////////////////////////////////////////

          S_Stop:begin
            if(counter >= clkdiv) begin
              counter <= 0;

              if(rx == 1) begin//结束位正确
                enr <= 1;
                state <= S_ZeroEn;
              end else //结束位不正确,数据传输有错误
                state <= S_PerStart;
            end else
              counter <= counter + 1'b1;
          end

          S_ZeroEn:begin
            state <= S_PerStart;
            enr <= 0;
          end

          default:state <= S_PerStart;
        endcase
      end
    end


endmodule
