library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity ProcessingWrapper is
port(
	
	swProcess	: in std_logic;
	swBinarize	: in std_logic;
	
	dataIn		: in std_logic_vector(23 downto 0);
	hSync			: in std_logic;
	vSync			: in std_logic;
	dataE			: in std_logic;
	pclk		 	: in std_logic;

	hdmiData 	: out std_logic_vector(23 downto 0);
	hdmiClk 		: out  std_logic;
	hdmiTxHs		: out  std_logic;
	hdmiTxVs 	: out  std_logic;
	hdmiTxDe 	: out  std_logic
);
end entity ProcessingWrapper;

architecture arc of ProcessingWrapper is

signal selector : std_logic_vector(1 downto 0);

signal RGBdataOut : std_logic_vector(7 downto 0);

signal	RGBDataReg 	:  std_logic_vector(23 downto 0);
signal	RGBClkReg 		:  std_logic;
signal	RGBTxHsReg		:  std_logic;
signal	RGBTxVsReg 	:  std_logic;
signal	RGBTxDeReg 	:  std_logic;

begin

selector <= swBinarize & swProcess ;

RGBDataReg <= RGBDataOut & RGBDataOut & RGBDataOut;

Inst_RGBToGrayScaler: RGBToGrayScaler PORT MAP(
		iCLK		=>	pclk,
		iRST		=> '0',
		dataI		=> dataIn,
		dataO		=> RGBdataOut,
		vsyncI		=> vsync,
		vsyncO		=> RGBTxVsReg,
		hsyncI		=> hsync,
		hsyncO		=> RGBTxHsReg,
		dataEnI		=> dataE,
		dataEnO		=>	RGBTxDeReg
  );

process(swProcess,dataIn,pclk,hsync,vsync,dataE)
begin


 case selector is
 
	when "01" => -- when swProcess = '1' and others 0
		hdmiData 	<= (others=>'0');
		hdmiClk 		<= '0';
		hdmiTxHs		<= '0';
		hdmiTxVs 	<= '0';
		hdmiTxDe 	<= '0';
		
	when "10" => -- when swGrayScaller = '1' and others 0
		hdmiData 	<= RGBDataReg;
		hdmiClk 		<= pclk;
		hdmiTxHs		<= RGBTxHsReg;
		hdmiTxVs 	<= RGBTxVsReg;
		hdmiTxDe 	<= RGBTxDeReg;
		
	when others =>
		hdmiData 	<= dataIn;
		hdmiClk 		<= pclk;
		hdmiTxHs		<= hsync;
		hdmiTxVs 	<= vsync;
		hdmiTxDe 	<= dataE;
		
 end case;
end process;



end architecture arc;