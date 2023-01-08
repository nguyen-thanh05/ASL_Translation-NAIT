read_vhdl -vhdl2008 { }
# read_verilog { }

synth_design -top top -part xc7z010clg400-1
read_xdc src/constrs/ebaz4205.xdc
opt_design
place_design
route_design
write_bitstream -force ./top.bit
