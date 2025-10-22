all:
	clang++ -I$(shell llvm-config --includedir) $(shell llvm-config --cppflags --ldflags --libs) ../hw1/src/sim.c src/main.cpp -lSDL2
