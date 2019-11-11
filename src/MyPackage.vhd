library ieee;
use ieee.std_logic_1164.all;

package MyPackage is

component pll is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic;        -- outclk0.clk 25
		outclk_1 : out std_logic;        -- outclk1.clk 50
		outclk_2 : out std_logic;        -- outclk2.clk 100
		locked   : out std_logic         --  locked.export
	);
end component;

end package MyPackage;