module slave #(parameter DATA=32,ADDR=32)(
  input wire pclk,
  input wire prstn,
  input wire penable,
  input wire psel,
  input wire pwrite,
  input wire [ADDR-1:0] paddr,
  input wire [DATA-1:0] pwdata,
  
  output reg [DATA-1:0] prdata,
  output reg prdy
);
  reg [DATA-1:0] mem [0:255];
  always @(posedge pclk or negedge prstn) begin
    if(!prstn) begin
      prdata<=0;
      prdy<=0;
    end
    else begin
      if(psel && penable) begin
        prdy<=1;
        if(pwrite)
          mem[paddr]<=pwdata;
        else
          prdata<=mem[paddr];
      end
      else prdy<=0;
    end
  end
endmodule
