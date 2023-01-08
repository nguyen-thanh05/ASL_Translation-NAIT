run_top_tb: elab_top_tb
	ghdl -r --std=08 top_tb --wave=top.ghw --stop-time=15ns

elab_top_tb: import_vhdl
	ghdl -m --std=08 top_tb


import_vhdl:
	ghdl -i --std=08 ../src/vhdl/top.vhd
	ghdl -i --std=08 ./*_tb.vhd

clean:
	rm -f work*.cf
