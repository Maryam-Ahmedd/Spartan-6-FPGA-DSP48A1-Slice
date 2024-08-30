vlib work
vlog registered_or_notRegistered_mux.v reg_or_notReg_mux_tb.v 
vsim -voptargs=+acc work.reg_notReg_tb 
add wave *
run -all
#quit -sim