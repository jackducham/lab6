module testbench();

timeunit 10ns;
timeprecision 1ns;

// internal signals
logic [15:0] S;
logic Clk = 0;
logic Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic CE, UB, LB, OE, WE;
logic [19:0] ADDR;
wire [15:0] Data;

// internal monitoring
//logic [15:0] MAR0, MDR0, IR0, PC0, PC;
logic [15:0] IR0, PC0;

integer error_count = 0;

lab6_toplevel p0(.*);

always #1 Clk = ~Clk;

always_comb begin
//    MAR0 = p0.my_slc.d0.MAR;
//    MDR0 = p0.my_slc.d0.MDR;
    IR0 = p0.my_slc.IR;
//    PC0 = p0.my_slc.d0.PC_MDR;
    PC0 = p0.my_slc.d0.PC;
end


initial begin
    Reset = 1;
    Run = 1;
    Continue = 1;
    S = 16'h005a;
    
    #2 Reset = 0;
    #2 Reset = 1;
    #2 Run = 0;
    #2 Run = 1;
//    #5 Continue = 0;
//    #5 Continue = 1;
//    #5 Run = 0;
//    #5 Run = 1;
//    #5 Continue = 0;
//    #5 Continue = 1;
//    #5 Run = 0;
//    #5 Run = 1;
//    #5 Continue = 0;
//    #5 Continue = 1;
//    #5 Run = 0;
//    #5 Run = 1;
//    #5 Continue = 0;
//    #5 Continue = 1;
//    #5 Run = 0;
//    #5 Run = 1;
//    #5 Continue = 0;
//    #5 Continue = 1;
        
    
end
endmodule
