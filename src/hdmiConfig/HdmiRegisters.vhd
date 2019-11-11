--HdmiRegisters.vhd


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity HdmiRegisters is
  Port ( clk      : in  STD_LOGIC;
    resend   : in  STD_LOGIC;
    advance  : in  STD_LOGIC;
    command  : out  std_logic_vector(15 downto 0);
    finished : out  STD_LOGIC);
end HdmiRegisters;

architecture Behavioral of HdmiRegisters is

  signal sreg   : std_logic_vector(15 downto 0);
  signal address : std_logic_vector(7 downto 0) := (others => '0');
  
begin

  command <= sreg;
  with sreg select finished  <= '1' when x"FFFF", '0' when others;

  process(clk)
    begin
      if rising_edge(clk) then
      
        if resend = '1' then 
          address <= (others => '0');
        elsif advance = '1' then
          address <= std_logic_vector(unsigned(address)+1);
        end if;

        case address is
          when x"00" => sreg <= x"9803"; -- 
          when x"01" => sreg <= x"0100"; -- 
          when x"02" => sreg <= x"0218"; -- 
          when x"03" => sreg <= x"0300"; -- 
          when x"04" => sreg <= x"1470"; -- 
          
			 when x"05" => sreg <= x"1520"; -- 
          when x"06" => sreg <= x"1630"; -- 
          when x"07" => sreg <= x"1846"; -- 
          when x"08" => sreg <= x"4080"; -- 
          when x"09" => sreg <= x"4110"; -- 
          
			 when x"0A" => sreg <= x"49A8"; -- 
          when x"0B" => sreg <= x"5510"; --
          when x"0C" => sreg <= x"5608"; --
          when x"0D" => sreg <= x"96F6"; --
          when x"0E" => sreg <= x"7307"; --
          
			 when x"0F" => sreg <= x"761f"; --
          when x"11" => sreg <= x"9902"; --
          when x"12" => sreg <= x"9ae0"; --
          when x"13" => sreg <= x"9c30"; --

          when x"14" => sreg <= x"9d61"; --
          when x"15" => sreg <= x"a2a4"; --
          when x"16" => sreg <= x"a3a4"; --
          when x"17" => sreg <= x"a504"; --
          when x"18" => sreg <= x"ab40"; -- 
          
			 when x"19" => sreg <= x"af16"; --
          when x"1B" => sreg <= x"d1ff"; -- 
          when x"1C" => sreg <= x"de10"; --
          when x"1D" => sreg <= x"e460"; --

          when x"1E" => sreg <= x"fa7d";

          when x"1F" => sreg <= x"9803";
			 
			 when others => sreg <= x"ffff";
        end case;
      end if;
    end process;
end Behavioral;
