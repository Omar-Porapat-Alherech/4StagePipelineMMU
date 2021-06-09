library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;


entity stage_1_tb is
end stage_1_tb;

--}} End of automatically maintained section

architecture testbench of stage_1_tb is
signal fetch, clk, reset : std_logic := '0';
signal s1_instr_in, s1_instr_out : std_logic_vector(24 downto 0);
constant period : time := 5ns;
begin
	UUT: entity stage1_ent port map(reset => reset, clk => clk, s1_instr_input => s1_instr_in, s1_instr_out => s1_instr_out, fetch => fetch);
	tb: process
	variable fill_inst_buff : integer := 1;
	begin	
		reset <= '0' after 7ns;	
		wait for 10ns;
		for i in 0 to 63 loop 
			s1_instr_in <= std_logic_vector(to_unsigned(fill_inst_buff, 25));
			wait for period;
			fetch <= '1';
			wait for period;
			fetch <= '0';
			fill_inst_buff := fill_inst_buff + 1;
		end loop;
		for i in 0 to 63 loop
			wait for period;
			clk <= '1';
			wait for period;
			clk <= '0';
			fill_inst_buff := fill_inst_buff + 1;
		end loop;
		std.env.finish;
	end process tb;
end testbench;
