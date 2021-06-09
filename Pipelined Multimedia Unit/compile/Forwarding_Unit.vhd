-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\Forwarding_Unit.vhd
-- Generated   : Fri Nov 27 21:39:42 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\Forwarding_Unit.bde
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

entity Forwarding_Unit is
  port(
       rs1_in_num : in STD_LOGIC_VECTOR(4 downto 0);
       rs2_in_num : in STD_LOGIC_VECTOR(4 downto 0);
       rs3_in_num : in STD_LOGIC_VECTOR(4 downto 0);
       write_backdest_reg_in : in STD_LOGIC_VECTOR(4 downto 0);
       writeback_toggle : in STD_LOGIC;
       sel_mux1 : out STD_LOGIC;
       sel_mux2 : out STD_LOGIC;
       sel_mux3 : out STD_LOGIC
  );
end Forwarding_Unit;

architecture Forwarding_Unit of Forwarding_Unit is

begin

---- Processes ----

decision : process (rs1_in_num,rs2_in_num,rs3_in_num,writeback_toggle,write_backdest_reg_in)
                       begin
                         sel_mux1 <= '0';
                         sel_mux2 <= '0';
                         sel_mux3 <= '0';
                         if writeback_toggle = '1' and rs1_in_num = write_backdest_reg_in then
                            sel_mux1 <= '1';
                         end if;
                         if writeback_toggle = '1' and rs2_in_num = write_backdest_reg_in then
                            sel_mux1 <= '1';
                         end if;
                         if writeback_toggle = '1' and rs3_in_num = write_backdest_reg_in then
                            sel_mux1 <= '1';
                         end if;
                       end process;
                      

end Forwarding_Unit;
