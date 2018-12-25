library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PC is
	port (
		clk,loadPC,incPC: in std_logic;
		address: in std_logic_vector(2 downto 0);
		execadd: out std_logic_vector(2 downto 0));
end PC;

architecture pc1 of PC is

signal temp: std_logic_vector(2 downto 0):="000";

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (loadPC='0' and incPC='0') then
				temp<="000";
			elsif (loadPC='0' and incPC='1') then
				temp<= temp + "001";
			elsif (loadPC='1' and incPC='0') then
				temp<=temp;
			elsif (loadPC='1' and incPC='1') then
				temp<=address;
			end if;
		end if;
	end process;
execadd<=temp;

end pc1;

