`timescale 1ns/1ns

//1-bit adder test 
module OnebitAdderTest;

	reg clk;
	reg rst_n;
	
	initial begin
		clk = 1;
		rst_n = 1;
	end
	
	always #5 clk=~clk;
	
	wire A, B;
	wire CarryIn;
	wire Result, CarryOut;
	wire Andresult, Orresult;
	
	OnebitAdder onebitadder(A, B, CarryIn, Result, CarryOut, Andresult, Orresult);
	
	reg [2:0] temp;
	assign A = temp[0];
	assign B = temp[1];
	assign CarryIn = temp [2];
	
	initial temp = 0;
	always @(posedge clk) temp = temp + 1;
	
endmodule

//32-bit adder test 
module ThirtytwobitAdderTest;

	reg clk;
	reg rst_n;
	
	initial begin
		clk = 1;
		rst_n = 1;
	end
	
	always #5 clk=~clk;
	
	reg [31:0] A, B;
	wire [31:0] Result;
	
	ThirtytwobitAdder adder(A, B, Result);
	
	initial begin
		A=32'ha0ced587; B=32'haca69a1b;
		#10 A=32'hd6f28b79; B=32'h449a9035;
		#10 A=32'he2bb5641; B=32'h1e0049d5;
		#10 A=32'h04361d9c; B=32'h1023104d;
	end
	
endmodule