--AddressGenerator.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AddressGenerator is
	generic (
		sWidth : integer := 640;
		sHigh  : integer := 480
	);
  Port ( 
		rst_i : in std_logic;
		CLK25 : in STD_LOGIC;
		enable : in STD_LOGIC;
		vsync : in STD_LOGIC;
		address : out STD_LOGIC_VECTOR (19 downto 0)
  );  
end AddressGenerator;


architecture Behavioral of AddressGenerator is

  signal val: STD_LOGIC_VECTOR(address'range) := (others => '0');
  
begin

  address <= val;

  process(CLK25)
  begin
    if rising_edge(CLK25) then
    
      if (rst_i = '0') then
        val <= (others => '0'); 
      else 
        if (enable='1') then
          if (val < sWidth*sHigh) then     
					val <= val + 1 ;
			 else if( val = sWidth*sHigh) then
						val <= (others => '0');
					end if;
          end if;

        end if;
        if vsync = '0' then 
           val <= (others => '0');
        end if;        
      end if;
      
    end if;  
  end process;
    
end Behavioral;
