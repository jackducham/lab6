module reg_file
(
	input logic Clk, Reset, LD_REG,
	input logic [2:0] DR, SR1, SR2,
	input logic [15:0] DATA,
	output logic [15:0] SR1_OUT, SR2_OUT
);

	logic LD_REG0, LD_REG1, LD_REG2, LD_REG3, LD_REG4, LD_REG5, LD_REG6, LD_REG7;
	
	register16 reg_0(.Clk(Clk),.Reset(Reset),.Load(LD_REG0),.D(DATA),.Data_Out());
	register16 reg_1(.Clk(Clk),.Reset(Reset),.Load(LD_REG1),.D(DATA),.Data_Out());
	register16 reg_2(.Clk(Clk),.Reset(Reset),.Load(LD_REG2),.D(DATA),.Data_Out());
	register16 reg_3(.Clk(Clk),.Reset(Reset),.Load(LD_REG3),.D(DATA),.Data_Out());
	register16 reg_4(.Clk(Clk),.Reset(Reset),.Load(LD_REG4),.D(DATA),.Data_Out());
	register16 reg_5(.Clk(Clk),.Reset(Reset),.Load(LD_REG5),.D(DATA),.Data_Out());
	register16 reg_6(.Clk(Clk),.Reset(Reset),.Load(LD_REG6),.D(DATA),.Data_Out());
	register16 reg_7(.Clk(Clk),.Reset(Reset),.Load(LD_REG7),.D(DATA),.Data_Out());
	
	mux8 MUX_SR1(.d0(reg_0),.d1(reg_1),.d2(reg_2),.d3(reg_3),.d4(reg_4),.d5(reg_5),
					 .d6(reg_6),.d7(reg_7),.s(SR1),.y(SR1_OUT));
	mux8 MUX_SR2(.d0(reg_0),.d1(reg_1),.d2(reg_2),.d3(reg_3),.d4(reg_4),.d5(reg_5),
					 .d6(reg_6),.d7(reg_7),.s(SR2),.y(SR2_OUT));
					 
	always_comb
	begin
		LD_REG0 = 1'b0;
		LD_REG1 = 1'b0;
		LD_REG2 = 1'b0;
		LD_REG3 = 1'b0;
		LD_REG4 = 1'b0;
		LD_REG5 = 1'b0;
		LD_REG6 = 1'b0;
		LD_REG7 = 1'b0;
		
		if(LD_REG)
		begin
			case (DR)
				3'b000: LD_REG0 = 1'b1;
				3'b001: LD_REG1 = 1'b1;
				3'b010: LD_REG2 = 1'b1;
				3'b011: LD_REG3 = 1'b1;
				3'b100: LD_REG4 = 1'b1;
				3'b101: LD_REG5 = 1'b1;
				3'b110: LD_REG6 = 1'b1;
				3'b111: LD_REG7 = 1'b1;
			endcase
		end
   end

endmodule
