/* 
 * This file contain the definition of a 32-bit full adder.
 * The adder is designed specificly for Sha256.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module ThirtytwobitAdder(A, B, Result);
	
	input[31:0] A, B;
	output[31:0] Result;
	
	//In module definition
	wire[7:0] CarryIn, CarryOut;
	wire[7:0] G, P;
	wire[7:0] C; //The alias of CarryIn;
	
	//4-bit Adder units
	FourbitAdder adder1(A[3:0], B[3:0], CarryIn[0], Result[3:0], CarryOut[0], G[0], P[0]);
	FourbitAdder adder2(A[7:4], B[7:4], CarryIn[1], Result[7:4], CarryOut[1], G[1], P[1]);
	FourbitAdder adder3(A[11:8], B[11:8], CarryIn[2], Result[11:8], CarryOut[2], G[2], P[2]);
	FourbitAdder adder4(A[15:12], B[15:12], CarryIn[3], Result[15:12], CarryOut[3], G[3], P[3]);
	FourbitAdder adder5(A[19:16], B[19:16], CarryIn[4], Result[19:16], CarryOut[4], G[4], P[4]);
	FourbitAdder adder6(A[23:20], B[23:20], CarryIn[5], Result[23:20], CarryOut[5], G[5], P[5]);
	FourbitAdder adder7(A[27:24], B[27:24], CarryIn[6], Result[27:24], CarryOut[6], G[6], P[6]);
	FourbitAdder adder8(A[31:28], B[31:28], CarryIn[7], Result[31:28], CarryOut[7], G[7], P[7]);
	
	//CLA Part
	assign CarryIn = C;
	assign C[0] = 0;
	assign C[1] = G[0];
	assign C[2] = G[1]|(P[1]&G[0]);
	assign C[3] = G[2]|(P[2]&G[1])|(P[2]&P[1]&G[0]);
	assign C[4] = G[3]|(P[3]&G[2])|(P[3]&P[2]&G[1])|(P[3]&P[2]&P[1]&G[0]);
	assign C[5] = G[4]|(P[4]&C[4]);
	assign C[6] = G[5]|(P[5]&G[4])|(P[5]&P[4]&C[4]);
	assign C[7] = G[6]|(P[6]&G[5])|(P[6]&P[5]&G[4])|(P[6]&P[5]&P[4]&C[4]);
	
endmodule

