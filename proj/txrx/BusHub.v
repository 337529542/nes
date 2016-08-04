`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:16:15 07/20/2016
// Design Name:
// Module Name:    BusHub
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
module BusHub(
    input rst_n,
    input clk,
    input [15:0] In1_Addr,
    input [15:0] In2_Addr,
    output [7:0] In1_RData,
    output [7:0] In2_RData,
    input [7:0] In1_WData,
    input [7:0] In2_WData,
    input In1_RW,
    input In2_RW,
    input In1_Cmd,
    input In2_Cmd,
    output In1_Finish,
    output In2_Finish,
    output [15:0] O_Addr,
    input [7:0] O_RData,
    output [7:0] O_WData,
    output O_RW,
    output O_Cmd,
    input O_Finish
    );

    reg cmd1 = 0;
    reg cmd2 = 0;
    reg cmd = 0;
    reg [15:0] addr1;
    reg [15:0] addr2;
    reg [7:0] rdata1;
    reg [7:0] rdata2;
    reg [7:0] wdata1;
    reg [7:0] wdata2;
    reg rw1;
    reg rw2;
    reg fin1 = 0;
    reg fin2 = 0;
    reg channel = 0;//

    assign O_Addr = channel ? addr2 : addr1;
    assign O_WData = channel ? wdata2 : wdata1;
    assign O_RW = channel ? rw2 : rw1;
    assign In1_Finish = fin1;
    assign In2_Finish = fin2;
    assign In1_RData = rdata1;
    assign In2_RData = rdata2;
    assign O_Cmd = cmd;

    parameter S_Wait = 0;
    parameter S_BUSBusy = 1;
    parameter S_Finish = 2;

    reg [1:0] state = S_Wait;

    always @ (posedge clk) begin
      if (!rst_n) begin
        cmd1 <= 0;
        cmd2 <= 0;
        cmd <= 0;
        channel <= 0;
        state <= S_Wait;
        fin1 <= 0;
        fin2 <= 0;
      end else begin
        //搬运
        if(In1_Cmd)begin
          cmd1 <= 1;
          addr1 <= In1_Addr;
          wdata1 <= In1_WData;
          rw1 <= In1_RW;
        end

        if(In2_Cmd)begin
          cmd2 <= 1;
          addr2 <= In2_Addr;
          wdata2 <= In2_WData;
          rw2 <= In2_RW;
        end

        case(state)
          S_Wait:begin
            if(cmd1)begin

              cmd1 <= 0;
              channel <= 0;
              state <= S_BUSBusy;
              cmd <= 1;

            end else if(cmd2) begin

              cmd2 <= 0;
              channel <= 1;
              state <= S_BUSBusy;
              cmd <= 1;

            end
          end

          S_BUSBusy:begin //等待执行完成后，通知上面
            cmd <= 0;
            if(O_Finish)begin
              state <= S_Finish;
              if(channel == 0)begin
                fin1 <= 1;
                rdata1 <= O_RData;
              end else begin
                fin2 <= 1;
                rdata2 <= O_RData;
              end
            end
          end

          S_Finish:begin
            state <= S_Wait;
            fin1 <= 0;
            fin2 <= 0;
          end

          default:state <= S_Wait;

        endcase

      end

    end




endmodule
