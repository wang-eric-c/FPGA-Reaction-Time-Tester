module binary_to_ssd (
    input logic [$clog2(10000)-1:0] binary_in,
    output logic [6:0] display_out [3:0]
);

    logic [3:0] units = 4'b0000;
    logic [3:0] tens = 4'b0000;
    logic [3:0] hundreds = 4'b0000;
    logic [3:0] thousands = 4'b0000;
    
    always @(*)
    begin
        units = (binary_in) % 10; //units digit
        tens = (binary_in / 10) % 10; //tens digit
        hundreds = (binary_in / 100) % 10; //hundreds digit
        thousands = (binary_in / 1000) % 10; //thousands digit
    end
    
    seven_segment_digit ssd_inst1 (
        .digit(units),
        .display_bits(display_out[0])
    );    
    seven_segment_digit ssd_inst2 (
        .digit(tens),
        .display_bits(display_out[1])
    );    
    seven_segment_digit ssd_inst3 (
        .digit(hundreds),
        .display_bits(display_out[2])
    );    
    seven_segment_digit ssd_inst4 (
        .digit(thousands),
        .display_bits(display_out[3])
    );
    
endmodule