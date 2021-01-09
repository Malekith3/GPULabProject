library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.SpecialArrays.all;
use work.ImageProcessing.all;
entity MedianFilter is
	port (
		Prev_row , Curr_row,Next_row  	: in output_array(1 to 3);
		Proc_row 					 	: out output_array(1 to 3)
		 );
end MedianFilter;

architecture MedianFilter_arc of MedianFilter is
begin
	process(Prev_row, Curr_row , Next_row)
	variable Prev_row_zeropadded,Curr_row_zeropadded,Next_row_zeropadded: pixelArray(1 to 256+2);
	variable rowToFilt: row3; 
	begin
	 for i in 1 to 3 loop
		Prev_row_zeropadded :=  StdToPixelArray(Prev_row(i)); 
		Curr_row_zeropadded :=  StdToPixelArray(Curr_row(i));
		Next_row_zeropadded :=  StdToPixelArray(Next_row(i));
		rowToFilt(1)		:= Prev_row_zeropadded;
		rowToFilt(2)		:= Curr_row_zeropadded;
		rowToFilt(3)		:= Next_row_zeropadded;
		Proc_row (i)		<= PixelArrayToStd(Median3Rows(rowToFilt));
	end loop;
	end process;

end MedianFilter_arc;