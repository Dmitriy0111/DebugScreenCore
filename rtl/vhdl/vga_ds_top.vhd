--
-- File            :   vga_ds_top.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is vga top module (based on SystemVerilog version)
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
use dsc.display_mem_nanoFOX_pkg.all;
use dsc.display_mem_schoolMIPS_pkg.all;
use dsc.dsc_components.all;

entity vga_ds_top is
    generic
    (
        cpu         : string := "nanoFOX";
        sub_path    : string := ""
    );
    port 
    (
        clk         : in    std_logic;                      -- clock
        resetn      : in    std_logic;                      -- reset
        en          : in    std_logic;                      -- enable input
        hsync       : out   std_logic;                      -- hsync output
        vsync       : out   std_logic;                      -- vsync output
        bgColor     : in    std_logic_vector(11 downto 0);  -- background color
        fgColor     : in    std_logic_vector(11 downto 0);  -- foreground color
        regData     : in    std_logic_vector(31 downto 0);  -- register data input from cpu
        regAddr     : out   std_logic_vector(4  downto 0);  -- register addr output to cpu
        R           : out   std_logic_vector(3  downto 0);  -- R-color
        G           : out   std_logic_vector(3  downto 0);  -- G-color
        B           : out   std_logic_vector(3  downto 0)   -- B-color
    );
end vga_ds_top;

architecture rtl of vga_ds_top is
    constant REG_VALUE_WIDTH    : integer := 8;

    function mem_sel( cpu_v : string ) return mem_t is
        variable mem_ret : mem_t(2559 downto 0)(7 downto 0) := ( others => X"XX" );
    begin
        if( cpu = "nanoFOX" ) then
            mem_ret := display_mem_nanoFOX_hex;
        elsif( cpu = "schoolMIPS" ) then
            mem_ret := display_mem_schoolMIPS_hex;
        end if;
        return mem_ret;
    end function; -- mem_sel
    
    constant mem_disp_i     : mem_t(2559 downto 0)(7 downto 0) := mem_sel( cpu );   -- display memory;

    signal pix_x            : std_logic_vector(2  downto 0);    -- current pixel x position in symbol memory
    signal pix_y            : std_logic_vector(3  downto 0);    -- current pixel y position in symbol memory
    signal sym_x            : std_logic_vector(6  downto 0);    -- current symbol position x
    signal sym_y            : std_logic_vector(5  downto 0);    -- current symbol position y
    signal disp_x           : std_logic_vector(6  downto 0);    -- to display memory x position
    signal disp_y           : std_logic_vector(13 downto 0);    -- to display memory y position
    signal bg_fg            : std_logic;                        -- current pixel is background 
    signal ascii_regData    : std_logic_vector(7  downto 0);    -- symbol from cpu
    signal ascii_display    : std_logic_vector(7  downto 0);    -- symbol from display memory
    signal bin_f            : std_logic_vector(31 downto 0);    -- full bin
    signal bin              : std_logic_vector(3  downto 0);    -- enable one tetrad from regData
    signal sym_ascii        : std_logic_vector(7  downto 0);    -- current symbol code
begin

    bin_gen : 
    if( cpu = "nanoFOX" ) generate
        bin_f <= std_logic_vector( shift_right( unsigned( regData ) , to_integer( unsigned( 28 - ( ( sym_x - 10 ) & "00" ) ) ) ) );
    elsif( cpu = "schoolMIPS" ) generate
        bin_f <= std_logic_vector( shift_right( unsigned( regData ) , to_integer( unsigned( 28 - ( ( sym_x - 6  ) & "00" ) ) ) ) );
    else generate
        bin_f <= std_logic_vector( shift_right( unsigned( regData ) , to_integer( unsigned( 28 - ( ( sym_x - 0  ) & "00" ) ) ) ) );
    end generate;

    bin <= bin_f(3 downto 0);

    regAddr <= sym_y(4 downto 0);
    ascii_regData <= ( 4X"0" & bin ) + 8X"30" when ( bin <= 4X"9") else ( 4X"0" & bin ) + 8X"41" - 10;   -- binary to ascii convertion

    R <= 4X"0" when ( not ( ( sym_x < 80 ) and ( sym_y < 32 ) ) ) else fgColor(11 downto 8) when bg_fg else bgColor(11 downto 8);
    G <= 4X"0" when ( not ( ( sym_x < 80 ) and ( sym_y < 32 ) ) ) else fgColor(7  downto 4) when bg_fg else bgColor(7  downto 4);
    B <= 4X"0" when ( not ( ( sym_x < 80 ) and ( sym_y < 32 ) ) ) else fgColor(3  downto 0) when bg_fg else bgColor(3  downto 0);

    sym_ascii_gen : 
    if( cpu = "nanoFOX" ) generate
        sym_ascii <= ascii_regData when( ( sym_x >= 10 ) and ( sym_x < 10 + REG_VALUE_WIDTH ) ) else ascii_display;
    elsif( cpu = "schoolMIPS" ) generate
        sym_ascii <= ascii_regData when( ( sym_x >= 6  ) and ( sym_x < 6  + REG_VALUE_WIDTH ) ) else ascii_display;
    else generate
        sym_ascii <= ascii_regData when( ( sym_x >= 0  ) and ( sym_x < 0  + REG_VALUE_WIDTH ) ) else ascii_display;
    end generate;
         
    -- creating one vga pixel symbol number generator
    vga_pix_symbol_0 : vga_pix_symbol 
    port map
    (
        clk     => clk,         -- clock
        resetn  => resetn,      -- reset
        en      => en,          -- enable
        pix_x   => pix_x,       -- x pixel position in the symbol
        pix_y   => pix_y,       -- y pixel position in the symbol
        sym_x   => sym_x,       -- symbol x number on the screen
        sym_y   => sym_y,       -- symbol y number on the screen
        disp_x  => disp_x,      -- display x symbol position
        disp_y  => disp_y       -- display y symbol position
    );
    -- creating one symbol memory
    symbol_mem_0 : symbol_mem 
    port map
    (
        clk     => clk,         -- clock
        ascii   => sym_ascii,   -- ascii symbol code
        pix_x   => pix_x,       -- x pixel position in the symbol
        pix_y   => pix_y,       -- y pixel position in the symbol
        bg_fg   => bg_fg        -- background or foreground enable
    );
    --creating one display memory
    display_mem_0 : display_mem 
    generic map
    (
        mem_i   => mem_disp_i
    )
    port map
    (
        disp_x  => disp_x,          -- display x symbol position
        disp_y  => disp_y,          -- display y symbol position
        ascii   => ascii_display    -- current symbol from display in ascii
    );
    -- creating one vga signal unit
    vga_signal_0 : vga_signal 
    port map
    (
        clk     => clk,     -- clock
        resetn  => resetn,  -- reset
        en      => en,      -- enable
        hsync   => hsync,   -- hsync output
        vsync   => vsync    -- vsync output
    );

end rtl; -- vga_ds_top
