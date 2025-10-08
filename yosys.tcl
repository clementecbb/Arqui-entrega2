# yosys.tcl
yosys read_verilog computer.v alu.v register.v pc.v mux4.v instruction_memory.v data_memory.v control_unit.v status.v mux2.v

yosys synth
yosys write_verilog out/netlist.v

yosys stat
yosys tee -q -o "out/computer.rpt" stat
