`timescale 1ns / 1ps

module seven_segment(
    input clk,
    input [15:0] data_in,
    output reg [6:0] seg_o,      
    output reg [3:0] anodes_o      
    );
    
    parameter clkfreq	= 100_000_000;
    parameter  c_timer1ms = clkfreq/1000;
    
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter A     = 7'b000_1000;  // A
    parameter B     = 7'b110_0000;  // B
    parameter C     = 7'b011_0001;  // C
    parameter D     = 7'b100_0010;  // D
    parameter E     = 7'b011_0000;  // E
    parameter F     = 7'b011_1000;  // F
    
    logic [3:0] anodes = 4'b1110;
        
    logic [7:0] seg [3:0];
    
    
    integer timer1ms = 0;
    
    always @*
    begin
        case(data_in[3:0])
            4'b0000 : seg[0] = ZERO;
            4'b0001 : seg[0] = ONE;
            4'b0010 : seg[0] = TWO;
            4'b0011 : seg[0] = THREE;
            4'b0100 : seg[0] = FOUR;
            4'b0101 : seg[0] = FIVE;
            4'b0110 : seg[0] = SIX;
            4'b0111 : seg[0] = SEVEN;
            4'b1000 : seg[0] = EIGHT;
            4'b1001 : seg[0] = NINE;
            4'b1010 : seg[0] = A;
            4'b1011 : seg[0] = B;
            4'b1100 : seg[0] = C;
            4'b1101 : seg[0] = D;
            4'b1110 : seg[0] = E;
            4'b1111 : seg[0] = F;        
        endcase
    end
    
    always @*
    begin
        case(data_in[7:4])
            4'b0000 : seg[1] = ZERO;
            4'b0001 : seg[1] = ONE;
            4'b0010 : seg[1] = TWO;
            4'b0011 : seg[1] = THREE;
            4'b0100 : seg[1] = FOUR;
            4'b0101 : seg[1] = FIVE;
            4'b0110 : seg[1] = SIX;
            4'b0111 : seg[1] = SEVEN;
            4'b1000 : seg[1] = EIGHT;
            4'b1001 : seg[1] = NINE;
            4'b1010 : seg[1] = A;
            4'b1011 : seg[1] = B;
            4'b1100 : seg[1] = C;
            4'b1101 : seg[1] = D;
            4'b1110 : seg[1] = E;
            4'b1111 : seg[1] = F;        
        endcase
    end
    
    always @*
    begin
        case(data_in[11:8])
            4'b0000 : seg[2] = ZERO;
            4'b0001 : seg[2] = ONE;
            4'b0010 : seg[2] = TWO;
            4'b0011 : seg[2] = THREE;
            4'b0100 : seg[2] = FOUR;
            4'b0101 : seg[2] = FIVE;
            4'b0110 : seg[2] = SIX;
            4'b0111 : seg[2] = SEVEN;
            4'b1000 : seg[2] = EIGHT;
            4'b1001 : seg[2] = NINE;
            4'b1010 : seg[2] = A;
            4'b1011 : seg[2] = B;
            4'b1100 : seg[2] = C;
            4'b1101 : seg[2] = D;
            4'b1110 : seg[2] = E;
            4'b1111 : seg[2] = F;        
        endcase
    end
 
    always @*
    begin
        case(data_in[15:12])
            4'b0000 : seg[3] = ZERO;
            4'b0001 : seg[3] = ONE;
            4'b0010 : seg[3] = TWO;
            4'b0011 : seg[3] = THREE;
            4'b0100 : seg[3] = FOUR;
            4'b0101 : seg[3] = FIVE;
            4'b0110 : seg[3] = SIX;
            4'b0111 : seg[3] = SEVEN;
            4'b1000 : seg[3] = EIGHT;
            4'b1001 : seg[3] = NINE;
            4'b1010 : seg[3] = A;
            4'b1011 : seg[3] = B;
            4'b1100 : seg[3] = C;
            4'b1101 : seg[3] = D;
            4'b1110 : seg[3] = E;
            4'b1111 : seg[3] = F;        
        endcase
     end 
        
    always_ff @(posedge clk) begin
        if (anodes[0] == 1'b0) begin
            seg_o <= seg[0];
        end else if (anodes[1] == 1'b0) begin
            seg_o <= seg[1];
        end else if (anodes[2] == 1'b0) begin
            seg_o <= seg[2];
        end else if (anodes[3] == 1'b0) begin
            seg_o <= seg[3];
        end else begin
            seg_o <= 7'b1111111; 
        end
    end
    
    always_ff @(posedge clk) begin
    if (timer1ms == c_timer1ms-1) begin
        timer1ms <= 0;
        anodes[3:1] <= anodes[2:0];
        anodes[0] <= anodes[3];
    end else begin
        timer1ms <= timer1ms + 1;
    end
    end
    assign anodes_o = anodes;
endmodule