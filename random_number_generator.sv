module random_number_generator (
    input logic clk,
    input logic rst,
    input logic generate_num,
    output logic [7:0] random_number
);

    logic [7:0] seed = 8'b01011001;
    logic feedback;
    assign feedback = seed[7] ^ seed[5] ^ seed[4] ^ seed[3];
    
    always @(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            seed <= 8'b01011001;
        end
        else
        begin
            seed <= {seed[6:0], feedback};
        end
        
        if(generate_num && !rst)
        begin
            random_number <= seed;
        end
    end

endmodule

