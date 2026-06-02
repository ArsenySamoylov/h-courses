SIM = simv
TOP = tb_cpu

IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

SRCS = \
	src/tb_cpu.sv \
	src/tb_cpu_branch.sv \
	src/cpu.sv \
	src/control_unit.sv \
	src/hazard_unit.sv \
	src/alu.sv \
	src/imm.sv \
	src/regfile.sv

SVFLAGS = -g2012 -Wall

all: run

build:
	$(IVERILOG) $(SVFLAGS) \
	-s $(TOP) \
	-o $(SIM) \
	-I src/ \
	$(SRCS)

run: build
	$(VVP) $(SIM)

wave: run
	$(GTKWAVE) cpu.vcd

clean:
	rm -f $(SIM) cpu.vcd

rebuild: clean all