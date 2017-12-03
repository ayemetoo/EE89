// EEM16 - Logic Design
// Design Assignment #2 - Problem #2.2
// dassign2_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs

`include "constants2_2.vh"

// ***************
// Building blocks
// ***************

// D-register (flipflop).  Width set via parameter.
// Includes propagation delay t_PD = 3
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= #3 d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign #3 y = sel ? b : a;
endmodule

// 4-1 Mux.  Width set via parameter.
// Includes propagation delay t_PD = 3
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= #3 a;
            2'b01:    y <= #3 b;
            2'b10:    y <= #3 c;
            default:  y <= #3 d;
        endcase
    end
endmodule

// ****************
// Blocks to design
// ****************

//Adds 1 to the input if cond = 1, else does nothing.
module cond_add (cond, in, out);
	parameter width = 8;
	input cond;
	input [width-1:0] in;
	output [width-1:0] out;
	
	assign out = cond ? (in + 1) : in;
endmodule
    
// Evaluates incoming pulses/gaps 
// Use any combination of declarative or structural verilog
// IMPORTANT: Do not change module or port names
module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;

    // your code here
    // do not use any delays!
	//regs and wires
  	wire current;
  	wire [width-1: 0] cur_pwidth, mux_pwidth;
  
  	//use two dregs to clk the widths
  	dreg cur(clk, in, current);
	
	//set new to whether previous is diff from current
  	assign new = (current != in);
	
  	//reset pwidth if new, else continue
  	mux2 #(8) mux_width(pwidth, 8'b00000001, new, mux_pwidth);
	//dreg for timing
  	dreg #(8) reg_width(clk,mux_pwidth, cur_pwidth);
	//update width if nothing new
	cond_add update_width(!new, cur_pwidth, pwidth);
	
    //if pwidth is greater than short than long, else short
  	assign long = new ? ((pwidth > `THRESHOLD) ? 1 : 0) : 0;
  	
  	//just set type to current 
	assign type = new ? current : 0;
endmodule

// Four valued shift-register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
  	output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!
  	//wires and regs
  	wire [width-1:0] mux_in, mux_3, mux_2, mux_1;
  
  	//four eight-width d regs
  	dreg #(width) reg_0(clk, mux_in, out0);
  	dreg #(width) reg_1(clk, mux_1, out1);
  	dreg #(width) reg_2(clk, mux_2, out2);
  	dreg #(width) reg_3(clk, mux_3, out3);
  
  	//4-1 mux for each reg            
  	mux4 #(width) reg_mux_0(1'b0, in, out0, out0, cmd, mux_in);
  	mux4 #(width) reg_mux_1(1'b0, out0, out1, out1, cmd, mux_1);
  	mux4 #(width) reg_mux_2(1'b0, out1, out2, out2, cmd, mux_2);
  	mux4 #(width) reg_mux_3(1'b0, out2, out3, out3, cmd, mux_3);
endmodule

// Control FSM for shift register
// Use any combination of declarative or structural verilog
//    or procedural verilog, provided it obeys rules for combinational logic
// IMPORTANT: Do not change module or port names
module control_fsm(clk, long, type, cmd, done);
    input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    output done;

    // your code here
    // do not use any delays!
  //make shift hold until valid input--> when type changes
  //wires and regs
  wire curren;
  wire valid;
  //dreg for type
  dreg reg_type(clk, type, curren);
  assign valid = type != curren;
  
  //done if long and the type is 0
  assign done = long & (!type);
  mux4 #(2) mux_cmd(2'b10, 2'b00, 2'b01, 2'b01, {type, long}, cmd);

endmodule

// Input de-serializer
// Use structural verilog only
// IMPORTANT: Do not change module or port names
module deserializer(clk, in, out3, out2, out1, out0, done);
    parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;

    // your code here
    // do not use any delays!
  	//wires and regs
  	wire long, type, new, cur_in;
  	wire [width-1:0] pwidth, cur_pwidth;
  	wire [1:0] cmd;
  	dreg reg_in(clk, in, cur_in);
  	pulse_width pulse_width(clk, cur_in, pwidth, long, type, new);
	control_fsm control_fsm(clk, long, type, cmd, done);
  	//dreg #(8) reg_pwidth(clk, pwidth, cur_pwidth);
  	shift4 #(8) shift4(clk, pwidth, cmd, out3, out2, out1, out0);
endmodule

/*EE 89*/
//Clocking
/* The meaty bit */

//displaying
module display_values(clk, rst, in, cmd, refresh, shift_clk, cur_digit, seg);
    input clk;
    input [7:0] in; //set via switches (left)
    input rst; //set via switches, left right
    input [`CMD_WIDTH-1:0] cmd; //set commands via switches (right)
    output refresh, shift_clk;
  	output [3:0] cur_digit; reg [3:0] cur_digit;
  	output [6:0] seg; reg [6:0] seg;
  	
  	//shifting
  	wire [7:0] out3, out2, out1, out0;
  	reg [3:0] bin3, bin2, bin1, bin0;
  	
    display_clk shifty_clk(clk,rst,shift_clk);
  	shift4 #(8) shift4(shift_clk, in, cmd, out3, out2, out1, out0);
  	//getting lower 4 bits
  	//get update from shift every 0.33s
  	always @ (posedge(shift_clk), posedge(rst))
  	begin
  	    bin3 <= rst ? 0 : out3[3:0];
        bin2 <= rst ? 0 : out2[3:0];
        bin1 <= rst ? 0 : out1[3:0];
        bin0 <= rst ? 0 : out0[3:0];
  	end
  	//refresh digit every 1ms --> clock with 500000 half_period
  	reg [1:0] refresh_counter;
  	display_clk #(300000) display_clk(clk,rst,refresh);
  	always @ (posedge(refresh), posedge(rst))
  	begin
  	 if (rst==1)
  	     refresh_counter <= 0;
  	 else if (refresh_counter < 3)
  	     refresh_counter <= refresh_counter + 1;
  	else 
  	 refresh_counter = refresh_counter + 1;
  	end
  	
  	//choose current digit
  	reg [3:0] cur_value;
  	always @(*)
  	begin
  	 case(refresh_counter)
  	 2'b00: begin //leftmost
  	     cur_digit <= 4'b0111;
  	     cur_value <= bin3;
  	     end
  	 2'b01: begin
  	     cur_digit <= 4'b1011;
         cur_value <= bin2;
         end
     2'b10: begin
        cur_digit <= 4'b1101;
        cur_value <= bin1;
        end
     2'b11: begin //rightmost
        cur_digit <= 4'b1110;
        cur_value <= bin0;
        end
     default: begin
        cur_digit <= 4'b0000;
        cur_value <= 4'b0000;
        end
  	endcase
  	end
  	
  	//display
  	always @(*)
          begin
              case(cur_value)
              4'b0000: seg  = 7'b0000001; // "0"     
              4'b0001: seg  = 7'b1001111; // "1" 
              4'b0010: seg  = 7'b0010010; // "2" 
              4'b0011: seg  = 7'b0000110; // "3" 
              4'b0100: seg  = 7'b1001100; // "4" 
              4'b0101: seg  = 7'b0100100; // "5" 
              4'b0110: seg  = 7'b0100000; // "6" 
              4'b0111: seg  = 7'b0001111; // "7" 
              4'b1000: seg  = 7'b0000000; // "8"     
              4'b1001: seg  = 7'b0000100; // "9" 
              4'b1010: seg  = 7'b0001000; // "A" 
              4'b1011: seg  = 7'b1100000; // "B"     
              4'b1100: seg  = 7'b1110010; // "C" 
              4'b1101: seg  = 7'b1000010; // "D" 
              4'b1110: seg  = 7'b0110000; // "E"     
              4'b1111: seg  = 7'b0111000; // "F" 
              default: seg  = 7'b0000001; // "0"
              
              endcase
          end
  	
endmodule