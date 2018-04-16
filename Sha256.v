/* 
 * This file contain the top module of the system.
 * @date 03/30/2018
 * @author Harry Zhou
 * 
 */

module Sha256(clk, rst_n, calcu_en, calcu_rdy, read_en, wordIn, wordOut);
	
	input clk;
	input rst_n;
	input calcu_en;
	output calcu_rdy;
	input read_en;
	input[31:0] wordIn;
	output[31:0] wordOut;
	
	/*
	 * Control signals
	 */
	reg[5:0] counter;
	wire counterIsZero, counterIsFull;
	wire genReady;
	reg genReadyPrevious;
	wire hashUpdate;
	//Counter judgement
	assign counterIsZero = ~|counter[5:0];
	assign counterIsFull = &counter[5:0];
	//Generate hash update signal
	always @(posedge clk) genReadyPrevious = genReady;
	assign hashUpdate = genReady&(~genReadyPrevious);
	//Counter update
	always @(posedge clk) begin
		counter <= (rst_n)?(
			((counterIsZero&(~calcu_en))|(counterIsFull&(~genReady)))?counter:counter+1
		):6'h0;
	end
	//Calculation ready signal
	assign calcu_rdy = rst_n&(genReady|calcu_rdy)&(~calcu_en);
	
	/*
	 * Calcualtion part
	 */
	reg[31:0] Hash[0:7];
	wire[31:0] Aa, Ab, B, C, D, E, F, G, H;
	wire[31:0] faa1a, faa1b;
	wire[31:0] addout[0:7];
	wire[31:0] Hinit[0:7]; //Initial values of H registers
	//Provide initial values
	InitialConstant initConst({Hinit[0],Hinit[1],Hinit[2],Hinit[3],
		Hinit[4],Hinit[5],Hinit[6],Hinit[7]}); 
	//Generator
	Generator generator(clk, rst_n, counter, wordIn, 
		{Hash[0],Hash[1],Hash[2],Hash[3],Hash[4],Hash[5],Hash[6],Hash[7]}, 
		genReady, {Aa, Ab, B, C, D, E, F, G, H});
	//Compressors and adders
	ThirtytwobitCompressor faa1(Aa, Ab, Hash[0], faa1a, faa1b);
	ThirtytwobitAdder adder1(faa1a, faa1b, addout[0]);
	ThirtytwobitAdder adder2(B, Hash[1], addout[1]);
	ThirtytwobitAdder adder3(C, Hash[2], addout[2]);
	ThirtytwobitAdder adder4(D, Hash[3], addout[3]);
	ThirtytwobitAdder adder5(E, Hash[4], addout[4]);
	ThirtytwobitAdder adder6(F, Hash[5], addout[5]);
	ThirtytwobitAdder adder7(G, Hash[6], addout[6]);
	ThirtytwobitAdder adder8(H, Hash[7], addout[7]);
	//Hash value update
	genvar i;
	generate for (i=0; i<8; i=i+1) begin
		always @(posedge clk) 
			Hash[i] <= (rst_n)?((hashUpdate)?addout[i]:Hash[i]):Hinit[i];
	end endgenerate
	
	/*
	 * Output part
	 */
	ParaToSerial p2s(clk, rst_n, read_en, 
		{Hash[0],Hash[1],Hash[2],Hash[3],Hash[4],Hash[5],Hash[6],Hash[7]}, wordOut);
	
	//Debug part
	/* wire[31:0] A;
	assign A = Aa+Ab; */
	
endmodule