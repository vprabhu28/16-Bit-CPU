library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;


entity RegB is 
port(	clk,LoadB: in std_logic;
	DataBin: in std_logic_vector(15 downto 0);
	DataBout: out std_logic_vector(15 downto 0)
    );
end entity RegB;

architecture reg2 of RegB is
signal tempB: std_logic_vector(15 downto 0);
begin
	process(clk,LoadB)
	begin
		if rising_edge(clk) then
			if (LoadB = '1') then
			DataBout<=DataBin;
			tempB<=DataBin;
			
			elsif (LoadB = '0') then
			DataBout<=tempB;
			end if;	
		end if;
	end process;
end reg2;
