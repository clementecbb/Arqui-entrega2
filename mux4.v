// mux4.v
// MUX de 4 entradas de 8 bits
module mux4(e0, e1, e2, e3, sel, out);
  input      [7:0] e0, e1, e2, e3;
  input      [1:0] sel; // selector de 2 bits
  output reg [7:0] out;
  
  wire  [7:0]  e0, e1, e2, e3;
  wire  [1:0]  sel;
  
  /* para MUX A:
    sel=00: out = regA
    sel=01: out = regB
    sel=10: out = numero 1 en 8 bits
    sel=11: out = numero 0 en 8 bits
  */
  
  /* para MUX B:
    sel=00: out = regB
    sel=01: out = valor leido en la memoria de datos de 8 bits (out de Data Memory)
    sel=10: out = k8 (literal; los 8 LSBs salientes de Instruction Memory)
    sel=11: out = numero 0 en 8 bits
  */

  always @* begin
    case(sel)
      2'b00: out = e0;
      2'b01: out = e1;
      2'b10: out = e2;
      2'b11: out = e3;

      default: out = 8'b00000000;
    endcase // sel
  end // always @*
endmodule
