`timescale 1ns / 1ps

module top #
  (
    parameter integer clkfreq = 100_000_000,
    parameter integer baudrate = 115_200,
    parameter integer stopbit = 2
  )
  (
    input logic clk,
    input logic [7:0] sw_i,
    input logic [4:0] btn_i,
    input logic rx_in,
    input logic auto_transfer,
    output logic [7:0] led_o,
    output logic [3:0] anodes_o,
    output logic [6:0] seg_o,
    output logic [1:0] status_led_o,
    output logic tx_out,
    output logic tx_or_rx //indicates which memory displayed(TX or RX)
  );
    
    logic [7:0] tx_data_i = 0;
    logic [7:0] rx_data_o;
    
    logic [15:0] seven_segment_in;
    logic [15:0] seven_segment_reg = 0;
    
    logic btnC, btnU, btnL, btnR, btnD;
    logic btnC_reg,btnC_reg2,btnC_reg3,btnC_reg4;
    
    assign btnC = btn_i[0];
    assign btnU = btn_i[1];
    assign btnL = btn_i[2];
    assign btnR = btn_i[3];
    assign btnD = btn_i[4];
    
    logic tx_start = '0;
    logic tx_done;
    integer tx_counter = 0;
     
    logic rx_done;
    
    logic seg_index = '1;
    logic tx_or_rx_s = '0;
    
    logic btnC_deb, btnD_deb, btnU_deb, btnL_deb, btnR_deb;
    logic btnC_deb_next, btnD_deb_next, btnU_deb_next, btnL_deb_next, btnR_deb_next;
    
    logic rst = '0; 

    reg [7:0] txbuf [3:0] = {0,0,0,0};
    reg [7:0] rxbuf [3:0] = {0,0,0,0};
    reg [7:0] sw_next;
    reg [7:0] sw_reg;
    
    logic rx_i;
    logic tx_o;
       
    assign tx_out = tx_o;
    
    assign sw_next = sw_i;
    assign rx_i = rx_in;
        
    always @(posedge clk) begin
    
        btnC_reg2 <= btnC_reg;
        btnC_reg3 <= btnC_reg2;
        btnC_reg4 <= btnC_reg3;
    
        btnL_deb_next <= btnL_deb;
        btnD_deb_next <= btnD_deb;
        btnC_deb_next <= btnC_deb;
        btnR_deb_next <= btnR_deb;
        btnU_deb_next <= btnU_deb;
        
        led_o[7:0] <= 0;
        btnC_reg <= '0;
        tx_start <= btnC_deb & (!btnC_deb_next);
        
        if((btnL_deb & !btnL_deb_next) || (btnR_deb & !btnR_deb_next)) 
            seg_index = ~seg_index;
            
        if (btnD_deb & !btnD_deb_next) begin
            led_o[7:0] <= sw_i;            
            sw_reg <= sw_next;
            txbuf[3] <= sw_i[7:0];
            txbuf[2] <= txbuf[3];
            txbuf[1] <= txbuf[2];
            txbuf[0] <= txbuf[1];                        
        end else begin
            led_o[7:0] <= sw_reg;
        end
        
        if(!auto_transfer)  begin                        
            if (btnC_deb & !btnC_deb_next) begin
                tx_start <= 1;
                txbuf[3] <= 0; 
                txbuf[2] <= txbuf[3];
                txbuf[1] <= txbuf[2];
                txbuf[0] <= txbuf[1]; 
                tx_data_i <= txbuf[0];   
           end    
            if(rx_done) begin
                rxbuf[3] <= rx_data_o;
                rxbuf[2] <= rxbuf[3];
                rxbuf[1] <= rxbuf[2];
                rxbuf[0] <= rxbuf[1];                  
            end
            
        end else begin
            if (btnC_deb & !btnC_deb_next) begin
                btnC_reg <= '1;
            end
            if(btnC_deb & !btnC_deb_next) begin
                tx_start <= 1; 
                txbuf[3] <= 0; 
                txbuf[2] <= txbuf[3];
                txbuf[1] <= txbuf[2];
                txbuf[0] <= txbuf[1]; 
                tx_data_i <= txbuf[0]; 
                tx_counter = tx_counter + 1;     
            end
                  
            if(tx_done & (tx_counter != 4) & (tx_counter != 0)) begin 
                tx_start <= 1; 
                txbuf[3] <= 0; 
                txbuf[2] <= txbuf[3];
                txbuf[1] <= txbuf[2];
                txbuf[0] <= txbuf[1]; 
                tx_data_i <= txbuf[0]; 
                tx_counter = tx_counter + 1;   
                if(tx_counter == 4) begin 
                    tx_counter = 0;    
                end           
            end    
            
            if(rx_done) begin
                rxbuf[3] <= rx_data_o;
                rxbuf[2] <= rxbuf[3];
                rxbuf[1] <= rxbuf[2];
                rxbuf[0] <= rxbuf[1];                  
            end
        end 
        
        if ((btnL_deb & !btnL_deb_next) || (btnR_deb & !btnR_deb_next)) begin
            if (seg_index) begin
                if(!tx_or_rx_s)
                    seven_segment_reg <= {txbuf[3], txbuf[2]};
                else
                    seven_segment_reg <= {rxbuf[3], rxbuf[2]};
            end else begin
                if(!tx_or_rx_s)
                    seven_segment_reg <= {txbuf[1], txbuf[0]};
                else
                    seven_segment_reg <= {rxbuf[1], rxbuf[0]};
            end
        end else begin
            if (seg_index) 
                if(!tx_or_rx_s)
                    seven_segment_reg <= {txbuf[3], txbuf[2]};
                else
                    seven_segment_reg <= {rxbuf[3], rxbuf[2]};
            else 
                if(!tx_or_rx_s)
                    seven_segment_reg <= {txbuf[1], txbuf[0]};
                else
                    seven_segment_reg <= {rxbuf[1], rxbuf[0]};
        end       
           
        if(btnU_deb & !btnU_deb_next) begin
            tx_or_rx_s <= ~tx_or_rx_s;
        end  
           
        if (!seg_index) 
            status_led_o <= 2'b10;
        else
            status_led_o <= 2'b01;                                                      
    end 
    
    assign tx_or_rx = tx_or_rx_s;    
    assign seven_segment_in = seven_segment_reg;  
    
    seven_segment s1 (
        .data_in(seven_segment_in), 
        .clk(clk),         
        .seg_o(seg_o),    
        .anodes_o(anodes_o)    
    );
    
    uart_tx #(
        .clkfreq(clkfreq),	
        .baudrate(baudrate),	
        .stopbit(stopbit)
    ) uart_tx_inst (
        .clk(clk),
        .din_i(tx_data_i),
        .tx_start_i(tx_start),
        .tx_o(tx_o),
        .tx_done_o(tx_done)
    );
    
    uart_rx #(
        .clkfreq(clkfreq),	
        .baudrate(baudrate)
    ) uart_rx_inst (
        .clk(clk),
        .rx_i(rx_i),
        .dout_o(rx_data_o),
        .rx_done_o(rx_done)
    );
    
    debouncer deb1(
        .clk(clk),
        .inp(btnL),
        .outp(btnL_deb)
    );
    
    debouncer deb2(
        .clk(clk),
        .inp(btnR),
        .outp(btnR_deb)
    );
    
    debouncer deb3(
        .clk(clk),
        .inp(btnC),
        .outp(btnC_deb)
    );  

    debouncer deb4(
        .clk(clk),
        .inp(btnD),
        .outp(btnD_deb)
    );
    
    debouncer deb5(
        .clk(clk),
        .inp(btnU),
        .outp(btnU_deb)
    );     
    
      
endmodule
