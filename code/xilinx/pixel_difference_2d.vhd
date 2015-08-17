
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pixel_difference_2d is
    Port ( i_clk : in  STD_LOGIC;
           i_reset : in  STD_LOGIC;
           i_R : in  STD_LOGIC_VECTOR (7 downto 0);
           i_G : in  STD_LOGIC_VECTOR (7 downto 0);
           i_B : in  STD_LOGIC_VECTOR (7 downto 0);
			  i_framevalid : in  STD_LOGIC;
			  i_linevalid : in  STD_LOGIC;
           o_focusvalue : out  STD_LOGIC_VECTOR(31 downto 0);
			  o_dv : out  STD_LOGIC
			  );
end pixel_difference_2d;

architecture Behavioral of pixel_difference_2d is

	COMPONENT color_space_converter
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;
		i_R : IN std_logic_vector(7 downto 0);
		i_G : IN std_logic_vector(7 downto 0);
		i_B : IN std_logic_vector(7 downto 0);
		i_framevalid : IN std_logic;
		i_linevalid : IN std_logic;          
		o_Y : OUT std_logic_vector(7 downto 0);
		o_framevalid : OUT std_logic;
		o_linevalid : OUT std_logic
		);
	END COMPONENT;

	COMPONENT focus_calculation_pixel_difference_2d
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;
		i_framevalid : IN std_logic;
		i_linevalid : IN std_logic;
		i_Y : IN std_logic_vector(7 downto 0);          
		o_focusvalue : OUT std_logic_vector(31 downto 0);
		o_dv : OUT std_logic
		);
	END COMPONENT;
	
	signal s_framevalid : STD_LOGIC;
	signal s_linevalid : STD_LOGIC;
	
	signal s_Y : STD_LOGIC_VECTOR(7 downto 0);

begin

	Inst_color_space_converter: color_space_converter PORT MAP(
		i_clk => i_clk,
		i_reset => i_reset,
		i_R => i_R,
		i_G => i_G,
		i_B => i_B,
		i_framevalid => i_framevalid,
		i_linevalid => i_linevalid,
		o_Y => s_Y,
		o_framevalid => s_framevalid,
		o_linevalid => s_linevalid
	);

	Inst_focus_calculation: focus_calculation_pixel_difference_2d PORT MAP(
		i_clk => i_clk,
		i_reset => i_reset,
		i_framevalid => s_framevalid,
		i_linevalid => s_linevalid,
		i_Y => s_Y,
		o_focusvalue => o_focusvalue,
		o_dv => o_dv
	);

end Behavioral;

