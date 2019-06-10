/*
*  File            :   vga_signal.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is vga unit for generating hsync and vsync signal's
*  Copyright(c)    :   2018 - 2019
*                      Barsukov Dmitriy
*                      Vlasov Dmitriy
*                      Stanislav Zhelnio
*/

`include    "../../inc/sv/vga.svh"

module vga_signal
(
    input   logic   [0  : 0]    clk,    // clock
    input   logic   [0  : 0]    resetn, // reset
    input   logic   [0  : 0]    en,     // enable
    output  logic   [0  : 0]    hsync,  // hsync output
    output  logic   [0  : 0]    vsync   // vsync output
);

    logic   [9 : 0]     hsync_c;    // hsync counter
    logic   [9 : 0]     vsync_c;    // vsync counter

    assign  hsync = ( hsync_c < ( `HVA + `HFP ) ) || ( hsync_c >= ( `HVA + `HFP + `HSP ) ),
            vsync = ( vsync_c < ( `VVA + `VFP ) ) || ( vsync_c >= ( `VVA + `VFP + `VSP ) );

    always_ff @(posedge clk, negedge resetn)
        if( !resetn )
        begin
            hsync_c <= '0;
            vsync_c <= '0;
        end
        else 
        begin
            if( en )
            begin
                hsync_c <= hsync_c + 1'b1;
                if( hsync_c == `HWL - 1'b1 )
                begin
                    hsync_c <= '0;
                    vsync_c <= vsync_c + 1'b1;
                end
                else if( vsync_c == `VWF )
                begin
                    vsync_c <= '0;
                end
            end
        end

endmodule : vga_signal
