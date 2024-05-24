`default_nettype none
`timescale 1ns/1ps

module edge_detect (
    input wire signal,
    input wire clk,
    output wire leading_edge_detect
);

    reg q0, q1, q2;

    always @(posedge clk) begin
       q0 <= signal;
       q1 <= q0;
       q2 <= q1;
    end

    assign leading_edge_detect = q1 & (q2 != q1);   // leaving the leading edges

endmodule