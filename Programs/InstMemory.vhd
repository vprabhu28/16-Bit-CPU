library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity Instmem16b is
	generic ( N: integer := 3;
		  M: integer := 16);
	
	port(
 		addIM: in std_logic_vector(N-1 downto 0); -- Addressess to write/read memory
 		dataIM: in std_logic_vector(M-1 downto 0); -- Data to write into memory
		WE_IM: in std_logic; -- Write enable 
 		CLOCK: in std_logic; -- clock input for memory
 		DATA_OIM: out std_logic_vector(M-1 downto 0) -- Data output of memory
);
end Instmem16b;

architecture mem1 of Instmem16b is

-- define the new type for the 16-bit wide memory
type MEM_ARRAY is array (0 to M-1 ) of std_logic_vector (M-1 downto 0);

-- initial values in the memory are initialized to 0
signal MEM: MEM_ARRAY :=(others=> (others=>'0'));
   
begin
	process(CLOCK)
	begin
 		if(rising_edge(CLOCK)) then
 			if(WE_IM='1') then -- when write enable = 1, 
 			-- write input data into memory at the provided addressess
 			MEM(to_integer(unsigned(addIM))) <= dataIM;
		
			-- The index of the Memory array array type needs to be integer so
 			-- converts ADDRESS from std_logic_vector -> Unsigned -> Interger using numeric_std library
			
			elsif (WE_IM<='0') then
			 -- Data to be read out 
 			DATA_OIM <= MEM(to_integer(unsigned(addIM))); 
			end if;
 		end if;
	end process;
end mem1;
