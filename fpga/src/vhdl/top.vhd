library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(
        pwm_ctrl : in std_logic_vector(7 downto 0);
        pwm_out : out std_logic;
        pwm_load : in std_logic
    );
end top;

architecture Behavioral of top is
    signal pwm_ref_clk : std_logic := '0';
begin
    ps7_stub: entity work.ps7_stub(RTL)
        port map(
            fpga_clk => pwm_ref_clk
        );
    pwm_inst: entity work.pwm(Behavioral)
        generic map (
            refclk_period => 40,
            pwm_period => 20000000,
            pwm_bits => 8
        )
        port map (
            ref_clk => pwm_ref_clk, -- in std_logic;
            pwm_ctrl => pwm_ctrl, -- in std_logic_vector(pwm_bits - 1 downto 0);
            pwm_load => pwm_load,
            pwm_out => pwm_out -- out std_logic
        );
end Behavioral;

