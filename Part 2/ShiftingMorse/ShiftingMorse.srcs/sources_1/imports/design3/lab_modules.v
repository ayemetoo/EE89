// EEM16 - Logic Design
// Design Assignment #3 
// dassign3_modules.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided
//
// The modules you will have to design are at the end of the file
// Do not change the module or port names of these stubs

// Include constants file defining THRESHOLD, CMDs, STATEs, etc.

`include "constants3.vh"

// ***************
// Past lab modules
// ***************

// 5+2 input full adder
module fa5 (a,b,c,d,e,ci0,ci1, 
            co1,co0,s);

    input a,b,c,d,e,ci0,ci1;
    output co1, co0, s;
    // your code here
    // do not use any delays!
    wire s0, s1, c0, c1, cc;
    fa  fa_0( a,  b,   c,  c0,  s0);
    fa  fa_1( d,  e, ci1,  c1,  s1);
    fa  fa_2(s0, s1, ci0,  cc,   s);
    fa  fa_3(c0, c1,  cc, co1, co0);
endmodule

// 5-input 4-bit ripple-carry adder (with carries)
module adder5carry (a,b,c,d,e, ci1, ci0a, ci0b, co1, co0a, co0b, sum);
    input [3:0] a,b,c,d,e;
    input ci1, ci0a, ci0b;
    output [3:0] sum;
    output co1, co0a, co0b;

    wire c00, c01;
    wire c10, c11;
    wire c20;

    fa5  fa5_0(a[0], b[0], c[0], d[0], e[0], ci0a, ci0b,  c01,  c00, sum[0]);
    fa5  fa5_1(a[1], b[1], c[1], d[1], e[1],  c00,  ci1,  c11,  c10, sum[1]);
    fa5  fa5_2(a[2], b[2], c[2], d[2], e[2],  c10,  c01, co0a,  c20, sum[2]);
    fa5  fa5_3(a[3], b[3], c[3], d[3], e[3],  c20,  c11,  co1, co0b, sum[3]);
endmodule

// 5-input 4-bit ripple-carry adder 
module adder5 (a,b,c,d,e, sum);
    input [3:0] a,b,c,d,e;
    // your code here
    // do not use any delays!
    output [6:0] sum;

    wire c21;
    wire c30, c31;
    wire c40;

    adder5carry a5(a,b,c,d,e, 1'b0, 1'b0, 1'b0, c31, c30, c21, sum[3:0]);
    fa   fa_4(c30, c21, 1'b0,    c40, sum[4]);
    fa   fa_5(c40, c31, 1'b0, sum[6], sum[5]);
endmodule

// Max/argmax (declarative verilog)
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
    // your code here

    wire cmp;

    // t_PD 2 per bit
    assign #16 cmp = in1_value < in2_value;

    // t_PD 3 for muxes
    assign #3 out_value = cmp ? in2_value : in1_value;
    assign #3 out_label = cmp ? in2_label : in1_label;
endmodule

module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    // your code here
    // do not use any delays!

    wire [255:0] ins;
    wire [7:0] max;
    wire [159:0] labels;
    
    assign ins = {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,48'b0};
    assign labels = {5'd0, 5'd1, 5'd2, 5'd3, 5'd4,
                     5'd5, 5'd6, 5'd7, 5'd8, 5'd9,
                     5'd10, 5'd11, 5'd12, 5'd13, 5'd14,
                     5'd15, 5'd16, 5'd17, 5'd18, 5'd19,
                     5'd20, 5'd21, 5'd22, 5'd23, 5'd24,
                     5'd25, 30'b0};

    mamn #(32) mam32(ins, labels, max, out);
endmodule

module mamn (ins_value, ins_label, out_value, out_label);
    parameter n = 2;

    localparam vw2 = 8*n-1;
    localparam lw2 = 5*n-1;
    localparam vw1 = 8*(n>>1)-1;
    localparam lw1 = 5*(n>>1)-1;
    localparam vw = 8*(n>>1);
    localparam lw = 5*(n>>1);

    output  [7:0] out_value;
    output  [4:0] out_label;

    input  [vw2:0] ins_value;
    input  [lw2:0] ins_label;

    wire    [vw1:0] in1_value, in2_value;
    wire    [lw1:0] in1_label, in2_label;

    wire  [7:0] out1_value, out2_value;
    wire  [4:0] out1_label, out2_label;

    assign in1_value = ins_value[vw2:vw];
    assign in2_value = ins_value[vw1:0];
    assign in1_label = ins_label[lw2:lw];
    assign in2_label = ins_label[lw1:0];

    generate 
      if (n == 2)
        mam mam(in1_value, in1_label, in2_value, in2_label, out_value, out_label);
      else begin
        mamn #(n>>1) mamn_1(in1_value, in1_label, out1_value, out1_label);
        mamn #(n>>1) mamn_2(in2_value, in2_label, out2_value, out2_label);
        mam mam(out1_value, out1_label, out2_value, out2_label, out_value, out_label);
      end
    endgenerate
endmodule

/*
// Maximum index (structural verilog)
// IMPORTANT: Do not change module or port names
module maxindex(clk,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input clk;
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    // your code here

  	//1st level of mam
  	wire [7:0] out_1_1, out_1_2, out_1_3, out_1_4, out_1_5, out_1_6, out_1_7, out_1_8, out_1_9, out_1_10, out_1_11, out_1_12, out_1_13;
  	wire [4:0] outL_1_1, outL_1_2, outL_1_3, outL_1_4, outL_1_5, outL_1_6, outL_1_7, outL_1_8, outL_1_9, outL_1_10, outL_1_11, outL_1_12, outL_1_13;
    mam mam_1_1(a,5'b00000,b,5'b00001,out_1_1,outL_1_1);
    mam mam_1_2(c,5'b00010,d,5'b00011,out_1_2,outL_1_2);
    mam mam_1_3(e,5'b00100,f,5'b00101,out_1_3,outL_1_3);
  	mam mam_1_4(g,5'b00110,h,5'b00111,out_1_4,outL_1_4);
  	mam mam_1_5(i,5'b01000,j,5'b01001,out_1_5,outL_1_5);
  	mam mam_1_6(k,5'b01010,l,5'b01011,out_1_6,outL_1_6);
  	mam mam_1_7(m,5'b01100,n,5'b01101,out_1_7,outL_1_7);
  	mam mam_1_8(o,5'b01110,p,5'b01111,out_1_8,outL_1_8);
  	mam mam_1_9(q,5'b10000,r,5'b10001,out_1_9,outL_1_9);
  	mam mam_1_10(s,5'b10010,t,5'b10011,out_1_10,outL_1_10);
  	mam mam_1_11(u,5'b10100,v,5'b10101,out_1_11,outL_1_11);
  	mam mam_1_12(w,5'b10110,x,5'b10111,out_1_12,outL_1_12);
  	mam mam_1_13(y,5'b11000,z,5'b11001,out_1_13,outL_1_13);
  	//2nd level of mam
  	wire [7:0] out_2_1, out_2_2, out_2_3, out_2_4, out_2_5, out_2_6;
  	wire [4:0] outL_2_1, outL_2_2, outL_2_3, outL_2_4, outL_2_5, outL_2_6;
  	mam mam_2_1(out_1_1,outL_1_1,out_1_2,outL_1_2,out_2_1,outL_2_1);
  	mam mam_2_2(out_1_3,outL_1_3,out_1_4,outL_1_4,out_2_2,outL_2_2);
  	mam mam_2_3(out_1_5,outL_1_5,out_1_6,outL_1_6,out_2_3,outL_2_3);
  	mam mam_2_4(out_1_7,outL_1_7,out_1_8,outL_1_8,out_2_4,outL_2_4);
  	mam mam_2_5(out_1_9,outL_1_9,out_1_10,outL_1_10,out_2_5,outL_2_5);
  	mam mam_2_6(out_1_11,outL_1_11,out_1_12,outL_1_12,out_2_6,outL_2_6);
  	
  	wire dout_2_1,doutL_2_1,dout_2_2,doutL_2_2,dout_2_3,doutL_2_3,dout_2_4,doutL_2_4,dout_2_5,doutL_2_5,dout_2_6,doutL_2_6;
  	dreg #(78) dreg_mid(clk,{out_2_1,outL_2_1,out_2_2,outL_2_2,out_2_3,outL_2_3,out_2_4,outL_2_4,out_2_5,outL_2_5,out_2_6,outL_2_6}
  	, {dout_2_1,doutL_2_1,dout_2_2,doutL_2_2,dout_2_3,doutL_2_3,dout_2_4,doutL_2_4,dout_2_5,doutL_2_5,dout_2_6,doutL_2_6});
  	//3rd level of mam
  	wire [7:0] out_3_1, out_3_2, out_3_3;
  	wire [4:0] outL_3_1, outL_3_2, outL_3_3;
  	mam mam_3_1(dout_2_1,doutL_2_1,dout_2_2,doutL_2_2,out_3_1,outL_3_1);
  	mam mam_3_2(dout_2_3,doutL_2_3,dout_2_4,doutL_2_4,out_3_2,outL_3_2);
  	mam mam_3_3(dout_2_5,doutL_2_5,dout_2_6,doutL_2_6,out_3_3,outL_3_3);
  	//4th level of mam
  	wire [7:0] out_4_1, out_4_2;
  	wire [4:0] outL_4_1, outL_4_2;
  	mam mam_4_1(out_3_1,outL_3_1,out_3_2,outL_3_2,out_4_1,outL_4_1);
  	mam mam_4_2(out_3_3,outL_3_3,out_1_13,outL_1_13,out_4_2,outL_4_2);
  	//5th level of mam
 	wire [7:0] dontcare;
 	wire dout;
  	mam mam_5(out_4_1,outL_4_1,out_4_2,outL_4_2, dontcare, dout);
  	
  	dreg #(5) dreg_out(clk,dout,out);
    // do not use any delays!
endmodule
*/
module display_rom (letter, display);
    input   [4:0] letter;
    output  [6:0] display;
    reg     [6:0] display;
    // your code here
    // t_PD = 3 for a ROM
    always @(letter) begin
        case (letter)
            5'd0:    display = #3 7'b1110111; // a
            5'd1:    display = #3 7'b1111100; // b
            5'd2:    display = #3 7'b1011000; // c
            5'd3:    display = #3 7'b1011110; // d
            5'd4:    display = #3 7'b1111001; // e
            5'd5:    display = #3 7'b1110001; // f
            5'd6:    display = #3 7'b1101111; // g
            5'd7:    display = #3 7'b1110110; // h
            5'd8:    display = #3 7'b0000110; // i
            5'd9:    display = #3 7'b0011110; // j
            5'd10:   display = #3 7'b1111000; // k
            5'd11:   display = #3 7'b0111000; // l
            5'd12:   display = #3 7'b0010101; // m
            5'd13:   display = #3 7'b1010100; // n
            5'd14:   display = #3 7'b1011100; // o
            5'd15:   display = #3 7'b1110011; // p
            5'd16:   display = #3 7'b1100111; // q
            5'd17:   display = #3 7'b1010000; // r
            5'd18:   display = #3 7'b1101101; // s
            5'd19:   display = #3 7'b1000110; // t
            5'd20:   display = #3 7'b0111110; // u
            5'd21:   display = #3 7'b0011100; // v
            5'd22:   display = #3 7'b0101010; // w
            5'd23:   display = #3 7'b1001001; // x
            5'd24:   display = #3 7'b1101110; // y
            5'd25:   display = #3 7'b1011011; // z
            default: display = #3 7'b1000000; // -
        endcase
    end
endmodule

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

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~3.1~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
// 3.1a) Rectified linear unit
// out = max(0, in/4)
// 16 bit signed input
// 8 bit unsigned output
module relu(in, out);
    input [15:0] in;
    output [7:0] out;

    // your code here
  	assign out = in[15] ? 8'b00000000 : in[9:2]; 
endmodule

// 3.1b) Pipelined 5 input ripple-carry adder
// 16 bit signed inputs
// 1 bit input: valid (when the other inputs are useful numbers)
// 16 bit signed output (truncated)
// 1 bit output: ready (when the output is the sum of valid inputs)
module piped_adder(clk, a, b, c, d, e, valid, sum, ready);
    input clk, valid;
    input [15:0] a, b, c, d, e;
    output [15:0] sum;
    output ready;
  
    // your code here
  	//checking if valid
  	wire [15:0] val_a, val_b, val_c, val_d, val_e;
  	mux2 #(16) mux_a(16'b0,a,valid,val_a);
  	mux2 #(16) mux_b(16'b0,b,valid,val_b);
  	mux2 #(16) mux_c(16'b0,c,valid,val_c);
  	mux2 #(16) mux_d(16'b0,d,valid,val_d);
  	mux2 #(16) mux_e(16'b0,e,valid,val_e);
  	//1st stage: [3:0]
  	//wires and regs
  	wire [2:0] carry_0, carry_0_0;	
  	wire [3:0] sum_0, sum_0_0;
  	//modules
  adder5carry part_0(val_a[3:0],val_b[3:0],val_c[3:0],val_d[3:0],val_e[3:0], 1'b0, 1'b0, 1'b0, carry_0[2], 		carry_0[1], carry_0[0], sum_0);
  	dreg #(4) reg_sum_0_0(clk, sum_0, sum_0_0);
  	dreg #(3) reg_carry_0(clk, carry_0, carry_0_0);
  
  	//2nd stage: [7:4]
  	//wires and regs
  	wire [11:0] a_1, b_1, c_1, d_1, e_1;
  	wire [2:0] carry_1, carry_1_0;	
  	wire [3:0] sum_1, sum_1_0, sum_0_1;
    //modules
  dreg #(60) reg_in_1(clk, {val_a[15:4],val_b[15:4],val_c[15:4],val_d[15:4],val_e[15:4]}, 						{a_1,b_1,c_1,d_1,e_1});
    adder5carry part_1(a_1[3:0],b_1[3:0],c_1[3:0],d_1[3:0],e_1[3:0], carry_0_0[2], 				carry_0_0[1], carry_0_0[0], carry_1[2], carry_1[1], carry_1[0], sum_1);
    dreg #(8) reg_sum_1_0(clk, {sum_1,sum_0_0}, {sum_1_0,sum_0_1});
    dreg #(3) reg_carry_1(clk, carry_1, carry_1_0);
  
  	//3rd stage: [11:8]
  	//wires and regs
  	wire [7:0] a_2, b_2, c_2, d_2, e_2;
  	wire [2:0] carry_2, carry_2_0;	
  	wire [3:0] sum_2, sum_2_0, sum_1_1, sum_0_2;
  	//modules
  	dreg #(40) reg_in_2(clk, {a_1[11:4],b_1[11:4],c_1[11:4],d_1[11:4],e_1[11:4]}, 				{a_2,b_2,c_2,d_2,e_2});
  	adder5carry part_2(a_2[3:0],b_2[3:0],c_2[3:0],d_2[3:0],e_2[3:0], carry_1_0[2], 				carry_1_0[1], carry_1_0[0], carry_2[2], carry_2[1], carry_2[0], sum_2);
 	dreg #(12) reg_sum_2_0(clk, {sum_2,sum_1_0,sum_0_1}, {sum_2_0,sum_1_1,sum_0_2});
  	dreg #(3) reg_carry_2(clk, carry_2, carry_2_0);
  
  	//4rd stage: [15:12]
  	//wires and regs
  	wire [3:0] a_3, b_3, c_3, d_3, e_3;
  	wire [2:0] carry_3, carry_3_0;	
  	wire [3:0] sum_3, sum_3_0, sum_2_1, sum_1_2, sum_0_3;
  	//modules
  	dreg #(20) reg_in_3(clk, {a_2[7:4],b_2[7:4],c_2[7:4],d_2[7:4],e_2[7:4]}, 					{a_3,b_3,c_3,d_3,e_3});
  	adder5carry part_3(a_3[3:0],b_3[3:0],c_3[3:0],d_3[3:0],e_3[3:0], carry_2_0[2], 				carry_2_0[1], carry_2_0[0], carry_3[2], carry_3[1], carry_3[0], sum_3);
    dreg #(16) reg_sum_3_0(clk, {sum_3,sum_2_0,sum_1_1,sum_0_2}, 								{sum_3_0,sum_2_1,sum_1_2,sum_0_3});
    dreg #(3) reg_carry_3(clk, carry_3, carry_3_0);
  assign sum = {sum_3_0,sum_2_1,sum_1_2,sum_0_3};
  	//getting ready
  	wire ready_0, ready_1, ready_2;
  	dreg reg_ready_0(clk, valid, ready_0);
  	dreg reg_ready_1(clk, ready_0, ready_1);
  	dreg reg_ready_2(clk, ready_1, ready_2);
  	dreg reg_ready_3(clk, ready_2, ready);

endmodule

// 3.1c) Pipelined neuron
// 8 bit signed weights, bias (constant)
// 8 bit unsigned inputs 
// 1 bit input: new (when a set of inputs are available)
// 8 bit unsigned output 
// 1 bit output: ready (when the output is valid)
module neuron(clk, w1, w2, w3, w4, b, x1, x2, x3, x4, new, y, ready);
    input clk;
    input [7:0] w1, w2, w3, w4, b;  // signed 2s complement
    input [7:0] x1, x2, x3, x4;     // unsigned
    input new;
    output [7:0] y;                 // unsigned
    output ready;

    // your code here
  	//wires and regs
  	wire [15:0] prod_1, prod_2,prod_3,prod_4, prod_b;
  	wire ready_1, ready_2, ready_3, ready_4, ready_b;
  	wire [15:0] reg_prod_1, reg_prod_2, reg_prod_3, reg_prod_4, reg_prod_b;
  	wire reg_ready_1, reg_ready_2, reg_ready_3, reg_ready_4, reg_ready_b;
  	wire [7:0] reg_b;
  	//multiple w* w/ x*
  	multiply mult_1(clk, w1, x1, new, prod_1, ready_1);
  	multiply mult_2(clk, w2, x2, new, prod_2, ready_2);
  	multiply mult_3(clk, w3, x3, new, prod_3, ready_3);
  	multiply mult_4(clk, w4, x4, new, prod_4, ready_4);
  	multiply mult_b(clk, b, 8'd1, new, prod_b, ready_b);
  	dreg #(85) reg_mult(clk, {prod_1,prod_2,prod_3,prod_4,prod_b, ready_1,ready_2,ready_3,ready_4,ready_b},  {reg_prod_1,reg_prod_2,reg_prod_3,reg_prod_4, reg_prod_b, reg_ready_1,reg_ready_2,reg_ready_3,reg_ready_4,reg_ready_b});
  	//add them all w/ the bias
  	wire valid, ready_5;
  	wire [15:0] sum;
  	wire [15:0] reg_sum;
  	wire reg_ready_5;
  	assign valid = reg_ready_1 && reg_ready_2 && reg_ready_3 && reg_ready_4 && reg_ready_b;
  	piped_adder piped_adder(clk, reg_prod_1,reg_prod_2,reg_prod_3,reg_prod_4,{{8{reg_prod_b[7]}}, reg_prod_b}, valid, sum, ready_5);
  	dreg #(17) reg_add(clk, {sum,ready_5}, {reg_sum,reg_ready_5});
  	//assign output to be zero or the bottom seven bits of the sum using relu
  	relu relu(reg_sum,y);
  	assign ready = reg_ready_5;
endmodule

/*/////////////////////////////////FOR 3.2/////////////////////////////////*/

// 3.2a) Inter-layer module
// four sets of inputs: 8 bit value, 1 bit input ready
// one 1 bit input new (from input layer of neurons)
// four sets of 8 bits output
// one 1 bit output ready
module interlayer(clk, new, in1, ready1, in2, ready2, in3, ready3, in4, ready4,
                  out1, out2, out3, out4, ready_out);
    input clk;
    input new;
    input [7:0] in1, in2, in3, in4;
    input ready1, ready2, ready3, ready4;
    output [7:0] out1, out2, out3, out4;
    output ready_out;

    // your code here
  	
  	//don't do anything until new
  	//if you get ready==1 then you should start holding	
  	wire [7:0] new_in1,new_in2,new_in3,new_in4;
  	assign new_in1 = ready1 ? in1 : 8'd0;
  	assign new_in2 = ready2 ? in2 : 8'd0;
  	assign new_in3 = ready3 ? in3 : 8'd0;
  	assign new_in4 = ready4 ? in4 : 8'd0;
  
  	//hold in the regs until everything is ready
  	wire ready, reg_ready;
  	assign ready = ready1 && ready2 && ready3 && ready4;
  	wire [7:0] mux_out1, mux_out2, mux_out3, mux_out4;
  	mux2 #(8) mux_hold_1(8'b0,new_in1,ready, mux_out1);
  	mux2 #(8) mux_hold_2(8'b0,new_in2,ready,mux_out2);
  	mux2 #(8) mux_hold_3(8'b0,new_in3,ready,mux_out3);
  	mux2 #(8) mux_hold_4(8'b0,new_in4,ready,mux_out4);
  	dreg #(32) reg_out(clk,{mux_out1,mux_out2,mux_out3,mux_out4},{out1,out2,out3,out4}); 
  
  	//assign ready_out = reg_ready && !ready; //ready from 1 to 0
  	dreg #(1) reg_really_ready(clk,ready,reg_ready);
  	wire reg_reg_ready;
  	assign reg_reg_ready = ready && !reg_ready;
  
  	dreg #(1) reg_really_really_ready(clk,reg_reg_ready, ready_out); 
  	
endmodule

