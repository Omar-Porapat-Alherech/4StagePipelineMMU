-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\Register_File.vhd
-- Generated   : Fri Nov 27 21:39:45 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\Register_File.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity Register_File is
  port(
       clk : in STD_LOGIC;
       writeData : in STD_LOGIC_VECTOR(127 downto 0);
       writeRegister : in STD_LOGIC_VECTOR(4 downto 0);
       regWrite : in STD_LOGIC;
       reg_1 : in STD_LOGIC_VECTOR(4 downto 0);
       reg_2 : in STD_LOGIC_VECTOR(4 downto 0);
       reg_3 : in STD_LOGIC_VECTOR(4 downto 0);
       reg_1_val : out STD_LOGIC_VECTOR(127 downto 0);
       reg_2_val : out STD_LOGIC_VECTOR(127 downto 0);
       reg_3_val : out STD_LOGIC_VECTOR(127 downto 0)
  );
end Register_File;

architecture behavorial of Register_File is

---- Architecture declarations -----
--Added by Active-HDL. Do not change code inside this section.
type regArray is array (0 to 31) of STD_LOGIC_VECTOR(127 downto 0);
--End of extra code.


---- Signal declarations used on the diagram ----

signal registers : regArray := (others => (others => '0'));

begin

---- Processes ----

registerFileReadWrite : process (regWrite,writeData,clk,reg_1,reg_2,reg_3)
                       begin
                         reg_1_val <= registers(to_integer(unsigned(reg_1)));
                         reg_2_val <= registers(to_integer(unsigned(reg_2)));
                         reg_3_val <= registers(to_integer(unsigned(reg_3)));
                         if (rising_edge(clk)) then
                            if (regWrite = '1') then
                               registers(to_integer(unsigned(writeRegister))) <= writeData;
                            end if;
                         end if;
                         if (reg_1 = writeRegister) then
                            reg_1_val <= writeData;
                         end if;
                         if (reg_2 = writeRegister) then
                            reg_2_val <= writeData;
                         end if;
                         if (reg_3 = writeRegister) then
                            reg_3_val <= writeData;
                         end if;
                       end process;
                      

end behavorial;
