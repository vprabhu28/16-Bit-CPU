library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;

entity ALU is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		mode: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(31 downto 0);
		equ,grt,lst,zra,zrb: out std_logic);
end ALU;

architecture ALU1 of ALU is
	-- Arithmatic Unit declaration
	component arith is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outau: out std_logic_vector(31 downto 0));
		
	end component;

	-- Logic Unit declaration
	component logu is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outlu: out std_logic_vector(15 downto 0);
		eq,gt,lt,za,zb:out std_logic);
		
	end component;

	-- Barrelshift declaration	
	component bs is
		port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outbs: out std_logic_vector(15 downto 0));
		
	end component;

signal outau: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal outlu,outbs: std_logic_vector(15 downto 0):="0000000000000000";
signal eq,gt,lt,za,zb,ovf: std_logic := '0';
signal temp: std_logic_vector(1 downto 0);


begin

	DUT1: arith port map(a,b,opcode,outau);
	DUT2: logu port map(a,b,opcode,outlu,eq,gt,lt,za,zb);
	DUT3: bs port map(a,b,opcode,outbs);

	-- Depending on Mode, the outputs are selected

	with mode select output <=
		outau when "00",
		"0000000000000000" & outlu when "01",
		"0000000000000000" & outbs when "10",
		"00000000000000000000000000000000" when others;

	with mode select equ <=
		eq when "01",
		'0' when others;
	
	with mode select grt <=
		gt when "01",
		'0' when others;

	with mode select lst <=
		lt when "01",
		'0' when others;

	with mode select zra <=
		za when "01",
		'0' when others;

	with mode select zrb <=
		zb when "01",
		'0' when others;

	
end ALU1;
