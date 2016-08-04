`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    12:54:44 07/20/2016
// Design Name:
// Module Name:    BUS
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//      range : 0x0000 - 0x000F
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module BUS_RAM_Small(
    input [15:0] Addr,
    output [7:0] RData,
    input [7:0] WData,
    input Cmd,
    input RW,
    output Finish,
    input clk,
    input rst_n
    );

    parameter S_Wait = 0;
    parameter S_Finish = 1;

    reg state = S_Wait;

    reg [7:0]mem[0:15];

    reg fin = 0;
    assign Finish = fin;

    reg [7:0]da;
    assign RData = da;

    always @ (posedge clk) begin
      if (!rst_n) begin
        fin <= 0;
        state <= S_Wait;
      end else begin
        case(state)
        S_Wait:begin
          if(Cmd && (Addr[15:4] == 0)) begin
            state <= S_Finish;
            if(RW == 1) begin //写操作
              mem[Addr[3:0]] <= WData;
              fin <= 1;
            end else begin  //读操作
              da <= mem[Addr[3:0]];
              fin <= 1;
            end
          end
        end

        S_Finish:begin
          state <= S_Wait;
          fin <= 0;
        end

        endcase
      end

    end



endmodule
