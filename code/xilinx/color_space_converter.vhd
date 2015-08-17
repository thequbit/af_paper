library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_space_converter is
    Port ( i_clk : in  STD_LOGIC;
			  i_reset : in  STD_LOGIC;
           i_R : in  STD_LOGIC_VECTOR (7 downto 0);
           i_G : in  STD_LOGIC_VECTOR (7 downto 0);
           i_B : in  STD_LOGIC_VECTOR (7 downto 0);
           i_framevalid: in  STD_LOGIC;
           i_linevalid: in STD_LOGIC;
           o_Y : out  STD_LOGIC_VECTOR (7 downto 0);
		   o_framevalid : out  STD_LOGIC;
		   o_linevalid : out  STD_LOGIC
		 );
end color_space_converter;

architecture Behavioral of color_space_converter is

	signal r_y : STD_LOGIC_VECTOR(8 downto 0);
	signal r_r : STD_LOGIC_VECTOR(7 downto 0);
	signal r_g : STD_LOGIC_VECTOR(7 downto 0);
	signal r_b : STD_LOGIC_VECTOR(7 downto 0);
    
	signal r_framevalid : STD_LOGIC;
	signal r_framevalidout : STD_LOGIC;
	
	signal r_linevalid : STD_LOGIC;
	signal r_linevalidout : STD_LOGIC;
	
begin

   o_Y <= r_y(7 downto 0) when r_y < "100000000" else X"FF";
   o_framevalid <= r_framevalidout;
	o_linevalid <= r_linevalidout;
	
	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
				r_r <= (others => '0');
				r_g <= (others => '0');
				r_b <= (others => '0');
				r_y <= (others => '0');
			else
			
				-- 1/4th + 1/8th = 3/8ths, or 37.5% of value
			
			   r_r <= ("00" & i_R(7 downto 2)) + ("000" & i_R(7 downto 3));
				r_g <= ("00" & i_G(7 downto 2)) + ("000" & i_G(7 downto 3));
				r_b <= ("00" & i_B(7 downto 2)) + ("000" & i_B(7 downto 3));
				
				r_y <= ("0" & r_r) + ("0" & r_g) + ("0" & r_b);
				
			end if;
		end if;
	end process;

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
				
				r_framevalid <= '0';
				r_framevalidout <= '0';
				
				r_linevalid <= '0';
				r_linevalidout <= '0';
			else
			
				r_framevalid <= i_framevalid;
				r_framevalidout <= r_framevalid;
				
				r_linevalid <= i_linevalid;
				r_linevalidout <= r_linevalid;
			end if;
		end if;
	end process;

end Behavioral;