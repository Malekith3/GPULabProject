LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

USE work.SpecialArrays.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity ROM3 is
	
generic 
	(
		data_size1 : integer;
		addr_size1 : integer;
		mem_files : mif_files(1 to 3)
	);

	port (

		Read_address  : in std_logic_vector(addr_size1-1 downto 0);
		Read_en,clock : in std_logic;
		New_row		  : out  output_array(1 to 3)				
		 );
end ROM3;


architecture ROM3_arc of ROM3 is
	component  ROM is
		generic(
	
		data_size : integer;
		addr_size : integer;
		mif_file  : string
			   );
		
		PORT(

		address		: IN STD_LOGIC_VECTOR (addr_size-1 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
			);

	end component ROM;
	signal current_address : std_logic_vector(addr_size1-1 downto 0 );
begin
	 ROMS : for i in 1 to 3 generate
	 	g1 : ROM
	 	generic map( 
	 		    data_size =>data_size1,	--depth of color*size of row
	 		    addr_size =>addr_size1,		--size of row in bits
	 		    mif_file  =>mem_files(i) 
	 		    )

	 	port map(
	 			clock=>clock,
	 			address=>current_address,
	 			q=>New_row(i)
	 			);
	 end generate ROMS;

	 process(clock)
	 begin

	 	if(rising_edge(clock)) then
	 		if (Read_en='1') then
	 		current_address<=Read_address;	
	 		end if;
	 	end if;
	 end process;
end ROM3_arc;