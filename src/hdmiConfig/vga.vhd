--vga.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity vga is
generic (
    sWidth : integer := 640;
	 sHigh  : integer := 480
);
  Port ( 
    CLK25 : in  STD_LOGIC;          
    clkout : out  STD_LOGIC;
    Hsync: out  STD_LOGIC;
	 Vsync : out  STD_LOGIC;
    Nblank : out  STD_LOGIC;
    activeArea : out  STD_LOGIC;
    Nsync : out  STD_LOGIC
  );        
end vga;


architecture Behavioral of vga is


signal Hcnt:STD_LOGIC_VECTOR(9 downto 0):="0000000000"; -- for counting columns
signal Vcnt:STD_LOGIC_VECTOR(9 downto 0):="1000001000"; -- for counting lines
signal video:STD_LOGIC;
constant HM: integer :=799;  --the maximum size considered 800 (horizontal)
constant HD: integer :=640;  --the size of the screen (horizontal)
constant HF: integer :=16;   --front porch
constant HB: integer :=48;   --back porch
constant HR: integer :=96;   --retrace
constant VM: integer :=524;  --the maximum size considered 525 (vertical)  
constant VD: integer :=480;  --the size of the screen (vertical)
constant VF: integer :=11;   --front porch
constant VB: integer :=31;   --back porch
constant VR: integer :=2;    --retrace



begin


-- initialization of a counter from 0 to 799 (800 pixels per line):
-- at each clock edge increments the column counter
-- ie from 0 to 799.
  process(CLK25)
  begin
    if (CLK25'event and CLK25='1') then
      if (Hcnt = HM) then -- 799
        Hcnt <= "0000000000";
        if (Vcnt= VM) then -- 524
          Vcnt <= "0000000000";
          activeArea <= '1';
        else
          if vCnt < sHigh-1 then
            activeArea <= '1';
          end if;
          Vcnt <= Vcnt+1;
        end if;
      else      
        if hcnt = sWidth-1 then
          activeArea <= '0';
        end if;
        Hcnt <= Hcnt + 1;
      end if;
    end if;
  end process;
  
  
-- generation of horizontal sync signal Hsync:
  process(CLK25)
  begin
    if (CLK25'event and CLK25='1') then
      if (Hcnt >= (HD+HF) and Hcnt <= (HD+HF+HR-1)) then -- Hcnt >= 656 and Hcnt <= 751
        Hsync <= '0';
      else
        Hsync <= '1';
      end if;
    end if;
  end process;


-- generation of the Vsync vertical synchronization signal:
  process(CLK25)
  begin
    if (CLK25'event and CLK25='1') then
      if (Vcnt >= (VD+VF) and Vcnt <= (VD+VF+VR-1)) then  ---Vcnt >= 490 and vcnt<= 491
        Vsync <= '0';
      else
        Vsync <= '1';
      end if;
    end if;
  end process;


-- Nblank and Nsync to order the ADV7123 covertor:
Nsync <= '1';
video <= '1' when (Hcnt < HD) and (Vcnt < VD) -- it is to use the complete 640x480 resolution 
        else '0';
Nblank <= video;
clkout <= CLK25;

    
end Behavioral;
