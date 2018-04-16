/* 
 * This file contain the definition of the initial hash constant.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */
 
module InitialConstant({init[0],init[1],init[2],init[3],init[4],init[5],init[6],init[7]});
	
	output[31:0] init[0:7];
	
	assign init[0] = 32'h6a09e667; assign init[1] = 32'hbb67ae85; 
	assign init[2] = 32'h3c6ef372; assign init[3] = 32'ha54ff53a; 
	assign init[4] = 32'h510e527f; assign init[5] = 32'h9b05688c; 
	assign init[6] = 32'h1f83d9ab; assign init[7] = 32'h5be0cd19; 
	
endmodule