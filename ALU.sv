module ALU
    (input logic [15:0] a, b,
     input logic [1:0] s,
     output logic [15:0] y);
     
     always_comb begin
        case (s)
            2'b00: y = a + b;
            2'b01: y = a & b;
            2'b10: y = ~a;
            2'b11: y = a;
        endcase
     end
     
     
endmodule
     