/*
*  File            :   vga.svh
*  Data            :   2018.12.24
*  Language        :   SystemVerilog
*  Description     :   This is vga constants
*  Copyright(c)    :   2018 - 2019
*                      Barsukov Dmitriy
*                      Vlasov Dmitriy
*                      Stanislav Zhelnio
*/

// VGA timing constants 640*480
// Horizontal timing
`define     HVA             640     // visible area
`define     HFP             16      // front porch
`define     HSP             96      // sync pulse
`define     HBP             48      // back porch
`define     HWL             800     // whole line
// Vertical timing
`define     VVA             480     // visible area
`define     VFP             10      // front porch
`define     VSP             2       // sync pulse
`define     VBP             33      // back porch
`define     VWF             525     // whole frame
