// alu.v
module alu(a, b, s, result_out, flags_out);
  input  [7:0] a, b;
  input  [2:0] s;    // selector de operacion (3 bits)
  output [7:0] result_out;
  output [3:0] flags_out; // {z, n, c, v} // zero, negative, carry, overflow

  wire [7:0]   a, b;
  wire [2:0]   s;
  reg  [7:0]   result_out;
  
  // z = 1 si out es 0
  // n = 1 si MSB de out es 1. Indica si numero es negativo en complemento 2
  // c = 1 si hubo carry (solo en suma y resta)
  // v = 1 si hubo overflow (solo en suma y resta)
  reg z, n, c, v;
  reg [8:0] result_with_carry; // 9 bits para detectar carry/borrow

  always @* begin
    // defaults en cada modificacion de inputs
    result_out = 8'b0;
    z = 0;
    n = 0;
    c = 0;
    v = 0;

    // operaciones
    case (s)
      3'b000: begin // ADD
        result_with_carry = {1'b0, a} + {1'b0, b};
        result_out = result_with_carry[7:0];
        c = result_with_carry[8];
        v = (a[7] == b[7]) && (result_out[7] != a[7]);
      end
      
      3'b001: begin // SUB
        result_with_carry = {1'b0, a} - {1'b0, b};
        result_out = result_with_carry[7:0];
        c = ~result_with_carry[8]; // carry es opuesto de borrow xd
        v = (a[7] != b[7]) && (result_out[7] != a[7]);
      end

      3'b010: result_out = a & b;    // AND
      3'b011: result_out = a | b;    // OR
      3'b100: result_out = ~a;       // NOT A (ignora b)
      3'b101: result_out = a ^ b;    // XOR
      3'b110: result_out = a << 1;   // SHL A (k=1) (ignora b)
      3'b111: result_out = a >> 1;   // SHR A (k=1, lógico) (ignora b)
      
      default: result_out = 8'b0;
    endcase // s

    z = (result_out == 8'b0);
    n = result_out[7];
  end // always @*

  assign flags_out = {z, n, c, v};
endmodule
