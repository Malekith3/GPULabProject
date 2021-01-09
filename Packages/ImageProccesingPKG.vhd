library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.std_logic_arith.all;
use work.SpecialArrays.all;

PACKAGE ImageProcessing IS
	type pixel  		is array (1 to 1) 			of std_logic_vector(4 downto 0);
	type pixelArray 	is array (natural Range <>) of pixel;
	type row3			is array (1 to 3)			of pixelArray(1 to 256+2);
    type Mat3X3 		is array (1 to 3) of pixelArray(1 to 3);
    function Median2D 	 					(arg: Mat3X3) 				 				return pixel;
    function Median   	 					(arg: pixelArray(1 to 3)) 	 				return pixel;
    function Median3Rows 					(arg: row3) 				 				return pixelArray;
    function StdToPixelArray				(arg: std_logic_vector (1279 downto 0))  	return pixelArray;
    function PixelArrayToStd				(arg: pixelArray(1 to 256))  				return std_logic_vector;
END;


Package Body ImageProcessing is

function Median3Rows (arg: row3) return pixelArray is
variable row: 			pixelArray(1 to 256);
variable tempMat:		Mat3X3;
begin

 for i in 1 to 256 loop 				--pixels loop
	 for j in 1 to 3 loop 				--rows loop
		tempMat(j) := arg(j)(i to i+2);
	end loop;

	row(i) := Median2D(tempMat);
end loop;

	return row;
end Median3Rows;

function Median2D (arg: Mat3X3) return pixel is
variable buff: pixelArray(1 to 3);
begin
	 for i in 1 to 3 loop
		buff(i) := Median(arg(i));
	end loop;
	return Median(buff);
end Median2D;

function Median   (arg: pixelArray(1 to 3)) return pixel is
variable temp:	  pixel;
begin
	if (conv_integer(unsigned(arg(3)(1))) >= conv_integer(unsigned(arg(2)(1))) and conv_integer(unsigned(arg(3)(1))) <= conv_integer(unsigned(arg(1)(1)))) then
        temp:= arg(3);

    elsif (conv_integer(unsigned(arg(3)(1))) >= conv_integer(unsigned(arg(1)(1))) and conv_integer(unsigned(arg(3)(1))) <= conv_integer(unsigned(arg(2)(1)))) then
        temp:= arg(3);

    elsif (conv_integer(unsigned(arg(2)(1))) >= conv_integer(unsigned(arg(1)(1))) and conv_integer(unsigned(arg(2)(1)))<= conv_integer(unsigned(arg(3)(1)))) then
       temp:= arg(2);

    elsif (conv_integer(unsigned(arg(2)(1))) >= conv_integer(unsigned(arg(3)(1))) and conv_integer(unsigned(arg(2)(1))) <= conv_integer(unsigned(arg(1)(1)))) then
        temp:= arg(2);

    elsif (conv_integer(unsigned(arg(1)(1))) >= conv_integer(unsigned(arg(2)(1))) and conv_integer(unsigned(arg(1)(1))) <= conv_integer(unsigned(arg(3)(1)))) then
        temp:= arg(1);

    elsif (conv_integer(unsigned(arg(1)(1))) >= conv_integer(unsigned(arg(3)(1))) and conv_integer(unsigned(arg(1)(1))) <= conv_integer(unsigned(arg(2)(1)))) then
        temp:= arg(1);

    else
        temp:= arg(1);
    end if;

	return temp;	
end Median;

function StdToPixelArray (arg: std_logic_vector (1279 downto 0)) return pixelArray is 		-- returns zero-padded
variable temp:	pixelArray(1 to 258);
begin
	  for i in 1 to 258 loop
	  	if (i <= 2 or i>256) then
	  		temp(i)(1) := "00000";
	  	else
	  		temp(i)(1)	:= arg((5*(i-2)-1) downto (5*(i-3)));
	  	end if;
	end loop;
	return temp;
end StdToPixelArray;

function PixelArrayToStd (arg: pixelArray(1 to 256)) return std_logic_vector  is
variable temp:	std_logic_vector (1279 downto 0);
begin
	 for i in 1 to 256 loop
		temp(5*i-1 downto 5*(i-1)) := arg(i)(1)(4 downto 0);
	end loop;
	return temp;
end PixelArrayToStd;
END Package Body ImageProcessing;

