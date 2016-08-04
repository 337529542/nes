`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:49:07 07/19/2016
// Design Name:
// Module Name:    cy_tx
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
module cy_tx(
    input rst_n,
    input clk,
    input [7:0] data,
    input en,
    output busy,
    output tx
    );

parameter  clkdiv = 434;

parameter S_Idle = 0;
parameter S_Start = 1;
parameter S_Data0 = 2;
parameter S_Data1 = 3;
parameter S_Data2 = 4;
parameter S_Data3 = 5;
parameter S_Data4 = 6;
parameter S_Data5 = 7;
parameter S_Data6 = 8;
parameter S_Data7 = 9;
parameter S_Stop1 = 10;
parameter S_Stop2 = 11;

reg [9:0]counter = 0;
reg [3:0]state = S_Idle;
reg [7:0]da; //缓存要发送的数据

reg txr = 1;
assign tx = txr;
assign busy = en || (state != S_Idle);

always @ (posedge clk) begin
  if (!rst_n) begin
    counter <= 0;
    state <= S_Idle;
    txr <= 1;
  end else begin

    case (state)
      S_Idle:begin
        txr <= 1;
        if(en) begin
          state <= S_Start;
          da <= data;
          counter <= 0;
        end
      end

      S_Start:begin //此时发送开始位后马上跳转到下一个状态，并将counter+1以保证时间正确。
                    //以后每个发送数据的状态都会在计时结束时发送本次的数据。
        counter <= 1;//计时器时间修正，因为本次状态机执行占用了一个clk
        txr <= 0;//发送开始位
        state <= S_Data0;
      end

      //////////////////////////////////////////////////////////////
      S_Data0:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[0];
          state <= S_Data1;
        end else
          counter <= counter + 1'b1;
      end

      S_Data1:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[1];
          state <= S_Data2;
        end else
          counter <= counter + 1'b1;
      end

      S_Data2:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[2];
          state <= S_Data3;
        end else
          counter <= counter + 1'b1;
      end

      S_Data3:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[3];
          state <= S_Data4;
        end else
          counter <= counter + 1'b1;
      end

      S_Data4:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[4];
          state <= S_Data5;
        end else
          counter <= counter + 1'b1;
      end

      S_Data5:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[5];
          state <= S_Data6;
        end else
          counter <= counter + 1'b1;
      end

      S_Data6:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[6];
          state <= S_Data7;
        end else
          counter <= counter + 1'b1;
      end

      S_Data7:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= da[7];
          state <= S_Stop1;
        end else
          counter <= counter + 1'b1;
      end
      ///////////////////////////////////////////////////////////////

      S_Stop1:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= 1;
          state <= S_Stop2;
        end else
          counter <= counter + 1'b1;
      end

      S_Stop2:begin
        if(counter >= clkdiv) begin
          counter <= 0;
          txr <= 1;
          state <= S_Idle;
        end else
          counter <= counter + 1'b1;
      end

      default:state <= S_Idle;

    endcase

  end
end

endmodule
