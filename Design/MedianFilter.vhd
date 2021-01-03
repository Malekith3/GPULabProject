library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.SpecialArrays.all;

entity MedianFilter is
	port (
		Prev_row , Curr_row,Next_row  	: in output_array(1 to 3);
		Proc_row 					 	: out output_array(1 to 3)
		 );
end MedianFilter;

architecture MedianFilter_arc of MedianFilter is
begin

end MedianFilter_arc;