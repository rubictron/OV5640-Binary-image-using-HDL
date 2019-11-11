-- 	TopLevelHdmi.vhd
--		├───HdmiRegisters.vhd
--		├───i2c_sender.vhd
--		├───vga.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;


entity HdmiWrapper is
  Port ( 
		clkI2c    				: in    std_logic;
		clkHdmi    				: in    std_logic;
		
		reset 					: in	  std_logic;
		
		resend 					: in    std_logic;
		config_finished 		: out std_logic;
		hdmiSioc  				: out   STD_LOGIC;
		hdmiSiod  				: inout std_logic;
		
		redIn 				: in std_logic_vector(7 downto 0);
		greenIn 				: in std_logic_vector(7 downto 0);
		blueIn 				: in std_logic_vector(7 downto 0);
		
		hdmiData 			: out std_logic_vector(23 downto 0);
		
		hdmiClk 				: out  std_logic;
		hdmiTxHs				: out  std_logic;
		hdmiTxVs 			: out  std_logic;
		nBlank 				: out  std_logic;
		sync_N 				: out  std_logic;
		
		rdaddress				: out std_logic_vector(19 downto 0)
);
end HdmiWrapper;


architecture Behavioral of HdmiWrapper is

 

  signal sys_clk  : std_logic := '0';  
  signal command  : std_logic_vector(15 downto 0);
  signal finished : std_logic := '0';
  signal taken    : std_logic := '0';
  signal send     : std_logic;
  
  signal	activeArea 	: std_logic;
  
  signal vsync 		: std_logic:='0';


  constant slave_address : std_logic_vector(7 downto 0) := x"72"; --data sheet
  
begin

  config_finished <= finished;  
  send 				<= not finished;
  hdmiData			<= redIn & greenIn & blueIn;
  hdmiTxVs 			<= vsync;
  

  
  Inst_i2c_sender: i2c_sender PORT MAP(
		clk   => clkI2c,
		taken => taken,
		siod  => hdmiSiod,
		sioc  => hdmiSioc,
		send  => send,
		id    => slave_address,
		reg   => command(15 downto 8),
		value => command(7 downto 0)
  );

  
Inst_HdmiRegisters: HdmiRegisters PORT MAP(
		clk      => clkI2c,
		advance  => taken,
		command  => command,
		finished => finished,
		resend   => resend
  );
  
  
Inst_VGA: VGA PORT MAP(
		CLK25      => clkHdmi,
		clkout     => hdmiClk,
		Hsync      => hdmiTxHs,
		Vsync      => vsync,
		Nblank     => nBlank,
		Nsync      => sync_N,
		activeArea => activeArea
  ); 
  
Inst_AddressGenerator: AddressGenerator PORT MAP(  
  		rst_i 	=>  reset,
		CLK25 	=>  clkHdmi,
		enable 	=>  activeArea,
		vsync 	=>  vsync, 
		address 	=>  rdaddress
  );
  
end Behavioral;