module plus_1
    (input logic [15:0] pc,
     output logic [15:0] y);
     
     assign y = pc + 16'h1;
     
endmodule
     