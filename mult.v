`timescale 1ns / 1ps

// combinational multiplier begins

module MUL4(a,b,flag,out_half);
input [3:0] a,b;
input flag;
output [3:0] out_half;
//output [7:0] out;
wire [19:0] w1;
wire [4:0] w2,w3;
wire [7:0] out_;


partial p1(w1[4:0],a,b[0]);
partial p2(w1[9:5],a,b[1]);
partial p3(w1[14:10],a,b[2]);
partial p4(w1[19:15],a,b[3]);
assign out_[0] = w1[0];
RCadder m1(w1[4:1],w1[8:5],w2[3:0],w2[4]);
assign out_[1] = w2[0];
RCadder m2(w2[4:1],w1[13:10],w3[3:0],w3[4]);
assign out_[2] = w3[0];
RCadder m3(w3[4:1],w1[18:15],out_[6:3],out_[7]);

assign out_half = flag ? out_[7:4] : out_[3:0];
endmodule

module partial(out,a,b);
input [3:0] a;
input b;
output [4:0] out;
and(out[0],a[0],b);
and(out[1],a[1],b);
and(out[2],a[2],b);
and(out[3],a[3],b);
assign out[4] = 0;
endmodule

module RCadder(
    input [3:0] a,b,
    output [3:0] sum,
    output cout
    );
wire c0,c1,c2;
FA m1(a[0],b[0],0,c0,sum[0]);
FA m2(a[1],b[1],c0,c1,sum[1]);
FA m3(a[2],b[2],c1,c2,sum[2]);
FA m4(a[3],b[3],c2,cout,sum[3]);
endmodule

module FA(a,b,cin,cout,sum);
input a,b,cin;
output cout, sum;
wire w1,w2,w3;
HA m1(a,b,w1,w2);
HA m2(w1,cin,sum,w3);
or(cout,w2,w3);
endmodule

module HA(a,b,sum,carry);
input a,b;
output sum,carry;
xor(sum,a,b);
and(carry,a,b);
endmodule

