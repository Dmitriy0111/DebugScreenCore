set test "sv"
set test "vhdl"

vlib work

if {$test == "vhdl"} {

    vcom -2008 ../inc/vhdl/dsc_help_pkg.vhd     -work dsc
    vcom -2008 ../inc/vhdl/dsc_mem_pkg.vhd      -work dsc
    vcom -2008 ../inc/vhdl/dsc_components.vhd   -work dsc
    vcom -2008 ../vga_mem/vhdl/*.vhd            -work dsc

    vcom -2008  ../rtl/vhdl/*.vhd

} elseif {$test == "sv"} {

    vlog -sv ../rtl/sv/*.*v 

}

vlog ../tb/vga_tb.sv

vsim -novopt work.vga_tb

add wave sim:/vga_tb/vga_debug_screen_50MHz_0/*

set StdArithNoWarnings 1
set NumericStdNoWarnings 1

run -all

wave zoom full
