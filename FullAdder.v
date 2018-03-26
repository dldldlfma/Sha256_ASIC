/* 
 * This file contain the defination of a 32-bit full adder
 * and a 32-bit 3:2 compressor.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */

/*
 * This is the one bit adder
 */
module OnebitAdder(A, B, CarryIn, Result, CarryOut, Andresult, Orresult);
	
	input A, B, CarryIn;
	output Result, CarryOut;
	output Andresult, Orresult; //Used for g&p calculation to perform Carry Look Ahead
	
	wire ABxor;
	
	//Basic Operations
	assign Andresult = A&B;
	assign Orresult = A|B;
	assign ABxor = A^B;
	assign Result = ABxor^CarryIn;
	assign CarryOut = (A&B)|(CarryIn&ABxor);
	
endmodule