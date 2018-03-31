/* 
 * This file contain the module tranfer 256-bit parallel to
 * 32-bit serial.
 * @date 03/30/2018
 * @author Harry Zhou
 * 
 */

module ParaToSerial(clk, rst_n, enable, in, out);
	
	input clk, rst_n;
	input enable;
	input[255:0] in;
	output[31:0] out;
	
	//In module defination
	reg[2:0] counter;
	wire isZero;
	wire[31:0] word[0:7];
	
	//Wire connection
	genvar i;
	generate for (i=0; i<8; i=i+1)
		assign word[i] = in[32*(8-i)-1:32*(8-i-1)];
	endgenerate
	assign isZero = ~|counter[2:0];
	assign out = word[counter];
	//counter update
	always @(posedge clk) counter <= (rst_n)?((isZero&(~enable))?counter:counter+1):3'h0;
	
endmodule