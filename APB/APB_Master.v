module master #(parameter DATA=32,ADDR=32)(
  input wire pclk,
  input wire prstn,
  input wire prdy,
  input wire [DATA-1:0] prdata,
  input wire rw,
  input wire transfer,
  input wire [DATA-1:0] data_in,
  input wire [ADDR-1:0] addr_in,
  
  output reg psel,
  output reg penable,
  output reg pwrite,
  output reg [DATA-1:0] pwdata,
  output reg [ADDR-1:0] paddr
);
  reg [1:0] state,next_state;
  parameter IDLE=2'b00,
  			SETUP=2'b01,
  			ACCESS=2'b10;
  
  always @(posedge pclk or negedge prstn) begin
    if(!prstn) state<=IDLE;
    else state<=next_state;
  end
  always @(*) begin
    next_state=state;
    psel=0;
    penable=0;
    pwrite=0;
    pwdata=0;
    paddr=0;
    
    case(state)
      IDLE: begin
        next_state=(transfer)?SETUP:IDLE;
      end
      SETUP: begin
        next_state=ACCESS;
        psel=1;
        penable=0;
        pwrite=rw;
        pwdata=data_in;
        paddr=addr_in;
      end
      ACCESS: begin
        if(!prdy) next_state=ACCESS;
        else if(transfer) next_state=SETUP;
        else next_state=IDLE;
        psel=1;
        penable=1;
        pwrite=rw;
        pwdata=data_in;
        paddr=addr_in;
      end
      default: next_state=IDLE;
    endcase
  end
endmodule
        
        
  
