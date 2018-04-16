/* 
 * This file contain the definition of a one-bit full adder.
 * The adder is designed specificly for Sha256.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module OnebitAdder(A, B, CarryIn, Result, CarryOut, Andresult, Orresult);
	
	input A, B, CarryIn;
	output Result, CarryOut;
	output Andresult, Orresult; //Used for g&p calculation to perform Carry Look Ahead
	
	//In module definition
	wire ABxor;
	
	//Basic Operations
	assign Andresult = A&B;
	assign Orresult = A|B;
	assign ABxor = A^B;
	assign Result = ABxor^CarryIn;
	assign CarryOut = (A&B)|(CarryIn&ABxor);
	
endmodule