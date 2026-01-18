APP_FLAGS = -lSDL2
ANTLR_FLAGS = -I /usr/include/antlr4-runtime/ -lantlr4-runtime

LLVM_FLAGS = $(shell llvm-config --cppflags --ldflags --libs)

antlr: MiniGo.g4
	rm -r src/gen
	antlr4 -Dlanguage=Cpp MiniGo.g4 -o src/gen -visitor -no-listener

all: antlr
	rm -rf a.out
	clang++ -g src/main.cpp src/sim.c src/gen/*.cpp ${ANTLR_FLAGS} ${APP_FLAGS} ${LLVM_FLAGS} 

