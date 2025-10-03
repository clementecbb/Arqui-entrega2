//pc.v
module pc(clk, k8, load, pc);
  input         clk;
  input  [7:0]  k8;    // pc = k8 cuando load = 1
  input         load;  // load desde CU para acceder a una instruccion dada
  output [7:0]  pc;

  wire          clk;
  wire   [7:0]  k8;
  wire          load;
  reg    [7:0]  pc;
  
  initial begin
    pc = 0;
  end

  always @(posedge clk) begin
    if (load) begin
      pc <= k8;     // carga directa del literal a pc
    end else begin
      pc <= pc + 1; // ejecucion normal: pc++
    end
  end
endmodule
