// mux2_a.v
module mux2_a(e0, e1, c, out);
  input  [7:0] e0, e1; // A y B, respectivamente
  input        c;
  output [7:0] out;

  reg   [7:0]  out;

  always @* begin
    case (c)
      1'b0: out = e0; // camino 0
      1'b1: out = e1; // camino 1
    endcase
  end
endmodule
