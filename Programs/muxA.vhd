library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity muxA is
	port(
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(2 downto 0);
		selA: in std_logic;
		muxAout: out std_logic_vector(31 downto 0));
end muxA;

architecture mux1 of muxA is
begin
	process(a,b,selA)
	begin
			if(selA='0') then
				muxAout<=a;		-- ALU output
			elsif(selA='1') then
				muxAout<= "00000000000000000000000000000" & b;
			end if;
		end process;
end mux1;
