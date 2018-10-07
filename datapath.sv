module datapath
(
	input logic Clk, Reset,
					BEN,
					GATEPC, GATEMDR, GATEALU, GATEMARMUX,
					LD_MAR, LD_MDR, LD_IR, LD_PC, LD_BEN, LD_CC, LD_REG, LD_LED,
					DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
					MIO_EN,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic[15:0] DATA, DATA_TO_CPU,
	output logic[15:0] MAR, IR, MDR, PC, DATA_OUT
);

	logic [15:0] DATA_TO_MDR, DATA_TO_PC, PC_1, ADDER_OUT, ADDER_A, ADDER_B,
					 A2M_0, A2M_1, A2M_2;
	logic [3:0] GATE_SELECT;
	
	//MUX to select which gate drives the bus
	assign GATE_SELECT = {GATEMDR, GATEPC, GATEMARMUX, GATEALU};
	mux16 MUX_TO_BUS(.d0(MDR),.d1(PC),.d2(ADDER_OUT),.d3(),.x(16'bZ),
						  .s(GATE_SELECT),.y(DATA_OUT));
	
	//MDR components
	register16 REG_MDR(.Clk(Clk),.Reset(Reset),.Load(LD_MDR),.D(DATA_TO_MDR),.Data_Out(MDR));
	mux2       MUX_TO_MDR(.d0(DATA),.d1(DATA_TO_CPU),.s(MIO_EN),.y(DATA_TO_MDR));
	
	//MAR components
	register16 REG_MAR(.Clk(Clk),.Reset(Reset),.Load(LD_MAR),.D(DATA),.Data_Out(MAR));
	
	//PC components
	assign PC_1 = PC + 16'h1;
	register16 REG_PC(.Clk(Clk),.Reset(Reset),.Load(LD_PC),.D(DATA_TO_PC),.Data_Out(PC));
	mux4		  MUX_TO_PC(.d0(DATA),.d1(ADDER_OUT),.d2(PC_1),.d3(),.s(PCMUX),.y(DATA_TO_PC));
	
	//IR components
	register16 REG_IR(.Clk(Clk),.Reset(Reset),.Load(LD_IR),.D(DATA),.Data_Out(IR));
	
	//MARMUX components
	assign A2M_0 = {{5{IR[10]}},IR[10:0]};
	assign A2M_1 = {{7{IR[8]}},IR[8:0]};
	assign A2M_2 = {{10{IR[5]}},IR[5:0]};
	carry_lookahead_adder ADDER(.A(ADDER_A),.B(ADDER_B),.Sum(ADDER_OUT),.CO());
	mux4                  ADDR2_MUX(.d0(A2M_0),.d1(A2M_1),.d2(A2M_2),.d3(16'h0),
											  .s(ADDR2MUX),.y(ADDER_A));
	mux2                  ADDR1_MUX(.d0(),.d1(PC),.s(ADDR1MUX),.y(ADDER_B));
	
	//ALU components
	ALU  ALU_UNIT(.a(),.b(ALU_B),.s(ALUK),.y());
	mux2 SR2_MUX(.d0(),.d1(),.s(),.y());
	
endmodule
