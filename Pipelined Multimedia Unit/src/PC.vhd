--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {p_counter} architecture {p_counter}}

library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;

ENTITY p_counter IS
	PORT ( 
	--pc_in: in std_logic_vector(5 downto 0);
	--pc_update: in STD_LOGIC;
	reset : IN  STD_LOGIC ;
	clock : IN  STD_LOGIC ;
	pc_out : OUT  STD_LOGIC_vector(5 downto 0);
	fetch : in STD_LOGIC
	) ;
END p_counter;


--}} End of automatically maintained section

architecture p_counter of p_counter is	 
-- switched back to variable assignment because signal assignment caused a delay in the testbench -- 
begin	   
	program_counter: process(clock, reset, fetch) -- pc_in, pc_update
	variable zero : STD_LOGIC_VECTOR(5 downto 0):= (0 => '0', others =>'0');
	variable counter: integer := 0;
	begin 
		-- First we deal with the reset signal --
		-- It has to be written this way or the counter never hits 0 it goes to 1 -- 
		if reset = '1' or rising_edge(reset)then
			-- Immediate assignment of PC switched to variable for lack of delay --
			counter := 0;	
		elsif rising_edge(clock) or rising_edge(fetch)then
			counter := counter + 1;
			-- Instruction buffer is at max 64-- 
		--elsif rising_edge(clock) and pc_update = '1' then
		--	curr_val <= pc_in;
			if counter = 64 then
					counter := 0;
			end if;
		end if;
		pc_out <= STD_LOGIC_VECTOR(to_unsigned(counter, pc_out'length));
		end process;

	 -- enter your statements here --

end p_counter;
