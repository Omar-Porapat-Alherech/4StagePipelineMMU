--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ex_wb_ent} architecture {ex_wb_arch}}

library IEEE;
use IEEE.std_logic_1164.all;

entity ex_wb_ent is
	 port(
		 clk : in STD_LOGIC;
		 togglewb : in STD_LOGIC;
		 togglewb_out : out STD_LOGIC;
		 stage3_output_in : in STD_LOGIC_VECTOR(127 downto 0);
		 dest_reg_in : in STD_LOGIC_VECTOR(4 downto 0);
		 dest_reg_out : out STD_LOGIC_VECTOR(4 downto 0);
		 write_val : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end ex_wb_ent;

--}} End of automatically maintained section

architecture ex_wb_arch of ex_wb_ent is
begin
	ex_wb: process(clk)
	begin
		if rising_edge(clk) then
			togglewb_out <= togglewb;	  
			dest_reg_out <= dest_reg_in;
			write_val <= stage3_output_in;
		end if;
	 -- enter your statements here --
	end process ex_wb;
end ex_wb_arch;
