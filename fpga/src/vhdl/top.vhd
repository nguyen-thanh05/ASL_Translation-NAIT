library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port(
        uart_data : out std_logic_vector(7 downto 0);
        pwm_out : out std_logic_vector(0 to 0);
        rx : in std_logic;
        reset : in std_logic
    );
end top;

architecture Behavioral of top is
    constant num_servo_channels : natural := 1;
    signal fpga_clk : std_logic := '0';
    signal load_servo : std_logic := '0';
    signal uart_data_s : std_logic_vector(7 downto 0) := (others => '0');
    signal servo_angle : natural range 0 to 180 := 0;
    signal servo_address : natural range 0 to num_servo_channels - 1;
    signal uart_have_char : std_logic := '0';
begin
    uart_data <= uart_data_s;
    ps7_stub: entity work.ps7_stub(RTL)
        port map(
            fpga_clk => fpga_clk
        );
    servo_bank_inst : entity work.servo_bank(Behavioral)
        generic map (
            num_channels => num_servo_channels,
            pwm_bits => 10
        )
        port map(
            clk => fpga_clk, --in std_logic;
            load => load_servo, -- in std_logic;
            pwm_out => pwm_out, -- out std_logic_vector(0 to num_channels-1);
            address => servo_address, --in natural range 0 to num_channels - 1;
            angle => servo_angle, -- in natural range 0 to 180;
            reset => reset -- in std_logic;
        );
    uart_parser_inst : entity work.uart_parser(Behavioral)
        generic map (
            num_channels => num_servo_channels
        )
        port map (
            clk => fpga_clk, -- in std_logic;
            uart_data => uart_data_s, -- in std_logic_vector(7 downto 0);
            servo_angle => servo_angle, -- out natural range 0 to 180;
            servo_address => servo_address, -- out natural range 0 to num_channels - 1;
            uart_data_valid => uart_have_char, -- in std_logic;
            data_out_valid => load_servo, -- out std_logic;
            reset => reset -- in std_logic
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
            data_out_valid => uart_have_char, -- out std_logic;
            consumer_ready => '1' -- in std_logic
        );
end Behavioral;

