module Twiddle_Factor 
#(parameter LOG2_NFFT = 5, //-------------LOG2 (FFT points)--------------//
            DATA_WIDTH = 16)
(
    input wire [DATA_WIDTH-1:0]     address,
    output reg [DATA_WIDTH-1:0]     data_real, data_imag 
);

reg [DATA_WIDTH-1:0] ROM_real [2**LOG2_NFFT - 1:0];
reg [DATA_WIDTH-1:0] ROM_imag [2**LOG2_NFFT - 1:0];
initial
begin
    $readmemb("W_real_32.txt",ROM_real);
    $readmemb("W_imag_32.txt",ROM_imag);
end
 
 always @(*) 
 begin
    Data_real = ROM_real[Address];
    Data_imag = ROM_imag[Address];   
 end
endmodule