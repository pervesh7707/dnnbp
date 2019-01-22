////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Sigmoid Activation Module
// File Name        : act_sigmoid.v
// Version          : 3.0
// Description      : Module with NUM inputs, NUM weight, and 1 bias.
//                    Using Sigmoid function.
//
////////////////////////////////////////////////////////////////////////////////

module act_sigmoid (clk, rst, acc_x, acc_h, i_x, i_w, i_h, i_u, i_b, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input acc_x, acc_h;

// input ports
input signed [WIDTH-1:0] i_x;
input signed [WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_h;
input signed [WIDTH-1:0] i_u;
input signed [WIDTH-1:0] i_b;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] o_mac_1;
wire signed [WIDTH-1:0] o_mac_2;


// Two MAC module for x*w and h*u
mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_x (
		.clk (clk),
		.rst (rst),
		.acc (acc_x),
		.i_x (i_x),
		.i_m (i_w),
		.o   (o_mac_1)
	);

mac #(
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) mac_h (
		.clk (clk),
		.rst (rst),
		.acc (acc_h),
		.i_x (i_h),
		.i_m (i_u),
		.o   (o_mac_2)
	);


// Adding all multiplier output & bias
adder_3in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_adder_3in (.i_a(o_mac_1), .i_b(o_mac_2), .i_c(i_b), .o(o_add));

// Using sigmoid function for the Activation value
sigmf sigmoid (.i(o_add), .o(o));

endmodule