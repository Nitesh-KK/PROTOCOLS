`include "Master.v"
`include "Slave.v"

module top #(parameter DATA=32,ADDR=32)(
  input wire pclk,
  input wire prstn,
  input wire rw,
  input wire transfer,
  input wire [DATA-1:0] data_in,
  input wire [ADDR-1:0] addr_in,
  output wire [DATA-1:0] prdata
);
  wire [DATA-1:0] pwdata;
  wire [ADDR-1:0] paddr;
  wire prdy,penable,psel;
  wire pwrite;
  
  master #(.DATA(DATA),.ADDR(ADDR)) mas(
    .pclk(pclk),
    .prstn(prstn),
    .prdy(prdy),
    .prdata(prdata),
    .rw(rw),
    .transfer(transfer),
    .data_in(data_in),
    .addr_in(addr_in),
    
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .paddr(paddr)
  );
  
  slave #(.DATA(DATA),.ADDR(ADDR)) slve(
    .pclk(pclk),
    .prstn(prstn),
    .penable(penable),
    .psel(psel),
    .pwrite(pwrite),
    .paddr(paddr),
    .pwdata(pwdata),
    .prdata(prdata),
    .prdy(prdy)
  );
endmodule
