// 16-bit register

module register16(
        input logic Clk, Reset, Load,
        input logic [15:0] D,
        output logic [15:0] Data_Out);
	
	logic [15:0] out;
	
    always_ff @(posedge Clk) 
	 begin
        if (Reset)
			begin
            out <= 16'h0;
			end
        else if (Load)
			begin
            out <= D;
			end
        else
            out <= out;
    end

	 assign Data_Out = out;
	 
endmodule
