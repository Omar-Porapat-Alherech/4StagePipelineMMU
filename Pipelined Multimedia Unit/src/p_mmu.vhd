--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {p_mmu_ent} architecture {p_mmu_arch}}
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity p_mmu_ent is
	 port(
		 reset : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 fetch : in STD_LOGIC;
		 instr_input : in STD_LOGIC_VECTOR(24 downto 0)
	     );
end p_mmu_ent;

--}} End of automatically maintained section

architecture p_mmu_arch of p_mmu_ent is	
-- STAGE 1 -> STAGE 2 -- 
SIGNAL s1_instr_out_global: STD_LOGIC_VECTOR(24 DOWNTO 0);
-- STAGE 2- ID/EX-- 

SIGNAL stage2_rs1out_id_ex_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL stage2_rs2out_id_ex_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL stage2_rs3out_stage3_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL stage2_rs1out_val_id_ex_in : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL stage2_rs2out_val_id_ex_in : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL stage2_rs3out_val_id_ex_in : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL stage2_bits23_24_id_ex_in : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL stage2_shift_val_id_ex_in : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL stage2_rd_id_ex_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL stage2_immediate_ex_in : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL stage2_load_index_ex_in : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL stage2_command_bits_ex_in : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL stage2_ls_sa_hl_id_ex_in : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL stage2_regwrite_id_ex_in : STD_LOGIC;
-- ID/EX out - stage 3 -- 
SIGNAL id_ex_bit23_24_out_s3_in : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL id_ex_rs1_out_s3_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL id_ex_rs2_out_s3_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL id_ex_rs3_out_s3_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL id_ex_rs1_out_val_s3_in : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL id_ex_rs2_out_val_s3_in : STD_LOGIC_VECTOR(127 downto 0);
SIGNAL id_ex_rs3_out_val_s3_in	: STD_LOGIC_VECTOR(127 downto 0);
SIGNAL id_ex_immediate_out_s3_in : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL id_ex_li_sa_hs_bits_s3_in : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL id_ex_loadindex_out_s3_in  : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL id_ex_shift_val_out_s3_in : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL id_ex_command_bits_out_s3_in : STD_LOGIC_VECTOR(7 downto 0);
-- ID/EX -> EX_WB -- 
SIGNAL id_ex_reg_write_ex_wb_in  : STD_LOGIC;
SIGNAL id_ex_rd_out_ex_wb_in:  STD_LOGIC_VECTOR(4 downto 0);  

--stage 3 --
SIGNAL s3_alu_out_ex_wb_in: STD_LOGIC_VECTOR(127 downto 0);
-- WRITEBACK -- 
SIGNAL ex_wb_out_fw_write_toggle_in : STD_LOGIC;
SIGNAL ex_wb_out_fw_write_reg_in : STD_LOGIC_VECTOR(4 downto 0);
SIGNAL ex_wb_out_fw_write_val_in :  STD_LOGIC_VECTOR(127 downto 0);
begin
	stage1: entity stage1_ent port map(reset=>reset, clk=>clk, fetch=>fetch, s1_instr_input=>instr_input,
		s1_instr_out=>s1_instr_out_global);
	
	stage2: entity stage2_ent port map(
		clk=>clk,
		instr_input=>s1_instr_out_global,
		write_toggle=> ex_wb_out_fw_write_toggle_in,
		write_val=>	ex_wb_out_fw_write_val_in,
		rs1=>stage2_rs1out_id_ex_in,
		rs2=>stage2_rs2out_id_ex_in,
		rs3=>stage2_rs3out_stage3_in, 
		rs1_val=>stage2_rs1out_val_id_ex_in,
		rs2_val=>stage2_rs2out_val_id_ex_in,
		rs3_val=>stage2_rs3out_val_id_ex_in,
		write_reg=>ex_wb_out_fw_write_reg_in,
		bits23_24=>stage2_bits23_24_id_ex_in, 
		shift_val_out=>stage2_shift_val_id_ex_in,
		rd=>stage2_rd_id_ex_in,
		immediate_val=>stage2_immediate_ex_in,
		loadindex=>stage2_load_index_ex_in,
		command_bits=>stage2_command_bits_ex_in,
		ls_sa_hl_bits_out=>stage2_ls_sa_hl_id_ex_in,
		regwrite_out=> stage2_regwrite_id_ex_in
		);	
		
	ID_EX: entity ID_EX PORT MAP(
		clk =>clk,
		reg_write_in=>stage2_regwrite_id_ex_in,
		bit23_24_in=>stage2_bits23_24_id_ex_in,
		rs1_in=>stage2_rs1out_id_ex_in,
		rs2_in=>stage2_rs2out_id_ex_in,
		rs3_in=>stage2_rs3out_stage3_in,
		rs1_in_val=>stage2_rs1out_val_id_ex_in,
		rs2_in_val=>stage2_rs2out_val_id_ex_in,
		rs3_in_val=>stage2_rs3out_val_id_ex_in,
		immediate_in=>stage2_immediate_ex_in,
		loadindex_in=>stage2_load_index_ex_in,
		shift_val_in=>stage2_shift_val_id_ex_in,
		rd_in=>stage2_rd_id_ex_in,
		command_bits_in=>stage2_command_bits_ex_in,
		li_sa_ha_bits_in=>stage2_ls_sa_hl_id_ex_in,
		--
		bit23_24_out=>id_ex_bit23_24_out_s3_in,
		reg_write_out=>id_ex_reg_write_ex_wb_in,
		rs1_out=>id_ex_rs1_out_s3_in,
		rs2_out=>id_ex_rs2_out_s3_in,
		rs3_out=>id_ex_rs3_out_s3_in,
		rs1_out_val=>id_ex_rs1_out_val_s3_in,
		rs2_out_val=>id_ex_rs2_out_val_s3_in,
		rs3_out_val=>id_ex_rs3_out_val_s3_in,
		immediate_out=>id_ex_immediate_out_s3_in,
		loadindex_out=>id_ex_loadindex_out_s3_in,
		li_sa_ha_bits_out=>id_ex_li_sa_hs_bits_s3_in,
		shift_val_out=>id_ex_shift_val_out_s3_in,
		command_bits_out=>id_ex_command_bits_out_s3_in,
		rd_out=>id_ex_rd_out_ex_wb_in 
		);	   
			
	stage3: entity stage3_ent  PORT MAP(
		 s3_rs1_in=>id_ex_rs1_out_s3_in,
		 s3_rs2_in=>id_ex_rs2_out_s3_in,
		 s3_rs3_in=>id_ex_rs3_out_s3_in,
		 s3_rs1_in_val=>id_ex_rs1_out_val_s3_in,
		 s3_rs2_in_val=>id_ex_rs2_out_val_s3_in,
		 s3_rs3_in_val=>id_ex_rs3_out_val_s3_in,
		 s3_command_bits_in=>id_ex_command_bits_out_s3_in,
		 s3_ls_sa_hl_bits_in=>id_ex_li_sa_hs_bits_s3_in,
		 s3_load_index_in=>id_ex_loadindex_out_s3_in,
		 s3_bits23_24_in=>id_ex_bit23_24_out_s3_in, 
		 s3_immediate_in=>id_ex_immediate_out_s3_in,
		 s3_shift_val_in=>id_ex_shift_val_out_s3_in, 
		 ex_wb_rd_in=>id_ex_rd_out_ex_wb_in,
		 ex_wb_writeback_toggle_in=>ex_wb_out_fw_write_toggle_in,
		 ex_wb_out_s3_in=>ex_wb_out_fw_write_val_in,
		 s3_alu_out_ex_wb_in=>s3_alu_out_ex_wb_in

		);	
		
	EX_WB: entity ex_wb_ent  PORT MAP(
		clk=>clk,
		togglewb=>id_ex_reg_write_ex_wb_in,
		stage3_output_in=>s3_alu_out_ex_wb_in, 
		dest_reg_in=> id_ex_rd_out_ex_wb_in,
		dest_reg_out=>ex_wb_out_fw_write_reg_in,
		write_val=>ex_wb_out_fw_write_val_in, 
		togglewb_out=>ex_wb_out_fw_write_toggle_in

		);
		
	
		
	 -- enter your statements here --

end p_mmu_arch;
