library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions

entity FSM_TB is
	generic (
			addr_size: integer :=8
		    );
end FSM_TB;

architecture FSM_TB_arc of FSM_TB is

	signal clock								:  std_logic:='0';
	signal start,rst 							:  std_logic;
	signal Read_en,done,push,write_en			:  std_logic;
	signal Read_address,write_address			:  std_logic_vector(addr_size-1 downto 0);

	component FSM
	generic(
		addr_size : integer
	       );

	port(
		clock,start,rst 						: in std_logic;
		Read_en,done,push,write_en				: out std_logic;
		Read_address,write_address				: out std_logic_vector(addr_size-1 downto 0)
		);

	end component;

begin
	f1: FSM
	generic map(addr_size => addr_size)

	port map(
		clock 			=> clock,
		start 			=> start,
		rst   			=> rst,
		Read_en			=> Read_en,
		done			=> done,
		push			=> push,
		write_en		=> write_en,
		Read_address	=> Read_address,
		write_address 	=> write_address
			);

	clock <= not clock after 5 ns;

	process
	begin
		rst 	<= '1';
		wait until rising_edge(clock);
		rst		<= '0';
		wait for 20 ns;
		wait until rising_edge(clock);
		start 	<= '1';
		wait until rising_edge(clock);
		start 	<= '0';

	wait;
	end process;

end FSM_TB_arc;

