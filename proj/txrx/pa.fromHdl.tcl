
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name txrx -dir "E:/nes/s1/proj/txrx/planAhead_run_4" -part xc6slx9tqg144-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "txrx.ucf" [current_fileset -constrset]
add_files [list {ipcore_dir/RAM_2k.ngc}]
set hdlfile [add_files [list {ipcore_dir/RAM_2k.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {BUS_RAM_2k.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {wr_reg_read.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {wr_ping.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {wr_cpu_ctl.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {wr_bus_data.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {wr_bus_addr.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {cy_tx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {cy_rx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {cpu_clk_ctl.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {CPU.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {BusHub.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {BUS.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {txrx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top txrx $srcset
add_files [list {txrx.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/RAM_2k.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9tqg144-2
