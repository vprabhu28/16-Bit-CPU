library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity tb_CPU is
end tb_CPU;

architecture tb1 of tb_CPU is
		
	component CPU is
		port(
			clk,enable,we_IM: in std_logic;
			code_in: in std_logic_vector(15 downto 0);
			--code_addr: in std_logic_vector(11 downto 0);
			equ,grt,lst,zra,zrb: out std_logic);
	end component CPU;

signal clk,enable,we_IM: std_logic:='0';
signal code_in: std_logic_vector(15 downto 0);
--signal code_addr: std_logic_vector(11 downto 0);
signal equ,grt,lst,zra,zrb: std_logic;

constant clk_period : time := 10 ns;

begin
	DUT1: CPU port map(clk,enable,we_IM,code_in,equ,grt,lst,zra,zrb);
	
	
	 -- Clock process definitions
   CLOCK_process:	process
   			begin
 		 		clk <= '0';
  				wait for clk_period/2;
 				clk <= '1';
  				wait for clk_period/2;
   			end process;

   Simulation_process: 	process
			begin
				enable<='1'; 
 				we_IM <= '0'; 
  				
  				code_in<= x"FFFF";
      				wait for 100 ns; 
  			
			-- start reading data from memory 
  				we_IM <= '1';
 
			-- start writing to memory
			-- We know the 1st 4 bits are taken as OPCODE for controller
			-- We design the instruction set based on the reuirements

      				wait for clk_period*5;	
				code_in<= x"0FFF";	-- Load A
				wait for clk_period*5;
				code_in<= x"11AB";	-- Load B
				wait for clk_period*5;
				code_in<= x"23AB";	-- Load C
				wait for clk_period*5;				
				code_in<= x"3010";	-- ALU mode 00
				wait for clk_period*5;
 				code_in<= x"4110";	-- ALU mode 01
				wait for clk_period*5;
 				code_in<= x"5678";	-- ALU mode 10
				wait for clk_period*5;
				code_in<= x"6178";	-- ALU mode 11
				wait for clk_period*5;
 				code_in<= x"7011";	-- Writes ALU into C
				wait for clk_period*5;
				code_in<= x"8F1F";	-- Writes Immediate into C
				wait for clk_period*5;
  			
			-- Read the memory now

				we_IM <= '0';
				wait for clk_period*65;
 
			-- Exit the execution
  				enable<='0';
				wait;

      				
   			end process;


END tb1;
