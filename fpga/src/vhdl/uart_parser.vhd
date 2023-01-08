library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_parser is
    generic (
	num_channels : natural
    );
    port(
	clk : in std_logic;
        uart_data : in std_logic_vector(7 downto 0);
	servo_angle : out natural range 0 to 180;
	servo_address : out natural range 0 to num_channels - 1;
	uart_data_valid : in std_logic;
	data_out_valid : out std_logic;
        reset : in std_logic
    );
end uart_parser;

architecture Behavioral of uart_parser is
    signal address_tmp : natural range 0 to num_channels - 1;
    signal angle_tmp : natural range 0 to 180;
    signal reading_angle : std_logic := '0';
begin
    process (clk) is
    begin
	if rising_edge(clk) then
	    if reset = '1' then
		address_tmp <= 0;
		angle_tmp <= 0;
	    else
		if uart_data_valid = '1' then
		    if reading_angle = '0' then
			if uart_data = X"20" then
			    reading_angle <= '1';
			else
			    address_tmp <= address_tmp * 10 + (to_integer(unsigned(uart_data)) - 48);
			end if;
		    else
			if uart_data = X"0A" then
			    reading_angle <= '0';
			    servo_angle <= angle_tmp;
			    servo_address <= address_tmp;
			    angle_tmp <= 0;
			    address_tmp <= 0;
			    data_out_valid <= '1';
			else
			    angle_tmp <= angle_tmp * 10 + (to_integer(unsigned(uart_data)) - 48);
			end if;
		    end if;
		else
		    if data_out_valid = '1' then
			data_out_valid <= '0';
		    end if;
		end if; 
	    end if;
	end if;
    end process;
end Behavioral;

