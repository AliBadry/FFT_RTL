module Butterfly #(
    parameter DATA_WIDTH = 16           //LOG2_NFFT = 5
) (
    input wire [DATA_WIDTH-1:0] in1_i, in1_r, 
    input wire [DATA_WIDTH-1:0] in2_r, in2_i, 
    input wire [DATA_WIDTH-1:0] w_r, w_i,
    output reg [DATA_WIDTH-1:0] out1_r, out1_i, 
    output reg [DATA_WIDTH-1:0] out2_r out2_i
);

//-------- out1 = [in1_r + in2_r*w_r - in2_i*w_i] + j[in1_i + in2_r*w_i + in2_i*w_r]
//-------- out2 = [in1_r - in2_r*w_r - in2_i*w_i] + j[in1_i - in2_r*w_i - in2_i*w_r]

//-------- mul1 = in2_r * w_r
//-------- mul2 = in2_i * w_i
//-------- mul3 = in2_r * w_i
//-------- mul4 = in2_i * w_r

reg [DATA_WIDTH-1:0] mul1, mul2, mul3, mul4;

always @(*) 
begin
    //------evaluating the product terms----------//
    mul1 = multiplication(in2_r,w_r);
    mul2 = multiplication(in2_i,w_i);
    mul3 = multiplication(in2_r,w_i);
    mul4 = multiplication(in2_i,w_r);

    //------evaluating the output results----------//
    out1_r = in1_r + mul1 - mul2;
    out1_i = in1_i + mul3 + mul4;
    out2_r = in1_r - mul1 + mul2;
    out2_i = in1_i - mul3 - mul4;
end


//---------- defining the multiplication function -----------//
function [DATA_WIDTH-1:0] multiplication;
    input   [DATA_WIDTH-1:0]    in1, in2;
    reg     [DATA_WIDTH-1:0]    term1, term2;
    reg     [2*DATA_WIDTH-1:0]  result1, result2;
    begin
         term1 = in1[DATA_WIDTH-1]?-in1:in1;  //---absolute value of input----//
         term2 = in2[DATA_WIDTH-1]?-in2:in2;  //---absolute value of input----//
         result1 = Term1*Term2;
         result2 = in1[DATA_WIDTH-1] ^ in2[DATA_WIDTH-1]? -result1:result1;
         multiplication = result2 >> DATA_WIDTH/2; //--------resizing the result's number of bits-------//

    end
endfunction
    
endmodule