// EEM16 - Logic Design
// Design Assignment #1 - Problem #1.3
// dassign1_3.v
// Verilog template

// You may define any additional modules as necessary
// Do not change the module or port names of the given stubs

/* Arrays for convenience

  | abcdefghijklmnopqrstuvwxyz  <-- letter
__|___________________________
G | 11111111001001111111000111
F | 11001111001100011010101010
E | 11111101011111110100110001
D | 01111010011100100010111111
C | 11010011110011101011110010
B | 10010011110000011001101011
A | 10001110000010011010000101
^-- display segment
~~~

  | GFEDCBA <-- display segment
__|________
a | 1110111
b | 1111100
c | 1011000
d | 1011110
e | 1111001
f | 1110001
g | 1101111
h | 1110110
i | 0000110
j | 0011110
k | 1111000
l | 0111000
m | 0010101
n | 1010100
o | 1011100
p | 1110011
q | 1100111
r | 1010000
s | 1101101
t | 1000110
u | 0111110
v | 0011100
w | 0101010
x | 1001001
y | 1101110
z | 1011011
^-- letter
*/

// Display driver (procedural verilog)
// IMPORTANT: Do not change module or port names
module display_rom (letter, display);
    input   [4:0] letter;
    output  [6:0] display;
  	reg [6:0] x;
  
  always@(*)begin
    case(letter)
      5'b00000:x=7'b1110111;
      5'b00001:x=7'b1111100;
      5'b00010:x=7'b1011000;
      5'b00011:x=7'b1011110;
      5'b00100:x=7'b1111001;
      5'b00101:x=7'b1110001;
      5'b00110:x=7'b1101111;
      5'b00111:x=7'b1110110;
      5'b01000:x=7'b0000110;
      5'b01001:x=7'b0011110;
      5'b01010:x=7'b1111000;
      5'b01011:x=7'b0111000;
      5'b01100:x=7'b0010101;
      5'b01101:x=7'b1010100;
      5'b01110:x=7'b1011100;
      5'b01111:x=7'b1110011;
      5'b10000:x=7'b1100111;
      5'b10001:x=7'b1010000;
      5'b10010:x=7'b1101101;
      5'b10011:x=7'b1000110;
      5'b10100:x=7'b0111110;
      5'b10101:x=7'b0011100;
      5'b10110:x=7'b0101010;
      5'b10111:x=7'b1001001;
      5'b11000:x=7'b1101110;
      5'b11001:x=7'b1011011;
      default:x=7'b1000000;
    endcase
  end 
  
  assign display = x;
  
endmodule

module mux32_to_1(in,s,out);
    input [31:0] in;
    input [4:0] s;
    output out;
    assign out = in[s];
endmodule

module mux8_to_1(in,s,out);
    input [7:0] in;
    input [2:0] s;
    output out;
    assign out = in[s];
endmodule
  
module mux4_to_1(in,s,out);
    input [3:0] in;
    input [1:0] s;
    output out;
    assign out = in[s];
endmodule

module invertor(in,out);
    input in;
    output out;
    assign out = ~in;
endmodule
    
// Display driver (declarative verilog)
// IMPORTANT: Do not change module or port names
module display_mux (letter, g,f,e,d,c,b,a);
    input   [4:0] letter;
    output  g,f,e,d,c,b,a;
    wire G,F,E,D,C,B,A;
  
  mux32_to_1 driverA(32'b00000010100001011001000001110001,letter,A);
  mux32_to_1 driverB(32'b00000011010110011000001111001001,letter,B);
  mux32_to_1 driverC(32'b00000001001111010111001111001011,letter,C);
  mux32_to_1 driverD(32'b00000011111101000100111001011110,letter,D);
  mux32_to_1 driverE(32'b00000010001100101111111010111111,letter,E);
  mux32_to_1 driverF(32'b00000001010101011000110011110011,letter,F);
  mux32_to_1 driverG(32'b11111111100011111110010011111111,letter,G);
  
  /*wire [3:0] outA;
  
  mux8_to_1 driverA_layer1_1(8'b00000010,letter[4:2],outA[3]);
  mux8_to_1 driverA_layer1_2(8'b10000101,letter[4:2],outA[2]);
  mux8_to_1 driverA_layer1_3(8'b10010000,letter[4:2],outA[1]);
  mux8_to_1 driverA_layer1_4(8'b01110001,letter[4:2],outA[0]);
  
  mux4_to_1 driverA_layer2_1(outA,letter[1:0],A);
  
  wire [3:0] outG;
  
  mux8_to_1 driverG_layer1_1(8'b11111111,letter[4:2],outG[3]);
  mux8_to_1 driverG_layer1_2(8'b10001111,letter[4:2],outG[2]);
  mux8_to_1 driverG_layer1_3(8'b11100100,letter[4:2],outG[1]);
  mux8_to_1 driverG_layer1_4(8'b11111111,letter[4:2],outG[0]);
  
  mux4_to_1 driverG_layer2_1(outG,letter[1:0],G);*/
  
  invertor in1(A,a);
  invertor in2(B,b);
  invertor in3(C,c);
  invertor in4(D,d);
  invertor in5(E,e);
  invertor in6(F,f);
  invertor in7(G,g);
  
endmodule
