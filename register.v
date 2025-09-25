// register.v
module register(clk, data, load, out);
   input clk, load;
   input  [7:0] data;
   output [7:0] out;

   wire         clk, load;
   wire  [7:0]  data;
   reg   [7:0]  out;

   initial out = 8'b0;

   always @(posedge clk) begin
     if (load) out <= data;
   end
endmodule
