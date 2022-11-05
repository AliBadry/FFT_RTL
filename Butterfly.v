module Butterfly #(
    parameter DATA_WIDTH = 16           //LOG2_NFFT = 5
) (
    input wire [DATA_WIDTH-1:0] in1_i, in1_r, in2_r, in2_i, 
    input wire [DATA_WIDTH-1:0] w_r, w_i,
    output reg [DATA_WIDTH-1:0] out1_r, out1_i, out2_r out2_i
);

//---------product1: 

reg [DATA_WIDTH-1:0] product1, product2, product3, product4;
    
endmodule