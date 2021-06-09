-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\Instruction_Buffer.vhd
-- Generated   : Fri Nov 27 21:39:44 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\Instruction_Buffer.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

entity Instruction_Buffer is
  port(
       instr_index : in STD_LOGIC_VECTOR(5 downto 0);
       instr_out : out STD_LOGIC_VECTOR(24 downto 0);
       instr_input : in STD_LOGIC_VECTOR(24 downto 0);
       fetch : in STD_LOGIC
  );
end Instruction_Buffer;

architecture behavorial of Instruction_Buffer is

---- Architecture declarations -----
--Added by Active-HDL. Do not change code inside this section.
type buffer_unique is array (63 downto 0) of STD_LOGIC_VECTOR(24 downto 0);
--End of extra code.


begin

---- Processes ----

instruction_fetch : process (fetch,instr_index,instr_input)
                         variable buffer_var : buffer_unique;
                       begin
                         if rising_edge(fetch) then
                            buffer_var(to_integer(unsigned(instr_index))) := instr_input;
                            instr_out <= buffer_var(to_integer(unsigned(instr_index)));
                         end if;
                         if fetch'event then
                            instr_out <= buffer_var(to_integer(unsigned(instr_index)));
                         end if;
                       end process;
                      

end behavorial;
