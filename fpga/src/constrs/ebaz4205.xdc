##### Ethernet MII #####
# set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports txclk]; # TXCLK
# create_clock -add -name txclk -period 40.00 [get_ports txclk];
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {txclk_IBUF}]
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {txclk_debug_OBUF}]
# set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports txen]; # TXEN
# set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {txd[0]}]; # TXD0
# set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {txd[1]}]; # TXD1
# set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {txd[2]}]; # TXD2
# set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {txd[3]}]; # TXD3

# set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports rxclk]; # RXCLK
# create_clock -add -name uart_clk -period 40.00 [get_ports rxclk];
# set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {rx_dv}]; # RXDV
# set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {rxd[0]}]; # RXD0
# set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {rxd[1]}]; # RXD1
# set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {rxd[2]}]; # RXD2
# set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {rxd[3]}]; # RXD3

# set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {mdc}]; # MDC
# set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {mdio}]; # MDIO

# set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports { }]; # Red LED
# set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports { }]; # Green LED

# set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports { }]; # J3-3
# set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports { }]; # J3-4
#
# set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports { }]; # J5-3
# set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports { }]; # J5-4
create_clock -add -name pwm_ref_clk -period 40.00 [get_nets pwm_ref_clk]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports rx ]; # DATA1-5
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports { pwm_out[0] } ]; # DATA1-6
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports reset ]; # DATA1-7
# set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA1-8
# set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA1-9
# set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA1-11
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports { uart_data[0] }]; # DATA1-13
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports { uart_data[1] }]; # DATA1-14
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports { uart_data[2] }]; # DATA1-15
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports { uart_data[3] }]; # DATA1-16
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports { uart_data[4] }]; # DATA1-17
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports { uart_data[5] }]; # DATA1-18
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports { uart_data[6] }]; # DATA1-19
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports { uart_data[7] }]; # DATA1-20
 
# set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-5
# set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-6
# set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-7
# set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-8
# set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-9
# set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-11
# set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-13
# set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-14
# set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-15
# set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-16
# set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-17
# set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-18
# set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-19
# set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA2-20

# set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-5
# set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-6
# set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-7
# set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-8
# set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-9
# set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-11
# set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-13
# set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-14
# set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-15
# set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-16
# set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-17
# set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-18
# set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-19
# set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports { }]; # DATA3-20
