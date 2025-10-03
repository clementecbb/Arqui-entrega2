// mux2.v
// MUX de 2 entradas de 8 bits c/u
module mux2(e0, e1, s, out);
  input  [7:0] e0, e1;
  input        s;
  output [7:0] out;
  
  wire [7:0]   e0, e1;
  wire         s;
  reg  [7:0]   out;

  /*
  Para MUX Data (el MUX anterior al Data Memory):
    s=0: out = k8 (literal; 8 LSBs salientes de IM)
    s=1: out = regB
  */
  
  always @(e0, e1, s) begin
    case(s)
		  'b0: out = e0;
		  'b1: out = e1;
	  endcase
  end

endmodule