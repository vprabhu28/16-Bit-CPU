library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALU is
end tb_ALU;

architecture tb1 of tb_ALU is

	component ALU is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		mode: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(31 downto 0);
		
		equ,grt,lst,zra,zrb: out std_logic);
	end component;

signal a,b: std_logic_vector(15 downto 0):="0000000000000000";
signal opcode:std_logic_vector(2 downto 0):="000";
signal mode: std_logic_vector(1 downto 0):="11";
signal output: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal equ,grt,lst,zra,zrb: std_logic:='0';

begin
	CUT1: ALU port map (a,b,opcode,mode,output,equ,grt,lst,zra,zrb);

	process
	begin
		-- Checks for Mode 00 also B > A
		mode<="00";
		a<="0000000000000001"; b<="0000000000000011";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111"; 
		
		-- Checks for Mode 01 also B > A
		mode<="01";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111";  

		-- Checks for Mode 10 also B > A
		mode<="10";
		wait for 50 ns;

		-- Checks for Mode 11 also B > A		
		mode<="11";
		wait for 50 ns;

		-- Checks for Mode 00 and now A > B
		mode<="00";
		a<="0000000000001000"; b<="0000000000000011";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111";  
		
		-- Checks for Mode 01 and now A > B
		mode<="01";
		opcode<="000";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111"; 

		-- Checks for Mode 10 and now A > B
		mode<="10";
		wait for 10 ns;
		opcode<="000"; wait for 15 ns; opcode<="001";
		wait for 50 ns;

		-- Checks for Mode 11 and now A > B
		mode<="11";
		wait for 50 ns;

		
		-- Checks for Mode 00 and now A = B
		mode<="00";
		a<="0000000000000001"; b<="0000000000000001";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111";  
		
		-- Checks for Mode 01 and now A = B
		mode<="01";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111"; 

		-- Checks for Mode 10 and now A = B
		mode<="10";
		wait for 50 ns;

		-- Checks for Mode 11 and now A = B
		mode<="11";
		wait for 50 ns;

		-- Checks for Mode 00 and now A = B = 0	
		mode<="00";
		a<="0000000000000000"; b<="0000000000000000";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111";

		-- Checks for Mode 01 and now A = B = 0		
		mode<="01";
		wait for 15 ns;
		opcode<="001";	wait for 15 ns;	opcode<="010"; wait for 15 ns;	opcode<="011"; wait for 15 ns;
		opcode<="100"; 	wait for 15 ns;	opcode<="101"; wait for 15 ns;	opcode<="110"; wait for 15 ns;
		opcode<="111"; 

		-- Checks for Mode 10 and now A = B = 0	
		mode<="10";
		wait for 50 ns;
	
		-- Checks for Mode 11 and now A = B = 0	
		mode<="11";
		wait for 50 ns;
		
	end process;
end tb1;
