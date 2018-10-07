module sign_extend11to16bit
(
	input [10:0] in,
	output logic [15:0] out
);
	
	always_comb
	begin
	
		if(in[10])
			out = {5'b11111, in};
		else
			out = {5'b00000, in};
		
	end

endmodule

module sign_extend9to16bit
(
	input [8:0] in,
	output logic [15:0] out
);
	
	always_comb
	begin
	
		if(in[8])
			out = {7'b1111111, in};
		else
			out = {7'b0000000, in};
		
	end

endmodule

module sign_extend6to16bit
(
	input [5:0] in,
	output logic [15:0] out
);
	
	always_comb
	begin
	
		if(in[5])
			out = {10'b1111111111, in};
		else
			out = {10'b0000000000, in};
		
	end

endmodule

module sign_extend5to16bit
(
	input [4:0] in,
	output logic [15:0] out
);
	
	always_comb
	begin
	
		if(in[4])
			out = {11'b11111111111, in};
		else
			out = {11'b00000000000, in};
		
	end

endmodule
