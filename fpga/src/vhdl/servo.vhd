library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity servo is
    generic (
        pwm_bits : natural;
        min_pwm : natural;
        max_pwm : natural
    );
    port (
        clk : in std_logic;
        angle : in std_logic_vector(7 downto 0);
        pwm_data : out std_logic_vector(pwm_bits - 1 downto 0)
    );
end entity;

architecture Behavioral of servo is
    type deg_to_pwm_arr is array (0 to 180) of std_logic_vector(pwm_bits - 1 downto 0);

    function gen_lookup return deg_to_pwm_arr is
        variable arr : deg_to_pwm_arr;
    begin
        for i in arr'range loop
                arr(i) := std_logic_vector(to_unsigned(min_pwm + i*(max_pwm - min_pwm + 1)/181, pwm_bits));
        end loop;
        return arr;
    end function;

    constant deg_to_pwm : deg_to_pwm_arr := gen_lookup; 
begin
    process (clk)
    begin
        if rising_edge(clk) then
            pwm_data <= deg_to_pwm(to_integer(unsigned(angle)));
        end if;
    end process; 
end Behavioral;
