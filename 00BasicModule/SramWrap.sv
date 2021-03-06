module SramWrap #(
        parameter BITS   = 32 ,
        WORDS  = 36 ,
        ADRESS_WIDTH = 5,
        FILE = "file.sv")
        (//input
        clk,
        adress,
        cen,
        wen,
        din,
        mask,
        //output
        dout
        );
  input       clk;
  input       cen;
  input       wen;
  input   [ADRESS_WIDTH - 1 : 0]  adress; 
  input   [BITS - 1 : 0]       din;
  input   [BITS - 1 : 0]       mask;
  
  output  [BITS - 1 : 0]       dout;
  reg     [BITS - 1 : 0]       dout;
  
  reg     [BITS - 1 : 0]       mem[WORDS - 1 : 0];
  
  wire    read_en;
  wire    write_en;
  
  
  //read_event
  assign read_en = cen & (!wen) ; 
  always_ff @(posedge clk) begin
     if(read_en)
      dout <= mem[adress];
     else
      dout <= 'd0;
  end
  
  initial begin 
    $readmemh(FILE, mem);
  end
  
  integer i;
  assign write_en = cen & wen;
  always @(posedge clk) begin
    for(i = 0; i < BITS; i = i + 1) begin
      if(write_en)
        if(!mask[i])
          mem[adress][i] <= din[i];
        else
          mem[adress][i] <= mem[adress][i];
      else
        mem[adress][i] <= mem[adress][i];
    end
  end
  
  //assign write_en = cen & wen;
  //genvar i;
  //generate
  //  for(i = 0; i < BITS; i = i + 1) begin
  //    always_ff @(posedge clk)
  //      if(write_en)
  //        if(!mask[i])
  //          mem[adress][i] <= din[i];
  //        else
  //    mem[adress][i] <= mem[adress][i];
  //      else
  //        mem[adress][i] <= mem[adress][i];
  //  end
  //endgenerate

endmodule
