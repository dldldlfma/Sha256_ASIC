/* 
 * This file contain the definition of a one-bit 3:2 compressor
 * The compressor is designed specificly for Sha256.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module OnebitCompressor(A, B, C, Result, CarryOut);
	
	input A, B, C;
	output Result, CarryOut;
	
	//In module definition
	wire ABxor;
	
	//Basic Operations
	assign ABxor = A^B;
	assign Result = ABxor^C;
	assign CarryOut = (A&B)|(C&ABxor);
	
endmodule