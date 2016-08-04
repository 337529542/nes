`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    13:27:56 07/20/2016
// Design Name:
// Module Name:    wr_bus_addr
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
module wr_bus_data(
    input rst_n,
    input clk,
    input [7:0] opcode,
    input en,
    output [7:0] tx_data,
    output tx_en,
    input tx_busy,
    input [15:0] addr,
    output [15:0] bus_Addr,
    input [7:0] bus_RData,
    output [7:0] bus_WData,
    output Cmd,
    output RW,
    input Finish
    );

    parameter S_Wait = 0;
    parameter S_ReadBus = 1;
    parameter S_WriteBus = 2;

    parameter S_Send = 3;//发送数据
    parameter S_Finish = 4;//等待数据发送完成

    reg [3:0]state = S_Wait;
    reg [7:0]dataRead;//存放上一次读取的数据
    reg [7:0]da;
    reg ten = 0;
    reg rcmd = 0;
    reg rw = 0;

    assign tx_data = da;
    assign tx_en = ten;
    assign bus_Addr = addr;
    assign bus_WData = dataRead;
    assign Cmd = rcmd;
    assign RW = rw;

    always @ (posedge clk) begin
      if (!rst_n) begin
        ten <= 0;
        state <= S_Wait;
        rcmd <= 0;
        rw <= 0;
      end else begin
        case(state)
          S_Wait:begin
            if(en && (opcode == 8'b11000010)) begin //bus read
              da <= opcode;
              state <= S_ReadBus;
              rcmd <= 1;
              rw <= 0;
            end else if(en && (opcode == 8'b11000011)) begin //bus write
              da <= opcode;
              state <= S_WriteBus;
              rcmd <= 1;
              rw <= 1;
            end else if (en && (opcode == 8'b11000000)) begin //data low Read
              da[7:4] <= 4'b1100;
              da[3:0] <= dataRead[3:0];
              state <= S_Send;
            end else if (en && (opcode == 8'b11000001)) begin //data high Read
              da[7:4] <= 4'b1100;
              da[3:0] <= dataRead[7:4];
              state <= S_Send;
            end else if (en && (opcode[7:4] == 8'b1101)) begin //data low Write
              da <= opcode;
              state <= S_Send;
              dataRead[3:0] <= opcode[3:0];
            end else if (en && (opcode[7:4] == 8'b1110)) begin //data high Write
              da <= opcode;
              state <= S_Send;
              dataRead[7:4] <= opcode[3:0];
            end
          end

          S_ReadBus:begin
            rcmd <= 0;
            if(Finish) begin
              dataRead <= bus_RData;
              state <= S_Send;
            end
          end

          S_WriteBus:begin
            rcmd <= 0;
            if(Finish) begin
              state <= S_Send;
            end
          end


          S_Send:begin //尽快发出数据
            if(tx_busy == 0)begin
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
