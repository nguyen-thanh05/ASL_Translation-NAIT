library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(
        uart_data : out std_logic_vector(7 downto 0);
        pwm_out : out std_logic;
        rx : in std_logic;
        reset : in std_logic
    );
end top;

architecture Behavioral of top is
    signal fpga_clk : std_logic := '0';
    signal pwm_load : std_logic := '0';
    signal pwm_ctrl_s : std_logic_vector(9 downto 0) := (others => '0');
    signal uart_data_s : std_logic_vector(7 downto 0) := (others => '0');
begin
    uart_data <= uart_data_s;
    ps7_stub: entity work.ps7_stub(RTL)
        port map(
            fpga_clk => fpga_clk
        );
    servo_inst: entity work.servo(Behavioral)
        generic map (
            pwm_bits => 10,
            min_pwm => 16#18#,
            max_pwm => 16#78#
        )
        port map (
            clk => fpga_clk,
            angle => uart_data_s,
            pwm_data => pwm_ctrl_s
        );
    pwm_inst: entity work.pwm(Behavioral)
        generic map (
            refclk_period => 40,
            pwm_period => 20000000,
            pwm_bits => 10
        )
        port map (
            ref_clk => fpga_clk, -- in std_logic;
            pwm_ctrl => pwm_ctrl_s, -- in std_logic_vector(pwm_bits - 1 downto 0);
            pwm_load => pwm_load,
            pwm_out => pwm_out -- out std_logic
        );
    uart_rx_inst : entity work.uart_rx(Behavioral)
        generic map (
            refclk_freq => 25000000,
            baud_rate => 115200
        )
        port map (
            ref_clk => fpga_clk, -- in std_logic;
            rx => rx, -- in std_logic;
            reset => reset, -- in std_logic;
            data_out => uart_data_s, -- out std_logic_vector(7 downto 0);
            data_out_valid => pwm_load, -- out std_logic;
            consumer_ready => '1' -- in std_logic
        );
end Behavioral;

