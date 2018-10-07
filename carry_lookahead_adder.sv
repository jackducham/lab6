module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* 
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
	  logic g0, g4, g8, g12;
	  logic p0, p4, p8, p12;
	  logic c0, c4, c8, c12;
	  
	  assign c0 = 0;
	  
	  four_bit_adder_CLA fcla0(.a(A[3:0]),.b(B[3:0]),.cin(c0),.g(g0),.p(p0),.s(Sum[3:0]));
	  
	  assign c4 = g0 | (c0 & p0);
	  four_bit_adder_CLA fcla1(.a(A[7:4]),.b(B[7:4]),.cin(c4),.g(g4),.p(p4),.s(Sum[7:4]));
	  
	  assign c8 = g4 | (g0 & p4) | (c0 & p0 & p4);
	  four_bit_adder_CLA fcla2(.a(A[11:8]),.b(B[11:8]),.cin(c8),.g(g8),.p(p8),.s(Sum[11:8]));
	  
	  assign c12 = g8 | (g4 & p8) | (g0 & p8 & p4) | (c0 & p8 & p4 & p0);
	  four_bit_adder_CLA fcla3(.a(A[15:12]),.b(B[15:12]),.cin(c12),.g(g12),.p(p12),.s(Sum[15:12]));
	  
	  assign CO = g12 | (g8 & p12) | (g4 & p12 & p8) | (g0 & p12 & p8 & p4) | (c0 & p12 & p8 & p4 & p0);
	  
endmodule

module four_bit_adder_CLA
(
	input [3:0] a,
	input [3:0] b,
	input cin,
	output logic g,
	output logic p,
	output logic [3:0] s
);

	logic g0, g1, g2, g3;
	logic p0, p1, p2, p3;
	logic c1, c2, c3;
	
	full_adder_CLA fa0(.x(a[0]),.y(b[0]),.cin(cin),.g(g0),.p(p0),.s(s[0]));
	
	assign c1 = (cin & p0) | g0;
	full_adder_CLA fa1(.x(a[1]),.y(b[1]),.cin(c1),.g(g1),.p(p1),.s(s[1]));
	
	assign c2 = (cin & p0 & p1) | (g0 & p1) | g1;
	full_adder_CLA fa2(.x(a[2]),.y(b[2]),.cin(c2),.g(g2),.p(p2),.s(s[2]));
	
	assign c3 = (cin & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2;
	full_adder_CLA fa3(.x(a[3]),.y(b[3]),.cin(c3),.g(g3),.p(p3),.s(s[3]));
	
	assign g = g3 | (g2 & p3) | (g1 & p3 & p2) | (g0 & p3 & p2 & p1);
	assign p = p0 & p1 & p2 & p3;

endmodule

module full_adder_CLA
(
	input x,
	input y,
	input cin,
	output logic g,
	output logic p,
	output logic s
);

	assign g = x & y;
	assign p = x ^ y;
	assign s = x ^ y ^ cin;

endmodule
