--
-- File            :   vga_pix_symbol.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is vga unit for generating pixel, symbol and display position (based on SystemVerilog version)
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
use dsc.dsc_help_pkg.all;

entity vga_pix_symbol is
    generic
    (
        -- VGA timing constants 640*480
        -- Horizontal timing
        HVA     : integer := 640;   -- visible area
        HFP     : integer := 16;    -- front porch
        HSP     : integer := 96;    -- sync pulse
        HBP     : integer := 48;    -- back porch
        HWL     : integer := 800;   -- whole line
        -- Vertical timing
        VVA     : integer := 480;   -- visible area
        VFP     : integer := 10;    -- front porch
        VSP     : integer := 2;     -- sync pulse
        VBP     : integer := 33;    -- back porch
        VWF     : integer := 525    -- whole frame
    );
    port 
    (
        clk     : in    std_logic;                      -- clock
        resetn  : in    std_logic;                      -- reset
        en      : in    std_logic;                      -- enable module input
        pix_x   : out   std_logic_vector(2  downto 0);  -- x pixel position in the symbol
        pix_y   : out   std_logic_vector(3  downto 0);  -- y pixel position in the symbol
        sym_x   : out   std_logic_vector(6  downto 0);  -- symbol X number on the screen
        sym_y   : out   std_logic_vector(5  downto 0);  -- symbol Y number on the screen
        disp_x  : out   std_logic_vector(6  downto 0);  -- display x symbol positions
        disp_y  : out   std_logic_vector(13 downto 0)   -- display y symbol positions
    );
end vga_pix_symbol;

architecture rtl of vga_pix_symbol is
    signal line         : std_logic_vector(13 downto 0);    -- current line number [Y]
    signal sym_x_int    : std_logic_vector(9  downto 0);    -- symbol_x internal counter
    signal sym_y_int    : std_logic_vector(5  downto 0);    -- symbol_y internal counter
    signal pix_y_int    : std_logic_vector(3  downto 0);    -- y pixel position in the symbol (internal)
    signal disp_y_int   : std_logic_vector(13 downto 0);    -- display y symbol positions (internal)
begin 

    sym_x   <= sym_x_int(9 downto 3);
    disp_x  <= sym_x_int(9 downto 3);
    pix_x   <= line(2 downto 0);
    sym_y   <= sym_y_int;
    pix_y   <= pix_y_int;
    disp_y  <= disp_y_int;

    line_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            line <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en ) then
                line <= line + 1;
                if( line = HWL * 15 - 1 ) then 
                    line <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    sym_x_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            sym_x_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en ) then
                sym_x_int <= sym_x_int + 1;
                if( sym_x_int = HWL - 1 ) then 
                    sym_x_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    sym_y_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            sym_y_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en and bool2sl( line = HWL * 15 - 1 ) ) then
                sym_y_int <= sym_y_int + 1;
                if( sym_y_int = 34 ) then 
                    sym_y_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    pix_y_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            pix_y_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en and bool2sl( sym_x_int = HWL - 1 ) ) then
                pix_y_int <= pix_y_int + 1;
                if( pix_y_int = 14 ) then 
                    pix_y_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    disp_y_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            disp_y_int <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en and bool2sl( line = HWL * 15 - 1 ) ) then
                disp_y_int <= disp_y_int + 80;
                if( disp_y_int = 80 * 34 ) then 
                    disp_y_int <= (others => '0');
                end if;
            end if;
        end if;
    end process;

end rtl; -- vga_pix_symbol
