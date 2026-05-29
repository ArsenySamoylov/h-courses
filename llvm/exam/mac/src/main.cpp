#include "gen/macParser.h"
#include "gen/macLexer.h"
#include "gen/macVisitor.h"

#include "antlr4-runtime.h"

#include <iostream>
#include <string>

using namespace antlr4;

int main() {
    while (true) {
        std::string input;

        std::cout << "Enter MAC address: ";
        std::getline(std::cin, input);

        ANTLRInputStream stream(input);

        macLexer lexer(&stream);
        CommonTokenStream tokens(&lexer);

        macParser parser(&tokens);

        parser.removeErrorListeners();

        parser.setErrorHandler(
            std::make_shared<BailErrorStrategy>()
        );

        try {
            parser.mac();

            std::cout << "Valid MAC address\n";
        }
        catch (...) {
            std::cout << "Invalid MAC address\n";
        }

    }
    return 0;
}