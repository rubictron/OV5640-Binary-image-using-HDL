library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;
use work.MyPackage.all;

entity topLevelfypV_3_0 is
   port (
		--clock and reset--
		clkRef 		: in std_logic;
		btnRst		: in std_logic;
		
		--push buttons and slide switches --
		btnSetReg		: in std_logic :='1';
		
		swResend 		: in std_logic :='0';
		swProcess		: in std_logic;
		swBinarize 		: in std_logic:='0';
		swCaptureFrame	: in std_logic:='0';	
		
		-- HDMI Configeration and data -- 
		HDMI_TX_DATA	: out  std_logic_vector(23 downto 0);
		HDMI_TX_VS		: out  std_logic;
		HDMI_TX_HS		: out  std_logic;
		HDMI_TX_DE		: out  std_logic;
		HDMI_TX_CLK		: out  std_logic;
		HDMI_TX_INT		: in  std_logic;
		HDMI_I2C_SDA	: inout  std_logic;
		HDMI_I2C_SCL	: out  std_logic;
      
		--GPIO for connect camera --
		GPIO_cam_pclk  : in std_logic;
		GPIO_cam_xclk  : out std_logic;
		GPIO_cam_vsync : in std_logic;
		GPIO_cam_href  : in std_logic;
		GPIO_cam_data  : in std_logic_vector(7 downto 0);
		GPIO_cam_sioc  : out std_logic;
		GPIO_cam_siod  : inout std_logic;
		GPIO_cam_pwdn  : out std_logic;
		GPIO_cam_reset : out std_logic;
		
		--on board led--
		ledRegDone 	: out std_logic;
		ledRun			:out std_logic

   );
end entity topLevelfypV_3_0;

architecture arc of topLevelfypV_3_0 is

signal clk25				: std_logic;
signal clk50				: std_logic;
signal clk100				: std_logic;
signal reset					: std_logic;
signal pllLocked			: std_logic;

signal hsyncOutReg_cam			: std_logic;
signal vsyncOutReg_cam			: std_logic;
signal dataEReg_cam			: std_logic;
signal dataOutReg_cam			: std_logic_vector(23 downto 0);
signal pclktReg_cam				: std_logic;

signal hdmiDataReg		: std_logic_vector(23 downto 0);
signal hdmiClkReg 		: std_logic;
signal hdmiTxHsReg		: std_logic;
signal hdmiTxVsReg 		: std_logic;
signal hdmiTxDeReg		: std_logic;

signal red : std_logic_vector(7 downto 0);
signal green : std_logic_vector(7 downto 0);
signal blue : std_logic_vector(7 downto 0);

signal sync_N:std_logic;

signal hdmiRdaddress: std_logic_vector(19 downto 0);
signal hdmiWraddress: std_logic_vector(19 downto 0);


signal dataEReg_gray :std_logic;
signal hsyncOutReg_gray :std_logic;
signal vsyncOutReg_gray :std_logic;
signal pclkReg_gray 	:std_logic;
signal dataOutReg_gray	: std_logic_vector(7 downto 0);

signal dataEReg_bnry :std_logic;
signal hsyncOutReg_bnry :std_logic;
signal vsyncOutReg_bnry :std_logic;
signal pclkReg_bnry 	:std_logic;
signal dataOutReg_bnry	: std_logic;

signal binaryData		:std_logic;
signal bdataO			:std_logic;

signal BfbOut			:std_logic;
signal BfwriteEnable	:std_logic;
signal BfwrClk			:std_logic;
signal writeEnableOut_atb :std_logic;

signal hdmiReset	:std_logic;
signal temp	:std_logic;


begin

reset	<= btnRst;
ledRun<= pllLocked;


red <= (others=> BFbOut);
green <= (others=> BFbOut);
blue <= (others=> BFbOut);

--hdmiReset <= not btnSetReg;
BfwriteEnable <=  '0' when swCaptureFrame = '1' else writeEnableOut_atb;


Inst_captureCamData: captureCamData
 PORT MAP
  (
		clk  => pclkReg_bnry,
		clkOut => BfwrClk,
		address => hdmiWraddress,
		dataIn => dataOutReg_bnry,
		dataOut => binaryData,
		wrenable => writeEnableOut_atb,
		vsync => vsyncOutReg_bnry, 
		hsync => hsyncOutReg_bnry,
		enable => dataEReg_bnry
  );  


	 
Inst_resendDelay: resendDelay
 GENERIC MAP
	(
	num => 10000
	)
 PORT MAP
  (
		iCLK		=> clk25,												
		reset_out	=> hdmiReset,
		reset 	=> pllLocked
		
	);


Inst_pll: pll
  PORT MAP
  (
		refclk   => clkRef,
		rst      => not reset,
		outclk_0 => clk25,
		outclk_1 => clk50,
		outclk_2 => clk100,
		locked   => pllLocked
  );
  

Inst_CameraWrapper:CameraWrapper
   port map (
		-- clock reset --
		clk25 		=> clk25,
		rst	 		=> btnSetReg,
		-- camera pins --
		camera_pclk  =>	GPIO_cam_pclk,
		camera_xclk  =>	GPIO_cam_xclk,
		camera_vsync =>	GPIO_cam_vsync,
		camera_href  =>	GPIO_cam_href,
		camera_data  =>	GPIO_cam_data,
		camera_sioc  =>	GPIO_cam_sioc,
		camera_siod  =>	GPIO_cam_siod,
		camera_pwdn  =>	GPIO_cam_pwdn,
		camera_reset =>	GPIO_cam_reset,
		
		--data out --
		dataOut 		 =>	dataOutReg_cam,
		hSync			 => 	hsyncOutReg_cam,
		vSync			 =>	vsyncOutReg_cam,
		dataE			 =>	dataEReg_cam,
		clkOut		 =>	pclktReg_cam
		
   );
	
Inst_RGBToGrayScaler: RGBToGrayScaler PORT MAP(
		iCLK		=>	pclktReg_cam,
		oCLK		=>	pclkReg_gray,
		
		iRST		=> '1',
		
		dataI			=> dataOutReg_cam,
		dataO			=> dataOutReg_gray,
		vsyncI		=> vsyncOutReg_cam,
		vsyncO		=> vsyncOutReg_gray,
		hsyncI		=> hsyncOutReg_cam,
		hsyncO		=> hsyncOutReg_gray,
		dataEnI		=> dataEReg_cam,
		dataEnO		=>	dataEReg_gray
  );
  
Inst_Binarize : Binarize
GENERIC MAP (
	min => 125,
	max => 256,
	data_width => 8
	)
	PORT MAP(
		clk		=> pclkReg_gray,
		clkOut	=> pclkReg_bnry,
		data_i	=> dataOutReg_gray,
		data_o	=> dataOutReg_bnry,
		vsync_i	=> vsyncOutReg_gray,
		hsync_i	=> hsyncOutReg_gray,
		dataE_i	=> dataEReg_gray,
		vsync_o	=> vsyncOutReg_bnry,
		hsync_o	=> hsyncOutReg_bnry,
		dataE_o	=> dataEReg_bnry
		
	);


Inst_BinaryFrameBufferOne: BinaryFrameBuffer
  PORT MAP
  (
    data     	=> binaryData,
    rdaddress 	=> hdmiRdaddress,
    rdclock   	=> clk25,
    wraddress 	=> hdmiWraddress,
    wrclock   	=> BfwrClk,
    wren     	=> BfwriteEnable,
    q        	=> BfbOut 
  );	



Inst_HdmiWrapper: HdmiWrapper PORT MAP(
		clkI2c    			=> clk50,
		clkHdmi    			=> clk25,
		reset					=> reset,
		
		resend 				=> hdmiReset,
		config_finished 	=> ledRegDone,
		hdmiSioc  			=> HDMI_I2C_SCL,
		hdmiSiod  			=> HDMI_I2C_SDA,
		
		redIn 				=> red,
		greenIn 				=> green,
		blueIn 				=> blue,
		
		hdmiData 			=> HDMI_TX_DATA,
		
		hdmiClk 				=> HDMI_TX_CLK,
		hdmiTxHs				=> HDMI_TX_HS,
		hdmiTxVs 			=> HDMI_TX_VS,
		nBlank 				=> HDMI_TX_DE,
		sync_N 				=> sync_N,
		
		rdaddress			=> hdmiRdaddress
  );




end architecture arc;