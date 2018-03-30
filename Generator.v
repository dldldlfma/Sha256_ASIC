/* 
 * This file contain the definition of the generator
 * Generator is the major component of caclulating Sha256 value
 * Generator starts while counter is set to 0.
 * Counter value should keep growing after initialized to 0.
 * Counter should stop and maintain 63 untill ready signal is given.
 * Generator will output ready signal when calculation is done.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module Generator(clk, rst_n, counter, wordIn, 
	{Ain, Bin, Cin, Din, Ein, Fin, Gin, Hin}, ready, 
	{Aouta, Aoutb, Bout, Cout, Dout, Eout, Fout, Gout, Hout});
	
	input clk, rst_n;
	input[5:0] counter;
	input[31:0] wordIn;
	input[31:0] Ain, Bin, Cin, Din, Ein, Fin, Gin, Hin;
	output reg ready;
	output[31:0] Aouta, Aoutb, Bout, Cout, Dout, Eout, Fout, Gout, Hout;
	
	/*
	 * Pipeline stage 1
	 * Generate Wi
	 */
	reg[31:0] W[0:15];
	wire[31:0] Wi_16, Wi_15, Wi_7, Wi_2, Win;
	wire[31:0] s0, s1;
	wire[31:0] faa7a, faa7b, faa8a, faa8b;
	wire[31:0] addout3;
	wire inputSrc;
	
	//Word queue
	genvar i;
	generate for(i=0; i<15; i=i+1)
		always @(posedge clk) W[i] <= (rst_n)?W[i+1]:32'h0;
	endgenerate
	always @(posedge clk) W[15] <= (rst_n)?Win:32'h0;
	//Wire connection
	assign Wi_16 = W[0];
	assign Wi_15 = W[1];
	assign Wi_7 = W[9];
	assign Wi_2 = W[14];
	assign Win = (inputSrc)?addout3:wordIn;
	assign s0 = {Wi_15[6:0],Wi_15[31:7]}^{Wi_15[17:0],Wi_15[31:18]}^{3'b0,Wi_15[31:3]};
	assign s1 = {Wi_2[16:0],Wi_2[31:17]}^{Wi_2[18:0],Wi_2[31:19]}^{10'b0,Wi_2[31:10]};
	//Compressors and adders
	ThirtytwobitCompressor faa7(Wi_16, Wi_7, s0, faa7a, faa7b);
	ThirtytwobitCompressor faa8(s1, faa7a, faa7b, faa8a, faa8b);
	ThirtytwobitAdder adder3(faa8a, faa8b, addout3);
	
	/*
	 * Pipeline stage 2
	 * Calculate pipeline value L1, L2
	 */
	reg[5:0] counterS2;
	reg[63:0] L1, L2;
	wire[31:0] Ki, Wi;
	wire[31:0] faa1a, faa1b, faa2a, faa2b;
	wire[31:0] fwdH, fwdD;
	
	//Update counter
	always @(posedge clk) counterS2 <= (rst_n)?counter:6'b0;
	//Set up Wi
	assign Wi = W[15];
	//Select Ki
	K kvalue(counterS2, Ki);
	//Compressors
	ThirtytwobitCompressor faa1(fwdH, Wi, Ki, faa1a, faa1b);
	ThirtytwobitCompressor faa2(fwdD, faa1a, faa1b, faa2a, faa2b);
	//Pipeline register update
	always @(posedge clk)begin
		L1 <= (rst_n)?{faa2a,faa2b}:64'h0;
		L2 <= (rst_n)?{faa1a,faa1b}:64'h0;
	end
	
	/*
	 * Pipeline stage 3
	 * Update A ... H
	 */
	reg[5:0] counterS3;
	reg[31:0] Aa, Ab, B, C, D, E, F, G, H; //Main registers
	wire[31:0] Sig0, Sig1, Maj, Ch;
	wire[31:0] faa1aL, faa1bL, faa2aL, faa2bL;
	wire[31:0] faa3a, faa3b, faa4a, faa4b;
	wire[31:0] faa5a, faa5b, faa6a, faa6b;
	wire[31:0] faa9a, faa9b, faa10a, faa10b;
	wire[31:0] addout1, addout2;
	wire[31:0] A;
	wire fwdHSrc, fwdDSrc;
	wire regRst_n; //Reset Signal for main registers
	
	//Update counter
	always @(posedge clk) counterS3 <= (rst_n)?counterS2:6'b0;
	//Wire connection
	assign fwdH = (fwdHSrc)?H:G;
	assign fwdD = (fwdDSrc)?D:C;
	assign A = addout2;
	assign Sig1 = {E[5:0],E[31:6]}^{E[10:0],E[31:11]}^{E[24:0],E[31:25]};
	assign Ch = (E&F)^((~E)&G);
	assign Sig0 = {A[1:0],A[31:2]}^{A[12:0],A[31:13]}^{A[21:0],A[31:22]};
	assign Maj = (A&B)^(A&C)^(B&C);
	assign {faa1aL,faa1bL} = L2;
	assign {faa2aL,faa2bL} = L1;
	//Compressors and adders
	ThirtytwobitCompressor faa3(faa1aL, faa1bL, Sig1, faa3a, faa3b);
	ThirtytwobitCompressor faa4(faa2aL, faa2bL, Sig1, faa4a, faa4b);
	ThirtytwobitCompressor faa5(Ch, faa3a, faa3b, faa5a, faa5b);
	ThirtytwobitCompressor faa6(Ch, faa4a, faa4b, faa6a, faa6b);
	ThirtytwobitCompressor faa9(Sig0, faa5a, faa5b, faa9a, faa9b);
	ThirtytwobitCompressor faa10(Maj, faa9a, faa9b, faa10a, faa10b);
	ThirtytwobitAdder adder1(faa6a, faa6b, addout1);
	ThirtytwobitAdder adder2(Aa, Ab, addout2);
	//Update A ... H
	always @(posedge clk) begin
		Aa <= (rst_n&regRst_n)?((ready)?Aa:faa10a):Ain;
		Ab <= (rst_n&regRst_n)?((ready)?Ab:faa10b):32'h0;
		B <= (rst_n&regRst_n)?((ready)?B:A):Bin;
		C <= (rst_n&regRst_n)?((ready)?C:B):Cin;
		D <= (rst_n&regRst_n)?((ready)?D:C):Din;
		E <= (rst_n&regRst_n)?((ready)?E:addout1):Ein;
		F <= (rst_n&regRst_n)?((ready)?F:E):Fin;
		G <= (rst_n&regRst_n)?((ready)?G:F):Gin;
		H <= (rst_n&regRst_n)?((ready)?H:G):Hin;
	end
	//Connect output to A ... H
	assign Aouta = Aa; assign Aoutb = Ab; assign Bout = B;
	assign Cout = C; assign Dout = D;
	assign Eout = E; assign Fout = F;
	assign Gout = G; assign Hout = H;
	
	/*
	 * Control Signal
	 */
	assign inputSrc = |counter[5:4];
	assign regRst_n = |counter[5:1];
	assign fwdDSrc = ~|counterS2[5:0];
	assign fwdHSrc = fwdDSrc;
	always @(posedge clk) ready <= (rst_n)?(&counter[5:0])&(&counterS3[5:0]):1'b0;
	
	//Debug part
	// wire[31:0] T1, T2;
	// wire[31:0] Kreal;
	// wire[31:0] Areal, Ereal;
	// K krealvalue(counterS3, Kreal);
	// assign T1 = H+Sig1+Ch+Kreal+W[14];
	// assign T2 = Sig0+Maj;
	// assign Areal = T1+T2;
	// assign Ereal = D+T1;
	
endmodule