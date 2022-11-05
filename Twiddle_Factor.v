module Twiddle_Factor 
#(parameter NFFT = 8, //-------------number of FFT points--------------//
            Width = 16)
(
    input wire [Width-1:0]   Address,
    output reg [Width-1:0]     Data_real, Data_imag 
);

reg [Width-1:0] ROM_real [Width-1:0];
reg [Width-1:0] ROM_imag [Width-1:0];
initial
begin
    $readmemb("W_real_16",ROM_real);
    $readmemb("W_imag_16",ROM_imag);
end
 
 always @(*) 
 begin
    Data_real = ROM_real[Address];
    Data_imag = ROM_imag[Address];   
 end
    
endmodule