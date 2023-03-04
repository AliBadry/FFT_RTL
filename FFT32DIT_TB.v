`timescale 1ns/1ps
module FFT32DIT_TB #(
    parameter    DATA_WIDTH = 32, 
                    LOG2_NFFT = 5,   //log2(NFFT)    
                    NFFT_POINTS = 2**LOG2_NFFT // Number of FFT points used
) ();
    
    reg              clk; 
    reg              rst;
    reg  [DATA_WIDTH-1:0] stream_in_r   [0:NFFT_POINTS-1];
    reg  [DATA_WIDTH-1:0] stream_in_i   [0:NFFT_POINTS-1];
    wire [DATA_WIDTH-1:0] stream_out_r  [0:NFFT_POINTS-1];
    wire [DATA_WIDTH-1:0] stream_out_i  [0:NFFT_POINTS-1];
    reg [NFFT_POINTS:0] i;

    reg [DATA_WIDTH-1:0] stage1_real [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage1_imag [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage2_real [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage2_imag [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage3_real [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage3_imag [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage4_real [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage4_imag [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage5_real [0:NFFT_POINTS-1];
    reg [DATA_WIDTH-1:0] stage5_imag [0:NFFT_POINTS-1];
    initial
    begin
        $readmemb("stage1_real.txt",stage1_real);
        $readmemb("stage1_imag.txt",stage1_imag);
        $readmemb("stage2_real.txt",stage2_real);
        $readmemb("stage2_imag.txt",stage2_imag);
        $readmemb("stage3_real.txt",stage3_real);
        $readmemb("stage3_imag.txt",stage3_imag);
        $readmemb("stage4_real.txt",stage4_real);
        $readmemb("stage4_imag.txt",stage4_imag);
        $readmemb("stage5_real.txt",stage5_real);
        $readmemb("stage5_imag.txt",stage5_imag);
    end

initial begin
    clk = 0;
    rst = 1;

    #12
    rst = 0;
    #5
    rst = 1;
    #20
    for ( i=0;i< NFFT_POINTS; i=i+1) begin
        stream_in_r[i] = {i[15:0],{16{1'b0}}};
        stream_in_i[i] = 0;
    end

    #1000
//-------------------------------------------------------------//
//-----------------checking the output of stage 1--------------//
//-------------------------------------------------------------//
    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF1_out_r[i] != stage1_real[i])
        begin
        $display("Error in BF1_out_r[%d] because reference = %b and verilog = %b",i , stage1_real[i], FFT32DIT_TB.DUT.BF1_out_r[i]);
        $stop;
        end
    end

    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF1_out_i[i] != stage1_imag[i])
        begin
        $display("Error in BF1_out_i[%d] because reference = %b and verilog = %b",i , stage1_imag[i], FFT32DIT_TB.DUT.BF1_out_i[i]);
        $stop;
        end
    end
    $display("stage 1 success!");
//-------------------------------------------------------------//
//-----------------checking the output of stage 2--------------//
//-------------------------------------------------------------//
    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF2_out_r[i] != stage2_real[i])
        begin
        $display("Error in BF2_out_r[%d] because reference = %b and verilog = %b",i , stage2_real[i], FFT32DIT_TB.DUT.BF2_out_r[i]);
        $stop;
        end
    end

    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF2_out_i[i] != stage2_imag[i])
        begin
        $display("Error in BF2_out_i[%d] because reference = %b and verilog = %b",i , stage2_imag[i], FFT32DIT_TB.DUT.BF2_out_i[i]);
        $stop;
        end
    end
    $display("stage 2 success!");
//--------------------------------------------------------------//
//-----------------checking the output of stage 3--------------//
//-------------------------------------------------------------//
    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF3_out_r[i] != stage3_real[i])
        begin
            
            if(stage3_real[i]>FFT32DIT_TB.DUT.BF3_out_r[i])
            begin
                $display("Error in BF3_out_r[%d] with difference = %d",i , stage3_real[i]- FFT32DIT_TB.DUT.BF3_out_r[i]);
            if (stage3_real[i]- FFT32DIT_TB.DUT.BF3_out_r[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in BF3_out_r[%d] with difference = %d",i ,  FFT32DIT_TB.DUT.BF3_out_r[i]-stage3_real[i]);
                if ( FFT32DIT_TB.DUT.BF3_out_r[i]-stage3_real[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end

    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF3_out_i[i] != stage3_imag[i])
        begin
            
            if(stage3_imag[i]>FFT32DIT_TB.DUT.BF3_out_i[i])
            begin
                $display("Error in BF3_out_i[%d] with difference = %d",i , stage3_imag[i]- FFT32DIT_TB.DUT.BF3_out_i[i]);
            if (stage3_imag[i]- FFT32DIT_TB.DUT.BF3_out_i[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in BF3_out_i[%d] with difference = %d",i ,  FFT32DIT_TB.DUT.BF3_out_i[i]-stage3_imag[i]);
                if ( FFT32DIT_TB.DUT.BF3_out_i[i]-stage3_imag[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end
    $display("stage 3 success!");
    
//--------------------------------------------------------------//
//-----------------checking the output of stage 4--------------//
//-------------------------------------------------------------//
    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF4_out_r[i] != stage4_real[i])
        begin
            
            if(stage4_real[i]>FFT32DIT_TB.DUT.BF4_out_r[i])
            begin
                $display("Error in BF4_out_r[%d] with difference = %d",i , stage4_real[i]- FFT32DIT_TB.DUT.BF4_out_r[i]);
            if (stage4_real[i]- FFT32DIT_TB.DUT.BF4_out_r[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in BF4_out_r[%d] with difference = %d",i ,  FFT32DIT_TB.DUT.BF4_out_r[i]-stage4_real[i]);
                if ( FFT32DIT_TB.DUT.BF4_out_r[i]-stage4_real[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end

    for (i =0 ; i<32; i=i+1) begin
        if(FFT32DIT_TB.DUT.BF4_out_i[i] != stage4_imag[i])
        begin
            
            if(stage4_imag[i]>FFT32DIT_TB.DUT.BF4_out_i[i])
            begin
                $display("Error in BF4_out_i[%d] with difference = %d",i , stage4_imag[i]- FFT32DIT_TB.DUT.BF4_out_i[i]);
            if (stage4_imag[i]- FFT32DIT_TB.DUT.BF4_out_i[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in BF4_out_i[%d] with difference = %d",i , FFT32DIT_TB.DUT.BF4_out_i[i]-stage4_imag[i]);
                if ( FFT32DIT_TB.DUT.BF4_out_i[i]-stage4_imag[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end
    $display("stage 4 success!");

//--------------------------------------------------------------//
//-----------------checking the output of stage 5--------------//
//-------------------------------------------------------------//
    for (i =0 ; i<32; i=i+1) begin
        if(stream_out_r[i] != stage5_real[i])
        begin
            
            if(stage5_real[i]>stream_out_r[i])
            begin
                $display("Error in stream_out_r[%d] with difference = %d",i , stage5_real[i]- stream_out_r[i]);
            if (stage5_real[i]- stream_out_r[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in stream_out_r[%d] with difference = %d",i ,  stream_out_r[i]-stage5_real[i]);
                if ( stream_out_r[i]-stage5_real[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end

    for (i =0 ; i<32; i=i+1) begin
        if(stream_out_i[i] != stage5_imag[i])
        begin
            
            if(stage5_imag[i]>stream_out_i[i])
            begin
                $display("Error in stream_out_i[%d] with difference = %d",i , stage5_imag[i]- stream_out_i[i]);
            if (stage5_imag[i]- stream_out_i[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
            else
            begin
                $display("Error in stream_out_i[%d] with difference = %d",i , stream_out_i[i]-stage5_imag[i]);
                if ( stream_out_i[i]-stage5_imag[i] > 17'b10000000000000000) // equivalent to 1.0
            begin
                $display("Critical error");
                $stop;
            end
            end
        end
    end
    $display("Final stage success! ........ CONGRATULATIONS ;)");
    $stop;

end

initial
begin
    forever #5 clk = !clk;    
end


FFT32DIT #(.DATA_WIDTH (DATA_WIDTH), .LOG2_NFFT(LOG2_NFFT), .NFFT_POINTS(NFFT_POINTS))
    DUT (clk,rst, 
        stream_in_r[0], stream_in_r[1], stream_in_r[2], stream_in_r[3], stream_in_r[4], stream_in_r[5], stream_in_r[6], stream_in_r[7], stream_in_r[8], stream_in_r[9], stream_in_r[10],
        stream_in_r[11], stream_in_r[12], stream_in_r[13], stream_in_r[14], stream_in_r[15], stream_in_r[16], stream_in_r[17], stream_in_r[18], stream_in_r[19],stream_in_r[20],
        stream_in_r[21], stream_in_r[22], stream_in_r[23], stream_in_r[24], stream_in_r[25], stream_in_r[26], stream_in_r[27], stream_in_r[28], stream_in_r[29],stream_in_r[30],
        stream_in_r[31],
        stream_in_i[0], stream_in_i[1], stream_in_i[2], stream_in_i[3], stream_in_i[4], stream_in_i[5], stream_in_i[6], stream_in_i[7], stream_in_i[8], stream_in_i[9], stream_in_i[10],
        stream_in_i[11], stream_in_i[12], stream_in_i[13], stream_in_i[14], stream_in_i[15], stream_in_i[16], stream_in_i[17], stream_in_i[18], stream_in_i[19],stream_in_i[20],
        stream_in_i[21], stream_in_i[22], stream_in_i[23], stream_in_i[24], stream_in_i[25], stream_in_i[26], stream_in_i[27], stream_in_i[28], stream_in_i[29],stream_in_i[30],
        stream_in_i[31],
        stream_out_r[0], stream_out_r[1], stream_out_r[2], stream_out_r[3], stream_out_r[4], stream_out_r[5], stream_out_r[6], stream_out_r[7], stream_out_r[8], stream_out_r[9], stream_out_r[10],
        stream_out_r[11], stream_out_r[12], stream_out_r[13], stream_out_r[14], stream_out_r[15], stream_out_r[16], stream_out_r[17], stream_out_r[18], stream_out_r[19],stream_out_r[20],
        stream_out_r[21], stream_out_r[22], stream_out_r[23], stream_out_r[24], stream_out_r[25], stream_out_r[26], stream_out_r[27], stream_out_r[28], stream_out_r[29],stream_out_r[30],
        stream_out_r[31],
        stream_out_i[0], stream_out_i[1], stream_out_i[2], stream_out_i[3], stream_out_i[4], stream_out_i[5], stream_out_i[6], stream_out_i[7], stream_out_i[8], stream_out_i[9], stream_out_i[10],
        stream_out_i[11], stream_out_i[12], stream_out_i[13], stream_out_i[14], stream_out_i[15], stream_out_i[16], stream_out_i[17], stream_out_i[18], stream_out_i[19],stream_out_i[20],
        stream_out_i[21], stream_out_i[22], stream_out_i[23], stream_out_i[24], stream_out_i[25], stream_out_i[26], stream_out_i[27], stream_out_i[28], stream_out_i[29],stream_out_i[30], stream_out_i[31]
        );
endmodule
