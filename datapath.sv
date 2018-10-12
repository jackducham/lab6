module datapath
(
	input logic Clk, Reset,
					GATEPC, GATEMDR, GATEALU, GATEMARMUX,
					LD_MAR, LD_MDR, LD_IR, LD_PC, LD_CC, LD_BEN, LD_REG, MIO_EN,
					DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic[15:0] DATA, DATA_TO_CPU,
	output logic BEN_OUT,
	output logic[15:0] MAR, IR, MDR, PC, DATA_OUT
);
	
	logic BEN_IN, N_IN, Z_IN, P_IN, N_OUT, Z_OUT, P_OUT;
	logic [2:0] DR, SR1;
	logic [3:0] GATE_SELECT;
	logic [15:0] DATA_TO_MDR, DATA_TO_PC, PC_1, ADDER_OUT, ADDER_A, ADDER_B,
					 A2M_0, A2M_1, A2M_2, ALU_B, S2M_0, ALU_OUT, REG_1, REG_2;
	logic [15:0] BUS, BUS_OUT;
	
	assign BUS = DATA;
	assign DATA_OUT = BUS;
	
	//MUX to select which gate drives the bus
	assign GATE_SELECT = {GATEMDR, GATEPC, GATEMARMUX, GATEALU};
	mux16 MUX_TO_BUS(.d0(MDR),.d1(PC),.d2(ADDER_OUT),.d3(ALU_OUT),.x(16'bZ),
						  .s(GATE_SELECT),.y(BUS_OUT));
	
	//MDR components
	register16 REG_MDR(.Clk(Clk),.Reset(Reset),.Load(LD_MDR),.D(DATA_TO_MDR),.Data_Out(MDR));
	mux2       MUX_TO_MDR(.d0(BUS),.d1(DATA_TO_CPU),.s(MIO_EN),.y(DATA_TO_MDR));
	
	//MAR components
	register16 REG_MAR(.Clk(Clk),.Reset(Reset),.Load(LD_MAR),.D(BUS),.Data_Out(MAR));
	
	//PC components
	assign PC_1 = PC + 16'h1;
	register16 REG_PC(.Clk(Clk),.Reset(Reset),.Load(LD_PC),.D(DATA_TO_PC),.Data_Out(PC));
	mux4		  MUX_TO_PC(.d0(PC_1),.d1(BUS),.d2(ADDER_OUT),.d3(),.s(PCMUX),.y(DATA_TO_PC));
	
	//IR components
	register16 REG_IR(.Clk(Clk),.Reset(Reset),.Load(LD_IR),.D(BUS),.Data_Out(IR));
	
	//MARMUX components
	assign A2M_2 = {{5{IR[10]}},IR[10:0]};
	assign A2M_1 = {{7{IR[8]}},IR[8:0]};
	assign A2M_0 = {{10{IR[5]}},IR[5:0]};
	carry_lookahead_adder ADDER(.A(ADDER_A),.B(ADDER_B),.Sum(ADDER_OUT),.CO());
	mux4                  ADDR2_MUX(.d0(16'h0),.d1(A2M_0),.d2(A2M_1),.d3(A2M_2),
											  .s(ADDR2MUX),.y(ADDER_A));
	mux2                  ADDR1_MUX(.d0(PC),.d1(REG_1),.s(ADDR1MUX),.y(ADDER_B));
	
	//ALU components
	assign S2M_0 = {{11{IR[4]}},IR[4:0]};
	ALU  		ALU_UNIT(.a(REG_1),.b(ALU_B),.s(ALUK),.y(ALU_OUT));
	mux2 		SR2_MUX(.d0(REG_2),.d1(S2M_0),.s(SR2MUX),.y(ALU_B));
	reg_file REG_FILE(.Clk(Clk),.Reset(Reset),.LD_REG(LD_REG),.DR(DR),.SR1(SR1),
							.SR2(IR[2:0]),.DATA(BUS),.SR1_OUT(REG_1),.SR2_OUT(REG_2));
	mux2 #(3)    DR_MUX(.d0(IR[11:9]),.d1(3'b111),.s(DRMUX),.y(DR));
	mux2 #(3)    SR1_MUX(.d0(IR[11:9]),.d1(IR[8:6]),.s(SR1MUX),.y(SR1));
	
	//NZP and BEN components
	assign BEN_IN = (N_OUT & IR[11]) | (Z_OUT & IR[10]) | (P_OUT & IR[9]);
	assign N_IN = BUS[15];
	
	always_comb
	begin
		if(BUS == 16'h0)
			Z_IN = 1'b1;
		else
			Z_IN = 1'b0;
			
		if(Z_IN || N_IN)
			P_IN = 1'b0;
		else
			P_IN = 1'b1;
	end
	
	d_flip_flop N(.Clk(Clk),.Load(LD_CC),.Reset(Reset),.D(N_IN),.Q(N_OUT));
	d_flip_flop Z(.Clk(Clk),.Load(LD_CC),.Reset(Reset),.D(Z_IN),.Q(Z_OUT));
	d_flip_flop P(.Clk(Clk),.Load(LD_CC),.Reset(Reset),.D(P_IN),.Q(P_OUT));
	d_flip_flop BEN(.Clk(Clk),.Load(LD_BEN),.Reset(Reset),.D(BEN_IN),.Q(BEN_OUT));
	
endmodule
