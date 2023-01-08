read_vhdl -vhdl2008 { src/vhdl/top.vhd src/vhdl/ps_stub.vhd src/vhdl/pwm.vhd }

synth_design -top top -part xc7z010clg400-1
write_checkpoint -force top-synth.dcp
read_xdc src/constrs/ebaz4205.xdc
opt_design
place_design
route_design
write_checkpoint -force top-impl.dcp
write_bitstream -force ./top.bit
