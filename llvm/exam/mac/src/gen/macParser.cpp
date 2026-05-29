
// Generated from mac.g4 by ANTLR 4.9.2


#include "macVisitor.h"

#include "macParser.h"


using namespace antlrcpp;
using namespace antlr4;

macParser::macParser(TokenStream *input) : Parser(input) {
  _interpreter = new atn::ParserATNSimulator(this, _atn, _decisionToDFA, _sharedContextCache);
}

macParser::~macParser() {
  delete _interpreter;
}

std::string macParser::getGrammarFileName() const {
  return "mac.g4";
}

const std::vector<std::string>& macParser::getRuleNames() const {
  return _ruleNames;
}

dfa::Vocabulary& macParser::getVocabulary() const {
  return _vocabulary;
}


//----------------- MacContext ------------------------------------------------------------------

macParser::MacContext::MacContext(ParserRuleContext *parent, size_t invokingState)
  : ParserRuleContext(parent, invokingState) {
}

std::vector<tree::TerminalNode *> macParser::MacContext::HEXPAIR() {
  return getTokens(macParser::HEXPAIR);
}

tree::TerminalNode* macParser::MacContext::HEXPAIR(size_t i) {
  return getToken(macParser::HEXPAIR, i);
}

tree::TerminalNode* macParser::MacContext::EOF() {
  return getToken(macParser::EOF, 0);
}


size_t macParser::MacContext::getRuleIndex() const {
  return macParser::RuleMac;
}

antlrcpp::Any macParser::MacContext::accept(tree::ParseTreeVisitor *visitor) {
  if (auto parserVisitor = dynamic_cast<macVisitor*>(visitor))
    return parserVisitor->visitMac(this);
  else
    return visitor->visitChildren(this);
}

macParser::MacContext* macParser::mac() {
  MacContext *_localctx = _tracker.createInstance<MacContext>(_ctx, getState());
  enterRule(_localctx, 0, macParser::RuleMac);

#if __cplusplus > 201703L
  auto onExit = finally([=, this] {
#else
  auto onExit = finally([=] {
#endif
    exitRule();
  });
  try {
    enterOuterAlt(_localctx, 1);
    setState(2);
    match(macParser::HEXPAIR);
    setState(3);
    match(macParser::T__0);
    setState(4);
    match(macParser::HEXPAIR);
    setState(5);
    match(macParser::T__0);
    setState(6);
    match(macParser::HEXPAIR);
    setState(7);
    match(macParser::T__0);
    setState(8);
    match(macParser::HEXPAIR);
    setState(9);
    match(macParser::T__0);
    setState(10);
    match(macParser::HEXPAIR);
    setState(11);
    match(macParser::T__0);
    setState(12);
    match(macParser::HEXPAIR);
    setState(13);
    match(macParser::EOF);
   
  }
  catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

// Static vars and initialization.
std::vector<dfa::DFA> macParser::_decisionToDFA;
atn::PredictionContextCache macParser::_sharedContextCache;

// We own the ATN which in turn owns the ATN states.
atn::ATN macParser::_atn;
std::vector<uint16_t> macParser::_serializedATN;

std::vector<std::string> macParser::_ruleNames = {
  "mac"
};

std::vector<std::string> macParser::_literalNames = {
  "", "':'"
};

std::vector<std::string> macParser::_symbolicNames = {
  "", "", "HEXPAIR"
};

dfa::Vocabulary macParser::_vocabulary(_literalNames, _symbolicNames);

std::vector<std::string> macParser::_tokenNames;

macParser::Initializer::Initializer() {
	for (size_t i = 0; i < _symbolicNames.size(); ++i) {
		std::string name = _vocabulary.getLiteralName(i);
		if (name.empty()) {
			name = _vocabulary.getSymbolicName(i);
		}

		if (name.empty()) {
			_tokenNames.push_back("<INVALID>");
		} else {
      _tokenNames.push_back(name);
    }
	}

  static const uint16_t serializedATNSegment0[] = {
    0x3, 0x608b, 0xa72a, 0x8133, 0xb9ed, 0x417c, 0x3be7, 0x7786, 0x5964, 
       0x3, 0x4, 0x12, 0x4, 0x2, 0x9, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 
       0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 
       0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x3, 0x2, 0x2, 0x2, 0x3, 0x2, 
       0x2, 0x2, 0x2, 0x10, 0x2, 0x4, 0x3, 0x2, 0x2, 0x2, 0x4, 0x5, 0x7, 
       0x4, 0x2, 0x2, 0x5, 0x6, 0x7, 0x3, 0x2, 0x2, 0x6, 0x7, 0x7, 0x4, 
       0x2, 0x2, 0x7, 0x8, 0x7, 0x3, 0x2, 0x2, 0x8, 0x9, 0x7, 0x4, 0x2, 
       0x2, 0x9, 0xa, 0x7, 0x3, 0x2, 0x2, 0xa, 0xb, 0x7, 0x4, 0x2, 0x2, 
       0xb, 0xc, 0x7, 0x3, 0x2, 0x2, 0xc, 0xd, 0x7, 0x4, 0x2, 0x2, 0xd, 
       0xe, 0x7, 0x3, 0x2, 0x2, 0xe, 0xf, 0x7, 0x4, 0x2, 0x2, 0xf, 0x10, 
       0x7, 0x2, 0x2, 0x3, 0x10, 0x3, 0x3, 0x2, 0x2, 0x2, 0x2, 
  };

  _serializedATN.insert(_serializedATN.end(), serializedATNSegment0,
    serializedATNSegment0 + sizeof(serializedATNSegment0) / sizeof(serializedATNSegment0[0]));


  atn::ATNDeserializer deserializer;
  _atn = deserializer.deserialize(_serializedATN);

  size_t count = _atn.getNumberOfDecisions();
  _decisionToDFA.reserve(count);
  for (size_t i = 0; i < count; i++) { 
    _decisionToDFA.emplace_back(_atn.getDecisionState(i), i);
  }
}

macParser::Initializer macParser::_init;
