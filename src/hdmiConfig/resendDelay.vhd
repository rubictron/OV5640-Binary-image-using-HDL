library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity resendDelay is
	generic(
	num : integer := 200
	); 
	port(
		iCLK		:  in std_logic;												
		reset_out	: out std_logic;
		reset 	: in std_logic
		
	);
end resendDelay;

architecture arch of resendDelay is	

signal cnt : integer := 0 ;
signal rst_d0: std_logic:= '1';
	
begin

	process(iCLK,reset,cnt)			
	begin
	if rising_edge(iCLK) then
		reset_out <= rst_d0;

		if (reset = '0') then
			cnt <= 0;
			reset_out <= '1';
		end if;
		
		
			if(cnt > num )	then
				rst_d0 <= '0';
			else
				cnt <= cnt + 1;
			end if;
	end if;		
	end process;
	
end arch;



