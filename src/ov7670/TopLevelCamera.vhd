--TopLevelCamera.vhd
--├───CameraController.vhd
--│	├───CameraRegisters.vhdaldec
--│	└───i2c_sender.vhd
--├───CameraCapture.vhd
--├───RGBToGrayScaler.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevelCamera is
   port (
		clk_50 : in  STD_LOGIC;
		clk_25 : in  STD_LOGIC;
		cam_cfg_resend          : in  STD_LOGIC;
		cam_cfg_finished : out STD_LOGIC;
		
		wraddress: out STD_LOGIC_VECTOR (19 DOWNTO 0);
		wren: out STD_LOGIC;
		wrdata:out STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		camera_pclk  : in  STD_LOGIC;
		camera_xclk  : out STD_LOGIC;
		camera_vsync : in  STD_LOGIC;
		camera_href  : in  STD_LOGIC;
		camera_data  : in  STD_LOGIC_vector(7 downto 0);
		camera_sioc  : out STD_LOGIC;
		camera_siod  : inout STD_LOGIC;
		camera_pwdn  : out STD_LOGIC;
		camera_reset : out STD_LOGIC

   );
end entity TopLevelCamera;

architecture rtl of TopLevelCamera is


  COMPONENT CameraController
  PORT(
    clk : IN std_logic;
    resend : IN std_logic;    
    siod : INOUT std_logic;      
    config_finished : OUT std_logic;
    sioc : OUT std_logic;
    reset : OUT std_logic;
    pwdn : OUT std_logic;
    xclk : OUT std_logic
    );
  END COMPONENT;
  
  COMPONENT CameraCapture
  PORT(
    pclk : IN std_logic;
    vsync : IN std_logic;
    href : IN std_logic;
    d : IN std_logic_vector(7 downto 0);          
    addr : OUT std_logic_vector(19 downto 0);
    dout : OUT std_logic_vector(15 downto 0);
    we : OUT std_logic
    );
  END COMPONENT;
  
--  COMPONENT RGBToGrayScaler is
--	port(
--		iCLK		:  in std_logic;
--		iRST		:  in std_logic;
--		iRed		:  in std_logic_vector(7 downto 0);
--		iGreen	:  in std_logic_vector(7 downto 0);
--		iBlue		:  in std_logic_vector(7 downto 0);
--		oChannel	: out std_logic_vector(7 downto 0) := (OTHERS => '0');
--		wrin		: in std_logic;
--		wrout		: out std_logic;
--		waddressIn : in std_logic_vector(19 downto 0) := (OTHERS => '0');
--		waddressOut: out std_logic_vector(19 downto 0) := (OTHERS => '0')
--	);
--end COMPONENT;

--signal wrenReg : std_logic;

--signal waddressReg : std_logic_vector(19 downto 0);
--signal wrdataReg:std_logic_vector(15 downto 0);

signal reset : std_logic := '1';

--signal iredReg : std_logic_vector(7 downto 0):=(others=>'0');
--signal igreenReg : std_logic_vector(7 downto 0):=(others=>'0');
--signal iblueReg : std_logic_vector(7 downto 0):=(others=>'0');

begin


--iredReg   (6 downto 2)	<=  wrdataReg(15 downto 11);
--igreenReg (7 downto 2) 	<=  wrdataReg(10 downto 5);
--iblueReg  (6 downto 2) 	<=	 wrdataReg(4 downto 0);

  Inst_CameraController: CameraController PORT MAP(
    clk             => clk_50,
    resend          => cam_cfg_resend,
    config_finished => cam_cfg_finished,
    sioc            => camera_sioc,
    siod            => camera_siod,
    reset           => camera_reset,
    pwdn            => camera_pwdn,
    xclk            => camera_xclk
  );
   
  Inst_CameraCapture: CameraCapture PORT MAP(
    pclk  => camera_pclk,
    vsync => camera_vsync,
    href  => camera_href,
    d     => camera_data,
    addr  => wraddress,
    dout  => wrdata,
    we    => wren
  );
  

  
--Inst_RGBToGrayScaler: RGBToGrayScaler PORT MAP(
--		iCLK			=> clk_25,
--		iRST			=> reset,
--		iRed			=> iredReg,
--		iGreen		=> igreenReg,
--		iBlue			=> iblueReg,
--		oChannel		=>	wrdata,
--		wrin			=> wrenReg,
--		wrout			=> wren,
--		waddressIn 	=> waddressReg,
--		waddressOut	=> wraddress
--  );

end architecture rtl;




