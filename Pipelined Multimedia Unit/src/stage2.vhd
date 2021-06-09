--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {stage2_ent} architecture {stage2_behavior}}
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity stage2_ent is
	 port(
		 clk : IN STD_LOGIC;	  
		 instr_input : in STD_LOGIC_VECTOR(24 downto 0 );
		 regwrite_out : OUT STD_LOGIC;
		 write_toggle : IN STD_LOGIC;
		 write_reg : IN STD_LOGIC_VECTOR(4 downto 0);
		 write_val : IN STD_LOGIC_VECTOR(127 downto 0);
		 bits23_24 : OUT STD_LOGIC_VECTOR(1 downto 0);
		 rs1 : OUT STD_LOGIC_VECTOR(4 downto 0);
		 rs2 : OUT STD_LOGIC_VECTOR(4 downto 0);
		 rs3 : OUT STD_LOGIC_VECTOR(4 downto 0);
		 rs1_val : OUT STD_LOGIC_VECTOR(127 downto 0);
		 rs2_val : OUT STD_LOGIC_VECTOR(127 downto 0);
		 rs3_val : OUT STD_LOGIC_VECTOR(127 downto 0);
		 shift_val_out : OUT STD_LOGIC_VECTOR(3 downto 0);
		 rd : OUT STD_LOGIC_VECTOR(4 downto 0);
		 immediate_val : OUT STD_LOGIC_VECTOR(15 downto 0);
		 loadindex : OUT STD_LOGIC_VECTOR(2 downto 0);
		 command_bits : OUT STD_LOGIC_VECTOR(7 downto 0);
		 ls_sa_hl_bits_out : OUT STD_LOGIC_VECTOR(2 downto 0)
	     );
end stage2_ent;

--}} End of automatically maintained section

architecture stage2_behavior of stage2_ent is
-- We must move some signals from decoder to reg file we use signals here instead of a variable for the clock--
SIGNAL if_reg_conn_rs1 : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL if_reg_conn_rs2 : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL if_reg_conn_rs3 : STD_LOGIC_VECTOR(4 downto 0);
begin
	rs1<=if_reg_conn_rs1; 
	rs2<=if_reg_conn_rs2;
	rs3<=if_reg_conn_rs3;
	if_id : entity IF_ID PORT MAP(clk=>clk, instr_in=>instr_input, rs1=>if_reg_conn_rs1, rs2=>if_reg_conn_rs2, rs3=>if_reg_conn_rs3, command_bits=>command_bits, rd=>rd, ls_sa_hl_bits=>ls_sa_hl_bits_out,
		immediate_16 =>immediate_val, load_index =>loadindex, shift_val=>shift_val_out, regwrite=>regwrite_out, bit23_24=>bits23_24);		
	reg_file : entity Register_File PORT MAP (clk=>clk, reg_1_val=>rs1_val, reg_2_val=>rs2_val, reg_3_val=>rs3_val, writeRegister=>write_reg, writeData=>write_val, regWrite=>write_toggle,
		reg_1=>if_reg_conn_rs1, reg_2=>if_reg_conn_rs2, reg_3 =>if_reg_conn_rs3);	   
		

end stage2_behavior;
