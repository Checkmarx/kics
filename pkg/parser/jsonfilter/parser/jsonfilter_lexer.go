// Code generated from JSONFilter.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser

import (
	"fmt"
	"github.com/antlr4-go/antlr/v4"
	"sync"
	"unicode"
)

// Suppress unused import error
var _ = fmt.Printf
var _ = sync.Once{}
var _ = unicode.IsLetter

type JSONFilterLexer struct {
	*antlr.BaseLexer
	channelNames []string
	modeNames    []string
	// TODO: EOF string
}

var JSONFilterLexerLexerStaticData struct {
	once                   sync.Once
	serializedATN          []int32
	ChannelNames           []string
	ModeNames              []string
	LiteralNames           []string
	SymbolicNames          []string
	RuleNames              []string
	PredictionContextCache *antlr.PredictionContextCache
	atn                    *antlr.ATN
	decisionToDFA          []*antlr.DFA
}

func jsonfilterlexerLexerInit() {
	staticData := &JSONFilterLexerLexerStaticData
	staticData.ChannelNames = []string{
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN",
	}
	staticData.ModeNames = []string{
		"DEFAULT_MODE",
	}
	staticData.LiteralNames = []string{
		"", "'$.'", "'*'", "'{'", "'}'", "'('", "')'", "'['", "']'", "'.'",
		"'&&'", "'||'", "'='", "'!='", "'>'", "'<'", "'>='", "'<='", "'IS'",
		"'NOT'", "'NULL'", "'EXISTS'", "'TRUE'", "'FALSE'",
	}
	staticData.SymbolicNames = []string{
		"", "SEL_START", "STAR", "LCURLY", "RCURLY", "LPAREN", "RPAREN", "LBRACKET",
		"RBRACKET", "DOT", "AND", "OR", "EQUALS", "NOT_EQUALS", "GT", "LT",
		"GE", "LE", "IS", "NOT", "NULL", "EXISTS", "TRUE", "FALSE", "INDENTIFIER",
		"STRING", "NUMBER", "WS",
	}
	staticData.RuleNames = []string{
		"SEL_START", "STAR", "LCURLY", "RCURLY", "LPAREN", "RPAREN", "LBRACKET",
		"RBRACKET", "DOT", "AND", "OR", "EQUALS", "NOT_EQUALS", "GT", "LT",
		"GE", "LE", "IS", "NOT", "NULL", "EXISTS", "TRUE", "FALSE", "INDENTIFIER",
		"STRING", "ESC", "UNICODE", "HEX", "SAFECODEPOINT", "NUMBER", "INT",
		"EXP", "WS",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 0, 27, 207, 6, -1, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2,
		4, 7, 4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2,
		10, 7, 10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15,
		7, 15, 2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7,
		20, 2, 21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25,
		2, 26, 7, 26, 2, 27, 7, 27, 2, 28, 7, 28, 2, 29, 7, 29, 2, 30, 7, 30, 2,
		31, 7, 31, 2, 32, 7, 32, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 2, 1, 2, 1, 3,
		1, 3, 1, 4, 1, 4, 1, 5, 1, 5, 1, 6, 1, 6, 1, 7, 1, 7, 1, 8, 1, 8, 1, 9,
		1, 9, 1, 9, 1, 10, 1, 10, 1, 10, 1, 11, 1, 11, 1, 12, 1, 12, 1, 12, 1,
		13, 1, 13, 1, 14, 1, 14, 1, 15, 1, 15, 1, 15, 1, 16, 1, 16, 1, 16, 1, 17,
		1, 17, 1, 17, 1, 18, 1, 18, 1, 18, 1, 18, 1, 19, 1, 19, 1, 19, 1, 19, 1,
		19, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 21, 1, 21, 1, 21,
		1, 21, 1, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 23, 1, 23, 5,
		23, 140, 8, 23, 10, 23, 12, 23, 143, 9, 23, 1, 24, 1, 24, 1, 24, 5, 24,
		148, 8, 24, 10, 24, 12, 24, 151, 9, 24, 1, 24, 1, 24, 1, 25, 1, 25, 1,
		25, 3, 25, 158, 8, 25, 1, 26, 1, 26, 1, 26, 1, 26, 1, 26, 1, 26, 1, 27,
		1, 27, 1, 28, 1, 28, 1, 29, 3, 29, 171, 8, 29, 1, 29, 1, 29, 1, 29, 4,
		29, 176, 8, 29, 11, 29, 12, 29, 177, 3, 29, 180, 8, 29, 1, 29, 3, 29, 183,
		8, 29, 1, 30, 1, 30, 1, 30, 5, 30, 188, 8, 30, 10, 30, 12, 30, 191, 9,
		30, 3, 30, 193, 8, 30, 1, 31, 1, 31, 3, 31, 197, 8, 31, 1, 31, 1, 31, 1,
		32, 4, 32, 202, 8, 32, 11, 32, 12, 32, 203, 1, 32, 1, 32, 0, 0, 33, 1,
		1, 3, 2, 5, 3, 7, 4, 9, 5, 11, 6, 13, 7, 15, 8, 17, 9, 19, 10, 21, 11,
		23, 12, 25, 13, 27, 14, 29, 15, 31, 16, 33, 17, 35, 18, 37, 19, 39, 20,
		41, 21, 43, 22, 45, 23, 47, 24, 49, 25, 51, 0, 53, 0, 55, 0, 57, 0, 59,
		26, 61, 0, 63, 0, 65, 27, 1, 0, 10, 2, 0, 65, 90, 97, 122, 3, 0, 48, 57,
		65, 90, 97, 122, 8, 0, 34, 34, 47, 47, 92, 92, 98, 98, 102, 102, 110, 110,
		114, 114, 116, 116, 3, 0, 48, 57, 65, 70, 97, 102, 3, 0, 0, 31, 34, 34,
		92, 92, 2, 0, 43, 43, 45, 45, 1, 0, 48, 57, 1, 0, 49, 57, 2, 0, 69, 69,
		101, 101, 3, 0, 9, 10, 13, 13, 32, 32, 212, 0, 1, 1, 0, 0, 0, 0, 3, 1,
		0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 7, 1, 0, 0, 0, 0, 9, 1, 0, 0, 0, 0, 11, 1,
		0, 0, 0, 0, 13, 1, 0, 0, 0, 0, 15, 1, 0, 0, 0, 0, 17, 1, 0, 0, 0, 0, 19,
		1, 0, 0, 0, 0, 21, 1, 0, 0, 0, 0, 23, 1, 0, 0, 0, 0, 25, 1, 0, 0, 0, 0,
		27, 1, 0, 0, 0, 0, 29, 1, 0, 0, 0, 0, 31, 1, 0, 0, 0, 0, 33, 1, 0, 0, 0,
		0, 35, 1, 0, 0, 0, 0, 37, 1, 0, 0, 0, 0, 39, 1, 0, 0, 0, 0, 41, 1, 0, 0,
		0, 0, 43, 1, 0, 0, 0, 0, 45, 1, 0, 0, 0, 0, 47, 1, 0, 0, 0, 0, 49, 1, 0,
		0, 0, 0, 59, 1, 0, 0, 0, 0, 65, 1, 0, 0, 0, 1, 67, 1, 0, 0, 0, 3, 70, 1,
		0, 0, 0, 5, 72, 1, 0, 0, 0, 7, 74, 1, 0, 0, 0, 9, 76, 1, 0, 0, 0, 11, 78,
		1, 0, 0, 0, 13, 80, 1, 0, 0, 0, 15, 82, 1, 0, 0, 0, 17, 84, 1, 0, 0, 0,
		19, 86, 1, 0, 0, 0, 21, 89, 1, 0, 0, 0, 23, 92, 1, 0, 0, 0, 25, 94, 1,
		0, 0, 0, 27, 97, 1, 0, 0, 0, 29, 99, 1, 0, 0, 0, 31, 101, 1, 0, 0, 0, 33,
		104, 1, 0, 0, 0, 35, 107, 1, 0, 0, 0, 37, 110, 1, 0, 0, 0, 39, 114, 1,
		0, 0, 0, 41, 119, 1, 0, 0, 0, 43, 126, 1, 0, 0, 0, 45, 131, 1, 0, 0, 0,
		47, 137, 1, 0, 0, 0, 49, 144, 1, 0, 0, 0, 51, 154, 1, 0, 0, 0, 53, 159,
		1, 0, 0, 0, 55, 165, 1, 0, 0, 0, 57, 167, 1, 0, 0, 0, 59, 170, 1, 0, 0,
		0, 61, 192, 1, 0, 0, 0, 63, 194, 1, 0, 0, 0, 65, 201, 1, 0, 0, 0, 67, 68,
		5, 36, 0, 0, 68, 69, 5, 46, 0, 0, 69, 2, 1, 0, 0, 0, 70, 71, 5, 42, 0,
		0, 71, 4, 1, 0, 0, 0, 72, 73, 5, 123, 0, 0, 73, 6, 1, 0, 0, 0, 74, 75,
		5, 125, 0, 0, 75, 8, 1, 0, 0, 0, 76, 77, 5, 40, 0, 0, 77, 10, 1, 0, 0,
		0, 78, 79, 5, 41, 0, 0, 79, 12, 1, 0, 0, 0, 80, 81, 5, 91, 0, 0, 81, 14,
		1, 0, 0, 0, 82, 83, 5, 93, 0, 0, 83, 16, 1, 0, 0, 0, 84, 85, 5, 46, 0,
		0, 85, 18, 1, 0, 0, 0, 86, 87, 5, 38, 0, 0, 87, 88, 5, 38, 0, 0, 88, 20,
		1, 0, 0, 0, 89, 90, 5, 124, 0, 0, 90, 91, 5, 124, 0, 0, 91, 22, 1, 0, 0,
		0, 92, 93, 5, 61, 0, 0, 93, 24, 1, 0, 0, 0, 94, 95, 5, 33, 0, 0, 95, 96,
		5, 61, 0, 0, 96, 26, 1, 0, 0, 0, 97, 98, 5, 62, 0, 0, 98, 28, 1, 0, 0,
		0, 99, 100, 5, 60, 0, 0, 100, 30, 1, 0, 0, 0, 101, 102, 5, 62, 0, 0, 102,
		103, 5, 61, 0, 0, 103, 32, 1, 0, 0, 0, 104, 105, 5, 60, 0, 0, 105, 106,
		5, 61, 0, 0, 106, 34, 1, 0, 0, 0, 107, 108, 5, 73, 0, 0, 108, 109, 5, 83,
		0, 0, 109, 36, 1, 0, 0, 0, 110, 111, 5, 78, 0, 0, 111, 112, 5, 79, 0, 0,
		112, 113, 5, 84, 0, 0, 113, 38, 1, 0, 0, 0, 114, 115, 5, 78, 0, 0, 115,
		116, 5, 85, 0, 0, 116, 117, 5, 76, 0, 0, 117, 118, 5, 76, 0, 0, 118, 40,
		1, 0, 0, 0, 119, 120, 5, 69, 0, 0, 120, 121, 5, 88, 0, 0, 121, 122, 5,
		73, 0, 0, 122, 123, 5, 83, 0, 0, 123, 124, 5, 84, 0, 0, 124, 125, 5, 83,
		0, 0, 125, 42, 1, 0, 0, 0, 126, 127, 5, 84, 0, 0, 127, 128, 5, 82, 0, 0,
		128, 129, 5, 85, 0, 0, 129, 130, 5, 69, 0, 0, 130, 44, 1, 0, 0, 0, 131,
		132, 5, 70, 0, 0, 132, 133, 5, 65, 0, 0, 133, 134, 5, 76, 0, 0, 134, 135,
		5, 83, 0, 0, 135, 136, 5, 69, 0, 0, 136, 46, 1, 0, 0, 0, 137, 141, 7, 0,
		0, 0, 138, 140, 7, 1, 0, 0, 139, 138, 1, 0, 0, 0, 140, 143, 1, 0, 0, 0,
		141, 139, 1, 0, 0, 0, 141, 142, 1, 0, 0, 0, 142, 48, 1, 0, 0, 0, 143, 141,
		1, 0, 0, 0, 144, 149, 5, 34, 0, 0, 145, 148, 3, 51, 25, 0, 146, 148, 3,
		57, 28, 0, 147, 145, 1, 0, 0, 0, 147, 146, 1, 0, 0, 0, 148, 151, 1, 0,
		0, 0, 149, 147, 1, 0, 0, 0, 149, 150, 1, 0, 0, 0, 150, 152, 1, 0, 0, 0,
		151, 149, 1, 0, 0, 0, 152, 153, 5, 34, 0, 0, 153, 50, 1, 0, 0, 0, 154,
		157, 5, 92, 0, 0, 155, 158, 7, 2, 0, 0, 156, 158, 3, 53, 26, 0, 157, 155,
		1, 0, 0, 0, 157, 156, 1, 0, 0, 0, 158, 52, 1, 0, 0, 0, 159, 160, 5, 117,
		0, 0, 160, 161, 3, 55, 27, 0, 161, 162, 3, 55, 27, 0, 162, 163, 3, 55,
		27, 0, 163, 164, 3, 55, 27, 0, 164, 54, 1, 0, 0, 0, 165, 166, 7, 3, 0,
		0, 166, 56, 1, 0, 0, 0, 167, 168, 8, 4, 0, 0, 168, 58, 1, 0, 0, 0, 169,
		171, 7, 5, 0, 0, 170, 169, 1, 0, 0, 0, 170, 171, 1, 0, 0, 0, 171, 172,
		1, 0, 0, 0, 172, 179, 3, 61, 30, 0, 173, 175, 5, 46, 0, 0, 174, 176, 7,
		6, 0, 0, 175, 174, 1, 0, 0, 0, 176, 177, 1, 0, 0, 0, 177, 175, 1, 0, 0,
		0, 177, 178, 1, 0, 0, 0, 178, 180, 1, 0, 0, 0, 179, 173, 1, 0, 0, 0, 179,
		180, 1, 0, 0, 0, 180, 182, 1, 0, 0, 0, 181, 183, 3, 63, 31, 0, 182, 181,
		1, 0, 0, 0, 182, 183, 1, 0, 0, 0, 183, 60, 1, 0, 0, 0, 184, 193, 5, 48,
		0, 0, 185, 189, 7, 7, 0, 0, 186, 188, 7, 6, 0, 0, 187, 186, 1, 0, 0, 0,
		188, 191, 1, 0, 0, 0, 189, 187, 1, 0, 0, 0, 189, 190, 1, 0, 0, 0, 190,
		193, 1, 0, 0, 0, 191, 189, 1, 0, 0, 0, 192, 184, 1, 0, 0, 0, 192, 185,
		1, 0, 0, 0, 193, 62, 1, 0, 0, 0, 194, 196, 7, 8, 0, 0, 195, 197, 7, 5,
		0, 0, 196, 195, 1, 0, 0, 0, 196, 197, 1, 0, 0, 0, 197, 198, 1, 0, 0, 0,
		198, 199, 3, 61, 30, 0, 199, 64, 1, 0, 0, 0, 200, 202, 7, 9, 0, 0, 201,
		200, 1, 0, 0, 0, 202, 203, 1, 0, 0, 0, 203, 201, 1, 0, 0, 0, 203, 204,
		1, 0, 0, 0, 204, 205, 1, 0, 0, 0, 205, 206, 6, 32, 0, 0, 206, 66, 1, 0,
		0, 0, 13, 0, 141, 147, 149, 157, 170, 177, 179, 182, 189, 192, 196, 203,
		1, 6, 0, 0,
	}
	deserializer := antlr.NewATNDeserializer(nil)
	staticData.atn = deserializer.Deserialize(staticData.serializedATN)
	atn := staticData.atn
	staticData.decisionToDFA = make([]*antlr.DFA, len(atn.DecisionToState))
	decisionToDFA := staticData.decisionToDFA
	for index, state := range atn.DecisionToState {
		decisionToDFA[index] = antlr.NewDFA(state, index)
	}
}

// JSONFilterLexerInit initializes any static state used to implement JSONFilterLexer. By default the
// static state used to implement the lexer is lazily initialized during the first call to
// NewJSONFilterLexer(). You can call this function if you wish to initialize the static state ahead
// of time.
func JSONFilterLexerInit() {
	staticData := &JSONFilterLexerLexerStaticData
	staticData.once.Do(jsonfilterlexerLexerInit)
}

// NewJSONFilterLexer produces a new lexer instance for the optional input antlr.CharStream.
func NewJSONFilterLexer(input antlr.CharStream) *JSONFilterLexer {
	JSONFilterLexerInit()
	l := new(JSONFilterLexer)
	l.BaseLexer = antlr.NewBaseLexer(input)
	staticData := &JSONFilterLexerLexerStaticData
	l.Interpreter = antlr.NewLexerATNSimulator(l, staticData.atn, staticData.decisionToDFA, staticData.PredictionContextCache)
	l.channelNames = staticData.ChannelNames
	l.modeNames = staticData.ModeNames
	l.RuleNames = staticData.RuleNames
	l.LiteralNames = staticData.LiteralNames
	l.SymbolicNames = staticData.SymbolicNames
	l.GrammarFileName = "JSONFilter.g4"
	// TODO: l.EOF = antlr.TokenEOF

	return l
}

// JSONFilterLexer tokens.
const (
	JSONFilterLexerSEL_START   = 1
	JSONFilterLexerSTAR        = 2
	JSONFilterLexerLCURLY      = 3
	JSONFilterLexerRCURLY      = 4
	JSONFilterLexerLPAREN      = 5
	JSONFilterLexerRPAREN      = 6
	JSONFilterLexerLBRACKET    = 7
	JSONFilterLexerRBRACKET    = 8
	JSONFilterLexerDOT         = 9
	JSONFilterLexerAND         = 10
	JSONFilterLexerOR          = 11
	JSONFilterLexerEQUALS      = 12
	JSONFilterLexerNOT_EQUALS  = 13
	JSONFilterLexerGT          = 14
	JSONFilterLexerLT          = 15
	JSONFilterLexerGE          = 16
	JSONFilterLexerLE          = 17
	JSONFilterLexerIS          = 18
	JSONFilterLexerNOT         = 19
	JSONFilterLexerNULL        = 20
	JSONFilterLexerEXISTS      = 21
	JSONFilterLexerTRUE        = 22
	JSONFilterLexerFALSE       = 23
	JSONFilterLexerINDENTIFIER = 24
	JSONFilterLexerSTRING      = 25
	JSONFilterLexerNUMBER      = 26
	JSONFilterLexerWS          = 27
)
