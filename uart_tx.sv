module uart_tx #
    (
        parameter integer clkfreq = 100_000_000,
        parameter integer baudrate = 115_200,
        parameter integer stopbit = 2
    )
    (
        input logic clk,
        input logic [7:0] din_i,
        input logic tx_start_i,
        output logic tx_o,
        output logic tx_done_o
    );
    
    typedef enum logic [1:0] {S_IDLE, S_START, S_DATA, S_STOP} states;
    states state = S_IDLE;
    
    localparam c_bittimerlim = clkfreq / baudrate;
    localparam  c_stopbitlim = (clkfreq / baudrate) * stopbit;
    
    logic [7:0] shift_reg = 0;
    logic [2:0] bitcntr = 0;
    logic [31:0] bittimer = 0;
    
    always_ff @(posedge clk) begin : state_machine
    case (state)
      S_IDLE: begin
        tx_o <= 1'b1;
        tx_done_o <= 1'b0;
        bitcntr <= 3'b000;
        
        if (tx_start_i) begin
          state <= S_START;
          tx_o <= 1'b0;
          shift_reg <= din_i;
        end
      end
      
      S_START: begin
        if (bittimer == c_bittimerlim - 1) begin
          state <= S_DATA;
          tx_o <= shift_reg[0];
          shift_reg[7] <= shift_reg[0];
          shift_reg[6:0] <= shift_reg[7:1];
          bittimer <= 0;
        end else begin
          bittimer <= bittimer + 1;
        end
      end
      
      S_DATA: begin
        if (bitcntr == 3'b111) begin
          if (bittimer == c_bittimerlim - 1) begin
            bitcntr <= 3'b000;
            state <= S_STOP;
            tx_o <= 1'b1;
            bittimer <= 0;
          end else begin
            bittimer <= bittimer + 1;
          end
        end else begin
          if (bittimer == c_bittimerlim - 1) begin
            shift_reg[7] <= shift_reg[0];
            shift_reg[6:0] <= shift_reg[7:1];
            tx_o <= shift_reg[0];
            bitcntr <= bitcntr + 1;
            bittimer <= 0;
          end else begin
            bittimer <= bittimer + 1;
          end
        end
      end
      
      S_STOP: begin
        if (bittimer == c_stopbitlim - 1) begin
          state <= S_IDLE;
          tx_done_o <= 1'b1;
          bittimer <= 0;
        end else begin
          bittimer <= bittimer + 1;
        end
      end
      
    endcase
    end
    
endmodule
