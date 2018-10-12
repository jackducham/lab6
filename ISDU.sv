//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------
`include "SLC3_2.sv"
import SLC3_2::*;

module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum {  HALT, 
            PauseIR1, 
			PauseIR2,
            S_00,
            S_01,
            S_04,
            S_05,
            S_06,
            S_07,
            S_09,
            S_12,
            S_16,
            S_16_1,
			S_18,
            S_21,
            S_22,
            S_23,
            S_25,
            S_25_1,
            S_27,
            S_32,
			S_33, 
			S_33_1,
            S_35    } curr_state, next_state;   // Internal curr_state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			curr_state <= HALT;
		else 
			curr_state <= next_state;
	end
   
	always_comb
	begin 
		// Default next curr_state is staying at current curr_state
		next_state = curr_state;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b1;
		Mem_WE = 1'b1;
	
		// Assign next curr_state
		unique case (curr_state)
			HALT: 
				if (Run) 
					next_state = S_18;
            S_00:
                if (BEN)
                    next_state = S_22;
                else
                    next_state = S_18;
            S_01:
                next_state = S_18;
            S_04:
                next_state = S_21;
            S_05:
                next_state = S_18;
            S_06:
                next_state = S_25;
            S_07:
                next_state = S_23;
            S_09:
                next_state = S_18;
            S_12:
                next_state = S_18;
            S_16:
                next_state = S_16_1;
            S_16_1:
                next_state = S_18;
            S_18:
                next_state = S_33;
            S_21:
                next_state = S_18;
            S_22:
                next_state = S_18;
            S_23:
                next_state = S_16;
            S_25:
                next_state = S_25_1;
            S_25_1:
                next_state = S_27;
            S_27:
                next_state = S_18;
            S_32:
                case (Opcode)
                    op_BR:
                        next_state = S_00;
                    op_ADD:
                        next_state = S_01;
                    op_AND:
                        next_state = S_05;
                    op_NOT:
                        next_state = S_09;
                    op_JMP:
                        next_state = S_12;
                    op_JSR:
                        next_state = S_04;
                    op_LDR:
                        next_state = S_06;
                    op_STR:
                        next_state = S_07;
                    op_PSE:
                        next_state = PauseIR1;
                    default:
                        next_state = S_18;
                endcase
                    
			S_33:
                next_state = S_33_1;
			S_33_1:
                next_state = S_35;
            S_35:
                next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					next_state = PauseIR1;
				else 
					next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					next_state = PauseIR2;
				else 
					next_state = S_18;
			default: ;
		endcase
		
		// Assign control signals based on current curr_state
		case (curr_state)
			HALT: ;
            S_00: ;
			S_01: 
				begin 
                    LD_CC = 1'b1;
                    LD_REG = 1'b1;
                    GateALU = 1'b1;
                    ALUK = 2'b00;
                    SR1MUX = 1'b1;
					SR2MUX = IR_5;
				end
            S_04:
                begin
                    LD_REG = 1'b1;
                    GatePC = 1'b1;
                    DRMUX = 1'b1;
                end
            S_05:
                begin
                    LD_CC = 1'b1;
                    LD_REG = 1'b1;
                    GateALU = 1'b1;
                    ALUK = 2'b01;
                    SR1MUX = 1'b1;
                    SR2MUX = IR_5;                    
                end
            S_06:
                begin
                    LD_MAR = 1'b1;
                    GateMARMUX = 1'b1;
                    ADDR1MUX = 1'b1;
                    ADDR2MUX = 2'b01;
                end
            S_07:
                begin
                    LD_MAR = 1'b1;
                    GateMARMUX = 1'b1;
                    ADDR1MUX = 1'b1;
                    ADDR2MUX = 2'b01;
                end
            S_09:
                begin
                    LD_CC = 1'b1;
                    LD_REG = 1'b1;
                    GateALU = 1'b1;
                    ALUK = 2'b10;
                    SR1MUX = 1'b1;
                    SR2MUX = 1'b1;
                end
            S_12:
                begin
                    LD_PC = 1'b1;
                    PCMUX = 2'b10;
						  ADDR2MUX = 2b'00;
						  ADDR1MUX = 1b'1;
						  SR1MUX = 1'b1;
                end
            S_16:
                begin
                    Mem_WE = 1'b0;
                end
            S_16_1:
                begin
                    Mem_WE = 1'b0;
                end
            S_18: 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
            S_21:
                begin
                    LD_PC = 1'b1;
                    PCMUX = 2'b10;
                    ADDR2MUX = 2'b11;
                end
            S_22:
                begin
                    LD_PC = 1'b1;
                    PCMUX = 2'b10;
                    ADDR2MUX = 2'b10;
                end
            S_23:
                begin
                    LD_MDR = 1'b1;
                    GateALU = 1'b1;
                    ALUK = 2'b11;
                end
            S_25:
                begin
                    Mem_OE = 1'b0;
                end
            S_25_1:
                begin
                    LD_MDR = 1'b1;
                    Mem_OE = 1'b0;
                end
            S_27:
                begin
                    LD_CC = 1'b1;
                    LD_REG = 1'b1;
                    GateMDR = 1'b1;
                end
           	S_32: 
				LD_BEN = 1'b1; 
			S_33: 
				Mem_OE = 1'b0;
			S_33_1:
                begin
                    LD_MDR = 1'b1;
                    Mem_OE = 1'b0;
                end
			S_35: 
				begin
                    LD_IR = 1'b1;
					GateMDR = 1'b1;
				end
			PauseIR1: ;
			PauseIR2: ;
			default: ;
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
