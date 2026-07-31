module halfaddertb;
reg A, B;
wire Sum, Carry;

halfadder uut (
    .A(A),
    .B(B),
    .Sum(Sum),
    .Carry(Carry)
);

initial begin
    $dumpfile("halfadder.vcd");
    $dumpvars(0, halfaddertb);

    $display("A B | Sum Carry");
    $monitor("%b %b |  %b    %b", A, B, Sum, Carry);

    A=0; B=0; #10;
    A=0; B=1; #10;
    A=1; B=0; #10;
    A=1; B=1; #10;

    $finish;
end

endmodule
