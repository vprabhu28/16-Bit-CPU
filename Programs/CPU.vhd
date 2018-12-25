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
