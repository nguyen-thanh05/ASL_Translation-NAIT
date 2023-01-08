library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_rx_tb is
end entity;

architecture Behavioral of uart_rx_tb is
    signal ref_clk_tb : std_logic := '0';
    signal rx_tb : std_logic := '1';
    signal reset_tb : std_logic := '0';
    signal data_out_tb : std_logic_vector(7 downto 0);
    signal data_out_valid_tb : std_logic := '0';
    signal consumer_ready_tb : std_logic := '1';
begin 
    uart_rx_inst : entity work.uart_rx(Behavioral)
        generic map (
            refclk_freq => 25000000,
            baud_rate => 115200
        )
        port map (
            ref_clk => ref_clk_tb, -- in std_logic;
            rx => rx_tb, -- in std_logic;
            reset => reset_tb, -- in std_logic;
            data_out => data_out_tb, -- out std_logic_vector(7 downto 0);
            data_out_valid => data_out_valid_tb, -- out std_logic;
            consumer_ready => consumer_ready_tb -- in std_logic
        );
    process
    begin
        wait for 20 ps;
        ref_clk_tb <= not ref_clk_tb;
    end process; 
    
    process
    begin
        reset_tb <= '1';
        wait for 80 ps;
        reset_tb <= '0';
        wait for 80 ps;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait for 8.681 ns;
        rx_tb <= '0';
        wait for 8.681 ns;
        rx_tb <= '1';
        wait;
    end process;
end Behavioral;
