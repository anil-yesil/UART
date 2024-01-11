module debouncer(
    input wire inp,   
    input wire clk,     
    output reg outp  
);
    reg OP1, OP2, OP3;

    always @(posedge clk) begin
        OP1 <= inp;
        OP2 <= OP1;
        OP3 <= OP2;
    end

    assign outp = OP1 & OP2 & OP3;
endmodule
