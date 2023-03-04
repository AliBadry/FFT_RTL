module Multiplier #(
    parameter DATA_WIDTH = 32
) (
    input wire clk, rst,
    input  wire [DATA_WIDTH-1:0]    in1, in2,
    output reg  [DATA_WIDTH-1:0]    Product_o
);
    
    
    wire     [DATA_WIDTH-1:0]    term1, term2;
    wire     [2*DATA_WIDTH-1:0]  result1, result2;

    assign term1 = in1[DATA_WIDTH-1]?-in1:in1;  //---absolute value of input----//
    assign term2 = in2[DATA_WIDTH-1]?-in2:in2;  //---absolute value of input----//
    assign result1 = term1*term2;
    assign result2 = in1[DATA_WIDTH-1] ^ in2[DATA_WIDTH-1]? -result1:result1;

    always@(posedge clk or negedge rst)
    begin
        if (!rst) begin
            Product_o <= 'b0;
        end
        else
         begin
            Product_o <= result2 >> DATA_WIDTH/2; //--------resizing the result's number of bits-------//
         end
    end
endmodule