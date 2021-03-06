library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.std_logic_arith.all;



entity FSM is

	generic(
		addr_size : integer
	       );

	port(
		clock,start,rst 						: in std_logic;
		Read_en,done,push,write_en				: out std_logic;
		Read_address,write_address				: out std_logic_vector(addr_size-1 downto 0)
		);

end FSM;

architecture FSM_arc of FSM is
type state is(S0,S1,S2,S3,S4,S5);
signal current_state,next_state								: state;
signal current_read_address,current_write_address			: std_logic_vector(addr_size-1 downto 0):=(others=>'0');
signal full,counter_en										: std_logic:='0';
signal s_read_en,s_write_en,delay1,delay2,delay3			: std_logic;
begin
process(current_state,start,full)
begin
	next_state <= current_state;
	done	   <= '0';
	push	   <= '0';
	s_read_en  <= '0';
	s_write_en <= '0';
	counter_en <= '1';

	case current_state is

	when S0 =>
		counter_en 		<= '0';

		if (start = '1') then
			next_state <= S1;
		end if;

	when S1 =>
		push 			<= '1';
		counter_en      <= '0';
		s_read_en		<= '1';
		next_state		<= S2;

	when S2 =>
		push			<= '1';
		counter_en		<= '1';
		s_read_en		<= '1';
		next_state 		<= S3;

	when S3 =>
		push			<= '1';
		counter_en 		<= '1';
		s_read_en		<= '1';

		if(current_read_address > x"00") then
			s_write_en 	<= '1';
		end if;

		if(full = '1') then
			next_state	<= S4;
			counter_en 	<= '0';
		end if;

	when S4 =>
		counter_en 		<= '0';
		s_read_en 		<= '1';
		next_state 		<= S5;
		s_write_en 		<= '1';
		push			<= '1';

	when S5 =>
		counter_en 		<= '0';
		done			<= '1';
		push			<= '0';
		s_read_en		<= '0';
		s_write_en 		<= '0';

	end case;
end process;

process(rst,clock)
begin
	if(rst='1') then
		current_read_address 		<= x"00";
		current_write_address 		<= x"00";
		current_state				<= S0;
		full 						<= '0';
		write_en 					<= '0';
		delay1 						<= '0';
		delay2 						<= '0';
		delay3       				<= '0';

	elsif (rising_edge(clock)) then
		delay3						<= s_write_en;
		delay2						<= delay3;
		delay1						<= delay2;
		write_en 					<= delay1;
		current_state				<= next_state;
		current_write_address       <= current_write_address + delay1;
		current_read_address		<= current_read_address  + counter_en;

		if(conv_integer(unsigned(current_read_address))=254) then
			full					<= '1';
		end if;
	end if;
end process;

Read_address 						<= current_read_address;
write_address 						<= current_write_address;
Read_en 							<= s_read_en;

end FSM_arc;
