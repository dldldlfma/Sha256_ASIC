/* 
 * This file contain the defination of the Adder adding a number to one.
 * @date 03/26/2018
 * @author Harry Zhou
 * 
 */

module AddOne(In, Out, Full);
	
	input [5:0] In;
	output [5:0] Out;
	output Full; //Indicate the next equals to 0
	
	assign Out[0] = ~In[0];
	assign Out[1] = In[1]^In[0];
	assign Out[2] = In[2]^(&In[1:0]);
	assign Out[3] = In[3]^(&In[2:0]);
	assign Out[4] = In[4]^(&In[3:0]);
	assign Out[5] = In[5]^((&In[4:3])&(&In[2:0]));
	
	assign Full = (&In[5:3])&(&In[2:0]);
	
endmodule