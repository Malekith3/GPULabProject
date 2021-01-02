library IEEE;
use IEEE.std_logic_1164.all;
PACKAGE SpecialArrays IS
    type output_array is array (natural range <>) of std_logic_vector (1279 downto 0);
    type mif_files is array (natural range <>) of string (1 to 10);
END; 