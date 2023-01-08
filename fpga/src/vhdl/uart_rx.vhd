library IEEE;
use IEEE.std_logic_1164.all;

entity uart_rx is
    generic (
        refclk_freq : natural;
        baud_rate : natural
    );
    port (
        ref_clk : in std_logic;
	rx : in std_logic;
	reset: in std_logic;
        data_out : out std_logic_vector(7 downto 0);
        data_out_valid : out std_logic;
        consumer_ready : in std_logic
    );
end entity;

architecture Behavioral of uart_rx is
    constant clks_per_bit : natural := refclk_freq / baud_rate;
    type uart_state is (IDLE, START, DATA, STOP);
    signal state : uart_state := IDLE; 
    signal data_out_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal counter : natural range 0 to clks_per_bit;
    signal data_counter : natural range 0 to 7;
begin
    process (ref_clk) is
    begin
	if rising_edge(ref_clk) then
	    if reset = '0' then
		case state is
		    when IDLE =>
			if rx = '0' then
			    counter <= counter + 1;
			    if counter = clks_per_bit / 2 - 1 then
				state <= START;
				counter <= 0;
			    else
				state <= IDLE;
			    end if;
			else
			   state <= IDLE;
			   counter <= 0;
			end if;
		    when START =>
			counter <= counter + 1;
			if counter = clks_per_bit - 1 then
			    state <= DATA;
			    data_counter <= 0;
			    counter <= 0; 
			else
			    state <= START;
			end if;
		    when DATA =>
			if counter = 0 then
			    data_out_reg <= rx & data_out_reg(7 downto 1);
			end if; 
			if counter = clks_per_bit - 1 then
			    counter <= 0;
			    if data_counter = 7 then
				state <= STOP;
				data_counter <= 0;
			    else
				data_counter <= data_counter + 1;
			    end if;
			else
			    counter <= counter + 1;
			    state <= DATA;
			end if;
		    when STOP =>
			if counter = clks_per_bit/2 - 1 then
			    counter <= 0;
			    data_out <= data_out_reg;
			    data_out_valid <= '1';
			    state <= IDLE;
			else
			    counter <= counter + 1;
			    state <= STOP;
			end if;
		end case;
	    else
		data_out <= (others => '0');
		data_out_valid <= '0';
		counter <= 0;
		data_counter <= 0;
	    end if;
	end if;
    end process;
end Behavioral;
