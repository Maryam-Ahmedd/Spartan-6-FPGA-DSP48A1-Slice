vlib work
vlog DSP48A1.v DSP48A1_tb.v 
vsim -voptargs=+acc work.tb_DSP48A1 
add wave *
run -all
#quit -sim

