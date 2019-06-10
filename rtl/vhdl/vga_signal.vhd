--
-- File            :   vga_signal.vhd
-- Data            :   2019.06.12
-- Language        :   VHDL
-- Description     :   This is vga unit for generating hsync and vsync signal's (based on SystemVerilog version)
-- Copyright(c)    :   2019
--                     Barsukov Dmitriy
--                     Vlasov Dmitriy
--                     Stanislav Zhelnio
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_signal is
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
end vga_signal;

architecture rtl of vga_signal is
    signal hsync_c  : std_logic_vector(9 downto 0);     -- hsync counter
    signal vsync_c  : std_logic_vector(9 downto 0);     -- vsync counter
begin
        
    hsync <= '1' when ( hsync_c < ( HVA + HFP ) ) or ( hsync_c >= ( HVA + HFP + HSP ) ) else '0';
    vsync <= '1' when ( vsync_c < ( VVA + VFP ) ) or ( vsync_c >= ( VVA + VFP + VSP ) ) else '0';

    hvsync_proc : process( clk, resetn )
    begin
        if( not resetn ) then
            hsync_c <= (others => '0');
            vsync_c <= (others => '0');
        elsif( rising_edge(clk) ) then
            if( en ) then
                hsync_c <= hsync_c + 1;
                if( hsync_c = HWL - 1 ) then
                    hsync_c <= (others => '0');
                    vsync_c <= vsync_c + 1;
                elsif( vsync_c = VWF ) then
                    vsync_c <= (others => '0');
                end if;
            end if;
        end if;
    end process;

end rtl; -- vga_signal
