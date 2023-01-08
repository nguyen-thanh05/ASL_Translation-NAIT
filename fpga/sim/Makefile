run_top_tb: elab_top_tb
	ghdl -r --std=08 top_tb --wave=top.ghw --stop-time=15ns

elab_top_tb: import_vhdl
	ghdl -m --std=08 top_tb

run_pwm_tb: elab_pwm_tb
	ghdl -r --std=08 pwm_tb --wave=pwm.ghw --stop-time=200us

elab_pwm_tb: import_vhdl
	ghdl -m --std=08 pwm_tb

run_uart_rx_tb: elab_uart_rx_tb
	ghdl -r --std=08 uart_rx_tb --wave=uart_rx.ghw --stop-time=200ns

elab_uart_rx_tb: import_vhdl
	ghdl -m --std=08 uart_rx_tb

import_vhdl:
	ghdl -i --std=08 ../src/vhdl/pwm.vhd
	ghdl -i --std=08 ../src/vhdl/uart_rx.vhd
	ghdl -i --std=08 ./*_tb.vhd

clean:
	rm -f work*.cf
