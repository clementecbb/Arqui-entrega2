// computer.v
module computer(clk, alu_out_bus);
  input clk;
  output [7:0] alu_out_bus;
  // Recominedo pasar todas estas señales para afuera para poder ser vistas en el waveform

  wire [3:0]   pc_out_bus;
  wire [8:0]   im_out_bus;
  wire [7:0]   regA_out_bus;
  wire [7:0]   regB_out_bus;
  wire [7:0]   muxA_out_bus; // conexion de mux2_a.v
  wire [7:0]   muxB_out_bus;

  // zero-extend del literal de 4 bits a 8
  wire [7:0]   imm8 = {4'b0000, im_out_bus[3:0]};
  
  // señales de control
  wire         LA_sig, LB_sig, cB_sig, SA_sig;
  wire [2:0]   alu_s_sig;

  control_unit CU(
    .im(im_out_bus),
    .LA(LA_sig),
    .LB(LB_sig),
    .cB(cB_sig),
    .SA(SA_sig),
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
    .load(LA_sig), // antes .load(im_out_bus[6])
    .out(regA_out_bus)
  );

  register regB(
    .clk(clk),
    .data(alu_out_bus),
    .load(LB_sig), // antes .load(im_out_bus[7])
    .out(regB_out_bus)
  );

  // Mux A (e0=A, e1=B, c=SA)
  mux2_a muxA(
    .e0(regA_out_bus), 
    .e1(regB_out_bus), 
    .c(SA_sig), // antes .c(SA)
    .out(muxA_out_bus)
  );

  mux2 muxB(
    .e0(regB_out_bus), 
    .e1(imm8),  // antes e1(im_out_bus[3:0]) 
    .c(cB_sig), // antes .c(im_out_bus[8])
    .out(muxB_out_bus)
  );

  // ALU ahora toma 'a' desde muxA_out_bus:
  alu ALU(
    .a(muxA_out_bus), // antes .a(regA_out_bus)
    .b(muxB_out_bus),
    .s(alu_s_sig),    // antes .s(im_out_bus[5:4])
    .out(alu_out_bus)
  );
endmodule
