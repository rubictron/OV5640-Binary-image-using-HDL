library ieee;
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Binarize is
generic (
	min : integer := 125;
	max : integer := 256;
	data_width: integer:=8
	);
	port(
		clk		: in std_logic;
		clkOut	: out std_logic;	
		data_i	: in std_logic_vector(data_width-1 downto 0);
		data_o	: out std_logic;
		vsync_i	: in std_logic;
		hsync_i	: in std_logic;
		dataE_i	: in std_logic;
		vsync_o	: out std_logic;
		hsync_o	: out std_logic;
		dataE_o	: out std_logic
		
	);
end Binarize;

architecture arch of Binarize is	

	signal pixel  : integer := 0;
	signal vsd1,vsd2,hsd1,hsd2:std_logic;

begin

	vsync_o <= vsync_i;
	hsync_o <= hsync_i;
	dataE_o <= dataE_i;
	clkOut  <= clk;

	process(clk)
		constant Vmin : integer := min;	
		constant Vmax : integer := max;					
	begin
		if(rising_edge(clk)) then
		
			pixel 	<= to_integer(data_i);
	
			if(pixel > Vmin AND pixel < Vmax) then
				data_o <= '1';
			else
				data_o <= '0';
			end if;

		end if;
	end process;
end arch;