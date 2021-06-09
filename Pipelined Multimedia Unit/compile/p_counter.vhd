-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\p_counter.vhd
-- Generated   : Fri Nov 27 21:39:44 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\p_counter.bde
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

entity p_counter is
  port(
       reset : in STD_LOGIC;
       clock : in STD_LOGIC;
       pc_out : out STD_LOGIC_VECTOR(5 downto 0);
       fetch : in STD_LOGIC
  );
end p_counter;

architecture p_counter of p_counter is

begin

---- Processes ----

program_counter : process (clock,reset,fetch)
                         variable zero : STD_LOGIC_VECTOR(5 downto 0) := (0 => '0', others => '0');
                         variable counter : integer := 0;
                       begin
                         if reset = '1' then
                            counter := 0;
                         end if;
                         if rising_edge(clock) or rising_edge(fetch) then
                            counter := counter + 1;
                            if counter = 64 then
                               counter := 0;
                            end if;
                            pc_out <= STD_LOGIC_VECTOR(to_unsigned(counter,pc_out'length));
                         end if;
                       end process;
                      

end p_counter;
