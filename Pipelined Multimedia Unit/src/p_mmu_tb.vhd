--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {p_mmu_tb_ent} architecture {p_mmu_tb_arch}}

library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;	 
use IEEE.std_logic_textio.all;
use STD.TEXTIO.all;
library pipelined_multimedia_unit;
use pipelined_multimedia_unit.all;

entity p_mmu_tb_ent is
end p_mmu_tb_ent;


architecture p_mmu_tb_arch of p_mmu_tb_ent is 
type arr_size_64 is array(0 to 64) of STD_LOGIC_VECTOR(24 DOWNTO 0); 
	FILE assembled_instr : text;
	FILE results : text; 
	SIGNAL instr_arr : arr_size_64; 
	SIGNAL instruction_vector : STD_lOGIC_VECTOR(24 DOWNTO 0);
	SIGNAL base_clock : STD_LOGIC := '0';
	SIGNAL reset : STD_LOGIC := '0';
	CONSTANT PERIOD : TIME := 100 ns;  
	SIGNAL fetch_clock : STD_LOGIC := '0';
begin
	UUT: entity p_mmu_ent port map(instr_Input  => instruction_vector, clk => base_clock, reset => reset, fetch=>fetch_clock); 		
		
	--read Input  file
	parse: process
	VARIABLE text_line : line; 
	VARIABLE mmu_out : line;
	VARIABLE vector_line : STD_lOGIC_VECTOR(24 downto 0);
	--s1 in out
		ALIAS instruction_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage1.instruction_fetch.instr_out : STD_LOGIC_VECTOR(24 DOWNTO 0)>>;
		ALIAS instruction_in is <<SIGNAL .p_mmu_tb_ent.UUT.stage1.instruction_fetch.instr_Input  : STD_LOGIC_VECTOR(24 DOWNTO 0)>>;
	-- s2 in out
		ALIAS s2_instr_in is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.instr_in : STD_LOGIC_VECTOR(24 DOWNTO 0)>>;
		ALIAS s2_regwrite_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.regwrite : STD_LOGIC>>;
		ALIAS s2_bit23_24_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.bit23_24 : STD_LOGIC_VECTOR(1 DOWNTO 0)>>;
		ALIAS s2_load_index_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.load_index : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		ALIAS s2_immediate_16_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.immediate_16 : STD_LOGIC_VECTOR(15 DOWNTO 0)>>;
		ALIAS s2_rd_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.rd : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS s2_command_bits_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.command_bits : STD_LOGIC_VECTOR(7 DOWNTO 0)>>;
		ALIAS s2_rs1_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS s2_rs2_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS s2_rs3_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.rs3 : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS s2_rs1_val_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.reg_file.reg_1_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS s2_rs2_val_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.reg_file.reg_2_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS s2_rs3_val_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.reg_file.reg_3_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS s2_shift_val_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.shift_val : STD_LOGIC_VECTOR(3 DOWNTO 0)>>;
		ALIAS s2_ls_sa_hl_bits_out is <<SIGNAL .p_mmu_tb_ent.UUT.stage2.if_id.ls_sa_hl_bits : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		-- id ex --
		--iN  -- 
		ALIAS reg_write_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.reg_write_in :  STD_LOGIC>>;
		ALIAS bit23_24_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.bit23_24_in : STD_LOGIC_VECTOR(1 DOWNTO 0)>>;
		ALIAS rs1_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs1_in : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs2_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs2_in : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs3_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs3_in : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs1_in_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs1_in_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS rs2_in_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs2_in_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS rs3_in_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs3_in_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS immediate_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.immediate_in : STD_LOGIC_VECTOR(15 DOWNTO 0)>>;
		ALIAS loadindex_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.loadindex_in : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		ALIAS shift_val_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.shift_val_in : STD_LOGIC_VECTOR(3 DOWNTO 0)>>;
		ALIAS rd_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rd_in : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS command_bits_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.command_bits_in : STD_LOGIC_VECTOR(7 DOWNTO 0)>>;
		ALIAS li_sa_ha_bits_in is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.li_sa_ha_bits_in : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		-- OUT 
		ALIAS reg_write_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.reg_write_out :  STD_LOGIC>>;
		ALIAS bit23_24_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.bit23_24_out : STD_LOGIC_VECTOR(1 DOWNTO 0)>>;
		ALIAS rs1_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs1_out : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs2_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs2_out : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs3_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs3_out : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS rs1_out_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs1_out_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS rs2_out_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs2_out_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS rs3_out_val is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rs3_out_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;
		ALIAS immediate_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.immediate_out : STD_LOGIC_VECTOR(15 DOWNTO 0)>>;
		ALIAS loadindex_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.loadindex_out : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		ALIAS shift_val_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.shift_val_out : STD_LOGIC_VECTOR(3 DOWNTO 0)>>;
		ALIAS rd_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.rd_out : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS command_bits_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.command_bits_out : STD_LOGIC_VECTOR(7 DOWNTO 0)>>;
		ALIAS li_sa_ha_bits_out is <<SIGNAL .p_mmu_tb_ent.UUT.ID_EX.li_sa_ha_bits_out : STD_LOGIC_VECTOR(2 DOWNTO 0)>>;
		-- ex->s3 -- 
		ALIAS ex_wb_out_wbtoggle_s3_in is <<SIGNAL .p_mmu_tb_ent.UUT.EX_WB.togglewb_out :  STD_LOGIC>>;
		ALIAS ex_wb_out_rd_s3_in  is <<SIGNAL .p_mmu_tb_ent.UUT.EX_WB.dest_reg_out : STD_LOGIC_VECTOR(4 DOWNTO 0)>>;
		ALIAS ex_wb_out_wvalue_s3_in  is  <<SIGNAL .p_mmu_tb_ent.UUT.EX_WB.write_val : STD_LOGIC_VECTOR(127 DOWNTO 0)>>; 
		-- s3 -> ex -- 
		ALIAS s3_out_ex_in is <<SIGNAL .p_mmu_tb_ent.UUT.stage3.ALU.ALUresult : STD_LOGIC_VECTOR(127 DOWNTO 0)>>;

		

		
	
	
	
	begin
		file_open(assembled_instr, "mmu_input.txt", read_mode);
		file_open(results, "mmu_Output.txt", write_mode);
		while not endfile (assembled_instr) loop
			wait for PERIOD/2;
			fetch_clock <= '1';
			readline(assembled_instr, text_line); 
		    read(text_line, vector_line);
			instruction_vector <= vector_line;
			wait for PERIOD/2;
			fetch_clock<='0';
		end loop;
		file_close(assembled_instr);
		reset<='1';
		wait for PERIOD;
		reset<='0';
		wait for PERIOD;
		for cc in 0 to 100 loop
			wait for PERIOD;
			base_clock <= '1';
			-- using https://www.csee.umbc.edu/portal/help/VHDL/samples/samples.html as the example to write-- 
			write(mmu_out, string'("===============Clock Cycle ") & to_string(cc) & string'("==============="));	
			writeline(results, mmu_out); 
			write(mmu_out, string'("=============== UUT ==============="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("=============== STAGE1 ==============="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("===Inputs ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("Instruction Input  - this will be constant as everything has finished loading ") & to_string(instruction_in));
			writeline(results, mmu_out);
			write(mmu_out, string'("===Outputs ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("Instruction Output ") & to_string(instruction_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("=============== STAGE2 IF/ID DECODER ==============="));
			writeline(results, mmu_out); 
			write(mmu_out, string'("===Inputs ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("s2 Instruction Input  ") & to_string(s2_instr_in));
			writeline(results, mmu_out);
			write(mmu_out, string'("===Outputs ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_regwrite_out Output  ") & to_string(s2_regwrite_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_load_index_out Output  ") & to_string(s2_load_index_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_immediate_16_out Output ") & to_string(s2_immediate_16_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rd_out Output ") & to_string(s2_rd_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_command_bits_out") & to_string(s2_command_bits_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs1_out Output ") & to_string(s2_rs1_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs2_out Output ") & to_string(s2_rs2_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs3_out Output ") & to_string(s2_rs3_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs1_val_out Output ") & to_string(s2_rs1_val_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs2_val_out Output ") & to_string(s2_rs2_val_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_rs3_val_out Output ") & to_string(s2_rs3_val_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_shift_val_out Output ") & to_string(s2_shift_val_out));
			writeline(results, mmu_out); 
			write(mmu_out, string'("s2_ls_sa_hl_bits_out Output") & to_string(UNSIGNED(s2_ls_sa_hl_bits_out)));
			writeline(results, mmu_out);
			write(mmu_out, string'("s2_bit23_24_out Output ") & to_string(s2_bit23_24_out));
			writeline(results, mmu_out);
			write(mmu_out, string'("=== IN/OUT ID_EX ==="));
			writeline(results, mmu_out);
			write(mmu_out, string'(" reg_write_in Input  ") & to_string(reg_write_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" bit23_24_in Input  ") & to_string(bit23_24_in));
			writeline(results, mmu_out); 
			write(mmu_out, string'(" rs1_in Input  ") & to_string(rs1_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rs2_in Input  ") & to_string(rs2_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rs3_in Input  ") & to_string(rs3_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rs1_in_val Input  ") & to_string(rs1_in_val));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rs2_in_val Input  ") & to_string(rs2_in_val));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rs3_in_val Input  ") & to_string(rs3_in_val));
			writeline(results, mmu_out);
			write(mmu_out, string'(" immediate_in Input  ") & to_string(immediate_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" loadindex_in Input  ") & to_string(loadindex_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" shift_val_in Input  ") & to_string(shift_val_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" rd_in Input  ") & to_string(rd_in));
			writeline(results, mmu_out);   
			write(mmu_out, string'(" command_bits_in Input  ") & to_string(command_bits_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" li_sa_ha_bits_in Input  ") & to_string(li_sa_ha_bits_in));
			writeline(results, mmu_out);

			write(mmu_out, string'("===============STAGE 3 FOWARDING, ALU ==============="));
			writeline(results, mmu_out);
			write(mmu_out, string'("NOTE - ALL ID_EX OutputS ARE InputS HERE, SO Inputs  ARE NOT SPECIFIED EXCEPT FOR THE ONES COMING FROM EX_WB, ONLY OutputS ARE SPECIFIED FOR STAGE 3"));
			writeline(results, mmu_out);
			write(mmu_out, string'("===Inputs  S3 FOWARDING ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'(" dest_reg Input  ") & to_string(ex_wb_out_rd_s3_in));
			writeline(results, mmu_out);
			write(mmu_out, string'(" togglewb Input  ") & to_string(ex_wb_out_wbtoggle_s3_in));
			writeline(results, mmu_out); 
			write(mmu_out, string'("===Inputs  S3 MUX ==="));	
			writeline(results, mmu_out);
			write(mmu_out, string'(" write_val Input  ") & to_string(ex_wb_out_wvalue_s3_in));
			writeline(results, mmu_out);
			write(mmu_out, string'("===Outputs  ALU  ==="));
			write(mmu_out, string'(" ALU OUT ") & to_string(s3_out_ex_in));
			writeline(results, mmu_out); 
			write(mmu_out, string'("=============== EX_wB ==============="));
			writeline(results, mmu_out);  
			write(mmu_out, string'("Inputs "));
			writeline(results, mmu_out);
			write(mmu_out, string'(" dest_reg Output  ") & to_string(ex_wb_out_rd_s3_in));
			writeline(results, mmu_out);	
			write(mmu_out, string'(" togglewb Output  ") & to_string(ex_wb_out_wbtoggle_s3_in));
			writeline(results, mmu_out); 
			write(mmu_out, string'(" write_val Output  ") & to_string(ex_wb_out_wvalue_s3_in));
			writeline(results, mmu_out);
			wait for PERIOD;
			base_clock<='0'; 
		end loop;
	file_close(results);
	end process;
end p_mmu_tb_arch;
