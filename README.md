# 16-Bit-CPU
Design of a 16-Bit CPU using VHDL  

First, the various components of the CPU were programmed. Next, the control unit was designed using the port mapping techniques. Finally,
the CPU was put together at the last stage. The programming was done in VHDL. Testbenches were written for individual components at each 
stage to verify the functioning. 

The components used were:
1. ALU  
  a. Arithmetic Unit  
  b. Logic Unit  
  c. Shifter  
2. Data Memory
3. Instruction memory
4. Program Counter
5. Instruction Register
6. Multiplexer
7. Controller
8. CPU

----

## ALU
The ALU was required to perform arithmetic, logical or shift operation based on the opcode recieved. Individual units were first designed 
followed by the top model.

```VHDL
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
```

### Arithmetic Unit

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity arith is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outau: out std_logic_vector(31 downto 0));
		
end arith;

architecture a1 of arith is
begin
	--Changes observed with change in inputs and Opcode
	process (a,b,opcode)
	begin
		case opcode is
			when "000"=> outau <= "0000000000000000" & std_logic_vector(unsigned(a) + unsigned(b));
			when "001"=> outau <= std_logic_vector(unsigned(a) * unsigned(b));
			when others=> 
					outau <= "00000000000000000000000000000000";
		end case;
	end process;
end A1;
```

### Logic Unit

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;

entity logu is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outlu: out std_logic_vector(15 downto 0);
		eq,gt,lt,za,zb,ovf:out std_logic);
		
end logu;

architecture LU1 of logu is
begin
	op: process (a,b,opcode)
	begin
		case opcode is
			when "000"=> outlu <= a and b;
			when "001"=> outlu <= a or b;
			when "010"=> outlu <= a nand b;
			when "011"=> outlu <= a nor b;
			when "100"=> outlu <= not a;
			when "101"=> outlu <= not b;
			when "110"=> outlu <= a xor b;
			when "111"=> outlu <= a xnor b;
			when others=> outlu <= "0000000000000000";
		end case;
	end process op;

------------ To set the status vectors--------------------------------------
	gt <= '1' when (a>b)
	else '0';
	eq <= '1' when (a=b)
	else '0';
	lt <= '1' when (a<b)
	else '0';
	za <= '1' when (a="0000000000000000")
	else '0';
	zb <= '1' when (b="0000000000000000")
	else '0';
		
end LU1;
```

### Shift unit

```VHDL

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bs is
	port (
		a,b: in std_logic_vector(15 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		outbs: out std_logic_vector(15 downto 0));
		
end bs;

architecture bs1 of bs is
begin
	process(a,b,opcode)
	begin
		case opcode is
			when "000"=> outbs <= std_logic_vector (shift_right(unsigned(a),to_integer(unsigned(b))));
			when "001"=> outbs <= std_logic_vector (shift_left(unsigned(a),to_integer(unsigned(b))));
			when others => outbs <= "0000000000000000";
		end case;
	end process;
end bs1;
```
---

## Data Memory
This unit was mainly used to store the data or immediate value for the registers.

```VHDL
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
```

---

## Instruction Memory
The instruction memory will hold the address from the program counter and immediate values.

```VHDL
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
```
## Registers

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;


entity RegA is 
port(	clk,LoadA: in std_logic;
	DataAin: in std_logic_vector(15 downto 0);
	DataAout: out std_logic_vector(15 downto 0)
    );
end entity RegA;

architecture reg1 of RegA is
signal tempA: std_logic_vector(15 downto 0);
begin
	process(clk,LoadA)
	begin
		if rising_edge(clk) then
			if (LoadA = '1') then
			DataAout<=DataAin;
			tempA<=DataAin;
			
			elsif (LoadA = '0') then
			DataAout<=tempA;
			end if;	
		end if;
	end process;
end reg1;

---
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

---
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
```

---

## Program Counter
This unit holds the address of the next instruction to be executed.

```VHDL
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
```
---
## Instruction Register
This unit generates OPCODe for the ALU and provides adress or immediate value.

```VHDL
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
```
---
## Multiplexer
This unit is used to select the signal to pass through

```VHDL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity muxA is
	port(
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(2 downto 0);
		selA: in std_logic;
		muxAout: out std_logic_vector(31 downto 0));
end muxA;

architecture mux1 of muxA is
begin
	process(a,b,selA)
	begin
			if(selA='0') then
				muxAout<=a;		-- ALU output
			elsif(selA='1') then
				muxAout<= "00000000000000000000000000000" & b;
			end if;
		end process;
end mux1;
```
---
## Controller
This unit incorporates all the units using port mapping technique.

```VHDL
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
```
---
## CPU
This design is of the overall unit.

```VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity CPU is
	port(
		clk,enable,we_IM: in std_logic;
		code_in: in std_logic_vector(15 downto 0);
		equ,grt,lst,zra,zrb: out std_logic);
end CPU;

architecture cpu1 of CPU is

	component ALU is
		port (
			a,b: in std_logic_vector(15 downto 0);
			opcode: in std_logic_vector(2 downto 0);
			mode: in std_logic_vector(1 downto 0);
			output: out std_logic_vector(31 downto 0);
			equ,grt,lst,zra,zrb: out std_logic);
	end component ALU;

	component Datamem16b is
		generic ( N: integer := 3;
		  M: integer := 32);
	
		port(
 			addDM: in std_logic_vector(N-1 downto 0); -- Addressess to write/read memory
 			dataDM: in std_logic_vector(M-1 downto 0); -- Data to write into memory
			WE_DM: in std_logic; -- Write enable 
 			CLOCK: in std_logic; -- clock input for memory
 			DATA_ODM: out std_logic_vector(M-1 downto 0) -- Data output of memory
			);
	end component Datamem16b;

	component Instmem16b is
		generic ( N: integer := 3;
		  M: integer := 16);
	
		port(
 		addIM: in std_logic_vector(N-1 downto 0); -- Addressess to write/read memory
 		dataIM: in std_logic_vector(M-1 downto 0); -- Data to write into memory
		WE_IM: in std_logic; -- Write enable 
 		CLOCK: in std_logic; -- clock input for memory
 		DATA_OIM: out std_logic_vector(M-1 downto 0) -- Data output of memory
		);
	end component Instmem16b;

	component RegA is 
		port(	clk,LoadA: in std_logic;
			DataAin: in std_logic_vector(15 downto 0);
			DataAout: out std_logic_vector(15 downto 0)
    			);
	end component RegA;

	component RegB is 
		port(	clk,LoadB: in std_logic;
			DataBin: in std_logic_vector(15 downto 0);
			DataBout: out std_logic_vector(15 downto 0)
    			);
	end component RegB;

	component RegC is 
		port(	clk,LoadC: in std_logic;
			DataCin: in std_logic_vector(31 downto 0);
			DataCout: out std_logic_vector(31 downto 0)
    			);
	end component RegC;

	component PC is
		port (
			clk,loadPC,incPC: in std_logic;
			address: in std_logic_vector(2 downto 0);
			execadd: out std_logic_vector(2 downto 0));
	end component PC;

	component insreg is
		port(
			loadIR: in std_logic;
			dataIR: in std_logic_vector (15 downto 0);
			CUopcode: out std_logic_vector (3 downto 0);
			addressIR: out std_logic_vector(2 downto 0));
	end component insreg;

	component muxA is
		port(
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(2 downto 0);
			selA: in std_logic;
			muxAout: out std_logic_vector(31 downto 0));
	end component muxA;

	component controller is
		port(
			clk,enable: in std_logic;
			CUopcode: in std_logic_vector(3 downto 0);
			ALUmode: out std_logic_vector(1 downto 0);
			ALUopcode: out std_logic_vector(2 downto 0);
			loadPC,incPC,we_DM,selA,loadIR: out std_logic;
			loadA,loadB,loadC:out std_logic);
	end component controller;

signal loadA,loadB,loadC,loadPC,incPC,we_DM,selA: std_logic;
signal address,execadd,addressIR: std_logic_vector(2 downto 0);
signal data_OIM,dataAout,dataBout: std_logic_vector(15 downto 0);
signal data_ODM,muxAout,dataCout,output: std_logic_vector(31 downto 0);
signal ALUmode: std_logic_vector(1 downto 0);
signal CUopcode: std_logic_vector(3 downto 0);
signal ALUopcode: std_logic_vector(2 downto 0);
signal loadIR: std_logic;

begin
		DUT1: 	Instmem16b port map (execadd, code_in, we_IM, clk, data_OIM);
		DUT2:	insreg port map (loadIR,data_OIM,CUopcode,addressIR);
		DUT3:	PC port map (clk,loadPC,incPC,addressIR,execadd);
		DUT4:	controller port map (clk, enable, CUopcode, ALUmode,ALUopcode,loadPC,incPC,we_DM,selA,loadIR,loadA,loadB,loadC);
		DUT5:	ALU port map (DataAout,DataBout,ALUopcode,ALUmode,output,equ,grt,lst,zra,zrb);
		DUT6:	regA port map (clk,loadA,Data_ODM(15 downto 0),DataAout);
		DUT7:	regB port map (clk,loadB,Data_ODM(31 downto 16),DataBout);
		DUT8:	regC port map (clk,loadC,muxAout,DataCout);
		DUT9:	muxA port map (output,addressIR,selA,muxAout);
		DUT10: 	Datamem16b port map (addressIR,DataCout,we_DM,clk,data_ODM);

end cpu1;
```

***I have added the testbench programs and some simulation results for reference. The testbenches are names as tb_xxx.vhdl ***


