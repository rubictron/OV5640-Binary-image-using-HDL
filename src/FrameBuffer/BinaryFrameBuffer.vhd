LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY BinaryFrameBuffer IS
  PORT
  (
    data     : IN STD_LOGIC;
    rdaddress : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    rdclock   : IN STD_LOGIC;
    wraddress : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    wrclock   : IN STD_LOGIC;
    wren     : IN STD_LOGIC;
    q        : OUT STD_LOGIC
  );
END BinaryFrameBuffer;


ARCHITECTURE arc OF BinaryFrameBuffer IS

  
  COMPONENT ram_16_1 IS
  PORT
  (
    data    : IN STD_LOGIC;
    rdaddress    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    rdclock    : IN STD_LOGIC ;
    wraddress    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    wrclock    : IN STD_LOGIC  := '1';
    wren    : IN STD_LOGIC  := '0';
    q    : OUT STD_LOGIC
  );
  END COMPONENT;

  
  -- read signals
  signal q_0 : STD_LOGIC;
  signal q_1 : STD_LOGIC;
  signal q_2 : STD_LOGIC;
  signal q_3 : STD_LOGIC;
  signal q_4 : STD_LOGIC;
  -- write signals
  signal wren_0 : STD_LOGIC;
  signal wren_1 : STD_LOGIC;
  signal wren_2 : STD_LOGIC;
  signal wren_3 : STD_LOGIC;
  signal wren_4 : STD_LOGIC;  
  
begin
	
	
inst0_ram_16_8 : ram_16_1 PORT MAP (
		data	 => data,
		rdaddress	 => rdaddress(15 downto 0),
		rdclock	 => rdclock,
		wraddress	 => wraddress(15 downto 0),
		wrclock	 => wrclock,
		wren	 => wren_0,
		q	 => q_0
);

inst1_ram_16_8 : ram_16_1 PORT MAP (
		data	 => data,
		rdaddress	 => rdaddress(15 downto 0),
		rdclock	 => rdclock,
		wraddress	 => wraddress(15 downto 0),
		wrclock	 => wrclock,
		wren	 => wren_1,
		q	 => q_1
);

inst2_ram_16_8 : ram_16_1 PORT MAP (
		data	 => data,
		rdaddress	 => rdaddress(15 downto 0),
		rdclock	 => rdclock,
		wraddress	 => wraddress(15 downto 0),
		wrclock	 => wrclock,
		wren	 => wren_2,
		q	 => q_2
);

inst3_ram_16_8 : ram_16_1 PORT MAP (
		data	 => data,
		rdaddress	 => rdaddress(15 downto 0),
		rdclock	 => rdclock,
		wraddress	 => wraddress(15 downto 0),
		wrclock	 => wrclock,
		wren	 => wren_3,
		q	 => q_3
);

inst4_ram_16_8 : ram_16_1 PORT MAP (
		data	 => data,
		rdaddress	 => rdaddress(15 downto 0),
		rdclock	 => rdclock,
		wraddress	 => wraddress(15 downto 0),
		wrclock	 => wrclock,
		wren	 => wren_4,
		q	 => q_4
);
	
 
   
process (wraddress(19 downto 16), wren)
  begin
    case wraddress(19 downto 16) is 
      when "0000" =>
        wren_0 <= wren;	wren_1 <= '0';		wren_2 <= '0';		wren_3 <= '0'; 	wren_4 <= '0'; 
      when "0001" =>
        wren_0 <= '0'; 	wren_1 <= wren;	wren_2 <= '0';		wren_3 <= '0'; 	wren_4 <= '0'; 
		when "0010" =>
        wren_0 <= '0'; 	wren_1 <= '0';  	wren_2 <= wren;	wren_3 <= '0'; 	wren_4 <= '0';
		when "0011" =>
        wren_0 <= '0'; 	wren_1 <= '0';  	wren_2 <= '0';		wren_3 <= wren; 	wren_4 <= '0'; 	
		when "0100" =>
        wren_0 <= '0'; 	wren_1 <= '0';  	wren_2 <= '0';		wren_3 <= '0'; 	wren_4 <= wren; 	
		  
      when others =>
        wren_0 <= '0'; 	wren_1 <= '0'; 	wren_2 <= '0';		wren_3 <= '0'; 	wren_4 <= '0';
		  
    end case;
  end process;
  
process (rdaddress(19 downto 16), q_1, q_2,q_3,q_4)
  begin
    case rdaddress(19 downto 16) is 
      when "0000" =>
        q <= q_0;
      when "0001" =>
        q <= q_1;
		when "0010" =>
        q <= q_2;
		when "0011" =>
        q <= q_3;
		when "0100" =>
        q <= q_4;
      when others =>
        q <= '0';
    end case;
  end process;
   
END arc;
