library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;

entity logu is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outlu: out std_logic_vector(15 downto 0);
		eq,gt,lt,za,zb,ovf:out std_logic);
		
end logu;

architecture LU1 of logu is
begin
	op: process (a,b,opcode)
	begin
		case opcode is
			when "000"=> outlu <= a and b;
			when "001"=> outlu <= a or b;
			when "010"=> outlu <= a nand b;
			when "011"=> outlu <= a nor b;
			when "100"=> outlu <= not a;
			when "101"=> outlu <= not b;
			when "110"=> outlu <= a xor b;
			when "111"=> outlu <= a xnor b;
			when others=> outlu <= "0000000000000000";
		end case;
	end process op;

------------ To set the status vectors--------------------------------------
	gt <= '1' when (a>b)
	else '0';
	eq <= '1' when (a=b)
	else '0';
	lt <= '1' when (a<b)
	else '0';
	za <= '1' when (a="0000000000000000")
	else '0';
	zb <= '1' when (b="0000000000000000")
	else '0';
		
end LU1;
