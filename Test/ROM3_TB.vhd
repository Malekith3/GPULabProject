library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE work.heap_arr_pkg.all;

entity ROM3_TB is 
end ROM3_TB;

architecture ROM3_TB_ARCH of ROM3_TB is
	component ROM3 is
	generic 
		(
			data_size1 : integer;
			addr_size1 : integer;
			mem_files : mif_files(1 to 3)

		);

	port (

			Read_address  : in  std_logic_vector(addr_size1-1 downto 0);
			Read_en,clock : in  std_logic;
			New_row		  : out output_array(1 to 3)					
		 );

	end component ROM3;
		signal SRead_address  : std_logic_vector(7 downto 0):=(others=>'0');
		signal Read_en:std_logic;
		signal clock : std_logic:='1';
		signal New_row	      : output_array(1 to 3);
begin
	ROM3_component : ROM3
	generic map (
				data_size1=>1280,
				addr_size1=>8,
				mem_files=>("MIF\\r.mif","MIF\\g.mif","MIF\\b.mif")
				)
	port map    (
				clock=>clock,
				Read_en=>Read_en,
				Read_address=>SRead_address,
				New_row=>New_row
			    );
	clock <= not clock after 5 ns;
	process
	begin
		wait until rising_edge(clock);
		Read_en <= '0';
		wait for 10 ns;
		wait until rising_edge(clock);
		Read_en <= '1';
		AdressShit : for i in 0 to 10 loop
			SRead_address<= SRead_address + std_logic_vector(to_unsigned(1,SRead_address'length));
			wait for 10 ns;
		end loop;
		wait;
	end process;
end architecture ROM3_TB_ARCH;