`timescale 1ns / 1ps
module top (
    input  logic [31:0] a,   // IEEE 754 floating-point number
    input  logic [31:0] b,   // IEEE 754 floating-point number
    output logic [31:0] sum  // IEEE 754 floating-point sum
);


//Code starts here...

//Register Definition
wire sign_a, sign_b;
wire [7:0] exp_a, exp_b;
logic [23:0] mant_a, mant_b;
logic [7:0] exp_diff;
wire sign_result;
wire greater;
wire overflow, underflow;
logic [7:0] exp_result;
logic [7:0] exp_final = 0;
logic [23:0] mant_a_shifted, mant_b_shifted, mant_result;
logic [24:0] mant_temp;


// Extract sign, exponent, and mantissa
assign sign_a = a[31];
assign sign_b = b[31];
assign exp_a  = a[30:23];
assign exp_b  = b[30:23];
assign mant_a = {1'b1, a[22:0]}; // Implicit leading 1
assign mant_b = {1'b1, b[22:0]}; // Implicit leading 1

assign greater = (exp_a > exp_b)? 1'b1 : ((exp_b > exp_a)? 1'b0 : 1'bz);
wire same_exp = (exp_a == exp_b);
assign exp_diff = greater? (exp_a - exp_b) : (exp_b-exp_a);
assign sign_result = (greater & ~same_exp)? sign_a : ((~greater & ~same_exp)? sign_b : sign_a);
assign exp_result = greater? exp_a : exp_b;

always_comb begin
    if (greater & ~same_exp) begin
        mant_a_shifted = mant_a;
        mant_b_shifted = mant_b >> exp_diff;
    end
    else if (~greater & ~same_exp) begin
        mant_a_shifted = mant_a >> exp_diff;
        mant_b_shifted = mant_b;
    end
    else if(same_exp) begin
        mant_a_shifted = mant_a;
        mant_b_shifted = mant_b;
    end
end


always_comb begin
    if (sign_a == sign_b) begin
        mant_temp = mant_a_shifted + mant_b_shifted;
    end
    else begin
        if (greater & !same_exp) mant_temp = mant_a_shifted - mant_b_shifted;
        else if (!greater & !same_exp) mant_temp = mant_b_shifted - mant_a_shifted;
        else if (same_exp) begin
            if (mant_a > mant_b) mant_temp = mant_a_shifted - mant_b_shifted;
            else if(mant_a < mant_b) mant_temp = mant_b_shifted - mant_a_shifted;
            else if(mant_a == mant_b) mant_temp = 0;
        end
    end
end

assign overflow = (exp_result > 8'hFE);
assign underflow = (exp_result < 8'h01);

always_comb begin
    if (overflow || underflow) begin
        mant_result = 0;
    end
    else begin
        if (mant_temp[24]) begin
            mant_result = mant_temp[24:1];
            exp_final = exp_result + 1;
        end
        else begin
            for (int i = 23; i >= 0; i--) begin
                if (mant_temp[i]) begin
                    mant_result = mant_temp << (23 - i);
                    exp_final = exp_result - (23 - i);
                    break;
                end
            end
        end
    end
end


// Final result
assign sum = {sign_result,exp_final,mant_result[22:0]};
endmodule
