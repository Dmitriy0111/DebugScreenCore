/*
*  File            :   vga_top.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is vga top module
*  Copyright(c)    :   2018 Vlasov Dmitriy
*                           Barsukov Dmitriy
*                           Stanislav Zhelnio
*/

`include    "vga.svh"

module vga_top
(
    input   logic               clk,        // clock
    input   logic               resetn,     // reset
    input   logic               en,         // enable input
    output  logic               hsync,      // hsync output
    output  logic               vsync,      // vsync output
    input   logic   [11 : 0]    bgColor,    // background color in format: RRRRGGGGBBBB, MSB first
    input   logic   [11 : 0]    fgColor,    // foreground color in format: RRRRGGGGBBBB, MSB first
    input   logic   [31 : 0]    regData,    // register data input from cpu
    output  logic   [4  : 0]    regAddr,    // register addr output to cpu
    output  logic   [3  : 0]    R,          // R-color
    output  logic   [3  : 0]    G,          // G-color
    output  logic   [3  : 0]    B           // B-color
);

    logic   [2  : 0]    pix_x;          // current pixel x position in symbol memory
    logic   [3  : 0]    pix_y;          // current pixel y position in symbol memory
    logic   [6  : 0]    sym_x;          // current symbol position x
    logic   [5  : 0]    sym_y;          // current symbol position y
    logic   [6  : 0]    disp_x;         // to display memory x position
    logic   [13 : 0]    disp_y;         // to display memory y position
    logic               bg_fg;          // current pixel is background 
    logic   [7  : 0]    ascii_regData;  // symbol from cpu
    logic   [7  : 0]    ascii_display;  // symbol from display memory
    logic   [3  : 0]    bin;            // enable one tetrad from regData
    logic   [7  : 0]    sym_ascii;      // current symbol code

    assign  bin = regData >> ( 28 - ( sym_x - `REG_VALUE_POS ) * 4 );
    assign  regAddr = sym_y;
    assign  ascii_regData = ( bin <= "9" ) ? bin + "0" : bin - 10 + "A";    // binary to ascii convertion

    assign  { R, G, B } =   ( ( sym_x < 'd80 ) && ( sym_y < 'd32 ) ) ? // symbol in visible area ?
                            ( bg_fg ? fgColor : bgColor ) :
                            12'h000;

    assign  sym_ascii = ( ( sym_x >= `REG_VALUE_POS ) && ( sym_x < `REG_VALUE_POS + `REG_VALUE_WIDTH ) ) ? // symbol is register value ?
                        ascii_regData :
                        ascii_display;
    // creating one vga pixel symbol number generator
    vga_pix_symbol vga_pix_symbol_0
    (
        .clk    ( clk               ),  // clock
        .resetn ( resetn            ),  // reset
        .en     ( en                ),  // enable
        .pix_x  ( pix_x             ),  // x pixel position in the symbol
        .pix_y  ( pix_y             ),  // y pixel position in the symbol
        .sym_x  ( sym_x             ),  // symbol x number on the screen
        .sym_y  ( sym_y             ),  // symbol y number on the screen
        .disp_x ( disp_x            ),  // display x symbol position
        .disp_y ( disp_y            )   // display y symbol position
    );
    // creating one symbol memory
    symbol_mem symbol_mem_0
    (
        .clk    ( clk               ),  // clock
        .ascii  ( sym_ascii         ),  // ascii symbol code
        .pix_x  ( pix_x             ),  // x pixel position in the symbol
        .pix_y  ( pix_y             ),  // y pixel position in the symbol
        .bg_fg  ( bg_fg             )   // background or foreground enable
    );
    //creating one display memory
    display_mem display_mem_0
    (
        .disp_x ( disp_x            ),  // display x symbol position
        .disp_y ( disp_y            ),  // display y symbol position
        .ascii  ( ascii_display     )   // current symbol from display in ascii
    );
    // creating one vga signal unit
    vga_signal vga_signal_0
    (
        .clk    ( clk               ),  // clock
        .resetn ( resetn            ),  // reset
        .en     ( en                ),  // enable
        .hsync  ( hsync             ),  // hsync output
        .vsync  ( vsync             )   // vsync output
    );

endmodule : vga_top