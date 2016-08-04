`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:56:55 07/20/2016
// Design Name:
// Module Name:    wr_cpu_ctl
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
module wr_cpu_ctl(
    input rst_n,
    input clk,
    output ctl_stepmode,
    output ctl_step,
    input ctl_busy,
    output ctl_rst,
    input [7:0] opcode,
    input en,
    input tx_busy,
    output tx_en,
    output [7:0] tx_data
    );

    parameter S_Wait = 0;
    parameter S_Rst = 1;
    //parameter S_StepMode = 2;
    parameter S_Step = 3;
    parameter S_WaitBusyAndSendResult = 4;
    parameter S_Finish = 5;

    reg [3:0]data;
    reg ten = 0;
    reg [2:0] state = S_Wait;
    reg stepmode = 0;
    reg step = 0;
    reg rst = 0;

    assign tx_data[7:4] = 4'b0000;
    assign tx_data[3:0] = data;
    assign tx_en = ten;
    assign ctl_stepmode = stepmode;
    assign ctl_step = step;
    assign ctl_rst = rst;

    always @ (posedge clk) begin
      if (!rst_n) begin
        ten <= 0;
        state <= S_Wait;
        stepmode <= 0;
        step <= 0;
        rst <= 0;
      end else begin
        case(state)
          S_Wait:begin
            if(en && (opcode[7:4] == 4'b0000) )begin
              data <= opcode[3:0];
              case(opcode[3:0]) //reset
                4'b0000:begin
                  state <= S_Rst;
                  rst <= 1;
                end

                4'b0001:begin //one step
                  state <= S_Step;
                  step <= 1;
                end

                4'b0010:begin //step on
                  state <= S_WaitBusyAndSendResult;
                  stepmode <= 1;
                end

                4'b0011:begin //step off
                  state <= S_WaitBusyAndSendResult;
                  stepmode <= 0;
                end

                default:;

              endcase
            end
          end

          S_Rst:begin
            state <= S_WaitBusyAndSendResult;
            rst <= 0;
          end

          S_Step:begin
            state <= S_WaitBusyAndSendResult;
            step <= 0;
          end

          S_WaitBusyAndSendResult:begin
            if(!tx_busy && !ctl_busy)begin
              ten <= 1;
              state <= S_Finish;
            end
          end

          S_Finish:begin
            ten <= 0;
            state <= S_Wait;
          end

          default:state <= S_Wait;
        endcase
      end
    end


endmodule
