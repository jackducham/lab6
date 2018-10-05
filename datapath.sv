module datapath
(
	input logic Clk, Reset,
					GATEPC, GATEMDR,
					LD_MAR, LD_MDR, LD_IR, LD_PC,
					MIO_EN, PCMUX_EN,
	input logic[15:0] DATA, DATA_TO_MDR,
	output logic[15:0] MAR, IR, MDR, PC_MDR
);

	logic [15:0] a,b,c,d,e,f;
	assign MDR = c;
	mux2 mux2mdr(.d0(a),.d1(c),.s(GATEMDR),.y(PC_MDR));
	mux2 mux2pc(.d0(16'bZZZZZZZZZZZZZZZZ),.d1(b),.s(GATEPC),.y(a));
	register16 pc_reg(.Clk(Clk),.Reset(Reset),.Load(LD_PC),.D(d),.Data_Out(b));
	register16 mdr_reg(.Clk(Clk),.Reset(Reset),.Load(LD_MDR),.D(f),.Data_Out(c));
	plus_1 pc_plus_1(.pc(b),.y(d));
	//mux2 pcmux(.d0(DATA),.d1(d),.s(PCMUX_EN),.y(e));
	mux2 mdrmux(.d0(DATA),.d1(DATA_TO_MDR),.s(MIO_EN),.y(f));
	register16 ir_reg(.Clk(Clk),.Reset(Reset),.Load(LD_IR),.D(DATA),.Data_Out(IR));
	register16 mar_reg(.Clk(Clk),.Reset(Reset),.Load(LD_MAR),.D(DATA),.Data_Out(MAR));
	
endmodule
