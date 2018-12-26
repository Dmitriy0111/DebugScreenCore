/*
*  File            :   symbol_mem.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is memory for symbols
*  Copyright(c)    :   2018 - 2019
*                      Barsukov Dmitriy
*                      Vlasov Dmitriy
*                      Stanislav Zhelnio
*/

module symbol_mem
(
    input   logic               clk,    // clock
    input   logic   [7 : 0]     ascii,  // ascii symbol code
    input   logic   [2 : 0]     pix_x,  // x position of pixel in the symbol
    input   logic   [3 : 0]     pix_y,  // y position of pixel in the symbol
    output  logic               bg_fg   // background or foreground enable
);
    
    logic [7 : 0] mem [4096-1 : 0]; // glyph memory

    always_ff @(posedge clk)
        bg_fg <= mem[ { ascii, pix_y } ][7-pix_x];  //[7-pix_x]; for testing and Xilinx
                                                    //[pix_x]; for Altera

    initial // loading glyph memory table
        $readmemh("../vga_mem/symbol_mem.hex", mem); //4095,0); for Altera
                                                            //); for testing and Xilinx

endmodule : symbol_mem
