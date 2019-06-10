--
-- File            :   display_mem.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is memory for display (based on SystemVerilog version)
-- Copyright(c)    :   2019
--                     Barsukov Dmitriy
--                     Vlasov Dmitriy
--                     Stanislav Zhelnio
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library dsc;
use dsc.dsc_mem_pkg.all;

entity display_mem is
    generic
    (
        mem_i   : mem_t                                 -- init memory
    );
    port 
    (
        disp_x  : in    std_logic_vector(6  downto 0);  -- display x symbol position
        disp_y  : in    std_logic_vector(13 downto 0);  -- display y symbol position
        ascii   : out   std_logic_vector(7  downto 0)   -- ascii value of display symbol
    );
end display_mem;

architecture rtl of display_mem is
    signal mem      :   mem_t(4095 downto 0)(7 downto 0) := mem_init(mem_i, 4096);  -- display memory
    signal addr_m   :   std_logic_vector(13 downto 0);
begin
        
    addr_m <= disp_x + disp_y;

    ascii <= mem( to_integer( unsigned( addr_m ) ) );

end rtl; -- display_mem
