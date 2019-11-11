-----------------------------------------------------------------------------------
-- Rubictron(p.asithasandakalum@gmail.com)
-----------------------------------------------------------------------------------
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.numeric_std_unsigned.all;
use ieee_proposed.env.all;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.float_pkg.all;
use ieee_proposed.math_utility_pkg.all;
use ieee_proposed.numeric_std_additions.all;
use ieee_proposed.standard_additions.all;
use ieee_proposed.std_logic_1164_additions.all;
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

-----------------------------------------------------------------------------------
entity RGBToGrayScaler is
	port(
		iCLK		:  in std_logic;
		oCLK		:	out std_logic;
		iRST		:  in std_logic;
		dataI		:  in std_logic_vector(23 downto 0);
		dataO		: out std_logic_vector(7 downto 0) := (OTHERS => '0');
		vsyncI		: in std_logic;
		vsyncO		: out std_logic;
		hsyncI		: in std_logic;
		hsyncO		: out std_logic;
		dataEnI		: in std_logic;
		dataEnO		: out std_logic

	);
end RGBToGrayScaler;
-----------------------------------------------------------------------------------
architecture arch of RGBToGrayScaler is

	signal nRed,nBlue,nGreen : ufixed(9 downto -6) := (OTHERS => '0') ;
	constant xR  : ufixed( 0 downto - 6) := "0010011";
	constant xG  : ufixed( 0 downto - 6) := "0100101";
	constant xB  : ufixed( 0 downto - 6) := "0000001";
	signal   sum : ufixed(12 downto -12) := (OTHERS => '0');
	signal	 Red,Green,Blue : integer := 0;
	
	signal delayin : std_logic_vector (20 downto 0):=(others=>'0');
	signal delayedOut : std_logic_vector (2 downto 0):=(others=>'0');
-----------------------------------------------------------------------------------
begin

	Red    <= to_integer(dataI(23 downto 16));					
	Green  <= to_integer(dataI(15 downto 8));					 
	Blue   <= to_integer(dataI (7 downto 0));

	vsyncO <= delayedOut(2);
	hsyncO <= delayedOut(1);
	dataEnO <= delayedOut(0);
	
	oCLK <= iCLK;
-----------------------------------------------------------------------------------

Inst1_Delay: RGBTOGrayDelay 	
	generic map(
		data_width => 3
	) 
	port map(
		iCLK		=>	iClK,										
		iChannel	=> vsyncI & hsyncI & dataEnI,
		oChannel	=> delayedOut
		
	);
	
  
  -----------------------------------------------------------------------------------
	process(iCLK,iRST)
	begin
		if(iRST = '0') then
		elsif(iCLK'event AND iCLK = '1') then
			nRed	 <= to_ufixed(Red  ,9,-6);		
			nGreen <= to_ufixed(Green,9,-6);		
			nBlue  <= to_ufixed(Blue ,9,-6); 	
		end if;
	end process;
-----------------------------------------------------------------------------------
	process(iCLK,iRST)
	begin
		if(iRST = '0') then
		elsif(iCLK'event AND iCLK = '1') then
			sum <= nRed*xR + nGreen*xG + nBlue*xB;	
		end if;
	end process;
-----------------------------------------------------------------------------------
	process(iCLK,iRST)
	begin
		if(iRST = '0') then
			dataO <= (OTHERS => '0');				  
		elsif(iCLK'event AND iCLK = '1') then			 
			dataO <= to_slv(sum(7 downto 0));	
		end if;
	end process;
-----------------------------------------------------------------------------------
end arch;