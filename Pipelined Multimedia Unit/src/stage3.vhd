--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {stage3_ent} architecture {stage3_ent}}
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity stage3_ent is
	port(
	-- INPUTS 

		 s3_rs1_in : in STD_LOGIC_VECTOR(4 downto 0);
		 s3_rs2_in : in STD_LOGIC_VECTOR(4 downto 0);
		 s3_rs3_in : in STD_LOGIC_VECTOR(4 downto 0);
		 s3_rs1_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 s3_rs2_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 s3_rs3_in_val : in STD_LOGIC_VECTOR(127 downto 0);
		 s3_command_bits_in : in STD_LOGIC_VECTOR(7 downto 0);
		 s3_ls_sa_hl_bits_in : in STD_LOGIC_VECTOR(2 downto 0);
		 s3_load_index_in : in STD_LOGIC_VECTOR(2 downto 0);
		 ex_wb_rd_in : in STD_LOGIC_VECTOR(4 downto 0);
		 s3_bits23_24_in : in STD_LOGIC_VECTOR(1 downto 0); 
		 s3_immediate_in : in STD_LOGIC_VECTOR(15 downto 0);
		 s3_shift_val_in : in STD_LOGIC_VECTOR(3 downto 0);
		 ex_wb_writeback_toggle_in: in STD_LOGIC;
		 ex_wb_out_s3_in: in STD_LOGIC_VECTOR(127 DOWNTO 0);
		 s3_alu_out_ex_wb_in: out STD_LOGIC_VECTOR(127 DOWNTO 0)
	     );
end stage3_ent;

--}} End of automatically maintained section

architecture stage3_ent of stage3_ent is
-- connection foward to MUX -- 
SIGNAL foward_out_mux1_in : STD_LOGIC;
SIGNAL foward_out_mux2_in : STD_LOGIC;
SIGNAL foward_out_mux3_in : STD_LOGIC;
-- MUX TO ALU --
SIGNAL mux1_alu1 : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL mux2_alu2 : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL mux3_alu3 : STD_LOGIC_VECTOR(127 downto 0);
-- ALU TO EX_wB -- 
begin
	Forwarding_Unit: entity Forwarding_Unit PORT MAP(
		rs1_in_num=>s3_rs1_in,
		rs2_in_num=> s3_rs2_in,
		rs3_in_num=> s3_rs3_in,
		writeback_toggle=> ex_wb_writeback_toggle_in,
		write_backdest_reg_in=>ex_wb_rd_in,
		sel_mux1=>foward_out_mux1_in,
		sel_mux2=>foward_out_mux2_in,
		sel_mux3=>foward_out_mux3_in
		); 
		
	MUX_1: entity  mux21 PORT MAP(
		InputA=>s3_rs1_in_val,
		SEL=>foward_out_mux1_in,
		InputB=>ex_wb_out_s3_in,
		Output=>mux1_alu1
		);
		
	MUX_2: entity  mux21 PORT MAP(
		InputA=>s3_rs2_in_val,
		SEL=>foward_out_mux2_in,
		InputB=>ex_wb_out_s3_in,
		Output=>mux2_alu2
		);	
		
	MUX_3: entity  mux21 PORT MAP(
		InputA=>s3_rs3_in_val,
		SEL=>foward_out_mux3_in,
		InputB=>ex_wb_out_s3_in,
		Output=>mux3_alu3
		);	
		
	ALU : entity alu PORT MAP(
			BIT_24_23=>	s3_bits23_24_in,
			ALUin1_VAL=>mux1_alu1,
			ALUin2_VAL=>mux2_alu2,
			ALUin3_VAL=>mux3_alu3,
			loadIndex_in => s3_load_index_in,
			shift_val_in =>s3_shift_val_in,
			Immediate_in=>s3_immediate_in,
			ALU_OPCODE=>s3_command_bits_in,
			LI_SA_HL=>s3_ls_sa_hl_bits_in,
			ALUresult=>s3_alu_out_ex_wb_in
			);
	

	 -- enter your statements here --

end stage3_ent;
