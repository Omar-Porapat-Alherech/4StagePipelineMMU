--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {\2_1mux_ent\} architecture {\2_1mux_arch\}}

library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is
	 port(
		 SEL : in STD_LOGIC;
		 Output : out STD_LOGIC_VECTOR(127 downto 0);
		 InputA : in STD_LOGIC_VECTOR(127 downto 0);
		 InputB : in STD_LOGIC_VECTOR(127 downto 0)
	     );
end mux21;

--}} End of automatically maintained section

architecture mux21 of mux21 is
begin

	-- enter your statements here --
	 Output <= InputB when (SEL = '1') else InputA;

end mux21;
