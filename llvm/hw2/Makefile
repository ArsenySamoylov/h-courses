all: libPass.so
	rm -rf a.out
	clang -fpass-plugin=./libPass.so src/log.c ../hw1/src/app.c ../hw1/src/main.c ../hw1/src/sim.c -lSDL2 -O3

libPass.so: src/pass.cpp
	clang++ src/pass.cpp -fPIC -shared -I$(shell llvm-config --includedir) -o libPass.so
