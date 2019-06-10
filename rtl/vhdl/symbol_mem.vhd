--
-- File            :   symbol_mem.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is memory for symbols (based on SystemVerilog version)
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
use dsc.symbol_mem_pkg.all;

entity symbol_mem is
    port 
    (
        clk     : in    std_logic;                      -- clock
        ascii   : in    std_logic_vector(7 downto 0);   -- ascii symbol code
        pix_x   : in    std_logic_vector(2 downto 0);   -- x position of pixel in the symbol
        pix_y   : in    std_logic_vector(3 downto 0);   -- y position of pixel in the symbol
        bg_fg   : out   std_logic                       -- background or foreground enable
    );
end symbol_mem;

architecture rtl of symbol_mem is
    signal mem      :   mem_t(4095 downto 0)(7 downto 0) := symbol_mem_hex; -- glyph memory
    signal addr_m   :   std_logic_vector(11 downto 0);
begin
        
    addr_m <= ascii & pix_y;

    bg_fg_proc: process(clk)
    begin
        if( rising_edge(clk) ) then
            bg_fg <= mem( to_integer( unsigned( addr_m ) ) )( to_integer( unsigned( 7 - pix_x ) ) );
        end if;
    end process;

end rtl; -- symbol_mem
