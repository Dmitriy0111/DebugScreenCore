--
-- File            :   dsc_components.vhd
-- Autor           :   Vlasov D.V.
-- Data            :   2019.08.22
-- Language        :   VHDL
-- Description     :   This is debug screen core components package
-- Copyright(c)    :   2019 Vlasov D.V.
--

library ieee;
use ieee.std_logic_1164.all;

library dsc;
use dsc.dsc_mem_pkg.all;

package dsc_components is
    -- display_mem
    component display_mem
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
    end component;
    -- symbol_mem
    component symbol_mem
        port 
        (
            clk     : in    std_logic;                      -- clock
            ascii   : in    std_logic_vector(7 downto 0);   -- ascii symbol code
            pix_x   : in    std_logic_vector(2 downto 0);   -- x position of pixel in the symbol
            pix_y   : in    std_logic_vector(3 downto 0);   -- y position of pixel in the symbol
            bg_fg   : out   std_logic                       -- background or foreground enable
        );
    end component;
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
    -- vga_pix_symbol
    component vga_pix_symbol
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
    end component;
    -- vga_signal
    component vga_signal
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
            clk     : in    std_logic;  -- clock
            resetn  : in    std_logic;  -- reset
            en      : in    std_logic;  -- enable
            hsync   : out   std_logic;  -- hsync output
            vsync   : out   std_logic   -- vsync output
        );
    end component;
end dsc_components;

package body dsc_components is

end dsc_components;