/*
*  File            :   vga_pix_symbol.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is vga unit for generating pixel, symbol and display position
*  Copyright(c)    :   2018 Vlasov Dmitriy
*                           Barsukov Dmitriy
*                           Stanislav Zhelnio
*/

`include    "vga.svh"

module vga_pix_symbol
(
    input   logic               clk,    // clock
    input   logic               resetn, // reset
    input   logic               en,     // enable module input
    output  logic   [2  : 0]    pix_x,  // x pixel position in the symbol
    output  logic   [3  : 0]    pix_y,  // y pixel position in the symbol
    output  logic   [6  : 0]    sym_x,  // symbol X number on the screen
    output  logic   [5  : 0]    sym_y,  // symbol Y number on the screen
    output  logic   [6  : 0]    disp_x, // display x symbol positions
    output  logic   [13 : 0]    disp_y  // display y symbol positions
);

    logic  [13 : 0]  line;      // current line number [Y]
    logic  [9  : 0]  sym_x_int; // symbol_x internal counter

    assign sym_x = sym_x_int[3 +: 7];
    assign pix_x = line[0  +: 3];
    assign disp_x = sym_x;

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            line <= '0;
        else if( en )
        begin
            line <= line + 1'b1;
            if( line == `HWL * 15 - 1'b1 )
                line <= '0;
        end

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            sym_x_int <= '0;
        else if( en )
        begin
            sym_x_int <= sym_x_int + 1'b1;
            if( sym_x_int == `HWL - 1'b1 )
                sym_x_int <= '0;
        end
    
    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            pix_y <= '0;
        else if( ( sym_x_int == `HWL - 1'b1 ) && en )
        begin
            pix_y <= pix_y + 1'b1;
            if( pix_y == 'd14 )
                pix_y <= '0;
        end

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            disp_y <= '0;
        else if( ( line == `HWL * 15 - 1'b1 ) && en )
        begin
            disp_y <= disp_y + 'd80;
            if( disp_y == 'd80 * 'd34 )
                disp_y <= '0;
        end

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
            sym_y <= '0;
        else if( ( line == `HWL * 15 - 1'b1 ) && en )
        begin
            sym_y <= sym_y + 1'b1;
            if( sym_y == 'd34)
                sym_y <= '0;
        end

endmodule : vga_pix_symbol