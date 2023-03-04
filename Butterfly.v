module Butterfly #(
    parameter DATA_WIDTH = 32           //LOG2_NFFT = 5
) (
    input wire clk, rst,
    input wire [DATA_WIDTH-1:0] in1_i, in1_r, 
    input wire [DATA_WIDTH-1:0] in2_r, in2_i, 
    input wire [DATA_WIDTH-1:0] w_r, w_i,
    output reg [DATA_WIDTH-1:0] out1_r, out1_i, 
    output reg [DATA_WIDTH-1:0] out2_r, out2_i
);

//-------- out1 = [in1_r + in2_r*w_r - in2_i*w_i] + j[in1_i + in2_r*w_i + in2_i*w_r]
//-------- out2 = [in1_r - in2_r*w_r + in2_i*w_i] + j[in1_i - in2_r*w_i - in2_i*w_r]

//-------- mul1 = in2_r * w_r
//-------- mul2 = in2_i * w_i
//-------- mul3 = in2_r * w_i
//-------- mul4 = in2_i * w_r

wire [DATA_WIDTH-1:0] mul1, mul2, mul3, mul4;

//---------instantiating the twiddle factor term------------//

//------evaluating the product terms----------//
    Multiplier #(.DATA_WIDTH(DATA_WIDTH)) M1 (.clk(clk), .rst(rst), .in1(in2_r), .in2(w_r), .Product_o(mul1));
    Multiplier #(.DATA_WIDTH(DATA_WIDTH)) M2 (.clk(clk), .rst(rst), .in1(in2_i), .in2(w_i), .Product_o(mul2));
    Multiplier #(.DATA_WIDTH(DATA_WIDTH)) M3 (.clk(clk), .rst(rst), .in1(in2_r), .in2(w_i), .Product_o(mul3));
    Multiplier #(.DATA_WIDTH(DATA_WIDTH)) M4 (.clk(clk), .rst(rst), .in1(in2_i), .in2(w_r), .Product_o(mul4));

//------evaluating the output results----------//
always @(posedge clk or negedge rst) 
begin
    if(!rst) begin
        out1_r <= 'b0;
        out1_i <= 'b0;
        out2_r <= 'b0;
        out2_i <= 'b0;
    end
    else
    begin
        out1_r <= in1_r + mul1 - mul2;
        out1_i <= in1_i + mul3 + mul4;
        out2_r <= in1_r - mul1 + mul2;
        out2_i <= in1_i - mul3 - mul4;
    end
end
    
endmodule