library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity controller is
	port(
		clk,enable: in std_logic;
		CUopcode: in std_logic_vector(3 downto 0);
		ALUmode: out std_logic_vector(1 downto 0);
		ALUopcode: out std_logic_vector(2 downto 0);
		loadPC,incPC,we_DM,selA,loadIR: out std_logic;
		loadA,loadB,loadC:out std_logic);
end controller;

architecture cont1 of controller is
type state_type is (reset, storeINS, execution);
signal pstate,nstate: state_type;

begin

	t1:	process(clk,enable,pstate)
		begin
			if (enable='0') then
			pstate<=reset;
			elsif(enable='1') then
			pstate<=nstate;
			end if;
		end process t1;

	t2:	process(clk,pstate)
		begin
		if (clk'event and clk = '1') then
			case pstate is
			-- 	First We shall reset all the output ports --
				when reset =>
						loadA<='0';
						loadB<='0';
						loadC<='0';
						loadIR<='0';
						loadPC<='0';
						incPC<='0';
						selA<='Z';
						we_DM<='0';
						ALUmode<="00";
						ALUopcode<="000";
						nstate<=storeINS;

			--	Now we shall design based on the requirements provided --
			--	The first requirement requires to Store intruction in the instruction memory. --
			-- 	This will need us to load the program counter with the address then use the MUX,
			--	to store the information into the instruction memory
				
				when storeINS =>
						loadA<='0';
						loadB<='0';
						loadC<='0';
						loadIR<='1';
						loadPC<='1';	-- Program counter will load address to temp when load and inc = 1
						incPC<='1';
						selA<='Z';
						we_DM<='0';
						ALUmode<="00";
						ALUopcode<="000";
						loadPC<='0';	-- Increments program counter to have next address as incPC = 1
						nstate<= execution;

			--	At this point, we have instructions stored in memory and opcode is present for the CPU
			--	Second requirement wants us to load data on to A, B and then an into register C
			--	We will use the opcode to define each of these functionality

				when execution =>
						case CUopcode is
							when "0000" =>
									we_DM<='1';	-- Writes into Data memory to make sure Data Available 
									loadA<='1';	-- Loads value onto Register A
									loadB<='0';
									loadC<='0';
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="00";
									ALUopcode<="000";
									nstate<= storeINS;
							when "0001" =>
									we_DM<='1';	-- Writes into Data memory to make sure Data Available 
									loadA<='0';	
									loadB<='1';	-- Loads value onto Register B
									loadC<='0';
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="00";
									ALUopcode<="000";
									nstate<= storeINS;
							when "0010" =>
									we_DM<='1';	-- Writes into Data memory to make sure Data Available 
									loadA<='0';	
									loadB<='0';	
									loadC<='1';	-- Loads value onto Register C
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="00";
									ALUopcode<="000";
									nstate<= storeINS;
				
			-- 	Once the load is performed, we execute the ALU operations to ensure outputs are provided
			-- 	For this we make use of the AU opcodes must be passed 
			--	This can be achieved as shown,
				
							when "0011" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='0';	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="00";		-- Arithmetic unit selected
									ALUopcode<="000";	-- Add
									ALUopcode<="001";	-- Multiply
									nstate<= storeINS;

							when "0100" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='0';	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="01";		-- Logic unit selected

									ALUopcode<="000";	-- And
									
									ALUopcode<="001";	-- OR
									
									ALUopcode<="010";	-- NAND
									
									ALUopcode<="011";	-- NOR
									
									ALUopcode<="100";	-- NOT A
									
									ALUopcode<="101";	-- NOT B
									
									ALUopcode<="110";	-- A XOR B
									
									ALUopcode<="111";	-- A XNOR B
									
									nstate<= storeINS;
			
							when "0101" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='0';	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="10";		-- Barrel shifter selected
									ALUopcode<="000";	-- Right Shift
									ALUopcode<="001";	-- Left shift
									nstate<= storeINS;
							
							when "0110" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='0';	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='Z';
									ALUmode<="11";		-- Invalid mode
									ALUopcode<="000";	
									ALUopcode<="001";	
									nstate<= storeINS;	

				-- The next requirement is to store the value into register C. 
				-- From the block diagram, Register C can have two values. Either from ALU or from Instruction Register
				-- We will use the opcodes to do them in seperate cycles.
				
							when "0111" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='1';		-- Enables data write into RegC	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='0';		-- Writes the ALU output into C
									ALUmode<="00";		
									ALUopcode<="000";	
									nstate<= storeINS;
							when "1000" =>
									we_DM<='0';	
									loadA<='0';	
									loadB<='0';	
									loadC<='1';		-- Enables data write into RegC	
									loadIR<='0';
									loadPC<='0';
									incPC<='0';	
									selA<='1';		-- Writes the intruction register to C
									ALUmode<="00";		
									ALUopcode<="000";	
									nstate<= storeINS;
				
					-- All the required operations are now done. 
					-- For synthesis purpose, we must make sure all case values are checked
					-- That is why we must include default statement.
			
							when others => 
									nstate<= storeINS;
						end case;
				when others =>
						nstate<=reset;
			end case;
		end if;
		end process t2;
end cont1;
							
									
								



