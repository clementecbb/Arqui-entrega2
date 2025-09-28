// control_unit.v
module control_unit(
  input  [6:0] opcode,
  output       LA,
  output       LB,
  output [1:0] SA,   // selector de Mux A
  output [1:0] SB,   // selector de Mux B
  output [2:0] alu_s // selector de la ALU (3 bits)
);
  // defaults
  reg       la_r = 0;
  reg       lb_r = 0;
  reg [1:0] sa_r = 2'b00;  // regA por default
  reg [1:0] sb_r = 2'b00;  // regB por default

  reg [2:0] s_r = 3'b000;  // ADD por default

  /* ============= OPCODE DECODER =============*/
  always @* begin
    // defaults en cada modificacion de inputs 
    // (recordar que Control Unit es combinacional)
    la_r = 0; 
    lb_r = 0;
    sa_r = 2'b00; 
    sb_r = 2'b00;
    s_r  = 3'b000; // ADD por defecto

    case (opcode)
      /* ========== MOV ========== */
        // se usa OR para seleccionar el valor que se quiere mover.
        
        // ya que solo B puede ser el literal k8,
        // entonces A siempre debe ser 0 (sel=11 en el MUX de A)
        
        // entonces, si se hace 0 OR k8, el resultado es k8
        // y si se hace 0 OR B, el resultado es B, etc.

      7'b0000000: begin // MOV A,B (A=B)
        la_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b00;   // B
        s_r  = 3'b011;  // OR (pasa B)
      end

      7'b0000001: begin // MOV B,A (B=A)
        lb_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b00;   // A
        s_r  = 3'b011;  // OR (pasa A)
      end

      7'b0000010: begin // MOV A,Lit (A=k8)
        la_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b10;   // k8
        s_r  = 3'b011;  // OR (pasa k8)
      end

      7'b0000011: begin // MOV B,Lit (B=k8)
        lb_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b10;   // k8
        s_r  = 3'b011;  // OR (pasa k8)
      end


      /* ========== ADD (000) ========== */
      7'b0000100: begin // ADD A,B (A=A+B)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b000;
      end

      7'b0000101: begin // ADD B,A (B=A+B)
        lb_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b000;
      end

      7'b0000110: begin // ADD A,Lit (A=A+Lit)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b10;   // k8
        s_r  = 3'b000;
      end

      7'b0000111: begin // ADD B,Lit (B=B+Lit)
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8
        s_r  = 3'b000;
      end


      /* ========== SUB (001) ========== */
      7'b0001000: begin // SUB A,B (A=A-B)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b001;
      end

      7'b0001001: begin // SUB B,A (B=A-B)
        lb_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b001;
      end

      7'b0001010: begin // SUB A,Lit (A=A-Lit)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b10;   // k8
        s_r  = 3'b001;
      end

      7'b0001011: begin // SUB B,Lit (B=B-Lit)
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8
        s_r  = 3'b001;
      end


      /* ========== AND (010) ========== */
      7'b0001100: begin // AND A,B (A=A&B)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b010;
      end

      7'b0001101: begin // AND B,A (B=A&B)
        lb_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b010; 
      end

      7'b0001110: begin // AND A,Lit (A=A&Lit)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b10;   // k8
        s_r  = 3'b010;
      end

      7'b0001111: begin // AND B,Lit (B=B&Lit)
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8
        s_r  = 3'b010;
      end


      /* ========== OR (011) ========== */
      7'b0010000: begin // OR A,B (A=A|B)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b011;
      end

      7'b0010001: begin // OR B,A (B=A|B)
        lb_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b011;
      end

      7'b0010010: begin // OR A,Lit (A=A|Lit)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b10;   // k8
        s_r  = 3'b011; 
      end

      7'b0010011: begin // OR B,Lit (B=B|Lit)
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8
        s_r  = 3'b011;
      end


      /* ========== NOT (100) ========= */
        // ya que, en el ALU, NOT siempre agarra el out del MUX en A,
        // entonces sb_r no importa
      7'b0010100: begin // NOT A,A (A=~A)
        la_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b100; 
      end

      7'b0010101: begin // NOT A,B (A=~B)
        la_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b100; 
      end

      7'b0010110: begin // NOT B,A (B=~A)
        lb_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b100; 
      end

      7'b0010111: begin // NOT B,B (B=~B)
        lb_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b100; 
      end


      /* ========== XOR (101) ========== */
      7'b0011000: begin // XOR A,B (A=A^B)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b101; 
      end

      7'b0011001: begin // XOR B,A (B=A^B)
        lb_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b101; 
      end

      7'b0011010: begin // XOR A,Lit (A=A^Lit)
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b10;   // k8
        s_r  = 3'b101;
      end

      7'b0011011: begin // XOR B,Lit (B=B^Lit)
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8
        s_r  = 3'b101; 
      end


      /* ========== SHL (110) ========== */
        // ya que los shifts siempre agarran el out del MUX en A, 
        // entonces sb_r no importa
      7'b0011100: begin // SHL A,A (A=shl(A))
        la_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b110;
      end

      7'b0011101: begin // SHL A,B (A=shl(B))
        la_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b110;
      end

      7'b0011110: begin // SHL B,A (B=shl(A))
        lb_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b110;
      end

      7'b0011111: begin // SHL B,B (B=shl(B))
        lb_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b110;
      end

      /* ========== SHR (111) ========== */
        // ya que los shifts siempre agarran el out del MUX en A, 
        // entonces sb_r no importa
      7'b0100000: begin // SHR A,A (A=shr(A))
        la_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b111;
      end

      7'b0100001: begin // SHR A,B (A=shr(B))
        la_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b111;
      end

      7'b0100010: begin // SHR B,A (B=shr(A))
        lb_r = 1;
        sa_r = 2'b00;   // A
        s_r  = 3'b111;
      end

      7'b0100011: begin // SHR B,B (B=shr(B))
        lb_r = 1;
        sa_r = 2'b01;   // B
        s_r  = 3'b111;
      end


      /* ========== INC ========== */
      7'b0100100: begin // INC B
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b10;   // k8 (donde k=const1)
        s_r  = 3'b000;  // ADD
      end

      default: begin
        //nada
      end
    endcase // opcode
  end // always @*

  // asignamiento de outputs a partir de los registros internos
  assign LA    = la_r; 
  assign LB    = lb_r; 
  assign SA    = sa_r; 
  assign SB    = sb_r; 
  assign alu_s = s_r;
endmodule
