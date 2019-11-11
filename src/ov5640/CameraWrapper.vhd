library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CameraWrapper is
   port (
		-- clock reset --
		clk25 						: in  std_logic;
		rst	 						: in  std_logic;
		-- camera pins --
		camera_pclk  : in  std_logic;
		camera_xclk  : out std_logic;
		camera_vsync : in  std_logic;
		camera_href  : in  std_logic;
		camera_data  : in  std_logic_vector(7 downto 0);
		camera_sioc  : out std_logic;
		camera_siod  : inout std_logic;
		camera_pwdn  : out std_logic;
		camera_reset : out std_logic;
		
		--data out --
		dataOut 		 : out std_logic_vector(23 downto 0);
		hSync			 : out std_logic;
		vSync			 : out std_logic;
		dataE			 : out std_logic;
		clkOut		 : out std_logic
		

   );
end entity CameraWrapper;


architecture arc of CameraWrapper is

component OV5640_ML_IP is
port(
   CLK_i :in std_logic;
	rst : in std_logic;
	cmos_sclk_o :out std_logic;
	cmos_sdat_io:inout std_logic;
	cmos_vsync_i:in std_logic;
	cmos_href_i :in std_logic;
	cmos_pclk_i :in std_logic;
	cmos_xclk_o : out std_logic;
	cmos_data_i : in std_logic_vector(7 downto 0);
	hs_o: out std_logic;
   vs_o: out std_logic;
   de_o: out std_logic;
   rgb_o: out std_logic_vector(23 downto 0);
   clk_date_o : out std_logic
);
end component;

begin
camera_reset <= '1'; 	-- active '1'
camera_pwdn	 <= '1';		--power up device

Inst_OV5640_ML_IP:OV5640_ML_IP 
port map( 
	CLK_i 			=> clk25,
	rst => rst,

	cmos_sclk_o		=>	camera_sioc,
	cmos_sdat_io	=>	camera_siod,
	cmos_vsync_i	=>	camera_vsync,
	cmos_href_i		=>	camera_href,
	cmos_pclk_i		=>	camera_pclk,
	cmos_xclk_o		=>	camera_xclk,
	cmos_data_i		=>	camera_data,
	hs_o				=>	hsync,
   vs_o				=>	vsync,
   de_o				=>	dataE,
   rgb_o				=>	dataOut,
   clk_date_o 		=> clkOut
);


end architecture arc;





	