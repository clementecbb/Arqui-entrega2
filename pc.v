//pc.v
module pc(clk, pc);
  input clk;
  output [7:0]  pc;

  reg [7:0]     pc;
  wire          clk;

  initial begin
    pc = 0;
  end

  always @(posedge clk) begin
    pc <= pc + 1;
  end
endmodule
