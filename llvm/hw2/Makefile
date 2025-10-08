analyze: run
	rm -rf pics
	mkdir -p pics
	python3 scripts/analyze.py -t trace.log -o pics/O3-opt-1-windows -w 1
	python3 scripts/analyze.py -t trace.log -o pics/O3-opt-1-windows -w 2
	python3 scripts/analyze.py -t trace.log -o pics/O3-opt-1-windows -w 3
	python3 scripts/analyze.py -t trace.log -o pics/O3-opt-1-windows -w 4

run: build 
	rm -f trace.log
	-timeout 3 ./a.out

build: libPass.so
	rm -rf a.out
	clang -fpass-plugin=./libPass.so src/log.c ../hw1/src/app.c ../hw1/src/main.c ../hw1/src/sim.c -lSDL2 -O3

libPass.so: src/pass.cpp
	clang++ src/pass.cpp -fPIC -shared -I$(shell llvm-config --includedir) -o libPass.so
