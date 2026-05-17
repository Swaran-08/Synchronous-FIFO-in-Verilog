module fifo_tb;

reg clk;
reg reset;
reg write_en;
reg read_en;
reg [7:0] data_in;

wire [7:0] data_out;
wire fifofull;
wire fifoempty;

fifo DUT (
    .clk(clk),
    .reset(reset),
    .write_en(write_en),
    .read_en(read_en),
    .data_in(data_in),
    .data_out(data_out),
    .fifofull(fifofull),
    .fifoempty(fifoempty)
);

reg [7:0] expected_data [0:7];

integer i;
integer write_ptr;
integer read_ptr;

always #5 clk = ~clk;

initial begin

    $dumpfile("fifo.vcd");
    $dumpvars(0,fifo_tb);

    clk = 0;
    reset = 1;
    write_en = 0;
    read_en = 0;
    data_in = 0;

    write_ptr = 0;
    read_ptr  = 0;

    #15;
    reset = 0;

    // write operation

    for(i=0;i<8;i=i+1)
    begin
        @(posedge clk);

        if(!fifofull)
        begin
            write_en = 1;
            data_in = i + 20;

            expected_data[write_ptr] = data_in;
            write_ptr = (write_ptr + 1) % 8;
        end
    end

    @(posedge clk);
    write_en = 0;

    // checking full condition

    @(posedge clk);

    if(fifofull)
        $display("FIFO FULL DETECTED");
    else
        $display("FULL CONDITION FAILED");

    // overflow condition

    @(posedge clk);

    write_en = 1;
    data_in = 8'hFF;

    @(posedge clk);

    write_en = 0;

    // read operation

    for(i=0;i<8;i=i+1)
    begin
        @(posedge clk);

        if(!fifoempty)
        begin
            read_en = 1;

            @(posedge clk);

            if(data_out == expected_data[read_ptr])
                $display("DATA MATCHED : %0d",data_out);
            else
                $display("DATA ERROR Expected=%0d Got=%0d",
                          expected_data[read_ptr],data_out);

            read_ptr = (read_ptr + 1) % 8;
        end

        read_en = 0;
    end

    // empty condition

    @(posedge clk);

    if(fifoempty)
        $display("FIFO EMPTY DETECTED");
    else
        $display("EMPTY CONDITION FAILED");

    // underflow test

    @(posedge clk);

    read_en = 1;

    @(posedge clk);

    read_en = 0;

    // simultaneous read and write

    @(posedge clk);

    write_en = 1;
    read_en  = 1;
    data_in  = 8'hAA;

    @(posedge clk);

    write_en = 0;
    read_en  = 0;

    #30;

    $display("SIMULATION COMPLETED");

    $finish;

end

always @(posedge clk)
begin
    $display("TIME=%0t WRITE=%b READ=%b DIN=%0d DOUT=%0d FULL=%b EMPTY=%b",
              $time,write_en,read_en,data_in,data_out,fifofull,fifoempty);
end

endmodule
