module sign_extend11to16bit
(
	input [10:0] in,
	output logic [15:0] out
);

	logic [4:0] upper;
	
	always_comb
	begin
		
		out[10:0] = in;
	
		if(in[10])
			upper = 5'b11111;
		else
			upper = 5'b00000;
		
		out[15:11] = upper;
		
	end

endmodule

module sign_extend9to16bit
(
	input [8:0] in,
	output logic [15:0] out
);

	logic [6:0] upper;
	
	always_comb
	begin
		
		out[8:0] = in;
	
		if(in[8])
			upper = 7'b1111111;
		else
			upper = 7'b0000000;
		
		out[15:9] = upper;
		
	end

endmodule

module zero_extend8to16bit
(
	input [7:0] in,
	output logic [15:0] out
);
	
	always_comb
	begin
		
		out[7:0] = in;
		
		out[15:8] = 8'b00000000;
		
	end

endmodule

module sign_extend6to16bit
(
	input [5:0] in,
	output logic [15:0] out
);

	logic [9:0] upper;
	
	always_comb
	begin
		
		out[5:0] = in;
	
		if(in[5])
			upper = 10'b1111111111;
		else
			upper = 10'b0000000000;
		
		out[15:6] = upper;
		
	end

endmodule

module sign_extend5to16bit
(
	input [4:0] in,
	output logic [15:0] out
);

	logic [10:0] upper;
	
	always_comb
	begin
		
		out[4:0] = in;
	
		if(in[4])
			upper = 11'b11111111111;
		else
			upper = 11'b00000000000;
		
		out[15:5] = upper;
		
	end

endmodule
