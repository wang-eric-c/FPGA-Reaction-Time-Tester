//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 07:12:59 PM
// Design Name: 
// Module Name: lab_2_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab_2_top(
        input logic clk,
        input logic rst,
        input logic button,
        
        output logic led,
        output logic [6:0] digit,
        output logic [3:0] an
    );
    
    logic [6:0] segments [3:0] = '{default: 7'b0000000};
    
    logic [7:0] counter = 8'b0;
    logic [7:0] random_number = 8'b0;
    
    logic start_watch = 1'b0;
    logic [$clog2(10000)-1:0] elapsed_time = 0;
    
    localparam RESET = 2'b00;
    localparam SET = 2'b01;
    localparam GO = 2'b10;
    localparam SCORE = 2'b11;
    
    logic [1:0] state = RESET;
    
    stopwatch stopwatch_inst(
        .clk(clk),
        .rst(rst),
        .start_watch(start_watch),
        .elapsed_time(elapsed_time)
    );
    
    random_number_generator RNG_inst (
        .clk(clk),
        .rst(rst),
        .generate_num(button),
        .random_number(random_number)
    );
    
    binary_to_ssd bts_inst (
        .binary_in(elapsed_time),
        .display_out(segments)
    );
    
    ssd_display sd_inst (
        .clk(clk), 
        .rst(rst), 
        .ssd_in(segments), 
        .an(an), 
        .seg(digit) 
    );
    
    always @(posedge clk)
    begin
        if(rst == 1'b1)
        begin
            state       <= RESET;
            start_watch <= 1'b0;
            led         <= 1'b0;
            counter     <= 8'b0;
        end
        else
        begin
            case(state)
            RESET:
            begin
                if(button)
                begin
                    state <= SET;
                end
            end
            SET:
            begin
                if(counter == random_number)
                begin
                    counter <= 0;
                    state <= GO;
                end
                else
                begin
                    counter <= counter + 1;
                end
            end
            GO:
            begin
                start_watch <= 1'b1;
                led <= 1'b1;
                if(button)
                begin
                    state <= SCORE;
                end
            end
            SCORE:
            begin
                start_watch <= 1'b0;  
                led <= 1'b0;
            end
            endcase
        end
        
    end

    
    
endmodule
