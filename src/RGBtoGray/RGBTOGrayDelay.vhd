library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RGBTOGrayDelay is
	generic(
	data_width : integer := 8
	); 
	port(
		iCLK		:  in std_logic;												
		iChannel	:  in std_logic_vector(data_width-1 downto 0);
		oChannel	: out std_logic_vector(data_width-1 downto 0)
		
	);
end RGBTOGrayDelay;

architecture arch of RGBTOGrayDelay is	

	signal data1,data2  : std_logic_vector(data_width-1 downto 0);
	
begin
	
	process(iCLK)			
	begin
	if(rising_edge(iCLK)) then
		 data1 		<= 	ichannel;
		 data2 		<= 	data1;
		 oChannel 	<= 	data2;
	end if;
	end process;
	
end arch;