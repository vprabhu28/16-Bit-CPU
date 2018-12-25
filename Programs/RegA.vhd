library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;


entity RegA is 
port(	clk,LoadA: in std_logic;
	DataAin: in std_logic_vector(15 downto 0);
	DataAout: out std_logic_vector(15 downto 0)
    );
end entity RegA;

architecture reg1 of RegA is
signal tempA: std_logic_vector(15 downto 0);
begin
	process(clk,LoadA)
	begin
		if rising_edge(clk) then
			if (LoadA = '1') then
			DataAout<=DataAin;
			tempA<=DataAin;
			
			elsif (LoadA = '0') then
			DataAout<=tempA;
			end if;	
		end if;
	end process;
end reg1;
