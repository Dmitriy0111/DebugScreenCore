
# create modelsim working library
vlib work

# compile all the Verilog sources
vlog -sv ../rtl/*.*v 
vlog -sv ../tb/*.*v 

# open the testbench module for simulation
vsim -novopt work.vga_tb

# add all testbench signals to time diagram
add wave sim:/vga_tb/vga_debug_screen_50MHz_0/*

# run the simulation
run -all

# expand the signals time diagram
wave zoom full
