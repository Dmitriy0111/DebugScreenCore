--
-- File            :   vga_debug_screen.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is vga debug screen unit (based on SystemVerilog version)
-- Copyright(c)    :   2019
--                     Barsukov Dmitriy
--                     Vlasov Dmitriy
--                     Stanislav Zhelnio
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_debug_screen_50MHz is
    generic
    (
        bgColor : std_logic_vector(11 downto 0) := 12X"00f";
        fgColor : std_logic_vector(11 downto 0) := 12X"f00"
    );
    port 
    (
        clk     : in   std_logic;                       -- clock 
        resetn  : in   std_logic;                       -- reset
        hsync   : out  std_logic;                       -- hsync output
        vsync   : out  std_logic;                       -- vsync output
        regData : in   std_logic_vector(31 downto 0);   -- Register data input from cpu
        regAddr : out  std_logic_vector(4  downto 0);   -- Register data output to cpu
        R       : out  std_logic_vector(3  downto 0);   -- R-color
        G       : out  std_logic_vector(3  downto 0);   -- G-color
        B       : out  std_logic_vector(3  downto 0)    -- B-color
    );
end vga_debug_screen_50MHz;

architecture rtl of vga_debug_screen_50MHz is
    constant cpu    : string := "nanoFOX";
    signal en   : std_logic;
    -- vga_ds_top
    component vga_ds_top
        generic
        (
            cpu     : string := "nanoFOX"
        );
        port 
        (
            clk     : in    std_logic;                      -- clock
            resetn  : in    std_logic;                      -- reset
            en      : in    std_logic;                      -- enable input
            hsync   : out   std_logic;                      -- hsync output
            vsync   : out   std_logic;                      -- vsync output
            bgColor : in    std_logic_vector(11 downto 0);  -- background color
            fgColor : in    std_logic_vector(11 downto 0);  -- foreground color
            regData : in    std_logic_vector(31 downto 0);  -- register data input from cpu
            regAddr : out   std_logic_vector(4  downto 0);  -- register addr output to cpu
            R       : out   std_logic_vector(3  downto 0);  -- R-color
            G       : out   std_logic_vector(3  downto 0);  -- G-color
            B       : out   std_logic_vector(3  downto 0)   -- B-color
        );
    end component;
begin
        
    en_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            en <= '0';
        elsif( rising_edge(clk) ) then
            en <= not en;
        end if;
    end process;

    vga_ds_top_0 : vga_ds_top 
    generic map
    (
        cpu     => cpu
    )
    port map
    (
        clk     => clk,     -- clock
        resetn  => resetn,  -- reset
        en      => en,      -- enable input
        hsync   => hsync,   -- hsync output
        vsync   => vsync,   -- vsync output
        bgColor => bgColor, -- Background color
        fgColor => fgColor, -- Foreground color
        regData => regData, -- Register data input from cpu
        regAddr => regAddr, -- Register data output to cpu
        R       => R,       -- R-color
        G       => G,       -- G-color
        B       => B        -- B-color
    );

end rtl; -- vga_debug_screen_50MHz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_debug_screen_pll_25_175MHz is
    generic
    (
        bgColor : std_logic_vector(11 downto 0) := 12X"00f";
        fgColor : std_logic_vector(11 downto 0) := 12X"f00"
    );
    port 
    (
        clk     : in   std_logic;                       -- clock 
        resetn  : in   std_logic;                       -- reset
        hsync   : out  std_logic;                       -- hsync output
        vsync   : out  std_logic;                       -- vsync output
        regData : in   std_logic_vector(31 downto 0);   -- Register data input from cpu
        regAddr : out  std_logic_vector(4  downto 0);   -- Register data output to cpu
        R       : out  std_logic_vector(3  downto 0);   -- R-color
        G       : out  std_logic_vector(3  downto 0);   -- G-color
        B       : out  std_logic_vector(3  downto 0)    -- B-color
    );
end vga_debug_screen_pll_25_175MHz;

architecture rtl of vga_debug_screen_pll_25_175MHz is
    constant cpu    : string := "nanoFOX";
    -- vga_ds_top
    component vga_ds_top
        generic
        (
            cpu     : string := "nanoFOX"
        );
        port 
        (
            clk     : in    std_logic;                      -- clock
            resetn  : in    std_logic;                      -- reset
            en      : in    std_logic;                      -- enable input
            hsync   : out   std_logic;                      -- hsync output
            vsync   : out   std_logic;                      -- vsync output
            bgColor : in    std_logic_vector(11 downto 0);  -- background color
            fgColor : in    std_logic_vector(11 downto 0);  -- foreground color
            regData : in    std_logic_vector(31 downto 0);  -- register data input from cpu
            regAddr : out   std_logic_vector(4  downto 0);  -- register addr output to cpu
            R       : out   std_logic_vector(3  downto 0);  -- R-color
            G       : out   std_logic_vector(3  downto 0);  -- G-color
            B       : out   std_logic_vector(3  downto 0)   -- B-color
        );
    end component;
begin

    vga_ds_top_0 : vga_ds_top 
    generic map
    (
        cpu     => cpu
    )
    port map
    (
        clk     => clk,     -- clock
        resetn  => resetn,  -- reset
        en      => '1',     -- enable input
        hsync   => hsync,   -- hsync output
        vsync   => vsync,   -- vsync output
        bgColor => bgColor, -- Background color
        fgColor => fgColor, -- Foreground color
        regData => regData, -- Register data input from cpu
        regAddr => regAddr, -- Register data output to cpu
        R       => R,       -- R-color
        G       => G,       -- G-color
        B       => B        -- B-color
    );

end rtl; -- vga_debug_screen_pll_25_175MHz
