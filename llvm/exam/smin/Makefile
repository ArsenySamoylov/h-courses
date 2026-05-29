all:
	clang -S -emit-llvm smin.c
	clang -S -emit-llvm smin.c -O1 -fno-builtin -o smin-O1.ll