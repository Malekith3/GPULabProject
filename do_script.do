
echo Start of Simulation

set path_to_sim_lib C:/source/VHDL/Lab3_Hamming_code

# your project ordered file list
set file_list [list  "ROM.vhd"]
# your project top level
set top_level work.ROM
# set run time at online by user- (full flow control)
#puts "Set the simulation runtime including time units"
set run_time "300 ns"
#-------------------------------------------------------------------
# compile and run
#-------------------------------------------------------------------
cd $path_to_sim_lib
if {![file exists work]} {exec vlib work}
vmap work work
foreach file_name $file_list {vcom -93 -quiet -work work $file_name}
vsim -title $top_level $top_level
# for simulation with wave configuration script
#do wave.do
# general case
add wave -r *
run $run_time