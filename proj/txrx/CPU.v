`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    09:27:30 07/20/2016
// Design Name:
// Module Name:    CPU
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
module CPU(
    output [15:0] r_PC,
    output [7:0] r_AC,
    output [7:0] r_SP,
    output [7:0] r_XR,
    output [7:0] r_YR,
    output [7:0] r_SR,
    input clk,
    input rst_n,
    input soft_rst,
    output Step
    );

    assign r_PC = 16'h6789;
    assign r_AC = 8'hA1;
    assign r_SP = 8'hB2;
    assign r_XR = 8'hC3;
    assign r_YR = 8'hD4;
    assign r_SR = 8'hE5;
    assign Step = 1;


endmodule
