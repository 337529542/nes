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
module wr_bus_addr(
    input rst_n,
    input clk,
    input [7:0] opcode,
    input en,
    output [7:0] tx_data,
    output tx_en,
    input tx_busy,
    output [15:0] addr
    );


    parameter S_Wait = 0;//等待cmd
    parameter S_Send = 1;//发送数据
    parameter S_Finish = 2;//等待数据发送完成

    reg [1:0] state = S_Wait;
    reg [7:0] da;
    reg ten = 0;
    reg [15:0] adr;

    assign addr = adr;
    assign tx_data = da;
    assign tx_en = ten;

    always @ (posedge clk) begin
      if (!rst_n) begin
        state <= S_Wait;
        ten <= 0;
      end else begin

        case(state)
          S_Wait:begin
            if(en && (opcode[7:6] == 2'b10)) begin
              state <= S_Send;
              da <= opcode;
              case(opcode[5:4])
                2'b00:adr[3:0] <= opcode[3:0];
                2'b01:adr[7:4] <= opcode[3:0];
                2'b10:adr[11:8] <= opcode[3:0];
                2'b11:adr[15:12] <= opcode[3:0];
              endcase
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
