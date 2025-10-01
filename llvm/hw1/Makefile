all:
	clang src/main.c src/sim.c src/app.c -lSDL2

get_ir:
	mkdir -p llvm_ir
	clang src/app.c -emit-llvm -S -O2 -o llvm_ir/app_O2.ll