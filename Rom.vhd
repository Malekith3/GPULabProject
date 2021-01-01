LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Rom IS
	generic 
	(
		data_size : integer;
		addr_size : integer;
		mif_file : string
	);
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (addr_size-1 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (data_size-1 DOWNTO 0)
	);
END Rom;


ARCHITECTURE SYN OF Rom IS
	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (data_size-1 DOWNTO 0);
BEGIN
	q    <= sub_wire0(data_size-1 DOWNTO 0);
	
	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => mif_file,
		intended_device_family => "Cyclone IV E",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 2**addr_size,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => addr_size,
		width_a => data_size,
		width_byteena_a => data_size/8
	)
	PORT MAP (
		address_a => address,
		clock0 => clock,
		q_a => sub_wire0
	);



END SYN;