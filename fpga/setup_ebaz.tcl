adapter speed 30000
init
targets zynq.cpu0
halt
# Deassert PROG_B
mem2array test 32 0xf8007000 1
set xdcfg [expr $test(0) | (1 << 30)]
zynq.cpu0 mww 0xf8007000 $xdcfg
# SLCR Unlock
zynq.cpu0 mww 0xF8000008 0xDF0D
# SLCR Level Shifter Enable
zynq.cpu0 mww 0xF8000900 0xA
pld load 0 top.bit
# SLCR Level Shifter Enable
zynq.cpu0 mww 0xF8000900 0xF
# SLCR Lock
zynq.cpu0 mww 0xF8000004 0x767B
exit
