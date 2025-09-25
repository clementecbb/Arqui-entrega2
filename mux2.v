// mux2.v
//A, B, ALU y muxB sean de 8 bits,
module mux2(e0, e1, c, out);
   input  [7:0] e0, e1;
   input        c;
   output [7:0] out;
   
   wire  [7:0]  e0, e1;
   wire         c;
   reg   [7:0]  out;
   
   always @* begin
     case(c)
       1'b0: out = e0;
       1'b1: out = e1;
     endcase
   end
endmodule
