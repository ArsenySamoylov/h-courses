ANTLR_FLAGS = -I /usr/include/antlr4-runtime/ -lantlr4-runtime

all: antlr
	rm -rf a.out
	clang++ -g -I src/ src/main.cpp src/gen/*.cpp ${ANTLR_FLAGS}

antlr: mac.g4
	rm -rf src/gen
	antlr4 -Dlanguage=Cpp mac.g4 -o src/gen -visitor -no-listener
