
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity focus_calculation_pixel_difference_1d is
    Port ( i_clk : in  STD_LOGIC;
           i_reset : in  STD_LOGIC;
			  i_framevalid : in  STD_LOGIC;
			  i_linevalid : in  STD_LOGIC;
           i_Y : in  STD_LOGIC_VECTOR(7 downto 0);
           --i_dv : in  STD_LOGIC;
           o_focusvalue : out  STD_LOGIC_VECTOR (15 downto 0);
           o_dv : out  STD_LOGIC);
end focus_calculation_pixel_difference_1d;

architecture Behavioral of focus_calculation_pixel_difference_1d is

	--
	-- images are 865x577
	--
	-- ROI box size is 128x128
	--
	-- (865/2) - (128/2) = 368, "0101110000" (note: -1 for inclusive)
	-- (865/2) + (128/2) = 496, "0111110000" (note: +1 for inclusive)
	-- (577/2) - (128/2) = 224, "0011100000" (note: -1 for inclusive)
	-- (577/2) + (128/2) = 352, "0101100000" (note: +1 for inclusive)
	

	constant C_STARTPIXELCOUNT : STD_LOGIC_VECTOR(9 downto 0) := "0101111110";
	constant C_STOPPIXELCOUNT : STD_LOGIC_VECTOR(9 downto 0)  := "0111110001";
	constant C_STARTLINECOUNT : STD_LOGIC_VECTOR(9 downto 0)  := "0011111110";
	constant C_STOPLINECOUNT : STD_LOGIC_VECTOR(9 downto 0)   := "0101100001";

	signal r_framevalidlast : STD_LOGIC;
	signal r_linevalidlast : STD_LOGIC;
	signal r_linecount : STD_LOGIC_VECTOR(9 downto 0);
	signal r_pixelcount : STD_LOGIC_VECTOR(9 downto 0);
	signal r_pixelvalid : STD_LOGIC;

	signal r_y : STD_LOGIC_VECTOR(7 downto 0);
	signal r_y1 : STD_LOGIC_VECTOR(7 downto 0);

	signal r_pixelsum : STD_LOGIC_VECTOR(15 downto 0);

	signal r_dv :  STD_LOGIC;
	signal r_focusvalue :  STD_LOGIC_VECTOR(15 downto 0);

begin

	o_focusvalue <= r_focusvalue;
	o_dv <= r_dv;

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then

				r_framevalidlast <= '0';
				r_linevalidlast <= '0';
			else
			
				r_framevalidlast <= i_framevalid;
				r_linevalidlast <= i_linevalid;
			end if;
		end if;
	end process;

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then

				r_Y <= (others => '0');
				r_Y1 <= (others => '0');
				
			else
			
				-- delayed 2 clocks to compensate for r_pixelvalid calculation
				r_Y <= i_Y;
				r_Y1 <= r_Y;
			end if;
		end if;
	end process;

	-- linecount
	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
				r_linecount <= (others => '0');
			else
				r_linecount <= r_linecount;
				if ( r_framevalidlast = '0' and i_framevalid = '1' ) then
					r_linecount <= (others => '0');
				elsif ( i_framevalid = '1' ) then
					r_linecount <= r_linecount + '1';
				end if;
			end if;
		end if;
	end process;

	-- pixelcount
	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
				r_pixelcount <= (others => '0');
			else
				r_pixelcount <= r_pixelcount;
				if ( r_linevalidlast = '0' and i_linevalid = '1' ) then
					r_pixelcount <= (others => '0');
				elsif ( i_framevalid = '1' ) then
					r_pixelcount <= r_pixelcount + '1';
				end if;
			end if;
		end if;
	end process;

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
			else
				r_pixelvalid <= '0';
				if ( r_pixelcount > C_STARTPIXELCOUNT and r_pixelcount < C_STOPPIXELCOUNT and r_linecount > C_STARTLINECOUNT and r_linecount < C_STOPLINECOUNT ) then
					r_pixelvalid <= '1';
				end if;
			end if;
		end if;
	end process;

	-- pixelsum
	process( i_clk )
	begin
		if ( rising_edge ( i_clk ) ) then
			if ( i_reset = '1' ) then
				r_pixelsum <= (others => '0');
			else
				r_pixelsum <= r_pixelsum;
				if ( r_framevalidlast = '0' and i_framevalid = '1' ) and ( r_linevalidlast = '0' and i_linevalid = '1' ) then
					r_pixelsum <= (others => '0');
				else
					if ( r_pixelvalid = '1' ) then
						if ( r_Y > r_Y1 ) then
							r_pixelsum <= r_pixelsum + (r_Y - r_Y1);
						else
							r_pixelsum <= r_pixelsum + (r_Y1 - r_Y);
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	process( i_clk )
	begin
		if ( rising_edge( i_clk ) ) then
			if ( i_reset = '1' ) then
				r_dv <= '0';
				r_focusvalue <= (others => '0');
			else
				r_dv <= '0';
				r_focusvalue <= r_focusvalue;
				if ( r_pixelcount = C_STOPPIXELCOUNT and r_linecount = C_STOPLINECOUNT ) then
					r_dv <= '1';
					r_focusvalue <= r_pixelsum;
				end if;
			end if;
		end if;
	end process;

end Behavioral;