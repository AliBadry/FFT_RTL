module Multiplier #(
    parameter WIDTH = 16
) (
    input wire [WIDTH-1:0] in1, in2,
    output reg [WIDTH-1:0]  out
);
reg [2*WIDTH-1:0] out_2WIDTH;
reg [WIDTH-1:0] digit_product, mixed_product1, mixed_product2, decimal_product;

always @(*) 
begin
    if ((in1<0 && in2>0) || (in>0 && in2<0))
    begin
        digit_product = in1[WIDTH-1:WIDTH>>1] * in2[WIDTH-1:WIDTH>>1];
        mixed_product1 = in1[(WIDTH>>1)-1:0] * in2[WIDTH-1:WIDTH>>1] + in2[(WIDTH>>1)-1:0] * in1[WIDTH-1:WIDTH>>1];
        decimal_product = in1[(WIDTH>>1)-1:0] * in2[(WIDTH>>1)-1:0];
        out_2WIDTH = {digit_product + mixed_product1[WIDTH-1:WIDTH>>1], -decimal_product-mixed_product1[(WIDTH>>1)-1:0]};
    end
    else
    begin
        out_2WIDTH = in1*in2;
    end

    out = out_2WIDTH [WIDTH+(WIDTH>>1)-1:WIDTH>>1];
end
endmodule