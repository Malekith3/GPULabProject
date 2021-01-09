library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use work.SpecialArrays.all;
use work.ImageProcessing.all;
entity GPU_TB is
end GPU_TB;

architecture GPU_TB_arc of GPU_TB is
	signal clock 				: std_logic := '0';
	signal start , rst 			:  std_logic;
	signal done 			   	:  std_logic;
	component GPU
		port (
		clock ,start , rst : in std_logic;
		done 			   : out std_logic
	     ) ;
	end component;

begin
		G1:GPU
	port map (
		clock 	=> clock,
		start 	=> start,
		rst 	=> rst,
		done 	=>done
		
	);
	clock <= not clock after 5 ns;
process
begin
	
		rst 	<= '1';
		wait until rising_edge(clock);
		rst		<= '0';
		wait for 20 ns;
		wait until rising_edge(clock);
		start 	<= '1';
		wait until rising_edge(clock);
		start 	<= '0';
wait;
end process;
end  GPU_TB_arc;