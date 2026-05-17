module fifo(input clk , input reset,
input write_en,
input read_en,
input [7:0]data_in,
output reg[7:0]data_out,
output reg fifofull,
output reg fifoempty);
reg [3:0]wptr,rptr;
reg [7:0]r[0:7];
integer i;
always@(posedge clk)// can use * instead of posedge but to avoid glitches in real hardware.
begin
if(rptr[3:0]==wptr[3:0])
begin
    fifoempty<=1;
    fifofull<=0;
end
else if(rptr[2:0]==wptr[2:0]&&rptr[3]!=wptr[3])
begin
    fifofull<=1;
    fifoempty<=0;
end
else begin
    fifoempty<=0;
    fifofull<=0;
end 
end
always @(posedge clk or posedge reset) begin
    if(reset)
    begin
    wptr<=4'd0;
    rptr<=4'd0;
     data_out <= 8'd0;
    begin for(i=0;i<8;i++)
    r[i]<=8'd0;end
    end
    else begin
        if(write_en&&!fifofull)
        begin
        r[wptr[2:0]]<=data_in;
        wptr<=wptr+4'd1;
        end
        if(read_en&&!fifoempty)
        begin
            data_out<=r[rptr[2:0]];
            rptr<=rptr+4'd1;
        end
    end
end
endmodule
