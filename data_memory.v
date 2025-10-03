// data_memory.v
module data_memory(clk, data_in, address, w, data_out);
  input            clk;
  input      [7:0] data_in;  // output de la ALU
  input      [7:0] address;  // output de mux_data (k8 o regB)
  input            w;        // señal D_W (write enable) saliente de CU
  output     [7:0] data_out; // valor leido desde la memoria en la address dada

  wire [7:0] data_in, address;
  wire       w;

  // memoria 
  reg  [7:0]   mem [0:255];

  // asumimos que lectura es asincrona
  assign data_out = mem[address];
  
  // escritura es sincrona!!!
  always @(posedge clk) begin
    if (w) mem[address] <= data_in;
  end
endmodule