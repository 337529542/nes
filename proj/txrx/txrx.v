`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:33:11 07/19/2016
// Design Name:
// Module Name:    txrx
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
module txrx(
    input rst_n,
    input clk,
    output tx,
    input rx,
    output debug
    );



    wire [7:0] opcode;
    wire rxen;

    wire [7:0] txdata;
    wire txen;
    wire busy;

    wire [15:0] rPC;
    wire [7:0] rAC;
    wire [7:0] rSP;
    wire [7:0] rXR;
    wire [7:0] rYR;
    wire [7:0] rSR;
    wire cpu_step;
    wire cpu_clk;
    wire cpu_rst;
    wire ctl_stepmode;
    wire ctl_step;
    wire ctl_busy;
    wire ctl_rst;

    //bus
    wire [15:0] bAddr;
    wire [7:0] bRData;
    wire [7:0] bWData;
    wire bCmd;
    wire bRW;
    wire bFinish;

    wire [15:0] u1Addr;
    wire [7:0] u1RData;
    wire [7:0] u1WData;
    wire u1Cmd;
    wire u1RW;
    wire u1Finish;

    wire [15:0] u2Addr;
    wire [7:0] u2RData;
    wire [7:0] u2WData;
    wire u2Cmd;
    wire u2RW;
    wire u2Finish;

    //other
    wire [15:0] wr_bus_addr;


    assign debug = cpu_clk;

    //bus
    BusHub bushub1(.O_Addr(bAddr), .O_RData(bRData), .O_WData(bWData), .O_Cmd(bCmd), .O_RW(bRW), .O_Finish(bFinish), .clk(clk), .rst_n(rst_n)
                    ,.In1_Addr(u1Addr), .In1_RData(u1RData), .In1_WData(u1WData), .In1_Cmd(u1Cmd), .In1_RW(u1RW), .In1_Finish(u1Finish)
                    ,.In2_Addr(u2Addr), .In2_RData(u2RData), .In2_WData(u2WData), .In2_Cmd(u2Cmd), .In2_RW(u2RW), .In2_Finish(u2Finish));
    BUS bus1(.Addr(bAddr), .RData(bRData), .WData(bWData), .Cmd(bCmd), .RW(bRW), .Finish(bFinish), .clk(clk), .rst_n(rst_n));

    //outside
    cy_tx tx1(.rst_n(rst_n), .clk(clk), .data(txdata), .en(txen), .busy(busy), .tx(tx));
    cy_rx rx1(.rst_n(rst_n), .clk(clk), .data(opcode), .en(rxen), .rx(rx));
    CPU cpu1(.rst_n(rst_n), .clk(cpu_clk), .r_PC(rPC), .r_AC(rAC), .r_SP(rSP), .r_XR(rXR), .r_YR(rYR), .r_SR(rSR), .Step(cpu_step), .soft_rst(cpu_rst));

    cpu_clk_ctl cpu_clk_ctl1(.rst_n(rst_n), .ctl_stepmode(ctl_stepmode), .ctl_step(ctl_step), .clk_in(clk), .clk_cpu(cpu_clk)
                              , .ctl_busy(ctl_busy), .ctl_rst(ctl_rst), .cpu_step(cpu_step), .cpu_rst(cpu_rst));

    //wr_ping 0001 xxxx
    wire [7:0]wr_ping_data;
    wire wr_ping_en;
    wr_ping wr_ping_1(.rst_n(rst_n), .clk(clk), .opcode(opcode), .en(rxen), .tx_busy(busy), .tx_en(wr_ping_en), .tx_data(wr_ping_data));

    //wr_reg_read 0010 xxxx
    wire [7:0]wr_reg_read_data;
    wire wr_reg_read_en;
    wr_reg_read wr_reg_read_1(.rst_n(rst_n), .clk(clk), .opcode(opcode), .en(rxen), .tx_busy(busy), .tx_en(wr_reg_read_en), .tx_data(wr_reg_read_data)
                              , .PC(rPC), .AC(rAC), .SP(rSP), .XR(rXR), .YR(rYR), .SR(rSR));

    //wr_cpu_ctl 0000 xxxx
    wire [7:0]wr_cpu_ctl_data;
    wire wr_cpu_ctl_en;

    wr_cpu_ctl wr_cpu_ctl_1(.rst_n(rst_n), .clk(clk), .ctl_stepmode(ctl_stepmode), .ctl_step(ctl_step), .ctl_busy(ctl_busy), .ctl_rst(ctl_rst), .opcode(opcode)
                            , .en(rxen), .tx_busy(busy), .tx_en(wr_cpu_ctl_en), .tx_data(wr_cpu_ctl_data));

    //wr_bus_addr
    wire [7:0]wr_bus_addr_data;
    wire wr_bus_addr_en;
    wr_bus_addr wr_bus_addr_1(.rst_n(rst_n), .clk(clk), .opcode(opcode), .en(rxen), .tx_busy(busy), .tx_en(wr_bus_addr_en), .tx_data(wr_bus_addr_data)
                              , .addr(wr_bus_addr));

    //wr_bus_data
    wire [7:0]wr_bus_data_data;
    wire wr_bus_data_en;
    wr_bus_data wr_bus_data_1(.rst_n(rst_n), .clk(clk), .opcode(opcode), .en(rxen), .tx_busy(busy), .tx_en(wr_bus_data_en), .tx_data(wr_bus_data_data)
                              , .addr(wr_bus_addr), .bus_Addr(u1Addr), .bus_RData(u1RData), .bus_WData(u1WData), .Cmd(u1Cmd), .RW(u1RW), .Finish(u1Finish));


    assign txen = wr_ping_en | wr_reg_read_en | wr_cpu_ctl_en | wr_bus_addr_en | wr_bus_data_en | 0;
    assign txdata = wr_ping_en ? wr_ping_data :
                    wr_reg_read_en ? wr_reg_read_data :
                    wr_cpu_ctl_en ? wr_cpu_ctl_data :
                    wr_bus_addr_en ? wr_bus_addr_data :
                    wr_bus_data_en ? wr_bus_data_data :
                    0;

    //reg [7:0] data = 0;
    //wire busy;
    //wire [7:0] rxdata;
    //wire rxen;
    //reg en = 0;
    //reg todo = 0;

    //cy_tx tx1(.rst_n(rst_n), .clk(clk), .data(data), .en(en), .busy(busy), .tx(tx));
    //cy_rx rx1(.rst_n(rst_n), .clk(clk), .data(rxdata), .en(rxen), .rx(rx));

    /*always @ (posedge clk) begin
      if(!rst_n) begin
        data <= 0;
        en <= 0;
        todo <= 0;
      end else begin
        if(rxen) begin //接收数据
          data <= rxdata;
          todo <= 1;
        end

        if(busy) begin
          en <= 0;
        end else if(todo == 1) begin
          en <= 1;
          todo <= 0;
        end
      end
    end*/

    //循环发送数据
    /*always @ (posedge clk) begin
      if(!rst_n) begin
        data <= 0;
        en <= 0;
      end else begin
        if(busy) begin
          en <= 0;
        end else begin
          en <= 1;
          data <= data + 1;
        end
      end
    end*/

endmodule
