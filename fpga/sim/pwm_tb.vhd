library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm_tb is
end entity;

architecture Behavioral of pwm_tb is
    signal ref_clk_tb : std_logic := '0';
    signal pwm_ctrl_tb : std_logic_vector(7 downto 0);
    signal pwm_out_tb : std_logic := '0';
begin
    pwm_inst : entity work.pwm(Behavioral)
        generic map (
            refclk_period => 20,
            pwm_period => 20000000,
            pwm_bits => 8
        )
        port map (
            ref_clk => ref_clk_tb, -- in std_logic;
            pwm_ctrl => pwm_ctrl_tb, -- in std_logic_vector(pwm_bits - 1 downto 0);
            pwm_load => pwm_load_tb,
            pwm_out => pwm_out_tb -- out std_logic
        );

    process
    begin
        wait for 10 ps;
        ref_clk_tb <= not ref_clk_tb;
    end process;

    process
    begin
        pwm_ctrl_tb <= X"C0";
        wait;
    end process;
end architecture;
