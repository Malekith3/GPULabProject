library ieee;
USE work.SpecialArrays.all;
use ieee.std_logic_1164.all;


entity BufferGPU is
	port (
			clock , rst , push       			: in  std_logic;
			New_row                  			: in  output_array(1 to 3);
			Prev_row , Curr_row , Next_row 		: buffer output_array(1 to 3)
		);
end BufferGPU;

architecture Buffer_arc of BufferGPU is
begin
	process(clock,rst)
	begin

		if (rst = '1') then
			Zeros : for i in 1 to 3 loop
				Prev_row(i) <= (others=>'1');
				Curr_row(i) <= (others=>'1');
				Next_row(i) <= (others=>'1');
			end loop;

		elsif(rising_edge(clock)) then 

			if(push = '1') then
				Prev_row <= Curr_row;
				Curr_row <= Next_row;
				Next_row <= New_row;
			end if;

		end if;

	end process;
	
end architecture Buffer_arc;