--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {stage1_ent} architecture {stage1_arch}}
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity stage1_ent is
	 port(
		 fetch : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 reset : in STD_LOGIC;
		 s1_instr_input : in STD_LOGIC_VECTOR(24 downto 0);
		 s1_instr_out : out STD_LOGIC_VECTOR(24 downto 0)
	     );
end stage1_ent;

--}} End of automatically maintained section

architecture stage1_arch of stage1_ent is
signal pc_conn_buff : std_logic_vector(5 downto 0);
begin
	program_counter: entity p_counter port map(clock=>clk, reset=>reset, fetch=>fetch, pc_out=>pc_conn_buff);
	instruction_fetch: entity Instruction_Buffer port map(instr_input=>s1_instr_input, fetch=>fetch, instr_out=>s1_instr_out, instr_index=>pc_conn_buff);

	 -- enter your statements here --

end stage1_arch;
