--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:07:45 05/01/2014
-- Design Name:   
-- Module Name:   C:/dev/af_paper/ise/af_alogithms/focus_calculation_pixel_difference_2d_tb.vhd
-- Project Name:  af_alogithms
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: focus_calculation_pixel_difference_2d
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY focus_calculation_pixel_difference_2d_tb IS
END focus_calculation_pixel_difference_2d_tb;
 
ARCHITECTURE behavior OF focus_calculation_pixel_difference_2d_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT focus_calculation_pixel_difference_2d
    PORT(
         i_clk : IN  std_logic;
         i_reset : IN  std_logic;
         i_framevalid : IN  std_logic;
         i_linevalid : IN  std_logic;
         i_Y : IN  std_logic_vector(7 downto 0);
         o_focusvalue : OUT  std_logic_vector(31 downto 0);
         o_dv : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i_clk : std_logic := '0';
   signal i_reset : std_logic := '0';
   signal i_framevalid : std_logic := '0';
   signal i_linevalid : std_logic := '0';
   signal i_Y : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal o_focusvalue : std_logic_vector(31 downto 0);
   signal o_dv : std_logic;

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: focus_calculation_pixel_difference_2d PORT MAP (
          i_clk => i_clk,
          i_reset => i_reset,
          i_framevalid => i_framevalid,
          i_linevalid => i_linevalid,
          i_Y => i_Y,
          o_focusvalue => o_focusvalue,
          o_dv => o_dv
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;

		i_Y <= i_Y + '1';
		
   end process;
 
	--
	-- images are 865 x 577
	--
	-- 128 x 128 is ROI
	--
	-- ( 865 - 128 ) / 2 = 268 
	-- ( 577 - 128 ) / 2 = 224
	--
	-- 224 * 865  top buffer
	--
	-- 268        left buffer  -|
	-- 128        line data     | - x 128 lines
	-- 268        right buffer _|
	--
	-- 224 * 865  bottom buffer
 
	process
		variable x : integer range 0 to 1024 := 0;
		variable y : integer range 0 to 1024 := 0;
	begin
	
		i_framevalid <= '0';
		i_linevalid <= '0';
	
		-- equivilent of 2 lines of invalid frame
		wait for i_clk_period*865*2;
	
		i_framevalid <= '1';
		i_linevalid <= '0';
	
		-- one line invalid in beginning of frame
		for y in 0 to 1 loop
			for x in 0 to 577 loop
				i_framevalid <= '1';
				i_linevalid <= '0';
				wait for i_clk_period;
			end loop;
		end loop;
	
		-- one line invalid in beginning of frame
		for y in 0 to 577 loop
		
			-- ten pixels at beginning of line invalid
			for x in 0 to 10 loop
				i_framevalid <= '1';
				i_linevalid <= '0';
				wait for i_clk_period;
			end loop;
		
			-- 865 valid pixels
			for x in 0 to 865 loop
				i_framevalid <= '1';
				i_linevalid <= '1';
				wait for i_clk_period;
			end loop;
			
			-- ten pixels at end of line invalid
			for x in 0 to 10 loop
				i_framevalid <= '1';
				i_linevalid <= '0';
				wait for i_clk_period;
			end loop;
			
		end loop;
		
		-- one line invalid at end of frame
		for y in 0 to 1 loop
			for x in 0 to 577 loop
				i_framevalid <= '1';
				i_linevalid <= '0';
				wait for i_clk_period;
			end loop;
		end loop;
		
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	

		i_reset <= '1';

      wait for i_clk_period*10;

		i_reset <= '0';

      wait;
   end process;

END;
