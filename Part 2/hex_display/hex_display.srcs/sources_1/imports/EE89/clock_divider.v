/* The meaty bit */

//Clock divider. Uses counter and dregs to generate ~3Hz (0.33s) clk from 100MHz (10ns)
//Needs to count 33333333/2 = 16666667 times to get ~3Hz
module clk_div (clk, rst, new_clk);
	parameter half_period = 16666667;
	input clk;
	input rst;
	output new_clk;
	reg new_clk;
	
	//wires and regs
	reg [24:0] cnt;
	
	//counter
	always @ (posedge(clk), posedge(rst)) 
	begin
		if (rst == 1'b1)
			cnt <= 24'b0;
		else if (cnt == half_period)
			cnt <= 24'b0;
		else
			cnt <= cnt+1;
	end
	
	//flip-flop + comparator
	always @ (posedge(clk), posedge(rst))
	begin
		if (rst == 1'b1)
			new_clk <= 1'b0;
		else if (cnt == half_period - 1)
			new_clk <= ~new_clk;
		else
			new_clk <= new_clk;
	end
endmodule

module display_clk(clk,rst,clk_led);
    input clk;
    input rst;
    output clk_led;
    
    wire new_clk;
    clk_div clk_div(clk,rst,new_clk);
    assign clk_led = new_clk;
    
endmodule