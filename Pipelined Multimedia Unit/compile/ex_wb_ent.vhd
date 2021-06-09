-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\ex_wb_ent.vhd
-- Generated   : Fri Nov 27 21:39:42 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\ex_wb_ent.bde
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

architecture ex_wb_arch of ex_wb_ent is

begin

---- Processes ----

ex_wb : process (clk)
                       begin
                         if rising_edge(clk) then
                            togglewb_out <= togglewb;
                            dest_reg_out <= dest_reg_in;
                            write_val <= stage3_output_in;
                         end if;
                       end process;
                      

end ex_wb_arch;
