// testbench_auto.v
`timescale 1ns/1ps

module test;
  // --- Clock ---
  reg clk = 0;
  always #1 clk = ~clk; // periodo 2ns

  // --- Wires a observar ---
  wire [7:0] regA_out;
  wire [7:0] regB_out;
  wire [7:0] alu_out_bus;

  // --- DUT (ajusta el nombre del módulo si difiere) ---
  computer Comp(.clk(clk), .alu_out_bus(alu_out_bus));

  // --- Mapea las salidas de tus registros (ajusta rutas si difieren) ---
  assign regA_out = Comp.regA.out;
  assign regB_out = Comp.regB.out;

  // --- Golden trace esperado tras CADA instrucción (1..57) ---
  // Derivado exactamente del im.dat gigante propuesto.
  integer i;
  reg [7:0] expA [1:57];
  reg [7:0] expB [1:57];

  // Tarea de chequeo
  task check_regs(input integer idx, input [7:0] gotA, input [7:0] gotB, input [7:0] wantA, input [7:0] wantB);
    begin
      if (gotA !== wantA) begin
        $error("Inst %0d: regA mismatch. got=%0d(0x%0h) exp=%0d(0x%0h)", idx, gotA, gotA, wantA, wantA);
      end
      if (gotB !== wantB) begin
        $error("Inst %0d: regB mismatch. got=%0d(0x%0h) exp=%0d(0x%0h)", idx, gotB, gotB, wantB, wantB);
      end
    end
  endtask

  initial begin
    // VCD
    $dumpfile("out/dump.vcd");
    $dumpvars(0, test);

    // Carga de programa
    // Asegúrate de que Comp.IM.mem sea lo bastante grande (>=57 entradas de 15 bits)
    $readmemb("im.dat", Comp.IM.mem);

    // ===== Inicializa golden trace =====
    // Test 0: MOV (1..4)
    expA[1]=8'd42;  expB[1]=8'd0;
    expA[2]=8'd42;  expB[2]=8'd123;
    expA[3]=8'd42;  expB[3]=8'd42;
    expA[4]=8'd42;  expB[4]=8'd42;

    // Test 1: ADD (5..10)
    expA[5]=8'd2;   expB[5]=8'd42;
    expA[6]=8'd2;   expB[6]=8'd3;
    expA[7]=8'd5;   expB[7]=8'd3;
    expA[8]=8'd5;   expB[8]=8'd8;
    expA[9]=8'd15;  expB[9]=8'd8;
    expA[10]=8'd15; expB[10]=8'd28;

    // Test 2: SUB (11..16)
    expA[11]=8'd10; expB[11]=8'd28;
    expA[12]=8'd10; expB[12]=8'd4;
    expA[13]=8'd6;  expB[13]=8'd4;
    expA[14]=8'd6;  expB[14]=8'd254;
    expA[15]=8'd4;  expB[15]=8'd254;
    expA[16]=8'd4;  expB[16]=8'd253;

    // Test 3: AND (17..24)
    expA[17]=8'd240; expB[17]=8'd253;
    expA[18]=8'd240; expB[18]=8'd15;
    expA[19]=8'd0;   expB[19]=8'd15;
    expA[20]=8'd0;   expB[20]=8'd0;
    expA[21]=8'd170; expB[21]=8'd0;
    expA[22]=8'd10;  expB[22]=8'd0;
    expA[23]=8'd10;  expB[23]=8'd240;
    expA[24]=8'd10;  expB[24]=8'd80;   // 0x50

    // Test 4: OR (25..32)
    expA[25]=8'd170; expB[25]=8'd80;
    expA[26]=8'd170; expB[26]=8'd85;
    expA[27]=8'd255; expB[27]=8'd85;
    expA[28]=8'd255; expB[28]=8'd255;
    expA[29]=8'd15;  expB[29]=8'd255;
    expA[30]=8'd255; expB[30]=8'd255;
    expA[31]=8'd255; expB[31]=8'd240;
    expA[32]=8'd255; expB[32]=8'd255;

    // Test 5: NOT (33..37)
    expA[33]=8'd15;  expB[33]=8'd255;
    expA[34]=8'd240; expB[34]=8'd255;
    expA[35]=8'd0;   expB[35]=8'd255;
    expA[36]=8'd0;   expB[36]=8'd255;
    expA[37]=8'd0;   expB[37]=8'd0;

    // Test 6: XOR (38..45)
    expA[38]=8'd170; expB[38]=8'd0;
    expA[39]=8'd170; expB[39]=8'd85;
    expA[40]=8'd255; expB[40]=8'd85;
    expA[41]=8'd255; expB[41]=8'd170;
    expA[42]=8'd240; expB[42]=8'd170;
    expA[43]=8'd255; expB[43]=8'd170;
    expA[44]=8'd255; expB[44]=8'd170;
    expA[45]=8'd255; expB[45]=8'd85;

    // Test 7: SHL (46..50)
    expA[46]=8'd5;   expB[46]=8'd85;
    expA[47]=8'd10;  expB[47]=8'd85;
    expA[48]=8'd170; expB[48]=8'd85;
    expA[49]=8'd170; expB[49]=8'd84;  // 0xAA<<1 -> 0x54 = 84
    expA[50]=8'd170; expB[50]=8'd168; // 84<<1 = 168

    // Test 8: SHR (51..55)
    expA[51]=8'd20;  expB[51]=8'd168;
    expA[52]=8'd10;  expB[52]=8'd168;
    expA[53]=8'd84;  expB[53]=8'd168; // 168>>1 = 84
    expA[54]=8'd84;  expB[54]=8'd42;  // 84>>1 = 42
    expA[55]=8'd84;  expB[55]=8'd21;  // 42>>1 = 21

    // Test 9: INC (56..57)
    expA[56]=8'd84;  expB[56]=8'd8;
    expA[57]=8'd84;  expB[57]=8'd9;

    // ===== Ejecuta y verifica =====
    $display("\n===== RUN & CHECK: 57 instrucciones =====");

    // Espera un poquito para el primer fetch
    // (si tu CPU usa reset, asértalo aquí antes de empezar).
    #0.1;

    for (i = 1; i <= 57; i = i + 1) begin
      // avanza una instrucción (posedge) y samplea un instante después
      @(posedge clk);
      #0.1;
      check_regs(i, regA_out, regB_out, expA[i], expB[i]);
    end

    $display("\n>>>>> TEST COMPLETO (im.dat) FINALIZADO <<<<<\n");
    #2 $finish;
  end

endmodule
