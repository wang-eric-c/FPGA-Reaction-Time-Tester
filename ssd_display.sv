module ssd_display(
    input logic clk, 
    input logic rst, 
    input logic [6:0] ssd_in [3:0], 
    output logic [3:0] an, 
    output logic [6:0] seg 
);

    logic new_clk = 1'b0;
    clock_divider #(50000) clk_inst (
        .clk_in(clk),
        .rst(rst),
        .clk_out(new_clk)
    );
    
    logic [1:0] state= 2'b00; 
    localparam [1:0] UNITS = 2'b00;
    localparam [1:0] TENS = 2'b01;
    localparam [1:0] HUNDREDS = 2'b10;
    localparam [1:0] THOUSANDS = 2'b11;
    
    logic [6:0] temp [3:0] = '{default: 7'b0000000};
     
    always @(posedge new_clk)
    begin
        if(rst == 1'b1)
        begin
            state <= UNITS;
            temp <= '{default: 7'b0000000};
            an <= 4'b1111;
        end
        else
        begin
            case(state)
            UNITS:
            begin
                state <= TENS;
                an <= 4'b1110;
                seg <= ssd_in[0];
                temp <= ssd_in;
            end
            TENS:
            begin
                state <= HUNDREDS;
                an <= 4'b1101;
                seg <= temp[1];
            end
            HUNDREDS:
            begin
                state <= THOUSANDS;
                an <= 4'b1011;
                seg <= temp[2];
            end
            THOUSANDS:
            begin
                state <= UNITS;
                an <= 4'b0111;
                seg <= temp[3];
            end
            endcase
        end
    end

endmodule