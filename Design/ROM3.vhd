library IEEE;
use IEEE.std_logic_1164.all;

entity ROM3 is
	
generic 
	(
		data_size : integer;
		addr_size : integer;
		mif_files : array(0 to 2) of string:="MIF\\r.mif","MIF\\g.mif","MIF\\b.mif"

	);

	port (

		Read_address  : in std_logic_vector(addr_size-1 downto 0);
		Read_en,clock : in std_logic;
		New_row		  : out array(0 to 2) of std_logic_vector(data_size-1 downto 0)					


		 );
end ROM3;


architecture ROM3_arc of ROM3 is
	signal current_address : std_logic_vector(addr_size-1 downto 0 );

	component ROM
		generic(
	
		data_size : integer;
		addr_size : integer;
		mif_file : string
			   );
		
		PORT(

		address		: IN STD_LOGIC_VECTOR (addr_size-1 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		    : OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
			);

	end component;

begin
	 ROMS : for i in 0 to 2 generate
	 	generic ( 
	 		    data_size =>1280,	--depth of color*size of row
	 		    addr_size =>8,		--size of row in bits
	 		    mif_file  =>mif_files(i) 
	 		    )

	 	port map(
	 			clock=>clock,
	 			address=>current_address,
	 			q=>New_row(i)
	 			);
	 end generate;

	 process(clock)
	 begin

	 	if(rising_edge(clock)) then
	 		if (Read_en) then
	 		current_address<=Read_address;	
	 		end if;
	 	end if;
	 end process;
end ROM3_arc;