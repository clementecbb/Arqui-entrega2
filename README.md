# Arquitectura de Computadores: Proyecto 2

Este proyecto utiliza un `Makefile` para automatizar la simulación y síntesis del diseño en Verilog.

## Detalles de la Implementación

### Resultado de MUXs segun selector

#### Para MUX A:
- si sel=00: out = regA.
- si sel=01: out = regB.
- si sel=10: out = numero 1 en 8 bits.
- si sel=11: out = numero 0 en 8 bits.
  
#### Para MUX B:
- si sel=00: out = regB.
- si sel=01: out = valor leido en la memoria de datos de 8 bits (out de Data Memory).
- si sel=10: out = k8 (el literal; es decir, los 8 LSBs salientes de Instruction Memory).
- si sel=11: out = numero 0 en 8 bits.

#### Para MUX Data:
- si s=0: out = k8 (literal; 8 LSBs salientes de IM).
- si s=1: out = regB.

## Archivos del Proyecto

* `computer.v`, `testbench.v`, etc.: Los archivos fuente en Verilog para el diseño y su banco de pruebas.
* `yosys.tcl`: El script para la síntesis lógica.
* `Makefile`: El script principal para ejecutar todos los comandos.

## Cómo Ejecutar

Utiliza los siguientes comandos en tu terminal:

| Comando | Descripción |
|---|---|
| `make build` | Compila los archivos en Verilog. |
| `make run` | Ejecuta la simulación. |
| `make wave` | Abre las formas de onda con GTKWave. |
| `make synth` | Ejecuta la síntesis lógica. |
| `make clean` | Elimina todos los archivos generados. |
