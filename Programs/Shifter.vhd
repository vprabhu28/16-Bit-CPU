
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bs is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outbs: out std_logic_vector(15 downto 0));
		
end bs;

architecture bs1 of bs is
begin
	process(a,b,opcode)
	begin
		case opcode is
			when "000"=> outbs <= std_logic_vector (shift_right(unsigned(a),to_integer(unsigned(b))));
			when "001"=> outbs <= std_logic_vector (shift_left(unsigned(a),to_integer(unsigned(b))));
			when others => outbs <= "0000000000000000";
		end case;
	end process;
end bs1;
