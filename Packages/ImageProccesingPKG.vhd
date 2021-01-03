library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
PACKAGE ImageProcessing IS
	type pixel  		is std_logic_vector(4 downto 0);
	type pixelArray 	is array (natural Range <>) of pixel;
    type Mat3X3 		is array (1 to 3) of pixelArray(2 downto 0);
    function Median2D (arg: Mat3X3) return pixel;
    function Median   (arg: pixelArray(1 to 3)) return pixel;
END;


Package Body ImageProcessing is
function Median2D (arg: Mat3X3) return pixel is
variable buff: pixelArray(1 to 3);
begin
	 for i in 1 to 3 loop
		buff(i) = Median(arg(i))
	end loop;
	return Median(buff);
end Median2D;

function Median   (arg: pixelArray(1 to 3)) return pixel is
variable temp:	  pixel;
begin
	if (arg(2) >= arg(1) and arg(2) <= arg(0)) then
        temp:= arg(2);

    elsif (arg(2) >= arg(0) and arg(2) <= arg(1)) then
        temp:= d(2);

    elsif (arg(1) >= arg(0) and arg(1) <= arg(2)) then
       temp:= d(1);

    elsif (arg(1) >= arg(2) and arg(1) <= arg(0)) then
        temp:= d(1);

    elsif (arg(0) >= arg(1) and arg(0) <= arg(2)) then
        temp:= d(0);

    elsif (arg(0) >= arg(2) and arg(0) <= arg(1)) then
        temp:= arg(0);

    else
        temp:= arg(0);
    end if;

	return temp;	
end Median;
END Package Body ImageProcessing;

