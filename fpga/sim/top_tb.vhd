library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_tb is
end entity;

architecture Behavioral of top_tb is
    signal uart_data_tb : std_logic_vector (7 downto 0) := (others => '0');
    signal pwm_out_tb : std_logic_vector(0 to 0) := (others => '0');
    signal rx_tb : std_logic := '1';
    signal reset_tb : std_logic := '1';
begin
    top_inst: entity work.top(Behavioral)
        port map (
            uart_data => uart_data_tb, -- out std_logic_vector(7 downto 0);
            pwm_out => pwm_out_tb, -- out std_logic_vector(0 to 0);
            rx => rx_tb, -- in std_logic;
            reset => reset_tb -- in std_logic
        );
    process
    begin
        wait for 80 ps;
        reset_tb <= '0'; 
        wait for 80 ps;

        rx_tb <= '0'; -- start
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1'; -- stop
        wait for 8.681 ns;
        rx_tb <= '0'; -- start
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1'; -- stop
        wait for 8.681 ns;
        rx_tb <= '0'; -- start
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1'; -- stop
        wait for 8.681 ns;
        rx_tb <= '0'; -- start
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1'; -- stop
        wait for 8.681 ns;
        rx_tb <= '0'; -- start
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1'; -- stop
        wait for 8.681 ns;
        wait;
    end process;
end architecture;

