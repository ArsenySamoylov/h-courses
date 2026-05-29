
// Generated from mac.g4 by ANTLR 4.9.2


#include "macLexer.h"


using namespace antlr4;


macLexer::macLexer(CharStream *input) : Lexer(input) {
  _interpreter = new atn::LexerATNSimulator(this, _atn, _decisionToDFA, _sharedContextCache);
}

macLexer::~macLexer() {
  delete _interpreter;
}

std::string macLexer::getGrammarFileName() const {
  return "mac.g4";
}

const std::vector<std::string>& macLexer::getRuleNames() const {
  return _ruleNames;
}

const std::vector<std::string>& macLexer::getChannelNames() const {
  return _channelNames;
}

const std::vector<std::string>& macLexer::getModeNames() const {
  return _modeNames;
}

const std::vector<std::string>& macLexer::getTokenNames() const {
  return _tokenNames;
}

dfa::Vocabulary& macLexer::getVocabulary() const {
  return _vocabulary;
}

const std::vector<uint16_t> macLexer::getSerializedATN() const {
  return _serializedATN;
}

const atn::ATN& macLexer::getATN() const {
  return _atn;
}




// Static vars and initialization.
std::vector<dfa::DFA> macLexer::_decisionToDFA;
atn::PredictionContextCache macLexer::_sharedContextCache;

// We own the ATN which in turn owns the ATN states.
atn::ATN macLexer::_atn;
std::vector<uint16_t> macLexer::_serializedATN;

std::vector<std::string> macLexer::_ruleNames = {
  "T__0", "HEXPAIR", "HEX"
};

std::vector<std::string> macLexer::_channelNames = {
  "DEFAULT_TOKEN_CHANNEL", "HIDDEN"
};

std::vector<std::string> macLexer::_modeNames = {
  "DEFAULT_MODE"
};

std::vector<std::string> macLexer::_literalNames = {
  "", "':'"
};

std::vector<std::string> macLexer::_symbolicNames = {
  "", "", "HEXPAIR"
};

dfa::Vocabulary macLexer::_vocabulary(_literalNames, _symbolicNames);

std::vector<std::string> macLexer::_tokenNames;

macLexer::Initializer::Initializer() {
  // This code could be in a static initializer lambda, but VS doesn't allow access to private class members from there.
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
       0x2, 0x4, 0x10, 0x8, 0x1, 0x4, 0x2, 0x9, 0x2, 0x4, 0x3, 0x9, 0x3, 
       0x4, 0x4, 0x9, 0x4, 0x3, 0x2, 0x3, 0x2, 0x3, 0x3, 0x3, 0x3, 0x3, 
       0x3, 0x3, 0x4, 0x3, 0x4, 0x2, 0x2, 0x5, 0x3, 0x3, 0x5, 0x4, 0x7, 
       0x2, 0x3, 0x2, 0x3, 0x4, 0x2, 0x32, 0x3b, 0x43, 0x48, 0x2, 0xe, 0x2, 
       0x3, 0x3, 0x2, 0x2, 0x2, 0x2, 0x5, 0x3, 0x2, 0x2, 0x2, 0x3, 0x9, 
       0x3, 0x2, 0x2, 0x2, 0x5, 0xb, 0x3, 0x2, 0x2, 0x2, 0x7, 0xe, 0x3, 
       0x2, 0x2, 0x2, 0x9, 0xa, 0x7, 0x3c, 0x2, 0x2, 0xa, 0x4, 0x3, 0x2, 
       0x2, 0x2, 0xb, 0xc, 0x5, 0x7, 0x4, 0x2, 0xc, 0xd, 0x5, 0x7, 0x4, 
       0x2, 0xd, 0x6, 0x3, 0x2, 0x2, 0x2, 0xe, 0xf, 0x9, 0x2, 0x2, 0x2, 
       0xf, 0x8, 0x3, 0x2, 0x2, 0x2, 0x3, 0x2, 0x2, 
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

macLexer::Initializer macLexer::_init;
