
echo Start of Simulation

#set path_to_sim_lib C:/Software_Projects/GPU_Lab_Project_Hardware_Design/GPULabProject

# your project ordered file list
set package_list [list "Packages/SpecialArraysPKG.vhd" "Packages/ImageProccesingPKG.vhd"]
set file_list [list  "Packages/SpecialArraysPKG.vhd" "Packages/ImageProccesingPKG.vhd" "Design/ROM.vhd" "Design/ROM3.vhd" "Design/FSM.vhd" "Design/BufferGPU.vhd" "Design/RAM.vhd" "Design/RAM3.vhd" "Design/MedianFilter.vhd" "Design/MedianFilter.vhd" "Design/GPU.vhd" "Test/GPU_TB.vhd"]
# your project top level
set top_level work.GPU_TB
# set run time at online by user- (full flow control)
#puts "Set the simulation runtime including time units"
set run_time "3000 ns"
#-------------------------------------------------------------------
# compile and run
#-------------------------------------------------------------------
#cd $path_to_sim_lib
if {![file exists work]} {exec vlib work}
vmap work work
foreach file_name $package_list {vcom -93 -quiet -work work $file_name}
foreach file_name $file_list {vcom -93 -quiet -work work $file_name}
vsim -title $top_level $top_level
# for simulation with wave configuration script
#do wave.do
# general case
add wave *
run $run_time