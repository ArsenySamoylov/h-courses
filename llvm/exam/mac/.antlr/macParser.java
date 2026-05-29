// Generated from /home/arsenyfucker/Desktop/h-courses/llvm/exam/mac/mac.g4 by ANTLR 4.13.1
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue"})
public class macParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, HEXPAIR=2, WS=3;
	public static final int
		RULE_mac = 0;
	private static String[] makeRuleNames() {
		return new String[] {
			"mac"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "':'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, "HEXPAIR", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "mac.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public macParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class MacContext extends ParserRuleContext {
		public List<TerminalNode> HEXPAIR() { return getTokens(macParser.HEXPAIR); }
		public TerminalNode HEXPAIR(int i) {
			return getToken(macParser.HEXPAIR, i);
		}
		public TerminalNode EOF() { return getToken(macParser.EOF, 0); }
		public MacContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_mac; }
	}

	public final MacContext mac() throws RecognitionException {
		MacContext _localctx = new MacContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_mac);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(2);
			match(HEXPAIR);
			setState(3);
			match(T__0);
			setState(4);
			match(HEXPAIR);
			setState(5);
			match(T__0);
			setState(6);
			match(HEXPAIR);
			setState(7);
			match(T__0);
			setState(8);
			match(HEXPAIR);
			setState(9);
			match(T__0);
			setState(10);
			match(HEXPAIR);
			setState(11);
			match(T__0);
			setState(12);
			match(HEXPAIR);
			setState(13);
			match(EOF);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\u0004\u0001\u0003\u0010\u0002\u0000\u0007\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000\u0001\u0000"+
		"\u0000\u0000\u0001\u0000\u0000\u0000\u000e\u0000\u0002\u0001\u0000\u0000"+
		"\u0000\u0002\u0003\u0005\u0002\u0000\u0000\u0003\u0004\u0005\u0001\u0000"+
		"\u0000\u0004\u0005\u0005\u0002\u0000\u0000\u0005\u0006\u0005\u0001\u0000"+
		"\u0000\u0006\u0007\u0005\u0002\u0000\u0000\u0007\b\u0005\u0001\u0000\u0000"+
		"\b\t\u0005\u0002\u0000\u0000\t\n\u0005\u0001\u0000\u0000\n\u000b\u0005"+
		"\u0002\u0000\u0000\u000b\f\u0005\u0001\u0000\u0000\f\r\u0005\u0002\u0000"+
		"\u0000\r\u000e\u0005\u0000\u0000\u0001\u000e\u0001\u0001\u0000\u0000\u0000"+
		"\u0000";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}