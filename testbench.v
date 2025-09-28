// testbench.v
module test;
  reg clk = 0;
  wire [7:0] alu_out_bus;

  computer Comp(.clk(clk), .alu_out_bus(alu_out_bus));

  initial begin
    $dumpfile("out/dump.vcd");
    $dumpvars(0, test);

    $readmemb("im.dat", Comp.IM.mem);

    $display("mem[0] = %h", Comp.IM.mem[0]);
    $display("mem[1] = %h", Comp.IM.mem[1]);
    $display("mem[2] = %h", Comp.IM.mem[2]);
    $display("mem[3] = %h", Comp.IM.mem[3]);
    $display("mem[4] = %h", Comp.IM.mem[4]);
    $display("mem[5] = %h", Comp.IM.mem[5]);
    $display("mem[6] = %h", Comp.IM.mem[6]);
    $display("mem[7] = %h", Comp.IM.mem[7]);
    $display("mem[8] = %h", Comp.IM.mem[8]);
    $display("mem[9] = %h", Comp.IM.mem[9]);
    $display("mem[10] = %h", Comp.IM.mem[10]);
    $display("mem[11] = %h", Comp.IM.mem[11]);
    $display("mem[12] = %h", Comp.IM.mem[12]);
    
    $display("\npd: esta bien que mem[11] y mem[12] sean xxxx, ya que no hay mas de 10 instrucciones cargadas en im.dat\n");

    $monitor(
      "At %t | pc=%0d | im=%b | regA=0x%h | regB=0x%h | alu_out=0x%h",
      $time, Comp.pc_out_bus, Comp.im_out_bus,
      Comp.regA_out_bus, Comp.regB_out_bus, alu_out_bus
    );

    wait (Comp.PC.pc == 11);
    #2;
    $finish;
  end // initial

  always #1 clk = ~clk;
endmodule
