library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity insreg is
	port(
		loadIR: in std_logic;
		dataIR: in std_logic_vector (15 downto 0);
		CUopcode: out std_logic_vector (3 downto 0);
		addressIR: out std_logic_vector(2 downto 0));
end insreg;

architecture ins1 of insreg is
begin
	with loadIR select
		addressIR<=dataIR(2 downto 0) when '1',
		"000" when others;
	
	with loadIR select
		CUopcode<=dataIR(15 downto 12) when '1',
		"0000" when others;
end ins1;	

