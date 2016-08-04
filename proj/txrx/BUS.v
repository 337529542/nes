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
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module BUS(
    input [15:0] Addr,
    output [7:0] RData,
    input [7:0] WData,
    input Cmd,
    input RW,
    output Finish,
    input clk,
    input rst_n
    );

    BUS_RAM_2k RAM1(.Addr(Addr), .RData(RData), .WData(WData), .Cmd(Cmd), .RW(RW), .Finish(Finish), .clk(clk), .rst_n(rst_n));


endmodule
