/* 
 * This file contain the definition of a 32-bit 3:2 compressor
 * The compressor is designed specificly for Sha256.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module ThirtytwobitCompressor(A, B, C, Out1, Out2);
	
	input[31:0] A, B, C;
	output[31:0] Out1, Out2;
	
	//In module definition
	wire[31:0] Out2Temp;
	
	//1-bit Adder units
	genvar i;
	generate for (i=0; i<32; i=i+1) begin : Bit
		OnebitCompressor compressor(A[i], B[i], C[i], Out1[i], Out2Temp[i]);
	end endgenerate
	
	//Shift Out2Temp
	assign Out2 = Out2Temp << 1;
	
endmodule