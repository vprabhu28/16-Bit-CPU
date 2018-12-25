library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity arith is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		--prodau: out std_logic_vector(31 downto 0);
		outau: out std_logic_vector(31 downto 0));
		
end arith;

architecture a1 of arith is
begin
	--Changes observed with change in inputs and Opcode
	process (a,b,opcode)
	begin
		case opcode is
			when "000"=> outau <= "0000000000000000" & std_logic_vector(unsigned(a) + unsigned(b));
			when "001"=> outau <= std_logic_vector(unsigned(a) * unsigned(b));
			when others=> 
					outau <= "00000000000000000000000000000000";
					--prodau<="00000000000000000000000000000000";
		end case;
	end process;
end A1;
