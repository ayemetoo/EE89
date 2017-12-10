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

`include "constants3.vh"

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

module partial_product (a, b, pp);
    // your code here
    // Include a propagation delay of #1
    // assign #1 pp = ... ;

    input [15:0] a;
    input [7:0] b;
    output [15:0] pp;

    assign #1 pp = {(16){b[0]}} & a;
endmodule

module is_done (a, b, done);
    // your code here
    // Include a propagation delay of #4
    // assign #4 done = ... ;

    input [15:0] a;
    input [7:0] b;
    output done;

    assign #4 done = ~(|b);
endmodule

// 8 bit unsigned multiply (structural Verilog)
module multiply (clk, ain, bin, reset, prod, ready);
    input clk;
    input [7:0] ain, bin;
    input reset;
    output [15:0] prod;
    output ready;

    // your code here
    // do not use any delays!
    wire [15:0] a_d, a_q, a, acc_d, acc_q, acc;
    wire [7:0] b_d, b_q, b;
    wire done_d;
    wire [15:0] pp;

    mux2 #(16)   mux_a(a_q, {{8{a[7]}}, ain}, reset, a);
    mux2 #(8)    mux_b(b_q, bin, reset, b);
    mux2 #(16)   mux_acc(prod, 16'b0, reset, acc);

    shl #(16)   shl(a, a_d);
    shr #(8)    shr(b, b_d);

    partial_product pp1(a, b, pp);
    adder16         adder(acc, pp, acc_d);

    is_done         done1(a_d, b_d, done_d);

    dreg #(16)  dreg_a(clk, a_d, a_q);
    dreg #(8)   dreg_b(clk, b_d, b_q);
    dreg #(16)  dreg_acc(clk, acc_d, prod);
    dreg #(1)   dreg_done(clk, done_d, ready);
endmodule

module pulse_width(clk, in, pwidth, long, type, new);
    parameter width = 8;
    input clk, in;
    output [width-1:0] pwidth;
    output long, type, new;

    // your code here
    // do not use any delays!

    wire [width-1:0] pwidth_d;
    wire type_d, long_d, new_d;

    assign new_d = type ^ in;
    assign pwidth_d = new_d ? 1 : (pwidth + 1);
    assign long_d = pwidth_d > `THRESHOLD;
    assign type_d = in;

    dreg #(1)     dreg_new(clk, new_d, new);
    dreg #(width) dreg_pwidth(clk, pwidth_d, pwidth);
    dreg #(1)     dreg_long(clk, long_d, long);
    dreg #(1)     dreg_type(clk, type_d, type);
endmodule

module shift4(clk, in, cmd, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input [`CMD_WIDTH-1:0] cmd;
    output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!

    wire [width-1:0] out3_d, out2_d, out1_d, out0_d;

    mux4 #(width) mux4_3({(width){1'b0}}, out2, out3, out3, cmd, out3_d);
    mux4 #(width) mux4_2({(width){1'b0}}, out1, out2, out2, cmd, out2_d);
    mux4 #(width) mux4_1({(width){1'b0}}, out0, out1, out1, cmd, out1_d);
    mux4 #(width) mux4_0(in, in, in, out0, cmd, out0_d);

    dreg #(width) dreg_3(clk, out3_d, out3);
    dreg #(width) dreg_2(clk, out2_d, out2);
    dreg #(width) dreg_1(clk, out1_d, out1);
    dreg #(width) dreg_0(clk, out0_d, out0);

endmodule

module control_fsm(clk, long, type, cmd, done);
    input clk, long, type;
    output [`CMD_WIDTH-1:0] cmd;
    reg [`CMD_WIDTH-1:0] cmd;
    output done;

    // your code here
    // do not use any delays!

    wire [`STATE_WIDTH-1:0] state;

    reg [`STATE_WIDTH-1:0] state_d;
    reg done_d;

    dreg #(2) dreg_state(clk, state_d, state);
    dreg #(1) dreg_done(clk, done_d, done);

    always @(*) begin
        case (state)

            // A complete letter has been received
            `STATE_DONE: begin
                // Don't change the shift register
                done_d = 0;
                if (type) begin
                    cmd = `CMD_CLEAR;
                    state_d = `STATE_UPDATE;
                end else begin
                    cmd = `CMD_CLEAR;
                    state_d = `STATE_DONE;
                end
            end

            `STATE_UPDATE: begin
                done_d = 0;
                if (type) begin
                    state_d = `STATE_UPDATE;
                    cmd = `CMD_UPDATE;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                end
            end

            `STATE_LOAD: begin
                done_d = 0;
                if (type) begin
                    state_d = `STATE_UPDATE;
                    cmd = `CMD_UPDATE;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                end
            end

            default: begin
                if (type) begin
                    state_d = `STATE_LOAD;
                    cmd = `CMD_LOAD;
                    done_d = 0;
                end else if (long) begin
                    state_d = `STATE_DONE;
                    cmd = `CMD_HOLD;
                    done_d = 1;
                end else begin
                    state_d = `STATE_HOLD;
                    cmd = `CMD_HOLD;
                    done_d = 0;
                end
            end
        endcase
    end

endmodule

module deserializer(clk, in, out3, out2, out1, out0, done);
    parameter width = 8;
    input clk, in;
    output [width-1:0] out3, out2, out1, out0;
    output done;

    wire [width-1:0] pwidth;
    wire long, type, new;
    wire [`CMD_WIDTH-1:0] cmd;

    pulse_width pulse_width(clk, in, pwidth, long, type, new);
    control_fsm control(clk, long, type, cmd, done);
    shift4 #(8) shift4(clk, pwidth, cmd, out3, out2, out1, out0);

endmodule

/*EE 89*/
//displaying
module display_deserializer(clk, rst, in, refresh, real_clk, done, cur_digit, seg);
    input clk;
    input in; //set via switches (left)
    input rst; //set via switches, left right
    output refresh, real_clk;
    output done;
  	output [3:0] cur_digit; reg [3:0] cur_digit;
  	output [6:0] seg; reg [6:0] seg;
  	
  	//deserializer
  	wire [7:0] out3, out2, out1, out0;
  	reg [3:0] bin3, bin2, bin1, bin0;
    display_clk shifty_clk(clk,rst,real_clk);
  	deserializer deserializer(real_clk, in, out3, out2, out1, out0, done);
  	//getting lower 4 bits
  	//get update from shift every 0.33s
  	always @ (posedge(real_clk), posedge(rst))
  	begin
  	    bin3 <= rst ? 0 : out3[3:0];
        bin2 <= rst ? 0 : out2[3:0];
        bin1 <= rst ? 0 : out1[3:0];
        bin0 <= rst ? 0 : out0[3:0];
  	end
  	//refresh rate
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