module Multiplier #(
    parameter WIDTH = 16
) (
    input wire [WIDTH-1:0] in1, in2,
    output reg [WIDTH-1:0]  out
);
reg [2*WIDTH-1:0] out_2WIDTH;
reg [WIDTH-1:0] abs_in1, abs_in2;

always @(*) 
begin
    if (in1<0)
    begin
        abs_in1 = -in1;
    end
    else
    begin
        abs_in1 = in1;
    end
    if (in2<0)
    begin
        abs_in2 = -in2;
    end
    else
    begin
        abs_in2 = in2;
    end

    out_2WIDTH = abs_in1*abs_in2;

    if (in1[WIDTH-1]^in2[WIDTH-1]) 
    begin
        out_2WIDTH = -out_2WIDTH;
        out = out_2WIDTH [WIDTH+(WIDTH>>1)-1:WIDTH>>1];     
    end
    else
    begin
        out = out_2WIDTH [WIDTH+(WIDTH>>1)-1:WIDTH>>1];
    end
end
    
endmodule