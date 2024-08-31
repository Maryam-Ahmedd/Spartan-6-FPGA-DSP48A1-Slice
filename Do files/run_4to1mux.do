vlib work
vlog 4to1_mux.v 4to1_mux_tb.v 
vsim -voptargs=+acc work.mux4to1_tb 
add wave *
run -all
#quit -sim