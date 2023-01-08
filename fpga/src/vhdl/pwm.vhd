library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pwm is
    generic (
        refclk_period : natural;
        pwm_period : natural;
        pwm_bits : natural
    );
    port (
        ref_clk : in std_logic;
        pwm_ctrl : in std_logic_vector(pwm_bits - 1 downto 0);
        pwm_out : out std_logic
    );
end entity;

architecture Behavioral of pwm is
    constant cycle_clk_count : natural := pwm_period/refclk_period;
    subtype cycle_clk_count_t is natural range 0 to cycle_clk_count - 1;
    subtype step_clk_count_t is natural range 0 to cycle_clk_count/(2 ** pwm_bits) - 1;
    subtype step_count_t is natural range 0 to 2 ** pwm_bits - 1;

    signal cycle_clk_counter : cycle_clk_count_t := 0;
    signal step_clk_counter : step_clk_count_t := 0;
    signal step_counter : step_count_t := 0;
    signal pwm_ctrl_reg : std_logic_vector(pwm_bits - 1 downto 0) := (others => '0');
    signal pwm_out_s : std_logic := '0';
begin
    pwm_out <= pwm_out_s;
    process (ref_clk) is
    begin
        if rising_edge(ref_clk) then
            if cycle_clk_counter = cycle_clk_count_t'high then
                pwm_ctrl_reg <= pwm_ctrl;
                cycle_clk_counter <= 0;
                step_clk_counter <= 0;
                step_counter <= 0;
                pwm_out_s <= '1';
            else
                cycle_clk_counter <= cycle_clk_counter + 1;
                if step_clk_counter = step_clk_count_t'high then
                    step_clk_counter <= 0;
                    if step_counter >= to_integer(unsigned(pwm_ctrl_reg)) then
                        pwm_out_s <= '0';
                    else
                        if step_counter < step_count_t'high then
                            step_counter <= step_counter + 1;
                        end if;
                    end if;
                else
                    step_clk_counter <= step_clk_counter + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
