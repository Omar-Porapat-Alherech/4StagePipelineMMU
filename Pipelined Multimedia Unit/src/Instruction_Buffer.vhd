--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Instruction_Buffer} architecture {Instruction_Buffer}}

library IEEE;		   
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity Instruction_Buffer is
	port(
	instr_index : in STD_LOGIC_VECTOR(5 downto 0);	   
	instr_out : out STD_LOGIC_VECTOR(24 downto 0);  											 						
	instr_input: in STD_LOGIC_VECTOR(24 downto 0);
	fetch: in STD_LOGIC
	     );
end Instruction_Buffer;

--}} End of automatically maintained section

architecture behavorial of Instruction_Buffer is  
type buffer_unique is array(63 downto 0) of STD_LOGIC_VECTOR(24 downto 0);	  	 
begin	   	
	instruction_fetch: process (fetch, instr_index, instr_input) 
	variable buffer_var : buffer_unique;
	begin
		if rising_edge(fetch) then
			buffer_var(to_integer(unsigned(instr_index))) := instr_input;
			instr_out <= buffer_var(to_integer(unsigned(instr_index)));
		else	
			instr_out <= buffer_var(to_integer(unsigned(instr_index)));
		end if;
	end process instruction_fetch;
end behavorial;
