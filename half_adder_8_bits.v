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
    input  [7:0] A, B;
    output [8:0] sums;

    wire [7:0] carry;

    half_add ha0(sums[0], carry[0], A[0], B[0]);
 
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : full_adders
            full_add fa(
                .sum(sums[i]),
                .carry_out(carry[i]),
                .carry_in(carry[i-1]),
                .A(A[i]),
                .B(B[i])
            );
        end
    endgenerate

    assign sums[8] = carry[7];
endmodule


module main;
	reg  [7:0] A, B;
	wire [8:0] S;
	wire C_out;
	
	ripple_add ripple(S, A, B);
	
	initial
		begin
			A = 8'b10101101;
			B = 8'b00111001;
			#5; // wait 5 time units
			$display(A,"+",B,"=",S);
			$display("%b ", A, "+ %b = ", B, "%b", S);
		end	
endmodule

