module clock_divider #(parameter DIVISOR = 50000)
(
    input logic clk_in,
    input logic rst,
    output logic clk_out
    );
    
    logic [$clog2(DIVISOR) - 1:0] count = 0;
    
    always @(posedge clk_in)
    begin
        if(rst)
        begin
            count <= 0;
            clk_out <= 1'b0;
        end
        else if(count == DIVISOR - 1)
        begin
            count <= 0;
            clk_out <= ~clk_out;
        end
        else
        begin
            count <= count + 1;
        end
    end
    
endmodule
