// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.2
// dassign1_2.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of these stubs

// Max/argmax (declarative verilog)
// IMPORTANT: Do not change module or port names
module mam (in1_value, in1_label, in2_value, in2_label, out_value, out_label);
    input   [7:0] in1_value, in2_value;
    input   [4:0] in1_label, in2_label;
    output  [7:0] out_value;
    output  [4:0] out_label;
  
  	wire select_signal;
    
  	assign select_signal = in1_value >= in2_value;
  	assign out_value = (select_signal)?in1_value:in2_value;
  	assign out_label = (select_signal)?in1_label:in2_label;
  
endmodule

// Maximum index (structural verilog)
// IMPORTANT: Do not change module or port names
module maxindex(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,out);
    input [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output [4:0] out;
    
  wire [7:0] ov1,ov2,ov3,ov4,ov5,ov6,ov7,ov8,ov9,ov10,ov11,ov12,ov13,ov14,ov15,ov16,ov17,ov18,ov19,ov20,ov21,ov22,ov23,ov24,ov25;
  	wire [4:0] ol1,ol2,ol3,ol4,ol5,ol6,ol7,ol8,ol9,ol10,ol11,ol12,ol13,ol14,ol15,ol16,ol17,ol18,ol19,ol20,ol21,ol22,ol23,ol24;
  
  mam mam_layer1_1(a,5'b00000,b,5'b00001,ov1,ol1);
  mam mam_layer1_2(c,5'b00010,d,5'b00011,ov2,ol2);
  mam mam_layer1_3(e,5'b00100,f,5'b00101,ov3,ol3);
  mam mam_layer1_4(g,5'b00110,h,5'b00111,ov4,ol4);
  mam mam_layer1_5(i,5'b01000,j,5'b01001,ov5,ol5);
  mam mam_layer1_6(k,5'b01010,l,5'b01011,ov6,ol6);
  mam mam_layer1_7(m,5'b01100,n,5'b01101,ov7,ol7);
  mam mam_layer1_8(o,5'b01110,p,5'b01111,ov8,ol8);
  mam mam_layer1_9(q,5'b10000,r,5'b10001,ov9,ol9);
  mam mam_layer1_10(s,5'b10010,t,5'b10011,ov10,ol10);
  mam mam_layer1_11(u,5'b10100,v,5'b10101,ov11,ol11);
  mam mam_layer1_12(w,5'b10110,x,5'b10111,ov12,ol12);
  mam mam_layer1_13(y,5'b11000,z,5'b11001,ov13,ol13);
  
  	mam mam_layer2_1(ov1,ol1,ov2,ol2,ov14,ol14);
  	mam mam_layer2_2(ov3,ol3,ov4,ol4,ov15,ol15);
  	mam mam_layer2_3(ov5,ol5,ov6,ol6,ov16,ol16);
  	mam mam_layer2_4(ov7,ol7,ov8,ol8,ov17,ol17);
  	mam mam_layer2_5(ov9,ol9,ov10,ol10,ov18,ol18);
  	mam mam_layer2_6(ov11,ol11,ov12,ol12,ov19,ol19);
  
  	mam mam_layer3_1(ov14,ol14,ov15,ol15,ov20,ol20);
  	mam mam_layer3_2(ov16,ol16,ov17,ol17,ov21,ol21);
  	mam mam_layer3_3(ov18,ol18,ov19,ol19,ov22,ol22);
  
  	mam mam_layer4_1(ov20,ol20,ov21,ol21,ov23,ol23);
  	mam mam_layer4_2(ov22,ol22,ov13,ol13,ov24,ol24);
  
 	mam mam_layer5(ov23,ol23,ov24,ol24,ov25,out);
  
endmodule