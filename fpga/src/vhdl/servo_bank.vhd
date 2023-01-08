library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_bank is
    generic (
	num_channels : natural;
	pwm_bits : natural
    );
    port(
	clk : in std_logic;
	load : in std_logic;
        pwm_out : out std_logic_vector(0 to num_channels-1);
        address : in natural range 0 to num_channels - 1;
	angle : in natural range 0 to 180;
        reset : in std_logic
    );
end servo_bank;

architecture Behavioral of servo_bank is
    type pwm_reg_arr is array (0 to num_channels - 1) of std_logic_vector(pwm_bits - 1 downto 0);
    signal pwm_regs : pwm_reg_arr := (others => (others => '0'));
    signal pwm_data : std_logic_vector(pwm_bits - 1 downto 0);
begin
    servo_inst: entity work.servo(Behavioral)
        generic map (
            pwm_bits => 10,
            min_pwm => 16#18#,
            max_pwm => 16#78#
        )
        port map (
            clk => clk,
            angle => angle,
            pwm_data => pwm_data
        );

    gen_pwm_controllers : for i in 0 to num_channels - 1 generate
	pwm_module: entity work.pwm(Behavioral)
	    generic map (
		refclk_period => 40,
		pwm_period => 20000000,
		pwm_bits => 10
	    )
	    port map (
		ref_clk => clk, -- in std_logic;
		pwm_ctrl => pwm_regs(i), -- in std_logic_vector(pwm_bits - 1 downto 0);
		pwm_out => pwm_out(i) -- out std_logic
	    );
    end generate gen_pwm_controllers;

    process (clk) is
    begin
	if rising_edge(clk) then
	    if reset = '1' then
		pwm_regs <= (others => (others => '0'));
	    else
		if load = '1' then
		    pwm_regs(address) <= pwm_data;
		end if;
	    end if;
	end if;
    end process;

end Behavioral;
