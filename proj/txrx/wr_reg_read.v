`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    09:38:35 07/20/2016
// Design Name:
// Module Name:    wr_reg_read
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
module wr_reg_read(
    input rst_n,
    input clk,
    input [7:0] opcode,
    input en,
    input tx_busy,
    output tx_en,
    output [7:0] tx_data,
    input [15:0] PC,
    input [7:0] AC,
    input [7:0] SP,
    input [7:0] XR,
    input [7:0] YR,
    input [7:0] SR
    );

    parameter S_Wait = 0;//等待cmd
    parameter S_Send = 1;//发送数据
    parameter S_Finish = 2;//等待数据发送完成

    reg [1:0]state = S_Wait;
    reg ten = 0;
    reg [3:0]data;

    assign tx_en = ten;
    assign tx_data[7:4] = 4'b0010;
    assign tx_data[3:0] = data[3:0];

    always @ (posedge clk) begin
      if(!rst_n)begin
        ten <= 0;
        state <= S_Wait;
      end else begin
        case(state)
          S_Wait:begin
            if(en && (opcode[7:4] == 4'b0010)) begin

              state <= S_Send;
              case(opcode[3:0])
                4'b0000:data <= PC[3:0];
                4'b0001:data <= PC[7:4];
                4'b0010:data <= PC[11:8];
                4'b0011:data <= PC[15:12];
                4'b0100:data <= AC[3:0];
                4'b0101:data <= AC[7:4];
                4'b0110:data <= SP[3:0];
                4'b0111:data <= SP[7:4];
                4'b1000:data <= XR[3:0];
                4'b1001:data <= XR[7:4];
                4'b1010:data <= YR[3:0];
                4'b1011:data <= YR[7:4];
                4'b1100:data <= SR[3:0];
                4'b1101:data <= SR[7:4];
                default:data <= PC[3:0];
              endcase
            end
          end

          S_Send:begin
            if(tx_busy == 0) begin
              state <= S_Finish;
              ten <= 1;
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
