--
-- File            :   dsc_mem_pkg.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is memory package
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dsc_mem_pkg is

    type    mem_t is array (natural range<>) of std_logic_vector; 

    function mem_init( in_mem : mem_t ; mem_depth : integer ) return mem_t;

end package dsc_mem_pkg;

package body dsc_mem_pkg is

    function mem_init( in_mem : mem_t ; mem_depth : integer ) return mem_t is
        variable mem_ret : mem_t(mem_depth-1 downto 0)(7 downto 0) := ( others => X"XX" );
    begin
        mem_ret(in_mem'range) := in_mem;
        return mem_ret;
    end function; -- mem_i

end dsc_mem_pkg;