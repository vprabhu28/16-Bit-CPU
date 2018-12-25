library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;


entity RegC is 
port(	clk,LoadC: in std_logic;
	DataCin: in std_logic_vector(31 downto 0);
	DataCout: out std_logic_vector(31 downto 0)
    );
end entity RegC;

architecture reg3 of RegC is
signal tempC: std_logic_vector(31 downto 0);
begin
	process(clk,LoadC)
	begin
		if rising_edge(clk) then
			if (LoadC = '1') then
			DataCout<=DataCin;
			tempC<=DataCin;
			
			elsif (LoadC = '0') then
			DataCout<=tempC;
			end if;	
		end if;
	end process;
end reg3;
