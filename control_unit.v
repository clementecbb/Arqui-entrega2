// control_unit.v
module control_unit(
  input  [6:0] opcode,
  input  [3:0] flags_status, // {Z, N, C, V} desde status.v
  output       L_PC,         // load de PC
  output       D_W,          // write enable hacia Data Memory
  output       SD,           // selector de MUX data
  output       LA,           // load de regA
  output       LB,           // load de regB
  output [1:0] SA,           // selector de Mux A
  output [1:0] SB,           // selector de Mux B
  output [2:0] S_alu         // selector de la ALU (3 bits)
);
  // para instrucciones basicas, los siguientes tres valores no importan
  reg       l_pc_r = 0;
  reg       d_w_r = 0;
  reg       sd_r = 0;

  reg       la_r = 0;
  reg       lb_r = 0;
  reg [1:0] sa_r = 2'b00;  // regA por default
  reg [1:0] sb_r = 2'b00;  // regB por default
  reg [2:0] s_r = 3'b000;  // ADD por default

  /* ============= OPCODE DECODER =============*/
  always @* begin
    // defaults en cada modificacion de inputs 
    // (recordar que Control Unit es combinacional)
    l_pc_r = 0;
    d_w_r = 0;
    sd_r = 0;

    la_r = 0; 
    lb_r = 0;
    sa_r = 2'b00; 
    sb_r = 2'b00;
    s_r  = 3'b000; // ADD por defecto

    case (opcode)

    /* ==========================================================
    =================== INSTRUCCIONES BASICAS ===================
    ============================================================= 
    */

      /* ========== MOV ========== */
        // se usa OR para seleccionar el valor que se quiere mover.
        
        // ya que solo B puede ser el literal k8,
        // entonces A siempre sera 0 (sel=11 en el MUX de A) cuando se quiere mover un literal
        
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
        sa_r = 2'b00;   // A
        sb_r = 2'b11;   // 0
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
        sa_r = 2'b10;   // 1
        sb_r = 2'b00;   // B
        s_r  = 3'b000;  // ADD
      end


    /* ===========================================================
    ============= INSTRUCCIONES CON DIRECCIONAMIENTO =============
    ==============================================================
    */

      /* ========== MOV (DIR)  ========== */
      7'b0100101: begin // MOV A,(Dir) (A=Mem[Lit])
        sd_r = 0;       // Dir=Lit
        la_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b011;  // OR (pasa Mem[Dir])
      end

      7'b0100110: begin // MOV B,(Dir) (B=Mem[Lit])
        sd_r = 0;       // Dir=Lit
        lb_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b011;  // OR (pasa Mem[Dir])
      end

      7'b0100111: begin // MOV (Dir),A (Mem[Lit]=A)
        d_w_r = 1;      // data Write enabled
        sd_r  = 0;      // Dir=Lit
        sa_r  = 2'b00;  // A
        sb_r  = 2'b11;  // 0
        s_r   = 3'b011; // OR (pasa A)
      end

      7'b0101000: begin // MOV (Dir),B
        d_w_r = 1; 
        sd_r = 0;       // Dir=Lit
        sa_r = 2'b11;   // 0
        sb_r = 2'b00;   // B
        s_r  = 3'b011;  // OR (pasa B)
      end

      7'b0101001: begin // MOV A,(B)
        sd_r = 1;       // Dir=B
        la_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b011;  // OR (pasa Mem[Dir])
      end

      7'b0101010: begin // MOV B,(B)
        sd_r = 1;       // Dir=B
        lb_r = 1;
        sa_r = 2'b11;   // 0
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b011;  // OR (pasa Mem[Dir])
      end

      7'b0101011: begin // MOV (B),A
        d_w_r = 1; 
        sd_r = 1;       // Dir=B
        sa_r = 2'b00;   // A
        sb_r = 2'b11;   // 0
        s_r = 3'b011;   // OR (pasa A)
      end


      /* ========== ADD (DIR) ========== */
      7'b0101100: begin // ADD A,(Dir)
        sd_r = 0;       // Dir=Lit
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b000;  // ADD
      end
      
      7'b0101101: begin // ADD B,(Dir)
        sd_r = 0;       // Dir=Lit
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b000;  // ADD
      end

      7'b0101110: begin // ADD A,(B)
        sd_r = 1;       // Dir=B
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b000;  // ADD
      end

      7'b0101111: begin // ADD(dir) (Mem[Lit]=A+B)
        d_w_r = 1; 
        sd_r  = 0;      // Dir=Lit
        sa_r  = 2'b00;  // A
        sb_r  = 2'b00;  // B
        s_r   = 3'b000; // ADD
      end

      /* ========== SUB (DIR) ========== */
      7'b0110000: begin // SUB A,(Dir)
        sd_r = 0;       // Dir=Lit
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b001;  // SUB
      end

      7'b0110001: begin // SUB B,(Dir)
        sd_r = 0;       // Dir=Lit
        lb_r = 1;
        sa_r = 2'b01;   // B
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b001;  // SUB
      end

      7'b0110010: begin // SUB A,(B)
        sd_r = 1;       // Dir=B
        la_r = 1;
        sa_r = 2'b00;   // A
        sb_r = 2'b01;   // Mem[Dir]
        s_r  = 3'b001;  // SUB
      end

      7'b0110011: begin // SUB(dir) (Mem[Lit]=A-B)
        d_w_r = 1; 
        sd_r = 0;       // Dir=Lit
        sa_r = 2'b00;   // A
        sb_r = 2'b00;   // B
        s_r  = 3'b001;  // SUB
      end

      /* ========== AND (DIR)3'b010 ========== */
      7'b0110100: begin // (A = A AND Mem[Lit])
        sd_r = 0;       // lit
        la_r = 1;
        sa_r = 2'b00;
        sb_r = 2'b01;
        s_r  = 3'b010;
      end
  
      7'b0110101: begin //(B = B and Mem[Lit])
        sd_r = 0;       // lit
        la_r = 0;       // 0 en a
        lb_r = 1;       // 1 en b
        sa_r = 2'b01;   // b en sa
        sb_r = 2'b01;   // mem en sb
        s_r  = 3'b010;
      end
      
      7'b0110110: begin 
        sd_r = 1;
        la_r = 1;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b01;
        s_r  = 3'b010;
      end
      
      7'b0110111: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b00;
        s_r  = 3'b010;
      end

      /* ========== OR (DIR) ========== */

      // OR A,(Dir) 0111000  -> A = A | Mem[Lit]
      7'b0111000: begin
        d_w_r = 0;
        sd_r  = 0;            // address = k8
        la_r  = 1;            // escribir A
        sa_r  = 2'b00;        // regA
        sb_r  = 2'b01;        // Mem[address]
        s_r   = 3'b011;       // OR
      end

      // OR B,(Dir) 0111001  -> B = B | Mem[Lit]
      7'b0111001: begin
        sd_r = 0;            // address = k8
        lb_r = 1;
        sa_r = 2'b01;        // B
        sb_r = 2'b01;        // Mem[address]
        s_r  = 3'b011;
      end

      // OR A,(B) 0111010    -> A = A | Mem[B]
      7'b0111010: begin
        sd_r = 1;            // address = B
        la_r = 1;
        sa_r = 2'b00;        // A
        sb_r = 2'b01;        // Mem[addr]
        s_r  = 3'b011;
      end

      // OR (Dir) 0111011    -> Mem[Lit] = A | B
      7'b0111011: begin
        d_w_r = 1;           // escribir en Mem[Lit]
        sd_r  = 0;           // addr = k8
        sa_r  = 2'b00;       // A
        sb_r  = 2'b00;       // B
        s_r   = 3'b011;      // OR (dato que se escribe = ALU)
      end

      /* ========== NOT (DIR)3'b100 ========== */
      7'b0111100: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b11;
        s_r  = 3'b100;
      end

      7'b0111101: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b01;
        sb_r = 2'b11;
        s_r  = 3'b100;
      end

      7'b0111110: begin 
        d_w_r = 1;
        sd_r = 1;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b11;
        s_r  = 3'b100;
      end
      

      /* ========== XOR (DIR) ========== */
      
      // XOR A,(Dir) 0111111 -> A = A ^ Mem[Lit]
      7'b0111111: begin
        sd_r = 0;                // addr = k8
        la_r = 1;
        sa_r = 2'b00;            // A
        sb_r = 2'b01;            // Mem[addr]
        s_r  = 3'b101;           // XOR
      end

      // XOR B,(Dir) 1000000 -> B = B ^ Mem[Lit]
      7'b1000000: begin
        sd_r = 0;
        lb_r = 1;
        sa_r = 2'b01;            // B (entra por A de la ALU)
        sb_r = 2'b01;            // Mem[addr]
        s_r  = 3'b101;
      end

      // XOR A,(B) 1000001 -> A = A ^ Mem[B]
      7'b1000001: begin
        sd_r = 1;                // addr = B
        la_r = 1;
        sa_r = 2'b00;            // A
        sb_r = 2'b01;            // Mem[addr]
        s_r  = 3'b101;
      end

      // XOR (Dir) 1000010 -> Mem[Lit] = A ^ B
      7'b1000010: begin
        d_w_r = 1;
        sd_r  = 0;
        sa_r  = 2'b00;           // A
        sb_r  = 2'b00;           // B
        s_r   = 3'b101;          // XOR (dato = ALU)
      end

      /* ========== SHL (DIR)3'b110 ========== */
      7'b1000011: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b11;
        s_r = 3'b110;
      end

      7'b1000100: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b01;
        sb_r = 2'b11;
        s_r = 3'b110;
      end

      7'b1000101: begin 
        d_w_r = 1;
        sd_r = 1;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b11;
        s_r = 3'b110;
      end
      /* ========== SHR (DIR) ========== */

      // SHR (Dir),A 1000110 -> Mem[Lit] = A >> 1
      7'b1000110: begin
        d_w_r = 1;
        sd_r  = 0;                // addr = k8
        sa_r  = 2'b00;           // regA
        s_r   = 3'b111;          // SHR
      end

      // SHR (Dir),B 1000111 -> Mem[Lit] = B >> 1
      7'b1000111: begin
        d_w_r = 1;
        sd_r  = 0;
        sa_r  = 2'b01;           // regB
        s_r   = 3'b111;
      end

      // SHR (B) 1001000 -> Mem[B] = A >> 1
      7'b1001000: begin
        d_w_r = 1;
        sd_r  = 1;               // addr = B
        sa_r  = 2'b00;           // regA
        s_r   = 3'b111;
      end

      /* ========== INC (DIR) ========== */
      7'b1001001: begin 
        d_w_r = 1;
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b10;
        sb_r = 2'b01;
        s_r = 3'b000;
      end

      7'b1001010: begin 
        d_w_r = 1;
        sd_r = 1;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b10;
        sb_r = 2'b01;
        s_r = 3'b000;
      end

      /* ========== RST (DIR) ========== */

      // RST (Dir) 1001011 -> Mem[Lit] = 0
      7'b1001011: begin
        d_w_r = 1;
        sd_r  = 0;               // addr = k8
        sa_r  = 2'b11;           // 0
        sb_r  = 2'b11;           // 0
        s_r   = 3'b010;          // AND => 0
      end

      // RST (B) 1001100 -> Mem[B] = 0
      7'b1001100: begin
        d_w_r = 1;
        sd_r  = 1;               // addr = B
        sa_r  = 2'b11;           // 0
        sb_r  = 2'b11;           // 0
        s_r   = 3'b010;          // AND => 0
      end


    /* ===========================================================
    =================== INSTRUCCIONES DE SALTO ===================
    ==============================================================
    */

      /* ========== CMP ========== */
      7'b1001101: begin 
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b00;
        s_r = 3'b001;
      end

      7'b1001110: begin 
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b10;
        s_r = 3'b001;
      end

      7'b1001111: begin 
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b01;
        sb_r = 2'b10;
        s_r = 3'b001;
      end

      7'b1010000: begin 
        sd_r = 0;
        la_r = 0;
        lb_r = 0;
        sa_r = 2'b00;
        sb_r = 2'b01;
        s_r = 3'b001;
      end

      // CMP B,(Dir) 1010001  -> Flags = B - Mem[Lit]
      7'b1010001: begin
        l_pc_r = 0;
        d_w_r  = 0;           // no write
        sd_r   = 0;           // addr = k8 (Dir)
        la_r   = 0;
        lb_r   = 0;
        sa_r   = 2'b01;       // regB
        sb_r   = 2'b01;       // Mem[addr]
        s_r    = 3'b001;      // SUB (actualiza Z,N,C,V)
      end

      // CMP A,(B) 1010010   -> Flags = A - Mem[B]
      7'b1010010: begin
        l_pc_r = 0;
        d_w_r  = 0;
        sd_r   = 1;           // addr = B
        la_r   = 0;
        lb_r   = 0;
        sa_r   = 2'b00;       // regA
        sb_r   = 2'b01;       // Mem[addr]
        s_r    = 3'b001;      // SUB
      end
      


      /* ========== JMP ========== */
      7'b1010011: begin // JMP (PC=Lit)
        l_pc_r = 1;     // load PC
        sa_r = 2'b11;   // 0
        sb_r = 2'b10;   // k8
        s_r  = 3'b011;  // OR (pasa k8)
      end

      /* ========== JEQ ========== */
      7'b1010100: begin // JEQ (PC=Lit) si Z=1
        if (flags_status[3] == 1) begin // Z=1
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JNE ========== */
      7'b1010101: begin // JNE (PC=Lit) si Z=0
        if (flags_status[3] == 0) begin // Z=0
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JGT ========== */
      7'b1010110: begin // JGT (PC=Lit) si Z=0 y N=0
        if ((flags_status[3] == 0) && (flags_status[2] == 0)) begin // Z=0 y N=0
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JLT ========== */
      7'b1010111: begin // JLT (PC=Lit) si N=1
        if (flags_status[2] == 1) begin // N=1
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JGE ========== */
      7'b1011000: begin // JGE (PC=Lit) si N=0
        if (flags_status[2] == 0) begin // N=0
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JLE ========== */
      7'b1011001: begin // JLE (PC=Lit) si Z=1 o N=1
        if ((flags_status[3] == 1) || (flags_status[2] == 1)) begin // Z=1 o N=1
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JCR ========== */
      7'b1011010: begin // JCR (PC=Lit) si C=1
        if (flags_status[1] == 1) begin // C=1
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      /* ========== JOV ========== */
      7'b1011011: begin // JOV (PC=Lit) si V=1
        if (flags_status[0] == 1) begin // V=1
          l_pc_r = 1;     // load PC
          sa_r = 2'b11;   // 0
          sb_r = 2'b10;   // k8
          s_r  = 3'b011;  // OR (pasa k8)
        end
      end

      default: begin
        //nada
      end
    endcase // opcode
  end // always @*

  // asignamiento de outputs a partir de los registros internos
  assign L_PC  = l_pc_r; 
  assign D_W   = d_w_r; 
  assign SD    = sd_r;
  assign LA    = la_r; 
  assign LB    = lb_r; 
  assign SA    = sa_r; 
  assign SB    = sb_r; 
  assign S_alu = s_r;
endmodule
