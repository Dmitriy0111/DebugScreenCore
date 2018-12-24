module vga_tb();

    timeprecision   1ns;
    timeunit        1ns;

    parameter       T = 10;
    parameter       rst_delay = 7;

    bit                 clk;
    bit                 resetn;
    logic               hsync;
    logic               vsync;
    logic   [3 : 0]     R;
    logic   [3 : 0]     G;
    logic   [3 : 0]     B;

    vga_debug_screen
    #(
        .bgColor    ( 12'h00f   ),
        .fgColor    ( 12'hf00   )
    )
    vga_debug_screen_0
    (
        .clk        ( clk       ),  // clock
        .resetn     ( resetn    ),  // reset
        .hsync      ( hsync     ),  // hsync output
        .vsync      ( vsync     ),  // vsync output
        .regData    ( 'h12345678   ),  // Register data input from cpu
        .regAddr    ( regAddr   ),  // Register data output to cpu
        .R          ( R         ),  // R-color
        .G          ( G         ),  // G-color
        .B          ( B         )   // B-color
    );

    initial begin
        forever begin
            #(T/2) clk = ~ clk;
        end
    end

    initial begin 
        repeat(rst_delay) @(posedge clk);
        resetn <= '1;
    end

endmodule : vga_tb