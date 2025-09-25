// control_unit.v
module control_unit(
  input  [8:0] im,           // {c, LB, LA, S1, S0, imm[3:0]}
  output       LA,
  output       LB,
  output       cB,           // select de Mux B
  output       SA,           // select de Mux A
  output [2:0] alu_s         // selector extendido de la ALU (3 bits)
);
  wire c    = im[8];
  wire lb   = im[7];
  wire la   = im[6];
  wire [1:0] S = im[5:4];
  wire [3:0] imm = im[3:0];

  reg [2:0] s3;

  // Señales de carga y selects (passthrough por ahora)
  assign LA = la;
  assign LB = lb;
  assign cB = c;
  assign SA = 1'b0; // por ahora, ALU siempre toma A en la entrada 'a'

  // Decodificación de ALU (3 bits)
  always @* begin
    case (S)
      2'b00: s3 = 3'b000; // ADD
      2'b01: s3 = 3'b001; // SUB
      2'b10: s3 = 3'b010; // AND
      2'b11: begin
        // Especiales sólo si c=1 (inmediato) y dependiendo de imm
        if (c == 1'b1) begin
          case (imm)
            4'b0000: s3 = 3'b101; // NOT A
            4'b0001: s3 = 3'b100; // XOR
            4'b0010: s3 = 3'b110; // SHL A (1)
            4'b0011: s3 = 3'b111; // SHR A (1)
            default: s3 = 3'b011; // OR (por defecto)
          endcase
        end else begin
          s3 = 3'b011; // OR si no es inmediato
        end
      end
      default: s3 = 3'b000;
    endcase
  end

  assign alu_s = s3;
endmodule
