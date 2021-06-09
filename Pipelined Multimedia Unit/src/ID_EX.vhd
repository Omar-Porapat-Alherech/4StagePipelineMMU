--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ID_EX} architecture {ID_EX}}

library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
	port(
		 -- IN PORTS   EVERYTHING SHOULD BE 1-1
		 clk : in STD_LOGIC;
		 reg_write_in : in STD_LOGIC;
		 bit23_24_in : in STD_LOGIC_VECTOR(1 downto 0); 
		 rs1_in : in STD_LOGIC_VECTOR(4 downto 0);
		 rs2_in : in STD_LOGIC_VECTOR(4 downto 0);
		 rs3_in : in STD_LOGIC_VECTOR(4 downto 0);
		 rs1_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 rs2_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 rs3_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 immediate_in : in STD_LOGIC_VECTOR(15 downto 0);
		 loadindex_in : in STD_LOGIC_VECTOR(2 downto 0);
		 shift_val_in : in STD_LOGIC_VECTOR(3 downto 0);
		 rd_in : in STD_LOGIC_VECTOR(4 downto 0);
		 command_bits_in : in STD_LOGIC_VECTOR(7 downto 0); 
		 li_sa_ha_bits_in: in STD_LOGIC_VECTOR(2 DOWNTO 0);
		 
		 -- OUT PORTS 			  
		 bit23_24_out : out STD_LOGIC_VECTOR(1 downto 0);
		 rs1_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rs2_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rs3_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rs1_out_val : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2_out_val : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3_out_val : out STD_LOGIC_VECTOR(127 downto 0);
		 immediate_out : out STD_LOGIC_VECTOR(15 downto 0);
		 loadindex_out : out STD_LOGIC_VECTOR(2 downto 0);
		 shift_val_out : out STD_LOGIC_VECTOR(3 downto 0);
		 command_bits_out	: out STD_LOGIC_VECTOR(7 downto 0);	
		 li_sa_ha_bits_out: out STD_LOGIC_VECTOR(2 DOWNTO 0);
		 rd_out : out STD_LOGIC_VECTOR(4 downto 0);
		 reg_write_out : out STD_LOGIC
		 
		 
	     );
end ID_EX;

--}} End of automatically maintained section

architecture behavorial of ID_EX is
begin
	ID_EX_REG: process(clk)
	begin
		if rising_edge(clk) then 
			bit23_24_out <= bit23_24_in;
			rs1_out <= rs1_in;
			rs2_out <= rs2_in;
			rs3_out <= rs3_in;
			rs1_out_val <= rs1_in_val;
			rs2_out_val <= rs2_in_val;
			rs3_out_val <= rs3_in_val;
			immediate_out <= immediate_in;
			loadindex_out <= loadindex_in;
			shift_val_out <= shift_val_in;	  
			li_sa_ha_bits_out<=li_sa_ha_bits_in;
			command_bits_out <= command_bits_in;
			rd_out <= rd_in;
			reg_write_out <= reg_write_in;
		end if;
	end process ID_EX_REG;
end behavorial;
