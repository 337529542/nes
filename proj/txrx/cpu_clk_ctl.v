`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:27:05 07/20/2016
// Design Name:
// Module Name:    cpu_clk_ctl
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
module cpu_clk_ctl(
    input rst_n,
    input ctl_stepmode, // 0=disable step mode
    input ctl_step,
    input clk_in,
    output clk_cpu,
    output ctl_busy,
    input ctl_rst,
    input cpu_step,
    output cpu_rst
    );

    parameter S_Wait = 0;
    parameter S_DoRst = 1;
    parameter S_DoStep = 2;

    reg [1:0] state = S_Wait;
    reg clkctl = 0;
    reg busy = 0;
    reg cpu_rst_n = 1;
    assign cpu_rst = cpu_rst_n;
    assign ctl_busy = busy;
    assign clk_cpu = ctl_stepmode ? (clkctl ? clk_in : 0) : clk_in;

    always @ (posedge clk_in) begin
      if (!rst_n) begin
        state <= S_Wait;
        clkctl <= 0;
        busy <= 0;
        cpu_rst_n <= 1;
      end else begin
        case(state)
          S_Wait:begin
            if(ctl_rst) begin //有reset请求
              busy <= 1;
              clkctl <= 1;
              cpu_rst_n <= 0;
              state <= S_DoRst;
            end else if(ctl_step) begin //请求执行一条指令
              busy <= 1;
              clkctl <= 1;
              state <= S_DoStep;
            end
          end

          S_DoRst:begin
            busy <= 0;
            clkctl <= 0;
            cpu_rst_n <= 1;
            state <= S_Wait;
          end

          S_DoStep:begin
            if(cpu_step)begin
              state <= S_Wait;
              busy <= 0;
              clkctl <= 0;
            end
          end

          default:state <= S_Wait;

        endcase
      end
    end

endmodule
