library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity Datamem16b is
	generic ( N: integer := 3;
		  M: integer := 32);
	
	port(
 		addDM: in std_logic_vector(N-1 downto 0); -- Addressess to write/read memory
 		dataDM: in std_logic_vector(M-1 downto 0); -- Data to write into memory
		WE_DM: in std_logic; -- Write enable 
 		CLOCK: in std_logic; -- clock input for memory
 		DATA_ODM: out std_logic_vector(M-1 downto 0) -- Data output of memory
);
end Datamem16b;

architecture mem1 of Datamem16b is

-- define the new type for the 16-bit wide memory
type MEM_ARRAY is array (0 to M-1 ) of std_logic_vector (M-1 downto 0);

-- initial values in the memory are initialized to 0
signal MEM: MEM_ARRAY :=(others=> (others=>'0'));
   
begin
	process(CLOCK)
	begin
 		if(rising_edge(CLOCK)) then
 			if(WE_DM='1') then -- when write enable = 1, 
 			-- write input data into memory at the provided addressess
 			MEM(to_integer(unsigned(addDM))) <= dataDM;
		
			-- The index of the Memory array array type needs to be integer so
 			-- converts ADDRESS from std_logic_vector -> Unsigned -> Interger using numeric_std library
			
			elsif (WE_DM<='0') then
			 -- Data to be read out 
 			DATA_ODM <= MEM(to_integer(unsigned(addDM))); 
			end if;
 		end if;
	end process;
end mem1;
