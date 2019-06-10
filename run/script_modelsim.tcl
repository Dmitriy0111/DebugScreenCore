set test "sv"
set test "vhdl"

vlib work

if {$test == "vhdl"} {

    vcom -2008 ../inc/vhdl/*.vhd        -work dsc
    vcom -2008 ../vga_mem/vhdl/*.vhd    -work dsc

    vcom -2008  ../rtl/vhdl/*.vhd

} elseif {$test == "sv"} {

    vlog -sv ../rtl/sv/*.*v 

}

vlog ../tb/vga_tb.sv

vsim -novopt work.vga_tb

add wave sim:/vga_tb/vga_debug_screen_50MHz_0/*

run -all

wave zoom full
