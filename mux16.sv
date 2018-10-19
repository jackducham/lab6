module mux16
    #(parameter width = 16)
    (input logic [width-1:0] d0, d1, d2, d3, x,
	  input logic [3:0] s,
     output logic [width-1:0] y);
	  
     always_comb
	  begin
			unique case (s)
            4'b0000: y = 16'bzzzzzzzzzzzzzzzz;
            4'b1000: y = d0;
            4'b0100: y = d1;
            4'b0010: y = d2;
            4'b0001: y = d3;
			default: y = 16'bzzzzzzzzzzzzzzzz;
        endcase
     end
endmodule
