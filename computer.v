// computer.v
module computer(clk, alu_out_bus);
  input clk;
  output [7:0] alu_out_bus;
  
  // Recominedo pasar todas estas señales para afuera para poder ser vistas en el waveform
  wire [7:0]    pc_out_bus;
  wire [7:0]    dm_out_bus = 8'b00000000;  // por ahora 0, ya que Data Memory no se necesita para la primera entrega
  wire [14:0]   im_out_bus;
  
  wire [7:0]    regA_out_bus;
  wire [7:0]    regB_out_bus;
  wire [7:0]    muxA_out_bus;
  wire [7:0]    muxB_out_bus;
  
  // señales de control output-eadas por el control unit
  wire          LA_sig, LB_sig; // loads de 1 bit c/u, evidentemente
  wire [1:0]    SB_sig, SA_sig;
  wire [2:0]    alu_s_sig;

  // cables adicionales de numeros 0 y 1 para MUXs de A y B
  wire [7:0]    const0 = 8'b00000000;
  wire [7:0]    const1 = 8'b00000001;

  // slice de out bus de Instruction Memory para separar opcode y literal
  wire [6:0]    opcode = im_out_bus[14:8]; // 7 MSBs del instruction memory
  wire [7:0]    k8     = im_out_bus[7:0];  // literal; 8 LSBs del instruction memory


  /*======= CABLEADO DE MODULOS =======*/
  control_unit CU(
    .opcode(opcode),
    .LA(LA_sig),
    .LB(LB_sig),
    .SA(SA_sig),
    .SB(SB_sig),
    .alu_s(alu_s_sig)
  );

  pc PC(
    .clk(clk),
    .pc(pc_out_bus)
  );

  instruction_memory IM(
    .address(pc_out_bus),
    .out(im_out_bus)
  );

  register regA(
    .clk(clk), 
    .data(alu_out_bus), 
    .load(LA_sig), 
    .out(regA_out_bus)
  );
  
  register regB(
    .clk(clk), 
    .data(alu_out_bus), 
    .load(LB_sig), 
    .out(regB_out_bus)
  );

  mux4 muxA(
    .e0(regA_out_bus), 
    .e1(regB_out_bus),
    .e2(const1),
    .e3(const0),
    .sel(SA_sig),
    .out(muxA_out_bus)
  );

  mux4 muxB(
    .e0(regB_out_bus), 
    .e1(dm_out_bus),
    .e2(k8),
    .e3(const0),
    .sel(SB_sig),
    .out(muxB_out_bus)
  );

  alu ALU(
    .a(muxA_out_bus),
    .b(muxB_out_bus),
    .s(alu_s_sig),
    .out(alu_out_bus)
  );

endmodule
