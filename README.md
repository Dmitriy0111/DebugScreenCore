# DebugScreenCore

## DebugScreenCore ( VGA 640 * 480 60 Hz )
vga_top is top module DebugScreenCore

### Clock, reset, enable input's:
*   clk for connecting clock from pll (25.175 MHz) or from input FPGA pin 50 Mhz or 100 MHz;
*   resetn for connecting reset pin;
*   en is enable input. When clk input is connected from pll, en must be 1. When clk is connected from input FPGA pin (50 or 100 MHz), en input must be toggle.
### VGA signal's:
*   hsync is output pin horisontal synchronization;
*   vsync is output pin vertical synchronization;
*   R is output pin for connecting to R color VGA;
*   G is output pin for connecting to G color VGA;
*   B is output pin for connecting to B color VGA.
### Core side scanning signals:
*   regAddr is output bus for scanning register file;
*   regData is input bus for scanning value from register file.
### Color of foreground (symbol's) and background:
*   bgColor defined background color;
*   fgColor defined foreground color (symbol's color).

Example of connection vga_top described in vga_debug_screen.sv file.
