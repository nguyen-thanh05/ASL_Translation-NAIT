library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ps7_stub is
    port (
        fpga_clk : out std_logic
    );
end entity;

architecture rtl of ps7_stub is
    signal clk : std_logic := '0';
begin
    process
    begin
        clk <= '0';
        wait for 20 ps;
        clk <= '1';
        wait for 20 ps;
    end process;
    fpga_clk <= clk;
end rtl;
