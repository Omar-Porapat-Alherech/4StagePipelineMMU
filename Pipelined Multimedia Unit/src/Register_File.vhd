--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Register_File} architecture {Register_File}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity Register_File is
	port(
		 clk : in STD_LOGIC;
		 writeData : in STD_LOGIC_VECTOR(127 downto 0);
		 writeRegister : in STD_LOGIC_VECTOR(4 downto 0);	
		 -- regwrite ocmes from control unit -- 
		 regWrite : in STD_LOGIC;
		 reg_1 : in STD_LOGIC_VECTOR(4 downto 0);
		 reg_2 : in STD_LOGIC_VECTOR(4 downto 0);
		 reg_3 : in STD_LOGIC_VECTOR(4 downto 0);
		 reg_1_val : out STD_LOGIC_VECTOR(127 downto 0);
		 reg_2_val : out STD_LOGIC_VECTOR(127 downto 0);
		 reg_3_val : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end Register_File;

--}} End of automatically maintained section

architecture behavorial of Register_File is
type regArray is array (0 to 31) of std_logic_vector (127 downto 0);	
-- https://stackoverflow.com/questions/47436170/vhdl-initialize-generic-array-of-std-logic-vector -- 
signal registers:regArray := (others=>(others=>'0'));
begin
	registerFileReadWrite : process (regWrite,writeData, clk, reg_1, reg_2, reg_3)
	begin
	 reg_1_val <= registers(to_integer(unsigned(reg_1)));
	 reg_2_val <= registers(to_integer(unsigned(reg_2)));
	 reg_3_val <= registers(to_integer(unsigned(reg_3)));
	 -- enter your statements here --  
	 -- We assume writing happens in the first half of the clock cycle, so that fowards can happen to values that are read and written on the same clk 
	 -- textbook pg 308-- 
	 if (rising_edge(clk)) then
		 if (regWrite = '1') then
			 registers(to_integer(unsigned(writeRegister))) <= writeData;
		 end if;
	 end if;
	 --Forwarding--
	  if (reg_1 = writeRegister)
			 then reg_1_val <= writeData;
		 end if;
		 if (reg_2 = writeRegister) then
			 reg_2_val <= writeData;
		 end if;	 
		 if (reg_3 = writeRegister) then
			 reg_3_val <= writeData;
		 end if;
	end process registerFileReadWrite;
end behavorial;

