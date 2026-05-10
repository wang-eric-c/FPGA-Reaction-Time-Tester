module seven_segment_digit (
    input logic [3:0] digit,
    output logic [6:0] display_bits
);

    always @(*) begin
        case(digit)
            4'b0000: display_bits = 7'b0000001; // 0
            4'b0001: display_bits = 7'b1001111; // 1
            4'b0010: display_bits = 7'b0010010; // 2
            4'b0011: display_bits = 7'b0000110; // 3
            4'b0100: display_bits = 7'b1001100; // 4
            4'b0101: display_bits = 7'b0100100; // 5
            4'b0110: display_bits = 7'b0100000; // 6
            4'b0111: display_bits = 7'b0001111; // 7
            4'b1000: display_bits = 7'b0000000; // 8
            4'b1001: display_bits = 7'b0000100; // 9
            default: display_bits = 7'b1111111; // all off
        endcase
    end
    
endmodule

