module uart_rx #
  (
    parameter integer clkfreq = 100_000_000,
    parameter integer baudrate = 115_200
  )
  (
    input logic clk,
    input logic rx_i,
    output logic [7:0] dout_o,
    output logic rx_done_o
  );
  
  localparam integer c_bittimerlim = clkfreq / baudrate;
  
  typedef enum logic [1:0] {S_IDLE, S_START, S_DATA, S_STOP} states;
  states state = S_IDLE;
  
  logic [2:0] bitcntr = 0;
  logic [7:0] shift_reg = 0 ;
  logic [31:0] bittimer = 0;
  
  always_ff @(posedge clk) begin : state_machine
    case (state)
      S_IDLE: begin
        rx_done_o <= 1'b0;
        bittimer <= 0;
        
        if (!rx_i) begin
          state <= S_START;
        end
      end
      
      S_START: begin
        if (bittimer == c_bittimerlim/2 - 1) begin
          state <= S_DATA;
          bittimer <= 0;
        end else begin
          bittimer <= bittimer + 1;
        end
      end
      
      S_DATA: begin
        if (bittimer == c_bittimerlim - 1) begin
          if (bitcntr == 3'b111) begin
            state <= S_STOP;
            bitcntr <= 3'b000;
          end else begin
            bitcntr <= bitcntr + 1;
          end
          shift_reg <= {rx_i, shift_reg[7:1]};
          bittimer <= 0;
        end else begin
          bittimer <= bittimer + 1;
        end
      end
      
      S_STOP: begin
        if (bittimer == c_bittimerlim - 1) begin
          state <= S_IDLE;
          bittimer <= 0;
          rx_done_o <= 1'b1;
        end else begin
          bittimer <= bittimer + 1;
        end
      end
    endcase
  end
    
  assign dout_o = shift_reg;
  
endmodule
