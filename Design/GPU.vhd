library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;        -- for addition & counting
use ieee.numeric_std.all;               -- for type conversions
use work.SpecialArrays.all;
use work.ImageProcessing.all;

entity GPU is
	port (
		clock ,start , rst : in std_logic;
		done 			   : out std_logic
	     ) ;
end GPU;

architecture GPU_arc of GPU is
signal clk , Read_en , push, Write_en , reset 	: std_logic;
signal Read_address , Write_address 			: std_logic_vector(7 downto 0);
signal New_row 									: output_array(1 to 3);
Signal Prev_row , Curr_row , Next_row 			: output_array(1 to 3);
signal Proc_row 					 	        : output_array(1 to 3);
component ROM3
		generic (
		data_size1 : integer := 1280;
		addr_size1 : integer := 8;
		mem_files : mif_files(1 to 3) :=("MIF\\r.mif","MIF\\g.mif","MIF\\b.mif")
				);

	port (

		Read_address  : in std_logic_vector(addr_size1-1 downto 0);
		Read_en,clock : in std_logic;
		New_row		  : out  output_array(1 to 3)				
		 );
	end component;

	component RAM3
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
	end component;

	component MedianFilter
		port (
		Prev_row , Curr_row,Next_row  	: in output_array(1 to 3);
		Proc_row 					 	: out output_array(1 to 3)
			 );
	end component;

	component FSM
		generic(
		addr_size : integer :=8
	       	   );

	port(
		clock,start,rst 						: in std_logic;
		Read_en,done,push,write_en				: out std_logic;
		Read_address,write_address				: out std_logic_vector(addr_size-1 downto 0)
		);
	end component;

	component BufferGPU
		port (
			clock , rst , push       			: in  std_logic;
			New_row                  			: in  output_array(1 to 3);
			Prev_row , Curr_row , Next_row 		: buffer output_array(1 to 3)
			 );
	end component;
begin
	S1:ROM3
	port map (
		Read_address  	=> Read_address, 
		Read_en 	  	=> Read_en,
		clock 		  	=> clk,
		New_row		  	=> New_row	  	
			 );
	S2:FSM
	port map (
		clock 		  	=> clk,
		start		  	=> start,
		rst			  	=> reset,
		Read_en		  	=> Read_en,
		done    	  	=> done,
		push 	      	=> push,
		write_en 	  	=> Write_en,
		Read_address  	=> Read_address,
		write_address 	=> Write_address
			 );
	S3:BufferGPU
	port map (
		clock		  	=> clk,
		rst 		  	=> reset, 
		push 		  	=> push,
		New_row 	  	=> New_row,
		Prev_row 	 	=> Prev_row,
		Curr_row  	  	=> Curr_row, 
		Next_row      	=> Next_row
			 );
	S4:MedianFilter
	port map (
		Prev_row 	 	=> Prev_row,
		Curr_row 	 	=> Curr_row,
		Next_row 	 	=> Next_row, 
		Proc_row 	 	=> Proc_row
	         );
	S5:RAM3
	port map (
		Write_address 	=> Write_address,
		Write_en  		=> Write_en,
		clock 			=> clk,
		Proc_row		=> Proc_row		
		
			 );
	
	clk<=clock;
	reset<=rst;

end  GPU_arc;