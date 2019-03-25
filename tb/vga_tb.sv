/*
*  File            :   vga_tb.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is small testbench file
*  Copyright(c)    :   2018 - 2019
*                      Barsukov Dmitriy
*                      Vlasov Dmitriy
*                      Stanislav Zhelnio
*/

module vga_tb();

    timeprecision       1ns;
    timeunit            1ns;

    parameter           T = 10;
    parameter           rst_delay = 7;
    parameter           background = 12'h00f;
    parameter           foreground = 12'hf00;

    bit     [0  : 0]    clk;
    bit     [0  : 0]    resetn;
    logic   [0  : 0]    hsync;
    logic   [0  : 0]    vsync;
    logic   [3  : 0]    R;
    logic   [3  : 0]    G;
    logic   [3  : 0]    B;
    logic   [4  : 0]    regAddr;
    logic   [31 : 0]    regData;
    bit     [31 : 0]    test_mem [31 : 0];

    assign regData = test_mem[regAddr];

    vga_debug_screen_50MHz
    #(
        .bgColor    ( background    ),
        .fgColor    ( foreground    )
    )
    vga_debug_screen_50MHz_0
    (
        .clk        ( clk           ),  // clock
        .resetn     ( resetn        ),  // reset
        .hsync      ( hsync         ),  // hsync output
        .vsync      ( vsync         ),  // vsync output
        .regData    ( regData       ),  // Register data input from cpu
        .regAddr    ( regAddr       ),  // Register data output to cpu
        .R          ( R             ),  // R-color
        .G          ( G             ),  // G-color
        .B          ( B             )   // B-color
    );

    initial 
    begin
        forever 
            #(T/2) clk = ~ clk;
    end

    initial 
    begin 
        repeat(rst_delay) @(posedge clk);
        resetn <= '1;
    end

    initial
    begin
        foreach( test_mem[i] )
            test_mem[i] = $random;
    end

    initial
    begin
        forever
        begin
            @(posedge vsync);
            $stop;
        end
    end
    
    integer file;

    initial
    begin
        file = $fopen("../log","w");
        fork
            forever
            begin
                if( ( hsync == '1 ) && ( { R , G , B } != '0 ) )
                begin
                    $fwrite(file, "%s", ( { R , G , B } == background ) ? " " : ( { R , G , B } == foreground ) ? "#" : "" );
                end
                    @(negedge clk);
                    @(negedge clk);
            end
            forever
            begin
                @(negedge hsync);
                $fwrite(file,"\n");
            end
        join
    end
    
endmodule : vga_tb
