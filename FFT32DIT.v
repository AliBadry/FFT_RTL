//--------------some needed abbreviations for easier variable names--------------//
//---------------------------BF: butterfly------------------------//
//---------------------------TF: Twiddle Factor-------------------//
//---------------------------FB: Flip Bit-------------------------//
module FFT32DIT
#(     parameter    DATA_WIDTH = 32, 
                    LOG2_NFFT = 5,   //log2(NFFT)    
                    NFFT_POINTS = 2**LOG2_NFFT // Number of FFT points used
)
(
    input wire              clk, 
    input wire              rst,
    /*input wire  [DATA_WIDTH-1:0] stream_in_r   [0:NFFT_POINTS-1],
    input wire  [DATA_WIDTH-1:0] stream_in_i   [0:NFFT_POINTS-1],
    output reg  [DATA_WIDTH-1:0] stream_out_r  [0:NFFT_POINTS-1]
    output reg  [DATA_WIDTH-1:0] stream_out_i  [0:NFFT_POINTS-1]*/
    input wire  [DATA_WIDTH-1:0] stream_in_r0, stream_in_r1, stream_in_r2, stream_in_r3, stream_in_r4, stream_in_r5, stream_in_r6, stream_in_r7, stream_in_r8, stream_in_r9, stream_in_r10,
    input wire  [DATA_WIDTH-1:0] stream_in_r11, stream_in_r12, stream_in_r13, stream_in_r14, stream_in_r15, stream_in_r16, stream_in_r17, stream_in_r18, stream_in_r19,stream_in_r20,
    input wire  [DATA_WIDTH-1:0] stream_in_r21, stream_in_r22, stream_in_r23, stream_in_r24, stream_in_r25, stream_in_r26, stream_in_r27, stream_in_r28, stream_in_r29,stream_in_r30,
    input wire  [DATA_WIDTH-1:0] stream_in_r31,
    input wire  [DATA_WIDTH-1:0] stream_in_i0, stream_in_i1, stream_in_i2, stream_in_i3, stream_in_i4, stream_in_i5, stream_in_i6, stream_in_i7, stream_in_i8, stream_in_i9, stream_in_i10,
    input wire  [DATA_WIDTH-1:0] stream_in_i11, stream_in_i12, stream_in_i13, stream_in_i14, stream_in_i15, stream_in_i16, stream_in_i17, stream_in_i18, stream_in_i19,stream_in_i20,
    input wire  [DATA_WIDTH-1:0] stream_in_i21, stream_in_i22, stream_in_i23, stream_in_i24, stream_in_i25, stream_in_i26, stream_in_i27, stream_in_i28, stream_in_i29,stream_in_i30,
    input wire  [DATA_WIDTH-1:0] stream_in_i31,
    output wire  [DATA_WIDTH-1:0] stream_out_r0, stream_out_r1, stream_out_r2, stream_out_r3, stream_out_r4, stream_out_r5, stream_out_r6, stream_out_r7, stream_out_r8, stream_out_r9, stream_out_r10,
    output wire  [DATA_WIDTH-1:0] stream_out_r11, stream_out_r12, stream_out_r13, stream_out_r14, stream_out_r15, stream_out_r16, stream_out_r17, stream_out_r18, stream_out_r19,stream_out_r20,
    output wire  [DATA_WIDTH-1:0] stream_out_r21, stream_out_r22, stream_out_r23, stream_out_r24, stream_out_r25, stream_out_r26, stream_out_r27, stream_out_r28, stream_out_r29,stream_out_r30,
    output wire  [DATA_WIDTH-1:0] stream_out_r31,
    output wire  [DATA_WIDTH-1:0] stream_out_i0, stream_out_i1, stream_out_i2, stream_out_i3, stream_out_i4, stream_out_i5, stream_out_i6, stream_out_i7, stream_out_i8, stream_out_i9, stream_out_i10,
    output wire  [DATA_WIDTH-1:0] stream_out_i11, stream_out_i12, stream_out_i13, stream_out_i14, stream_out_i15, stream_out_i16, stream_out_i17, stream_out_i18, stream_out_i19,stream_out_i20,
    output wire  [DATA_WIDTH-1:0] stream_out_i21, stream_out_i22, stream_out_i23, stream_out_i24, stream_out_i25, stream_out_i26, stream_out_i27, stream_out_i28, stream_out_i29,stream_out_i30,
    output wire  [DATA_WIDTH-1:0] stream_out_i31
);

//-----------Definig usable regs--------//

wire [DATA_WIDTH-1:0] inputs_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] inputs_i [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] outputs_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] outputs_i [0:NFFT_POINTS-1];

wire [DATA_WIDTH-1:0] BF1_out_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF1_out_i [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF2_out_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF2_out_i [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF3_out_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF3_out_i [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF4_out_r [0:NFFT_POINTS-1];
wire [DATA_WIDTH-1:0] BF4_out_i [0:NFFT_POINTS-1];

wire [LOG2_NFFT-1:0] TF_address;
reg [DATA_WIDTH-1:0] TF_data_real [0:NFFT_POINTS-1];
reg [DATA_WIDTH-1:0] TF_data_imag [0:NFFT_POINTS-1];

//reg [LOG2_NFFT-1:0 ] FB_address, FB_out;
//reg [LOG2_NFFT-1:0 ] FB_out_array [0:NFFT_POINTS];



//------------array of inputs and outputs for easier instantiations-------------//
//------------------ This will also helo us in decimation-----------------//
assign inputs_r[0] = stream_in_r0;     assign inputs_r[1] = stream_in_r16;    assign inputs_r[2] = stream_in_r8;     assign inputs_r[3] = stream_in_r24;    assign inputs_r[4] = stream_in_r4;      
assign inputs_r[5] = stream_in_r20;    assign inputs_r[6] = stream_in_r12;    assign inputs_r[7] = stream_in_r28;    assign inputs_r[8] = stream_in_r2;     assign inputs_r[9] = stream_in_r18;      
assign inputs_r[10] = stream_in_r10;   assign inputs_r[11] = stream_in_r26;   assign inputs_r[12] = stream_in_r6;    assign inputs_r[13] = stream_in_r22;   assign inputs_r[14] = stream_in_r14;      
assign inputs_r[15] = stream_in_r30;   assign inputs_r[16] = stream_in_r1;    assign inputs_r[17] = stream_in_r17;   assign inputs_r[18] = stream_in_r9;    assign inputs_r[19] = stream_in_r25;      
assign inputs_r[20] = stream_in_r5;    assign inputs_r[21] = stream_in_r21;   assign inputs_r[22] = stream_in_r13;   assign inputs_r[23] = stream_in_r29;   assign inputs_r[24] = stream_in_r3;      
assign inputs_r[25] = stream_in_r19;   assign inputs_r[26] = stream_in_r11;   assign inputs_r[27] = stream_in_r27;   assign inputs_r[28] = stream_in_r7;    assign inputs_r[29] = stream_in_r23;      
assign inputs_r[30] = stream_in_r15;   assign inputs_r[31] = stream_in_r31;

assign inputs_i[0] = stream_in_i0;     assign inputs_i[1] = stream_in_i16;    assign inputs_i[2] = stream_in_i8;     assign inputs_i[3] = stream_in_i24;    assign inputs_i[4] = stream_in_i4;      
assign inputs_i[5] = stream_in_i20;    assign inputs_i[6] = stream_in_i12;    assign inputs_i[7] = stream_in_i28;    assign inputs_i[8] = stream_in_i2;     assign inputs_i[9] = stream_in_i18;      
assign inputs_i[10] = stream_in_i10;   assign inputs_i[11] = stream_in_i26;   assign inputs_i[12] = stream_in_i6;    assign inputs_i[13] = stream_in_i22;   assign inputs_i[14] = stream_in_i14;      
assign inputs_i[15] = stream_in_i30;   assign inputs_i[16] = stream_in_i1;    assign inputs_i[17] = stream_in_i17;   assign inputs_i[18] = stream_in_i9;    assign inputs_i[19] = stream_in_i25;      
assign inputs_i[20] = stream_in_i5;    assign inputs_i[21] = stream_in_i21;   assign inputs_i[22] = stream_in_i13;   assign inputs_i[23] = stream_in_i29;   assign inputs_i[24] = stream_in_i3;      
assign inputs_i[25] = stream_in_i19;   assign inputs_i[26] = stream_in_i11;   assign inputs_i[27] = stream_in_i27;   assign inputs_i[28] = stream_in_i7;    assign inputs_i[29] = stream_in_i23;      
assign inputs_i[30] = stream_in_i15;   assign inputs_i[31] = stream_in_i31;

assign  stream_out_r0  = outputs_r[0];    assign  stream_out_r1 = outputs_r[1];    assign stream_out_r2  = outputs_r[2];    assign stream_out_r3  = outputs_r[3];    assign stream_out_r4  =  outputs_r[4];     
assign  stream_out_r5  = outputs_r[5];    assign  stream_out_r6 = outputs_r[6];    assign stream_out_r7  = outputs_r[7];    assign stream_out_r8  = outputs_r[8];    assign stream_out_r9  =  outputs_r[9];     
assign  stream_out_r10 = outputs_r[10];   assign  stream_out_r11= outputs_r[11];   assign stream_out_r12 = outputs_r[12];   assign stream_out_r13 = outputs_r[13];   assign stream_out_r14 = outputs_r[14];      
assign  stream_out_r15 = outputs_r[15];   assign  stream_out_r16= outputs_r[16];   assign stream_out_r17 = outputs_r[17];   assign stream_out_r18 = outputs_r[18];   assign stream_out_r19 = outputs_r[19];      
assign  stream_out_r20 = outputs_r[20];   assign  stream_out_r21= outputs_r[21];   assign stream_out_r22 = outputs_r[22];   assign stream_out_r23 = outputs_r[23];   assign stream_out_r24 = outputs_r[24];      
assign  stream_out_r25 = outputs_r[25];   assign  stream_out_r26= outputs_r[26];   assign stream_out_r27 = outputs_r[27];   assign stream_out_r28 = outputs_r[28];   assign stream_out_r29 = outputs_r[29];      
assign  stream_out_r30 = outputs_r[30];   assign  stream_out_r31= outputs_r[31];

assign stream_out_i0  = outputs_i[0];    assign stream_out_i1  = outputs_i[1];    assign stream_out_i2  = outputs_i[2];    assign stream_out_i3  = outputs_i[3];    assign stream_out_i4  = outputs_i[4];     
assign stream_out_i5  = outputs_i[5];    assign stream_out_i6  = outputs_i[6];    assign stream_out_i7  = outputs_i[7];    assign stream_out_i8  = outputs_i[8];    assign stream_out_i9  = outputs_i[9];     
assign stream_out_i10 = outputs_i[10];   assign stream_out_i11 = outputs_i[11];   assign stream_out_i12 = outputs_i[12];   assign stream_out_i13 = outputs_i[13];   assign stream_out_i14 = outputs_i[14];      
assign stream_out_i15 = outputs_i[15];   assign stream_out_i16 = outputs_i[16];   assign stream_out_i17 = outputs_i[17];   assign stream_out_i18 = outputs_i[18];   assign stream_out_i19 = outputs_i[19];      
assign stream_out_i20 = outputs_i[20];   assign stream_out_i21 = outputs_i[21];   assign stream_out_i22 = outputs_i[22];   assign stream_out_i23 = outputs_i[23];   assign stream_out_i24 = outputs_i[24];      
assign stream_out_i25 = outputs_i[25];   assign stream_out_i26 = outputs_i[26];   assign stream_out_i27 = outputs_i[27];   assign stream_out_i28 = outputs_i[28];   assign stream_out_i29 = outputs_i[29];      
assign stream_out_i30 = outputs_i[30];   assign stream_out_i31 = outputs_i[31];


//----------------Twiddle factor--------------//
/*
    Twiddle_Factor  #(.LOG2_NFFT(LOG2_NFFT), .DATA_WIDTH(DATA_WIDTH))
                    TF (    .address(TF_address),
                            .data_real(TF_data_real),
                            .data_imag(TF_data_imag));
*/
initial
begin
    $readmemb("W_real_32.txt",TF_data_real);
    $readmemb("W_imag_32.txt",TF_data_imag);
end 

// ---------------First stage-----------------//
genvar i;
generate
for(i=0;i<NFFT_POINTS/2;i=i+1)
begin
Butterfly #(.DATA_WIDTH(DATA_WIDTH)) BF1 ( .clk(clk), .rst(rst), 
                                            .in1_r(inputs_r[2*i]), .in1_i(inputs_i[2*i]), .in2_r(inputs_r[2*i+1]), .in2_i(inputs_i[2*i+1]), 
                                            .w_r(TF_data_real[0]), .w_i(TF_data_imag[0]), 
                                            .out1_r(BF1_out_r[2*i]), .out1_i(BF1_out_i[2*i]), .out2_r(BF1_out_r[2*i+1]), .out2_i(BF1_out_i[2*i+1]));

end
endgenerate

// ---------------second stage-----------------//
generate
for(i=0;i<NFFT_POINTS;i=i+1)
begin
    if ((i%4)==0 || (i%4)==1) begin
        Butterfly #(.DATA_WIDTH(DATA_WIDTH)) BF2 ( .clk(clk), .rst(rst), 
                                            .in1_r(BF1_out_r[i]), .in1_i(BF1_out_i[i]), .in2_r(BF1_out_r[i+2]), .in2_i(BF1_out_i[i+2]), 
                                            .w_r(TF_data_real[(i%4)*8]), .w_i(TF_data_imag[(i%4)*8]), 
                                            .out1_r(BF2_out_r[i]), .out1_i(BF2_out_i[i]), .out2_r(BF2_out_r[i+2]), .out2_i(BF2_out_i[i+2]));
    end
end
endgenerate

// ---------------Third stage-----------------//
generate
for(i=0;i<NFFT_POINTS;i=i+1)
begin
    if ((i%8)==0 || (i%8)==1 || (i%8)==2 || (i%8)==3) begin
        Butterfly #(.DATA_WIDTH(DATA_WIDTH)) BF3 ( .clk(clk), .rst(rst), 
                                            .in1_r(BF2_out_r[i]), .in1_i(BF2_out_i[i]), .in2_r(BF2_out_r[i+4]), .in2_i(BF2_out_i[i+4]), 
                                            .w_r(TF_data_real[(i%8)*4]), .w_i(TF_data_imag[(i%8)*4]), 
                                            .out1_r(BF3_out_r[i]), .out1_i(BF3_out_i[i]), .out2_r(BF3_out_r[i+4]), .out2_i(BF3_out_i[i+4]));
    end
end
endgenerate

// ---------------Fourth stage-----------------//
generate
for(i=0;i<NFFT_POINTS;i=i+1)
begin
    if ((i%16)==0 || (i%16)==1 || (i%16)==2 || (i%16)==3 || (i%16)==4 || (i%16)==5 || (i%16)==6 || (i%16)==7) begin
        Butterfly #(.DATA_WIDTH(DATA_WIDTH)) BF4 ( .clk(clk), .rst(rst), 
                                            .in1_r(BF3_out_r[i]), .in1_i(BF3_out_i[i]), .in2_r(BF3_out_r[i+8]), .in2_i(BF3_out_i[i+8]), 
                                            .w_r(TF_data_real[(i%16)*2]), .w_i(TF_data_imag[(i%16)*2]), 
                                            .out1_r(BF4_out_r[i]), .out1_i(BF4_out_i[i]), .out2_r(BF4_out_r[i+8]), .out2_i(BF4_out_i[i+8]));
    end
end
endgenerate

// ---------------Fifith stage-----------------//
generate
for(i=0;i<NFFT_POINTS/2;i=i+1)
begin
        Butterfly #(.DATA_WIDTH(DATA_WIDTH)) BF5 ( .clk(clk), .rst(rst), 
                                            .in1_r(BF4_out_r[i]), .in1_i(BF4_out_i[i]), .in2_r(BF4_out_r[i+16]), .in2_i(BF4_out_i[i+16]), 
                                            .w_r(TF_data_real[i]), .w_i(TF_data_imag[i]), 
                                            .out1_r(outputs_r[i]), .out1_i(outputs_i[i]), .out2_r(outputs_r[i+16]), .out2_i(outputs_i[i+16]));
end
endgenerate
endmodule