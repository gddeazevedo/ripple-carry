module half_add(sum, carry, A, B);
	input  A, B;
	output sum, carry;
	
	xor xor1(sum, A, B);   // S = A ^ B
	and and1(carry, A, B); // C = A & B
endmodule


module full_add(sum, carry_out, carry_in, A, B);
	input  carry_in, A, B;
	output sum, carry_out;
	wire   w1, w2, w3;
	
	half_add half1(w1, w2, A, B);          // w1 is sum, w2 is carry
	half_add half2(sum, w3, carry_in, w1); // w3 is carry
	or or1(carry_out, w2, w3);
endmodule


module ripple_add(sums, A, B);
	input  [3:0] A, B;
	output [4:0] sums;
	output carry_out;
	wire   [3:1] carries;

	half_add h(sums[0], carries[1], A[0], B[0]);
	full_add f1(sums[1], carries[2], carries[1], A[1], B[1]);
	full_add f2(sums[2], carries[3], carries[2], A[2], B[2]);
	full_add f3(sums[3], sums[4], carries[3], A[3], B[3]);
endmodule


module main;
	reg  [3:0] A, B;
	wire [4:0] S;
	wire C_out;
	
	ripple_add ripple(S, A, B);
	
	initial
		begin
			A = 4'b1001;
			B = 4'b0111;
			#5; // wait 5 time units
			$display(A,"+",B,"=",S);
			$display("%b ", A, "+ %b = ", B, "%b", S);
		end	
endmodule

