library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.SpecialArrays.all;
entity Buffer_TB is
	
end entity Buffer_TB;

architecture Buffer_TB_arc of Buffer_TB is

	signal clock 								: std_logic:='0';
	signal rst , push       					: std_logic;
	signal New_row                  			: output_array(1 to 3);
	signal Prev_row , Curr_row , Next_row 		: output_array(1 to 3);

	component BufferGPU
		port (
			clock , rst , push       			: in  std_logic;
			New_row                  			: in  output_array(1 to 3);
			Prev_row , Curr_row , Next_row 		: buffer output_array(1 to 3)
			 );
	end component;

begin
	B1:BufferGPU
	port map (
			clock    => clock,
			rst      => rst,
			push     => push,
			New_row  => New_row,
			Prev_row => Prev_row,
			Curr_row => Curr_row,
			Next_row => Next_row
			 );

	clock <= not clock after 5 ns;

	process
	begin
		Zeros : for i in 1 to 3 loop
				New_row (i) <= (others=>'0');
			end loop;
		rst  <= '1';
		wait until rising_edge(clock);
		rst  <= '0';
		wait until rising_edge(clock);
		push <= '1';

		Flipping0 : for i in 1 to 3 loop
				  New_row(i)(3 downto 0)<= x"F";
		end loop;

		wait until rising_edge(clock);
		Flipping1 : for i in 1 to 3 loop
				  New_row(i)(6 downto 3)<= x"F";
		end loop;

		wait until rising_edge(clock);
		Flipping2 : for i in 1 to 3 loop
				  New_row(i)(9 downto 6)<= x"F";
		end loop;

	wait;
	end process;

end Buffer_TB_arc;