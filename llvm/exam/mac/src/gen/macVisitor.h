
// Generated from mac.g4 by ANTLR 4.9.2

#pragma once


#include "antlr4-runtime.h"
#include "macParser.h"



/**
 * This class defines an abstract visitor for a parse tree
 * produced by macParser.
 */
class  macVisitor : public antlr4::tree::AbstractParseTreeVisitor {
public:

  /**
   * Visit parse trees produced by macParser.
   */
    virtual antlrcpp::Any visitMac(macParser::MacContext *context) = 0;


};

