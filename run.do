
vlog ./FFT32DIT_TB.v
vlog ./Butterfly.v
vlog ./Multiplier.v
vlog ./FFT32DIT.v
vsim work.FFT32DIT_TB
add wave *
add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF1_out_r

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF1_out_i

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF2_out_r

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF2_out_i

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF3_out_r

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF3_out_i

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF4_out_r

add wave -position insertpoint  \
sim:/FFT32DIT_TB/DUT/BF4_out_i

add wave -position insertpoint  \
sim:/FFT32DIT_TB/stream_in_r

add wave -position insertpoint  \
sim:/FFT32DIT_TB/stream_in_i

add wave -position insertpoint  \
sim:/FFT32DIT_TB/stage2_real

run -all
