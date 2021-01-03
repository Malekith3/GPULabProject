LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

USE work.SpecialArrays.all;
library IEEE;
use IEEE.std_logic_1164.all;

entity RAM3 is
	
generic (
    	INST_NAMES: INST_NAMES(1 to 3):=("RRAM","GRAM","BRAM");
    	data_size : integer:=1280;
		addr_size : integer:=8
    	);

	port (

		Write_address  : in std_logic_vector(addr_size-1 downto 0);
		Write_en,clock : in std_logic;
		Proc_row	   : in  output_array(1 to 3)				
		 );
end RAM3;


architecture RAM3_arc of RAM3 is
	component  RAM is
		generic (
    		INST_NAME: string;
    		data_size : integer;
			addr_size : integer
    			);
		
		PORT(
					address		: IN STD_LOGIC_VECTOR (addr_size-1 DOWNTO 0);
					clock		: IN STD_LOGIC  := '1';
					data		: IN STD_LOGIC_VECTOR (data_size-1 DOWNTO 0);
					wren		: IN STD_LOGIC ;
		            q			: OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
		
			);

	end component RAM;

signal current_address : std_logic_vector(addr_size-1 downto 0 );
begin
	 RAMS : for i in 1 to 3 generate
	 	g1 : RAM
	 	generic map( 
	 			INST_NAME => INST_NAMES(i),
	 		    data_size => data_size,	--depth of color*size of row
	 		    addr_size => addr_size		--size of row in bits
	 		    
	 		    	)

	 	port map(
	 			clock  			=> clock,
	 			address 		=> Write_address,
	 			q	   			=> open,
	 			data 			=> Proc_row(i),
	 			wren 			=> Write_en
	 			);
	 end generate RAMS;
process(clock)
begin
end process;
end RAM3_arc;