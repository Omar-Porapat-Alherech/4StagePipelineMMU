--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {IF_ID} architecture {IF_ID}}

library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is
	 port(
		 clk : in STD_LOGIC;
		 instr_in : in STD_LOGIC_VECTOR(24 downto 0);
		 -- instr_out : in STD_LOGIC_VECTOR(24 downto 0);
		 regwrite: out STD_LOGIC;
		 bit23_24: out STD_LOGIC_VECTOR(1 downto 0); 
		 load_index: out STD_LOGIC_VECTOR(2 downto 0);
		 immediate_16: out STD_LOGIC_VECTOR(15 downto 0);
		 rd: out STD_LOGIC_VECTOR(4 downto 0);
		 command_bits: out STD_LOGIC_VECTOR(7 downto 0);
		 rs3: out STD_LOGIC_VECTOR(4 downto 0);	  
		 rs2: out STD_LOGIC_VECTOR(4 downto 0);
		 rs1: out STD_LOGIC_VECTOR(4 downto 0);		 
		 shift_val: out STD_LOGIC_VECTOR(3 downto 0);
		 ls_sa_hl_bits : out std_logic_vector(2 downto 0)
	     );
end IF_ID;

--}} End of automatically maintained section

architecture IF_ID of IF_ID is 
begin	 
	ifID: process(clk, instr_in)	 
	begin
		if (rising_edge(clk)) then
			-- instr_out <= instr_in;
			 -- LOGIC HAD TO BE MOVED -- 
			bit23_24 <= instr_in(24 downto 23);
			if instr_in(24 downto 23) = "00" then
				immediate_16 <= instr_in(20 downto 5);
				rd <= instr_in(4 downto 0 ); 
				load_index <= instr_in(23 downto 21); 
				-- Values that don't apply here -- shouldn't matter if you load them anyways
				command_bits <= (others => '0');
				rs1 <= (others => '0');
				rs2 <= (others => '0');
				rs3 <= (others => '0');	
				ls_sa_hl_bits <= (others => '0');	
				shift_val <= (others => '0');
				-- We will be using the register to write--
				regwrite <= '1';
				end if;
			if instr_in(24 downto 23) = "11" then 
				rd <= instr_in(4 downto 0 );
				rs2 <= instr_in(14 downto 10);
				rs1 <= instr_in(9 downto 5);
				ls_sa_hl_bits <= instr_in(22 downto 20); 
				command_bits <= instr_in(22 downto 15);
				shift_val <= instr_in(13 downto 10); 
				-- Values that don't apply here -- shouldn't matter if you load them anyways
				rs3 <= (others => '0');	
				immediate_16 <= (others => '0');	
				load_index <= (others => '0');		 
				regwrite <= '1';
				-- We will be using the register to write--
				if instr_in(18 downto 15) = "0000" then -- nop overwrite regwrite -- 
					regwrite <= '0';
				end if;
			end if;
			if instr_in(24 downto 23) = "10" then  
				rd <= instr_in(4 downto 0 );
				rs3 <= instr_in(19 downto 15);
				rs2 <= instr_in(14 downto 10);
				rs1 <= instr_in(9 downto 5);
				ls_sa_hl_bits <= instr_in(22 downto 20);
				-- Values that don't apply here -- shouldn't matter if you load them anyways
				immediate_16 <= (others => '0');	
				load_index <= (others => '0');	
				shift_val <= (others => '0');
				command_bits <= (others => '0');
				regwrite <= '1';
				end if;
			end if;

end process ifID;


	 -- enter your statements here --

end IF_ID;
