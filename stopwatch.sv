module stopwatch (
    input logic clk,
    input logic rst,         
    input logic start_watch, 
    output logic [$clog2(10000)-1:0] elapsed_time 
);

    logic new_clk = 1'b0;
    clock_divider #(50000) clk_inst (
        .clk_in(clk),
        .rst(rst),
        .clk_out(new_clk)
    );
    
    always @(posedge new_clk)
    begin
        if(rst)
        begin
            elapsed_time <= 0;
        end
        else if (start_watch)
        begin
            elapsed_time <= elapsed_time + 1;
        end
    end

endmodule

