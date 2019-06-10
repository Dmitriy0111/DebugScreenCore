/*
*  File            :   display_mem.sv
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is memory for display
*  Copyright(c)    :   2018 - 2019
*                      Barsukov Dmitriy
*                      Vlasov Dmitriy
*                      Stanislav Zhelnio
*/

module display_mem
#(
    parameter                   path2dm = "insert path to display_mem_*.hex" // path to display mem
)(
    input   logic   [6  : 0]    disp_x,  // display x symbol position
    input   logic   [13 : 0]    disp_y,  // display y symbol position
    output  logic   [7  : 0]    ascii    // ascii value of display symbol
);

    logic [7 : 0] mem [2560-1 : 0]; // display memory

    assign ascii = mem[ disp_x + disp_y ];

    initial // loading display memory
        $readmemh(path2dm, mem);

endmodule : display_mem
