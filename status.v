// status.v
module status(clk, flags_in, flags_out);
  input            clk;
  input      [3:0] flags_in;
  output reg [3:0] flags_out; // {Z,N,C,V} desde MSB->LSB

  wire       clk;
  wire [3:0] flags_in;

  initial begin
    flags_out = 4'b0;
  end

  always @(posedge clk) begin
    flags_out <= flags_in;
  end
endmodule