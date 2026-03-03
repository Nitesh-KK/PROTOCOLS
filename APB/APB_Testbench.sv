module apb_tb;
  parameter DATA=32;
  parameter ADDR=32;
  
  reg pclk;
  reg prstn;
  reg rw;
  reg transfer;
  reg [DATA-1:0] data_in;
  reg [ADDR-1:0] addr_in;
  wire [DATA-1:0] prdata;
  
  top #(.DATA(DATA),.ADDR(ADDR)) dut(
    .pclk(pclk),
    .prstn(prstn),
    .rw(rw),
    .transfer(transfer),
    .data_in(data_in),
    .addr_in(addr_in),
    .prdata(prdata)
  );
  initial pclk=0;
  always #2 pclk=~pclk;
  initial begin
    $dumpfile("APB_waves.vcd");
    $dumpvars;
    
    prstn=0;
    rw=0;
    transfer=0;
    data_in=0;
    addr_in=0;
    #20 prstn=1;
    
    write(8'hFA,32'hEEEE);
    write(8'hBA,32'h9999);
    write(8'hAC,32'hCCCC);
    write(8'hCE,32'h5555);
    
    read(8'hFA);
    read(8'hBA);
    read(8'hAC);
    read(8'hCE);
    
    #40 $finish;
  end
  
  task write([ADDR-1:0] addr,[DATA-1:0] data);
    begin
      @(posedge pclk);
      rw=1;
      transfer=1;
      data_in=data;
      addr_in=addr;
      
      @(posedge pclk);
      transfer=0;
      repeat(3) @(posedge pclk);
      $display("-----Write-----");
      $display("Address=%0h Data=%0h",addr,data);
    end
  endtask
  
  task read([ADDR-1:0] addr);
    begin
      @(posedge pclk);
      rw=0;
      transfer=1;
      addr_in=addr;
      
      @(posedge pclk);
      transfer=0;
      repeat(3) @(posedge pclk);
      $display("-----Read-----");
      $display("Address=%0h Data=%0h",addr,prdata);
    end
  endtask
endmodule
      
