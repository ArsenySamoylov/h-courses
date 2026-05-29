
// Generated from mac.g4 by ANTLR 4.9.2

#pragma once


#include "antlr4-runtime.h"
#include "macVisitor.h"


/**
 * This class provides an empty implementation of macVisitor, which can be
 * extended to create a visitor which only needs to handle a subset of the available methods.
 */
class  macBaseVisitor : public macVisitor {
public:

  virtual antlrcpp::Any visitMac(macParser::MacContext *ctx) override {
    return visitChildren(ctx);
  }


};

