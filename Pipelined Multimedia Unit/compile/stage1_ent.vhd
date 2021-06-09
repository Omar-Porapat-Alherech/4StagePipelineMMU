-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Pipelined Multimedia Unit
-- Author      : Porapat
-- Company     : Stony Brook UNiversity
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\compile\stage1_ent.vhd
-- Generated   : Fri Nov 27 21:39:45 2020
-- From        : C:\Users\Porapat\Downloads\345_Project\Pipelined Multimedia Unit\src\stage1_ent.bde
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

entity stage1_ent is
  port(
       fetch : in STD_LOGIC;
       clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       s1_instr_input : in STD_LOGIC_VECTOR(24 downto 0);
       s1_instr_out : out STD_LOGIC_VECTOR(24 downto 0)
  );
end stage1_ent;

architecture stage1_arch of stage1_ent is

---- Component declarations -----

component Instruction_Buffer
  port(
       instr_index : in STD_LOGIC_VECTOR(5 downto 0);
       instr_out : out STD_LOGIC_VECTOR(24 downto 0);
       instr_input : in STD_LOGIC_VECTOR(24 downto 0);
       fetch : in STD_LOGIC
  );
end component;
component p_counter
  port(
       reset : in STD_LOGIC;
       clock : in STD_LOGIC;
       pc_out : out STD_LOGIC_VECTOR(5 downto 0);
       fetch : in STD_LOGIC
  );
end component;

---- Signal declarations used on the diagram ----

signal pc_conn_buff : STD_LOGIC_VECTOR(5 downto 0);

begin

----  Component instantiations  ----

instruction_fetch : Instruction_Buffer
  port map(
       instr_index => pc_conn_buff,
       instr_out => s1_instr_out,
       instr_input => s1_instr_input,
       fetch => fetch
  );

program_counter : p_counter
  port map(
       reset => reset,
       clock => clk,
       pc_out => pc_conn_buff,
       fetch => fetch
  );


end stage1_arch;
