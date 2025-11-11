APP_FLAGS = -lSDL2
LLVM_INCLUDE = $(shell llvm-config --includedir)
LLVM_FLAGS = $(shell llvm-config --cppflags --ldflags --libs)
ASM_GEN_FLAGS = -I$(LLVM_INCLUDE) $(LLVM_FLAGS) $(APP_FLAGS)

application: app/main.c app/sim.c app/app.c
	clang -o app.out app/main.c app/sim.c app/app.c ${APP_FLAGS}

llvm_ir:
	clang app/app.c -emit-llvm -S -O2 -o app/app_O2.ll

asm2ir_1: src/app_asm_IRgen_1.cpp app/sim.c
	clang++ -o asm_ir_1.out  app/sim.c src/app_asm_IRgen_1.cpp -g -lasan ${ASM_GEN_FLAGS}
	./asm_ir_1.out src/app.s

asm2ir_2: src/app_asm_IRgen_2.cpp app/sim.c
	clang++ -o asm_ir_2.out  app/sim.c src/app_asm_IRgen_2.cpp ${ASM_GEN_FLAGS}
	./asm_ir_2.out src/app.s