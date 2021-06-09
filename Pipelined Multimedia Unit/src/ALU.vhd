--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {alu} architecture {alu_behavior}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	 port(
	 	 BIT_24_23 : in STD_LOGIC_VECTOR(1 downto 0);
		 ALUin1_VAL : in STD_LOGIC_VECTOR(127 downto 0);
		 ALUin2_VAL : in STD_LOGIC_VECTOR(127 downto 0);
		 ALUin3_VAL : in STD_LOGIC_VECTOR(127 downto 0);
		 Immediate_in : in STD_LOGIC_VECTOR(15 downto 0);
		 loadIndex_in : in STD_LOGIC_VECTOR(2 downto 0);
		 shift_val_in : in STD_LOGIC_VECTOR(3 downto 0);
		 ALU_OPCODE : in STD_LOGIC_VECTOR(7 downto 0);
		 LI_SA_HL : in STD_LOGIC_VECTOR(2 downto 0); 
		 ALUresult : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end alu;

--}} End of automatically maintained section

architecture behavorial of alu is
begin
	ALU : process (BIT_24_23, ALUin1_VAL, ALUin2_VAL, ALUin3_VAL, Immediate_in, loadIndex_in, shift_val_in, ALU_OPCODE, LI_SA_HL)
		variable t_int : integer;
		variable t_rot: integer;
		variable t_32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
		variable one_counter : Integer;	
		variable temp1 : STD_LOGIC_VECTOR(15 downto 0);
		variable temp2 : STD_LOGIC_VECTOR(31 downto 0);
		variable tempr1 : integer;
		variable tempr2 : integer;
		variable tempr3 : integer;
		variable tempr4 : integer;
		variable tempLoad : STD_LOGIC_VECTOR(127 downto 0);
	begin
		
		if (BIT_24_23 = "00" or BIT_24_23 = "01") then -- LOAD IMMEDIATE
			case loadIndex_in is
				when "000" => ALUresult <= ALUin1_VAL(127 downto 16) & Immediate_in;
				when "001" => ALUresult <= ALUin1_VAL(127 downto 32) & Immediate_in & ALUin1_VAL(15 downto 0);
				when "010" => ALUresult <= ALUin1_VAL(127 downto 48) & Immediate_in & ALUin1_VAL(31 downto 0);
				when "011" => ALUresult <= ALUin1_VAL(127 downto 64) & Immediate_in & ALUin1_VAL(47 downto 0);
				when "100" => ALUresult <= ALUin1_VAL(127 downto 80) & Immediate_in & ALUin1_VAL(63 downto 0);
				when "101" => ALUresult <= ALUin1_VAL(127 downto 96) & Immediate_in & ALUin1_VAL(79 downto 0);
				when "110" => ALUresult <= ALUin1_VAL(127 downto 112) & Immediate_in & ALUin1_VAL(95 downto 0);
				when "111" => ALUresult <= Immediate_in & ALUin1_VAL(111 downto 0);
				when others => null;
			end case;
			
			
		elsif (BIT_24_23 = "10") then -- R4 - INSTRUCTION FORMAT
			case LI_SA_HL is
				when "000" =>
				-- Signed Integer Multiply-Add Low with Saturation
					tempr1 := to_integer(signed(ALUin3_VAL(15 downto 0)) * signed(ALUin2_VAL(15 downto 0)) + signed(ALUin1_VAL(31 downto 0)));			
					tempr2 := to_integer(signed(ALUin3_VAL(47 downto 32)) * signed(ALUin2_VAL(47 downto 32)) + signed(ALUin1_VAL(63 downto 32)));			
					tempr3 := to_integer(signed(ALUin3_VAL(79 downto 64)) * signed(ALUin2_VAL(79 downto 64)) + signed(ALUin1_VAL(79 downto 64)));			
					tempr4 := to_integer(signed(ALUin3_VAL(111 downto 96)) * signed(ALUin2_VAL(111 downto 96)) + signed(ALUin1_VAL(111 downto 96)));			
					
					if (tempr1 > 214783647) then
						tempr1 := 214783647;
					elsif (tempr1 < -214783648) then
						tempr1 := -214783648;  
					end if;
					if (tempr2 > 214783647) then
						tempr2 := 214783647;
					elsif (tempr2 < -214783648) then
						tempr2 := -214783648;  
					end if;
					if (tempr3 > 214783647) then
						tempr3 := 214783647;
					elsif (tempr3 < -214783648) then
						tempr3 := -214783648;  
					end if;	 
					if (tempr4 > 214783647) then
						tempr4 := 214783647;
					elsif (tempr4 < -214783648) then
						tempr4 := -214783648;  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
	
				when "001" => 
				-- Signed Integer Multiply-Add High with Saturation
					tempr1 := to_integer(signed(ALUin3_VAL(31 downto 16)) * signed(ALUin2_VAL(31 downto 16)) + signed(ALUin1_VAL(31 downto 0)));			
					tempr2 := to_integer(signed(ALUin3_VAL(63 downto 48)) * signed(ALUin2_VAL(63 downto 48)) + signed(ALUin1_VAL(63 downto 32)));			
					tempr3 := to_integer(signed(ALUin3_VAL(95 downto 80)) * signed(ALUin2_VAL(95 downto 80)) + signed(ALUin1_VAL(79 downto 64)));			
					tempr4 := to_integer(signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)) + signed(ALUin1_VAL(127 downto 96)));			
					
					if (tempr1 > 214783647) then
						tempr1 := 214783647;
					elsif (tempr1 < -214783648) then
						tempr1 := -214783648;  
					end if;
					if (tempr2 > 214783647) then
						tempr2 := 214783647;
					elsif (tempr2 < -214783648) then
						tempr2 := -214783648;  
					end if;
					if (tempr3 > 214783647) then
						tempr3 := 214783647;
					elsif (tempr3 < -214783648) then
						tempr3 := -214783648;  
					end if;	 
					if (tempr4 > 214783647) then
						tempr4 := 214783647;
					elsif (tempr4 < -214783648) then
						tempr4 := -214783648;  
					end if;
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when "010" =>
				-- Signed Integer Multiply-Subract Low with Saturation
					tempr1 := to_integer(signed(ALUin1_VAL(31 downto 0)) - signed(ALUin3_VAL(15 downto 0)) * signed(ALUin2_VAL(15 downto 0)));			
					tempr2 := to_integer(signed(ALUin1_VAL(63 downto 32)) - signed(ALUin3_VAL(47 downto 32)) * signed(ALUin2_VAL(47 downto 32)));
					tempr3 := to_integer(signed(ALUin1_VAL(95 downto 64)) - signed(ALUin3_VAL(79 downto 64)) * signed(ALUin2_VAL(79 downto 64)));
					tempr4 := to_integer(signed(ALUin1_VAL(127 downto 96)) - signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)));			
					
					if (tempr1 > 214783647) then
						tempr1 := 214783647;
					elsif (tempr1 < -214783648) then
						tempr1 := -214783648;  
					end if;
					if (tempr2 > 214783647) then
						tempr2 := 214783647;
					elsif (tempr2 < -214783648) then
						tempr2 := -214783648;  
					end if;
					if (tempr3 > 214783647) then
						tempr3 := 214783647;
					elsif (tempr3 < -214783648) then
						tempr3 := -214783648;  
					end if;	 
					if (tempr4 > 214783647) then
						tempr4 := 214783647;
					elsif (tempr4 < -214783648) then
						tempr4 := -214783648;  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when "011" =>
				-- Signed Integer Mltiply-Subtract High with Saturation
					tempr1 := to_integer(signed(ALUin1_VAL(31 downto 0)) - signed(ALUin3_VAL(31 downto 16)) * signed(ALUin2_VAL(31 downto 16)));			
					tempr2 := to_integer(signed(ALUin1_VAL(63 downto 32)) - signed(ALUin3_VAL(63 downto 48)) * signed(ALUin2_VAL(63 downto 48)));
					tempr3 := to_integer(signed(ALUin1_VAL(95 downto 64)) - signed(ALUin3_VAL(95 downto 80)) * signed(ALUin2_VAL(95 downto 80)));
					tempr4 := to_integer(signed(ALUin1_VAL(127 downto 96)) - signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)));			
					
					if (tempr1 > 214783647) then
						tempr1 := 214783647;
					elsif (tempr1 < -214783648) then
						tempr1 := -214783648;  
					end if;
					if (tempr2 > 214783647) then
						tempr2 := 214783647;
					elsif (tempr2 < -214783648) then
						tempr2 := -214783648;  
					end if;
					if (tempr3 > 214783647) then
						tempr3 := 214783647;
					elsif (tempr3 < -214783648) then
						tempr3 := -214783648;  
					end if;	 
					if (tempr4 > 214783647) then
						tempr4 := 214783647;
					elsif (tempr4 < -214783648) then
						tempr4 := -214783648;  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when "100" =>  
				-- Signed Long Integer Multiply-Add Low with Saturation
					tempr1 := to_integer(signed(ALUin3_VAL(15 downto 0)) * signed(ALUin2_VAL(15 downto 0)) + signed(ALUin1_VAL(31 downto 0)));			
					tempr2 := to_integer(signed(ALUin3_VAL(47 downto 32)) * signed(ALUin2_VAL(47 downto 32)) + signed(ALUin1_VAL(63 downto 32)));			
					tempr3 := to_integer(signed(ALUin3_VAL(79 downto 64)) * signed(ALUin2_VAL(79 downto 64)) + signed(ALUin1_VAL(79 downto 64)));			
					tempr4 := to_integer(signed(ALUin3_VAL(111 downto 96)) * signed(ALUin2_VAL(111 downto 96)) + signed(ALUin1_VAL(111 downto 96)));			
					
					if (tempr1 > (2**63)-1) then
						tempr1 := (2**63)-1;
					elsif (tempr1 < -(2**63)) then
						tempr1 := -(2**63);  
					end if;
					if (tempr2 > (2**63)-1) then
						tempr2 := (2**63)-1;
					elsif (tempr2 < -(2**63)) then
						tempr2 := -(2**63);  
					end if;
					if (tempr3 > (2**63)-1) then
						tempr3 := (2**63)-1;
					elsif (tempr3 < -(2**63)) then
						tempr3 := -(2**63);  
					end if;	 
					if (tempr4 > (2**63)-1) then
						tempr4 := (2**63)-1;
					elsif (tempr4 < -(2**63)) then
						tempr4 := -(2**63);  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));	
				when "101" =>
				-- Signed Long Integer Multiply-ADd High with Saturation
					tempr1 := to_integer(signed(ALUin3_VAL(31 downto 16)) * signed(ALUin2_VAL(31 downto 16)) + signed(ALUin1_VAL(31 downto 0)));			
					tempr2 := to_integer(signed(ALUin3_VAL(63 downto 48)) * signed(ALUin2_VAL(63 downto 48)) + signed(ALUin1_VAL(63 downto 32)));			
					tempr3 := to_integer(signed(ALUin3_VAL(95 downto 80)) * signed(ALUin2_VAL(95 downto 80)) + signed(ALUin1_VAL(79 downto 64)));			
					tempr4 := to_integer(signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)) + signed(ALUin1_VAL(127 downto 96)));			
					
					if (tempr1 > (2**63)-1) then
						tempr1 := (2**63)-1;
					elsif (tempr1 < -(2**63)) then
						tempr1 := -(2**63);  
					end if;
					if (tempr2 > (2**63)-1) then
						tempr2 := (2**63)-1;
					elsif (tempr2 < -(2**63)) then
						tempr2 := -(2**63);  
					end if;
					if (tempr3 > (2**63)-1) then
						tempr3 := (2**63)-1;
					elsif (tempr3 < -(2**63)) then
						tempr3 := -(2**63);  
					end if;	 
					if (tempr4 > (2**63)-1) then
						tempr4 := (2**63)-1;
					elsif (tempr4 < -(2**63)) then
						tempr4 := -(2**63);  
					end if;
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when "110" => 
				-- Signed Long Integer Multiply-Subtract Low with Saturation
					tempr1 := to_integer(signed(ALUin1_VAL(31 downto 0)) - signed(ALUin3_VAL(15 downto 0)) * signed(ALUin2_VAL(15 downto 0)));			
					tempr2 := to_integer(signed(ALUin1_VAL(63 downto 32)) - signed(ALUin3_VAL(47 downto 32)) * signed(ALUin2_VAL(47 downto 32)));
					tempr3 := to_integer(signed(ALUin1_VAL(95 downto 64)) - signed(ALUin3_VAL(79 downto 64)) * signed(ALUin2_VAL(79 downto 64)));
					tempr4 := to_integer(signed(ALUin1_VAL(127 downto 96)) - signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)));			
					
					if (tempr1 > (2**63)-1) then
						tempr1 := (2**63)-1;
					elsif (tempr1 < -(2**63)) then
						tempr1 := -(2**63);  
					end if;
					if (tempr2 > (2**63)-1) then
						tempr2 := (2**63)-1;
					elsif (tempr2 < -(2**63)) then
						tempr2 := -(2**63);  
					end if;
					if (tempr3 > (2**63)-1) then
						tempr3 := (2**63)-1;
					elsif (tempr3 < -(2**63)) then
						tempr3 := -(2**63);  
					end if;	 
					if (tempr4 > (2**63)-1) then
						tempr4 := (2**63)-1;
					elsif (tempr4 < -(2**63)) then
						tempr4 := -(2**63);  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when "111" => 
				-- Signed Long Integer Multiply-Subtract High with Saturation
					tempr1 := to_integer(signed(ALUin1_VAL(31 downto 0)) - signed(ALUin3_VAL(31 downto 16)) * signed(ALUin2_VAL(31 downto 16)));			
					tempr2 := to_integer(signed(ALUin1_VAL(63 downto 32)) - signed(ALUin3_VAL(63 downto 48)) * signed(ALUin2_VAL(63 downto 48)));
					tempr3 := to_integer(signed(ALUin1_VAL(95 downto 64)) - signed(ALUin3_VAL(95 downto 80)) * signed(ALUin2_VAL(95 downto 80)));
					tempr4 := to_integer(signed(ALUin1_VAL(127 downto 96)) - signed(ALUin3_VAL(127 downto 112)) * signed(ALUin2_VAL(127 downto 112)));			
					
					if (tempr1 > (2**63)-1) then
						tempr1 := (2**63)-1;
					elsif (tempr1 < -(2**63)) then
						tempr1 := -(2**63);  
					end if;
					if (tempr2 > (2**63)-1) then
						tempr2 := (2**63)-1;
					elsif (tempr2 < -(2**63)) then
						tempr2 := -(2**63);  
					end if;
					if (tempr3 > (2**63)-1) then
						tempr3 := (2**63)-1;
					elsif (tempr3 < -(2**63)) then
						tempr3 := -(2**63);  
					end if;	 
					if (tempr4 > (2**63)-1) then
						tempr4 := (2**63)-1;
					elsif (tempr4 < -(2**63)) then
						tempr4 := -(2**63);  
					end if;
					
					ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_signed(tempr1,32));
					ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_signed(tempr2,32));
					ALUresult(63 downto 32)	<= STD_LOGIC_VECTOR(to_signed(tempr3,32));
					ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(to_signed(tempr4,32));
				when others => null;
			end case;
		else  -- R3 - INSTRUCTION FORMAT
			case ALU_OPCODE is	 
				-- not exactly sure what to do as it does nothing, hopefully NULL doesn't break it-- 
				when "00000000" => NULL;  
				-- AU -- 
				when "00000001"	=>
					ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(127 DOWNTO 96)) + UNSIGNED(ALUin2_VAL(127 DOWNTO 96))); 
					ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(95 DOWNTO 64)) + UNSIGNED(ALUin2_VAL(95 DOWNTO 64)));
					ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(63 DOWNTO 32)) + UNSIGNED(ALUin2_VAL(63 DOWNTO 32)));
					ALUresult(31 DOWNTO 0) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(31 DOWNTO 0)) + UNSIGNED(ALUin2_VAL(31 DOWNTO 0)));
				-- ABSDB -- 
				when "00000010"	=>
					ALUresult(127 DOWNTO 120) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(127 DOWNTO 120)) + SIGNED(ALUin2_VAL(127 DOWNTO 120))); 
					ALUresult(119 DOWNTO 112) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(119 DOWNTO 112)) + SIGNED(ALUin2_VAL(119 DOWNTO 112)));
					ALUresult(111 DOWNTO 104) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(111 DOWNTO 104)) + SIGNED(ALUin2_VAL(111 DOWNTO 104)));
					ALUresult(103 DOWNTO 96) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(103 DOWNTO 96)) + SIGNED(ALUin2_VAL(103 DOWNTO 96)));
					ALUresult(95 DOWNTO 88) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(95 DOWNTO 88)) + SIGNED(ALUin2_VAL(95 DOWNTO 88)));
					ALUresult(87 DOWNTO 80) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(87 DOWNTO 80)) + SIGNED(ALUin2_VAL(87 DOWNTO 80)));
					ALUresult(79 DOWNTO 72) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(79 DOWNTO 72)) + SIGNED(ALUin2_VAL(79 DOWNTO 72)));
					ALUresult(71 DOWNTO 64) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(71 DOWNTO 64)) + SIGNED(ALUin2_VAL(71 DOWNTO 64)));
					ALUresult(63 DOWNTO 56) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(63 DOWNTO 56)) + SIGNED(ALUin2_VAL(63 DOWNTO 56)));
					ALUresult(55 DOWNTO 48) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(55 DOWNTO 48)) + SIGNED(ALUin2_VAL(55 DOWNTO 48)));
					ALUresult(47 DOWNTO 40) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(47 DOWNTO 40)) + SIGNED(ALUin2_VAL(47 DOWNTO 40)));
					ALUresult(39 DOWNTO 32) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(39 DOWNTO 32)) + SIGNED(ALUin2_VAL(39 DOWNTO 32)));
					ALUresult(31 DOWNTO 24) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(31 DOWNTO 24)) + SIGNED(ALUin2_VAL(31 DOWNTO 24)));
					ALUresult(23 DOWNTO 16) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(23 DOWNTO 16)) + SIGNED(ALUin2_VAL(23 DOWNTO 16)));
					ALUresult(15 DOWNTO 8) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(15 DOWNTO 8)) + SIGNED(ALUin2_VAL(15 DOWNTO 8)));
					ALUresult(7 DOWNTO 0) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(7 DOWNTO 0)) + SIGNED(ALUin2_VAL(7 DOWNTO 0)));
				-- AHU -- 		
				when "00000011"	=>
					ALUresult(127 DOWNTO 112) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(127 DOWNTO 112)) + UNSIGNED(ALUin2_VAL(127 DOWNTO 112))); 
					ALUresult(111 DOWNTO 96) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(111 DOWNTO 96)) + UNSIGNED(ALUin2_VAL(111 DOWNTO 96)));
					ALUresult(95 DOWNTO 80) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(95 DOWNTO 80)) + UNSIGNED(ALUin2_VAL(95 DOWNTO 80)));
					ALUresult(79 DOWNTO 64) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(79 DOWNTO 64)) + UNSIGNED(ALUin2_VAL(79 DOWNTO 64)));
					ALUresult(63 DOWNTO 48) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(63 DOWNTO 48)) + UNSIGNED(ALUin2_VAL(63 DOWNTO 48)));
					ALUresult(47 DOWNTO 32) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(47 DOWNTO 32)) + UNSIGNED(ALUin2_VAL(47 DOWNTO 32)));
					ALUresult(31 DOWNTO 16) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(31 DOWNTO 16)) + UNSIGNED(ALUin2_VAL(31 DOWNTO 16)));
					ALUresult(15 DOWNTO 0) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(15 DOWNTO 0)) + UNSIGNED(ALUin2_VAL(15 DOWNTO 0)));
				-- AHS --  
				-- Take a 16 bit integer, convert it to -32768 if less and 32676 if greater, otherwise unchanges -- 
				when "00000100"	=>
					t_int := to_integer(SIGNED(ALUin1_VAL(127 DOWNTO 112)) + SIGNED(ALUin2_VAL(127 DOWNTO 112)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					--can't use 'length-- 
					ALUresult(127 DOWNTO 112) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(111 DOWNTO 96)) + SIGNED(ALUin2_VAL(111 DOWNTO 96)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(111 DOWNTO 96) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(95 DOWNTO 80)) + SIGNED(ALUin2_VAL(95 DOWNTO 80)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(95 DOWNTO 80) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(79 DOWNTO 64)) + SIGNED(ALUin2_VAL(79 DOWNTO 64)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(79 DOWNTO 64) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(63 DOWNTO 48)) + SIGNED(ALUin2_VAL(63 DOWNTO 48)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(63 DOWNTO 48) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(47 DOWNTO 32)) + SIGNED(ALUin2_VAL(47 DOWNTO 32)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(47 DOWNTO 32) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					
					t_int := to_integer(SIGNED(ALUin1_VAL(31 DOWNTO 16)) + SIGNED(ALUin2_VAL(31 DOWNTO 16)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(31 DOWNTO 16) <=STD_LOGIC_VECTOR(to_signed(t_int,16));	 
					
					t_int := to_integer(SIGNED(ALUin1_VAL(15 DOWNTO 0)) + SIGNED(ALUin2_VAL(15 DOWNTO 0)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
				-- AND -- 
				when "00000101" => 
				ALUresult <= ALUin1_VAL AND ALUin2_VAL; 
				-- BCW--
				when "00000110"	=> 
				-- SIGNED? UNSIGHED? ASSUMING NOTHING
					ALUresult(127 DOWNTO 96) <= ALUin1_VAL(127 DOWNTO 96) ;
					ALUresult(95 DOWNTO 64) <= ALUin1_VAL(95 DOWNTO 64);
					ALUresult(63 DOWNTO 32) <= ALUin1_VAL(63 DOWNTO 32);
					ALUresult(31 downto 0) <= ALUin1_VAL(31 downto 0); 
				-- MAXWS -- 	
				when "00000111"	=>
					----
					if SIGNED(ALUin1_VAL(127 DOWNTO 96)) > SIGNED(ALUin2_VAL(127 DOWNTO 96)) then 
						ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(127 DOWNTO 96)));
					else
						ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(127 DOWNTO 96)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(95 DOWNTO 64)) > SIGNED(ALUin2_VAL(95 DOWNTO 64)) then 
						ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(95 DOWNTO 64)));
					else
						ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(95 DOWNTO 64)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(63 DOWNTO 32)) > SIGNED(ALUin2_VAL(63 DOWNTO 32)) then 
						ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(63 DOWNTO 32)));
					else
						ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(63 DOWNTO 32)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(31 downto 0)) > SIGNED(ALUin2_VAL(31 downto 0)) then 
						ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(31 downto 0)));
					else
						ALUresult(31 downto 0) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(31 downto 0)));
					end if;
				-- MINWS -- 
				when "00001000"	=>
				----
					if SIGNED(ALUin1_VAL(127 DOWNTO 96)) < SIGNED(ALUin2_VAL(127 DOWNTO 96)) then 
						ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(127 DOWNTO 96)));
					else
						ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(127 DOWNTO 96)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(95 DOWNTO 64)) < SIGNED(ALUin2_VAL(95 DOWNTO 64)) then 
						ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(95 DOWNTO 64)));
					else
						ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(95 DOWNTO 64)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(63 DOWNTO 32)) < SIGNED(ALUin2_VAL(63 DOWNTO 32)) then 
						ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(63 DOWNTO 32)));
					else
						ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(63 DOWNTO 32)));
					end if;
					----	
					if SIGNED(ALUin1_VAL(31 DOWNTO 0)) < SIGNED(ALUin2_VAL(31 DOWNTO 0)) then 
						ALUresult(31 DOWNTO 0) <= STD_LOGIC_VECTOR(SIGNED(ALUin1_VAL(31 DOWNTO 0)));
					else
						ALUresult(31 DOWNTO 0) <= STD_LOGIC_VECTOR(SIGNED(ALUin2_VAL(31 DOWNTO 0)));
					end if;
				-- MLHU -- 
				when "00001001" =>
					ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(111 DOWNTO 96)) * UNSIGNED(ALUin2_VAL(111 DOWNTO 96)));
					ALUresult(95 DOWNTO 64)  <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(79 DOWNTO 64)) * UNSIGNED(ALUin2_VAL(79 DOWNTO 64)));
					ALUresult(63 DOWNTO 32)  <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(47 DOWNTO 32)) * UNSIGNED(ALUin2_VAL(47 DOWNTO 32)));
					ALUresult(31 DOWNTO 0)   <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(15 DOWNTO 0)) * UNSIGNED(ALUin2_VAL(15 DOWNTO 0)));
				-- MLCHU -- 
				when "00001010"	=>
					ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ALUin1_VAL(111 DOWNTO 96)) * UNSIGNED(ALUin2_VAL(4 DOWNTO 0)), 32));
					ALUresult(95 DOWNTO 64)  <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ALUin1_VAL(79 DOWNTO 64)) * UNSIGNED(ALUin2_VAL(4 DOWNTO 0)), 32));
					ALUresult(63 DOWNTO 32)  <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ALUin1_VAL(47 DOWNTO 32)) * UNSIGNED(ALUin2_VAL(4 DOWNTO 0)), 32));
					ALUresult(31 DOWNTO 0)   <= STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ALUin1_VAL(15 DOWNTO 0)) * UNSIGNED(ALUin2_VAL(4 DOWNTO 0)), 32));
				 -- or -- 
				when "00001011"	=>
					ALUresult <= ALUin1_VAL OR ALUin2_VAL;
				-- PCNTW -- 
				when "00001100"	=>
				one_counter := 0;
				for pos in 127 downto 96 loop
					if ALUin1_VAL(pos) = '1' then
						one_counter := one_counter + 1;
					end if;
				end loop;
				ALUresult(127 downto 96) <= STD_LOGIC_VECTOR(to_unsigned(one_counter,32));
				one_counter := 0;
				for pos in 95 DOWNTO 64 loop
					if ALUin1_VAL(pos) = '1' then
						one_counter := one_counter + 1;
					end if;
				end loop;
				ALUresult(95 downto 64) <= STD_LOGIC_VECTOR(to_unsigned(one_counter,32));
				one_counter := 0;
				for pos in 63 DOWNTO 32 loop
					if ALUin1_VAL(pos) = '1' then
						one_counter := one_counter + 1;
					end if;
				end loop;
				ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(to_unsigned(one_counter,32));
				one_counter := 0;
				for pos in 31 DOWNTO 0 loop
					if ALUin1_VAL(pos) = '1' then
						one_counter := one_counter + 1;
					end if;
				end loop;
				ALUresult(31 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(one_counter,32));
				-- ROTW -- 
				when "00001101"	=> 
				t_rot := to_integer(UNSIGNED(ALUin2_VAL(4 DOWNTO 0)));
				if t_rot = 0 then
					ALUresult <= ALUin1_VAL;
				else
					-- just remove and concat -- 
					ALUresult(127 DOWNTO 96) <= ALUin1_VAL(96 + (t_rot-1) DOWNTO 96) & ALUin1_VAL(127 DOWNTO (t_rot+96));
					ALUresult(95 DOWNTO 64)  <= ALUin1_VAL(64 + (t_rot-1) DOWNTO 64) & ALUin1_VAL(95 DOWNTO (t_rot+64));
					ALUresult(63 DOWNTO 32)  <=ALUin1_VAL(32 + (t_rot-1) DOWNTO 32) & ALUin1_VAL(63 DOWNTO (t_rot+32));
					ALUresult(31 DOWNTO 0)   <=ALUin1_VAL(t_rot-1 DOWNTO 0) & ALUin1_VAL(31 DOWNTO (t_rot+0));  
					
				end if;
					
					
				-- SFHS -- 	
				when "00001110" =>
				-- repeat of ahs -- 
				t_int := to_integer(SIGNED(ALUin1_VAL(127 DOWNTO 112)) - SIGNED(ALUin2_VAL(127 DOWNTO 112)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					--can't use 'length-- 
					ALUresult(127 DOWNTO 112) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(111 DOWNTO 96)) - SIGNED(ALUin2_VAL(111 DOWNTO 96)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(111 DOWNTO 96) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(95 DOWNTO 80)) - SIGNED(ALUin2_VAL(95 DOWNTO 80)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(95 DOWNTO 80) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(79 DOWNTO 64)) - SIGNED(ALUin2_VAL(79 DOWNTO 64)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(79 DOWNTO 64) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(63 DOWNTO 48)) - SIGNED(ALUin2_VAL(63 DOWNTO 48)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(63 DOWNTO 48) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					t_int := to_integer(SIGNED(ALUin1_VAL(47 DOWNTO 32)) - SIGNED(ALUin2_VAL(47 DOWNTO 32)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(47 DOWNTO 32) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					
					
					t_int := to_integer(SIGNED(ALUin1_VAL(31 DOWNTO 16)) - SIGNED(ALUin2_VAL(31 DOWNTO 16)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(31 DOWNTO 16) <=STD_LOGIC_VECTOR(to_signed(t_int,16));	 
					
					t_int := to_integer(SIGNED(ALUin1_VAL(15 DOWNTO 0)) - SIGNED(ALUin2_VAL(15 DOWNTO 0)));
					if t_int < -32768 then
						t_int := -32768;
					elsif t_int > 32767 then 
						t_int := -32768;
					end if;
					ALUresult(15 DOWNTO 0) <= STD_LOGIC_VECTOR(to_signed(t_int,16));
					-- SFW -- 
				when "00001111" =>
				-- repeat au -- 
					ALUresult(127 DOWNTO 96) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(127 DOWNTO 96)) - UNSIGNED(ALUin2_VAL(127 DOWNTO 96))); 
					ALUresult(95 DOWNTO 64) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(95 DOWNTO 64)) - UNSIGNED(ALUin2_VAL(95 DOWNTO 64)));
					ALUresult(63 DOWNTO 32) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(63 DOWNTO 32)) - UNSIGNED(ALUin2_VAL(63 DOWNTO 32)));
					ALUresult(31 DOWNTO 0) <= STD_LOGIC_VECTOR(UNSIGNED(ALUin1_VAL(31 DOWNTO 0)) - UNSIGNED(ALUin2_VAL(31 DOWNTO 0)));
				when others => null;
			end case;
		end if;
	end process ALU;
end behavorial;
