/* 
 * This file contain the definition of a four-bit full adder.
 * The adder is designed specificly for Sha256.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module FourbitAdder(A, B, CarryIn, Result, CarryOut, G, P);
	
	input[3:0] A, B;
	input CarryIn;
	output[3:0] Result;
	output CarryOut;
	output G, P;
	
	//In module definition
	wire Carry01, Carry12, Carry23;
	wire[3:0] g, p;
	
	//1 bit Adder units
	OnebitAdder Bit0(A[0], B[0], CarryIn, Result[0], Carry01, g[0], p[0]);
	OnebitAdder Bit1(A[1], B[1], Carry01, Result[1], Carry12, g[1], p[1]);
	OnebitAdder Bit2(A[2], B[2], Carry12, Result[2], Carry23, g[2], p[2]);
	OnebitAdder Bit3(A[3], B[3], Carry23, Result[3], CarryOut, g[3], p[3]);
	
	//CLA Part
	assign G = g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);
	assign P = p[3]&p[2]&p[1]&p[0];
	
endmodule