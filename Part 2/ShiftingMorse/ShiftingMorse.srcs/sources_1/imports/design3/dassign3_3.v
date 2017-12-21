// EEM16 - Logic Design
// Design Assignment #3.3
// dassign3_3.v
// Verilog template

// You may define any additional modules as necessary
// Do not delete or modify any of the modules provided

module net(clk, x3, x2, x1, x0, new, a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z, ready);
    input clk;
    input [7:0] x3, x2, x1, x0;
    input new;
    output [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
    output ready;

    reg [39:0] rom [0:29]; // ROM that stores neuron weights
    initial
    begin
    rom[0]= 40'b00000101_00001000_00000101_11111011_00000001;
    rom[1]= 40'b11111101_00000000_11111100_00001100_00000100;
    rom[2]= 40'b00010000_00000000_00000110_00000110_11110101;
    rom[3]= 40'b11111111_00000100_00001010_11111111_11101100;
    
    rom[4]= 40'b11110010_00000011_00000101_11100100_11111011;
    rom[5]= 40'b00000100_11110111_00000111_11101111_11111011;
    rom[6]= 40'b00000011_11110010_00000100_00000000_11111100;
    rom[7]= 40'b00010001_11111110_11101110_00001010_00001010;
    rom[8]= 40'b11111001_00001110_11100111_11111001_00100100;
    rom[9]= 40'b00000000_11110100_00000001_00001010_00000100;
    rom[10]= 40'b00001101_11111000_11101100_00010010_11110011;
    rom[11]= 40'b00001000_11111100_00000001_11111101_00010101;
    rom[12]= 40'b11111101_00000000_00000011_11111100_00100101;
    rom[13]= 40'b00000110_11111100_00000000_00000100_11110011;
    rom[14]= 40'b00001011_00000110_11111101_11111010_11101100;
    rom[15]= 40'b00001111_11111100_11111100_00000000_11111101;
    rom[16]= 40'b11101111_00000000_00000000_00001000_11110000;
    rom[17]= 40'b11110100_11110010_00000000_00010100_00010111;
    rom[18]= 40'b00000111_00000000_11110100_00010000_11100111;
    rom[19]= 40'b00001010_11111001_11111010_00001001_11110010;
    rom[20]= 40'b00000100_00000000_00000100_11110101_11100001;
    rom[21]= 40'b00000010_11111011_11110100_00010101_00001101;
    rom[22]= 40'b00001100_00000010_11110111_00000100_00100100;
    rom[23]= 40'b11011110_00001011_11111000_11110010_11100101;
    rom[24]= 40'b11100011_00000101_00000000_00000000_11100011;
    rom[25]= 40'b11111010_00000000_00001000_11110011_11100100;
    rom[26]= 40'b00000010_00000011_11111011_00001000_11111010;
    rom[27]= 40'b11111101_11111100_00001001_11101101_11110100;
    rom[28]= 40'b11111101_11111010_00000101_00000001_11111000;
    rom[29]= 40'b00001100_11110100_00000001_11111000_11110010;
    end

    // Initialize values in ROM
    //initial $readmemb("./weights_rom", rom);

    wire [7:0] y0, y1, y2, y3;
    wire [7:0] h0, h1, h2, h3;
    wire ready_0, ready_1, ready_2, ready_3, ready_h;
    wire [25:0] ready_out;

    // Input layer of neurons (from 3.1)
    neuron l0n3(clk, rom[0][39:32], rom[0][31:24], rom[0][23:16], rom[0][15:8], rom[0][7:0], x3, x2, x1, x0, new, y3, ready_3);
    neuron l0n2(clk, rom[1][39:32], rom[1][31:24], rom[1][23:16], rom[1][15:8], rom[1][7:0], x3, x2, x1, x0, new, y2, ready_2);
    neuron l0n1(clk, rom[2][39:32], rom[2][31:24], rom[2][23:16], rom[2][15:8], rom[2][7:0], x3, x2, x1, x0, new, y1, ready_1);
    neuron l0n0(clk, rom[3][39:32], rom[3][31:24], rom[3][23:16], rom[3][15:8], rom[3][7:0], x3, x2, x1, x0, new, y0, ready_0);

    // Interlayer module (from 3.2)
    interlayer i2o(clk, new, y3, ready_3, y2, ready_2, y1, ready_1, y0, ready_0, h3, h2, h1, h0, ready_h);

    // Output layer of neurons (from 3.1)
    neuron  l1n0(clk,  rom[4][39:32],  rom[4][31:24],  rom[4][23:16],  rom[4][15:8],  rom[4][7:0], h3, h2, h1, h0, ready_h, a,  ready_out[0]);
    neuron  l1n1(clk,  rom[5][39:32],  rom[5][31:24],  rom[5][23:16],  rom[5][15:8],  rom[5][7:0], h3, h2, h1, h0, ready_h, b,  ready_out[1]);
    neuron  l1n2(clk,  rom[6][39:32],  rom[6][31:24],  rom[6][23:16],  rom[6][15:8],  rom[6][7:0], h3, h2, h1, h0, ready_h, c,  ready_out[2]);
    neuron  l1n3(clk,  rom[7][39:32],  rom[7][31:24],  rom[7][23:16],  rom[7][15:8],  rom[7][7:0], h3, h2, h1, h0, ready_h, d,  ready_out[3]);
    neuron  l1n4(clk,  rom[8][39:32],  rom[8][31:24],  rom[8][23:16],  rom[8][15:8],  rom[8][7:0], h3, h2, h1, h0, ready_h, e,  ready_out[4]);
    neuron  l1n5(clk,  rom[9][39:32],  rom[9][31:24],  rom[9][23:16],  rom[9][15:8],  rom[9][7:0], h3, h2, h1, h0, ready_h, f,  ready_out[5]);
    neuron  l1n6(clk, rom[10][39:32], rom[10][31:24], rom[10][23:16], rom[10][15:8], rom[10][7:0], h3, h2, h1, h0, ready_h, g,  ready_out[6]);
    neuron  l1n7(clk, rom[11][39:32], rom[11][31:24], rom[11][23:16], rom[11][15:8], rom[11][7:0], h3, h2, h1, h0, ready_h, h,  ready_out[7]);
    neuron  l1n8(clk, rom[12][39:32], rom[12][31:24], rom[12][23:16], rom[12][15:8], rom[12][7:0], h3, h2, h1, h0, ready_h, i,  ready_out[8]);
    neuron  l1n9(clk, rom[13][39:32], rom[13][31:24], rom[13][23:16], rom[13][15:8], rom[13][7:0], h3, h2, h1, h0, ready_h, j,  ready_out[9]);
    neuron l1n10(clk, rom[14][39:32], rom[14][31:24], rom[14][23:16], rom[14][15:8], rom[14][7:0], h3, h2, h1, h0, ready_h, k, ready_out[10]);
    neuron l1n11(clk, rom[15][39:32], rom[15][31:24], rom[15][23:16], rom[15][15:8], rom[15][7:0], h3, h2, h1, h0, ready_h, l, ready_out[11]);
    neuron l1n12(clk, rom[16][39:32], rom[16][31:24], rom[16][23:16], rom[16][15:8], rom[16][7:0], h3, h2, h1, h0, ready_h, m, ready_out[12]);
    neuron l1n13(clk, rom[17][39:32], rom[17][31:24], rom[17][23:16], rom[17][15:8], rom[17][7:0], h3, h2, h1, h0, ready_h, n, ready_out[13]);
    neuron l1n14(clk, rom[18][39:32], rom[18][31:24], rom[18][23:16], rom[18][15:8], rom[18][7:0], h3, h2, h1, h0, ready_h, o, ready_out[14]);
    neuron l1n15(clk, rom[19][39:32], rom[19][31:24], rom[19][23:16], rom[19][15:8], rom[19][7:0], h3, h2, h1, h0, ready_h, p, ready_out[15]);
    neuron l1n16(clk, rom[20][39:32], rom[20][31:24], rom[20][23:16], rom[20][15:8], rom[20][7:0], h3, h2, h1, h0, ready_h, q, ready_out[16]);
    neuron l1n17(clk, rom[21][39:32], rom[21][31:24], rom[21][23:16], rom[21][15:8], rom[21][7:0], h3, h2, h1, h0, ready_h, r, ready_out[17]);
    neuron l1n18(clk, rom[22][39:32], rom[22][31:24], rom[22][23:16], rom[22][15:8], rom[22][7:0], h3, h2, h1, h0, ready_h, s, ready_out[18]);
    neuron l1n19(clk, rom[23][39:32], rom[23][31:24], rom[23][23:16], rom[23][15:8], rom[23][7:0], h3, h2, h1, h0, ready_h, t, ready_out[19]);
    neuron l1n20(clk, rom[24][39:32], rom[24][31:24], rom[24][23:16], rom[24][15:8], rom[24][7:0], h3, h2, h1, h0, ready_h, u, ready_out[20]);
    neuron l1n21(clk, rom[25][39:32], rom[25][31:24], rom[25][23:16], rom[25][15:8], rom[25][7:0], h3, h2, h1, h0, ready_h, v, ready_out[21]);
    neuron l1n22(clk, rom[26][39:32], rom[26][31:24], rom[26][23:16], rom[26][15:8], rom[26][7:0], h3, h2, h1, h0, ready_h, w, ready_out[22]);
    neuron l1n23(clk, rom[27][39:32], rom[27][31:24], rom[27][23:16], rom[27][15:8], rom[27][7:0], h3, h2, h1, h0, ready_h, x, ready_out[23]);
    neuron l1n24(clk, rom[28][39:32], rom[28][31:24], rom[28][23:16], rom[28][15:8], rom[28][7:0], h3, h2, h1, h0, ready_h, y, ready_out[24]);
    neuron l1n25(clk, rom[29][39:32], rom[29][31:24], rom[29][23:16], rom[29][15:8], rom[29][7:0], h3, h2, h1, h0, ready_h, z, ready_out[25]);
    assign ready = &(ready_out);
endmodule

// ****************
// Blocks to design
// ****************

// 3.3a) Morse decoder
// 1 bit time-series input 
// 5 bit letter [a=0, ..., z=25] output
// 7 bit 7-segment display output
// 1 bit flag indicating done

module decoder(clk, in, letter, display, done);
  input clk;
  input in;
  output [4:0] letter;
  output [6:0] display;
  output done;

  // your code here
  //deserializer
  wire [7:0] x3, x2, x1, x0, d_x3, d_x2, d_x1, d_x0;
  wire ser_done, d_ser_done, d_in;
  dreg #(1) dreg_in(clk,in,d_in);
  deserializer deserializer(clk, d_in, x3, x2, x1, x0, ser_done);
  dreg #(33) dreg_deser(clk, {x3,x2,x1,x0,ser_done}, {d_x3, d_x2, d_x1, d_x0, d_ser_done});
  //neural net
  wire [7:0] a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z;
  wire [7:0] d_a,d_b,d_c,d_d,d_e,d_f,d_g,d_h,d_i,d_j,d_k,d_l,d_m,
  d_n,d_o,d_p,d_q,d_r,d_s,d_t,d_u,d_v,d_w,d_x,d_y,d_z;
  wire net_ready, d_net_ready;
  net net(clk, d_x3, d_x2, d_x1, d_x0, d_ser_done, a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z, net_ready);
  dreg #(209) dreg_net(clk, {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z, net_ready}, {d_a,d_b,d_c,d_d,d_e,d_f,d_g,d_h,d_i,d_j,d_k,d_l,d_m,d_n,d_o,d_p,d_q,d_r,d_s,d_t,d_u,d_v,d_w,d_x,d_y,d_z, d_net_ready});
  //mam
  wire max_letter;
  maxindex maxindex(d_a,d_b,d_c,d_d,d_e,d_f,d_g,d_h,d_i,d_j,d_k,d_l,d_m,d_n,d_o,d_p,d_q,d_r,d_s,d_t,d_u,d_v,d_w,d_x,d_y,d_z,letter);
  
  //display_rom
  wire [6:0] max_display;
  display_rom display_rom (letter, max_display);
  dreg #(8) dreg_out(clk,{max_display,d_net_ready},{display, done});
  //pipeline properly
  //assign done = 0'b0;
  //flag when done --> appropriate amt of regs after net
endmodule

//EE 89
//shifting
module new_shift4(clk, in, shift, out3, out2, out1, out0);
    parameter width = 1;
    input clk;
    input [width-1:0] in;
    input shift;
    output [width-1:0] out3, out2, out1, out0;

    // your code here
    // do not use any delays!

    wire [width-1:0] out3_d, out2_d, out1_d, out0_d;

    mux2 #(width) mux2_3(out3, out2, shift, out3_d);
    mux2 #(width) mux2_2(out2, out1, shift, out2_d);
    mux2 #(width) mux2_1(out1, out0, shift, out1_d);
    mux2 #(width) mux2_0(out0, in, shift, out0_d);

    dreg #(width) dreg_3(clk, out3_d, out3);
    dreg #(width) dreg_2(clk, out2_d, out2);
    dreg #(width) dreg_1(clk, out1_d, out1);
    dreg #(width) dreg_0(clk, out0_d, out0);

endmodule


//displaying
module display_decoder (clk, in, real_clk, cur_digit, letter, cur_value, display, done);
    input clk;
    input in; //set via button (middle)
    output real_clk;
    output done;
    output [3:0] cur_digit; reg [3:0] cur_digit;
  	output [4:0] letter;
  	output [6:0] cur_value; reg [6:0] cur_value;
  	output [6:0] display;
  	
  	//deserializer
  	wire rst;
    display_clk shifty_clk(clk,rst,real_clk);
  	decoder decoder(real_clk,in,letter,display,done);
  	
  	//refresh rate
  	wire refresh;
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

    //getting input to shift
  	wire done_d,shift;
  	wire [6:0] seg;
  	dreg reg_done(real_clk, done, done_d); 
  	assign shift = !done_d && done; //shift when going from not done to done
  	assign seg = done ? ~display : 7'b1111111;
 
    //choose current digit
    wire [6:0] out3, out2, out1, out0;
    new_shift4 #(7) shift_display(real_clk, seg, shift, out3, out2, out1, out0);
    always @(*)
    begin
        case(refresh_counter)
        2'b00: begin //leftmost
            cur_digit <= 4'b0111;
            cur_value <= out3;
            end
        2'b01: begin
           cur_digit <= 4'b1011;
           cur_value <= out2;
           end
        2'b10: begin
           cur_digit <= 4'b1101;
           cur_value <= out1;
           end
        2'b11: begin //rightmost
           cur_digit <= 4'b1110;
           cur_value <= out0;
           end
        default: begin
           cur_digit <= 4'b0000;
           cur_value <= 7'b0;
           end
        endcase
    end
endmodule
