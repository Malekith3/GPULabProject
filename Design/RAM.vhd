

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY RAM IS
    generic (
    		INST_NAME: string;
    		data_size : integer;
			addr_size : integer
    		);
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (addr_size-1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (data_size-1 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
	);
END RAM;


ARCHITECTURE SYN OF RAM IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (data_size-1 DOWNTO 0);

BEGIN
	q    <= sub_wire0(data_size-1 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		intended_device_family => "Cyclone IV E",
		lpm_hint => "ENABLE_RUNTIME_MOD=YES,INSTANCE_NAME=" & INST_NAME,
		lpm_type => "altsyncram",
		numwords_a => 2**addr_size,
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => addr_size,
		width_a => data_size,
		width_byteena_a => data_size/8
	)
	PORT MAP (
		address_a => address,
		clock0 => clock,
		data_a => data,
		wren_a => wren,
		q_a => sub_wire0
	);



END SYN;

