--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Forwarding_Unit} architecture {Forwarding_Unit}}

library IEEE;
use IEEE.std_logic_1164.all;

entity Forwarding_Unit is
	port(
		rs1_in_num : IN STD_LOGIC_VECTOR(4 downto 0);
		rs2_in_num : IN STD_LOGIC_VECTOR(4 downto 0);
		rs3_in_num : IN STD_LOGIC_VECTOR(4 downto 0);
		write_backdest_reg_in : IN STD_LOGIC_VECTOR(4 downto 0);
		writeback_toggle: STD_LOGIC;  
		 -- Values moving to mux
	--	 rs1_out_val : in STD_LOGIC_VECTOR(127 downto 0);
	--	 rs2_out_val : in STD_LOGIC_VECTOR(127 downto 0);
	--	 rs3_out_val : in STD_LOGIC_VECTOR(127 downto 0);
	--	 rs1_in_val : in STD_LOGIC_VECTOR(127 downto 0);
	--	 rs2_in_val : in STD_LOGIC_VECTOR(127 downto 0);
	--	 rs3_in_val : in STD_LOGIC_VECTOR(127 downto 0)
		sel_mux1: out STD_LOGIC;
		sel_mux2: out STD_LOGIC;
		sel_mux3: out STD_LOGIC	
	     );
end Forwarding_Unit;

--}} End of automatically maintained section

architecture Forwarding_Unit of Forwarding_Unit is 
begin 
	decision: process(rs1_in_num, rs2_in_num, rs3_in_num, writeback_toggle, write_backdest_reg_in)
begin
	-- default to result from stage 2 -- 
	sel_mux1 <= '0';
	sel_mux2 <= '0';
	sel_mux3 <= '0'; 
	
	if writeback_toggle = '1' and rs1_in_num = write_backdest_reg_in then
		sel_mux1 <= '1';
	end if;
	if writeback_toggle = '1' and rs2_in_num = write_backdest_reg_in then
		sel_mux2 <= '1';
	end if;
	if writeback_toggle = '1' and rs3_in_num = write_backdest_reg_in then
		sel_mux3 <= '1';
	end if;
	end process decision;
	
	

	 -- enter your statements here --

end Forwarding_Unit;
