--AddressGenerator.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity captureCamData is
	generic (
		sWidth : integer := 640;
		sHigh  : integer := 480
	);
  Port ( 
		
		clk 		: in STD_LOGIC;
		clkOut 	: out STD_LOGIC;
		address 	: out STD_LOGIC_VECTOR (19 downto 0);
		dataIn	: in std_LOGIC;
		dataOut 	: out STD_LOGIC;
		enable 	: in STD_LOGIC;
		wrenable : out STD_LOGIC;
		vsync 	: in STD_LOGIC;
		hsync 	: in STD_LOGIC
		
  );  
end captureCamData;


architecture Behavioral of captureCamData is

  	signal val	: 	STD_LOGIC_VECTOR(address'range) := (others => '0');
	signal rst_i 	:  	STD_LOGIC;
		
  
begin

  	rst_i 	<= '1';
	
	wrenable <= enable;
	

	address <= val;
	clkOut <= clk; 
	
	
  process(clk)
  begin
    if rising_edge(clk) then
	 
	 
	dataOut <= dataIn;
    
		if vsync = '1' then 
           val <= (others => '0');
		else	  
			if (rst_i = '0') then
			  val <= (others => '0'); 
			else 
			  if (enable ='1' and hsync ='1' ) then
				
			  
				 if (val < sWidth*sHigh) then     
						val <= val + 1 ;
				 else --if( val = sWidth*sHigh) then
							val <= (others => '0');
						--end if;
				 end if;

			  end if;
        
        end if;        
      end if;
      
    end if;  
  end process;
    
end Behavioral;

