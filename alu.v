// alu.v
module alu(a, b, s, out);
  input  [7:0] a, b;
  input  [2:0] s;    // selector de operacion (3 bits)
  output [7:0] out;

  wire [7:0]   a, b;
  wire [2:0]   s;
  reg  [7:0]   out;

  always @* begin
    out = 8'b0;
    case (s)
      3'b000: out = a + b;    // ADD
      3'b001: out = a - b;    // SUB
      3'b010: out = a & b;    // AND
      3'b011: out = a | b;    // OR
      3'b100: out = ~a;       // NOT A (ignora b)
      3'b101: out = a ^ b;    // XOR
      3'b110: out = a << 1;   // SHL A (k=1) (ignora b)
      3'b111: out = a >> 1;   // SHR A (k=1, lógico) (ignora b)
      
      default: out = 8'b0;
    endcase // s
  end // always @*
endmodule
