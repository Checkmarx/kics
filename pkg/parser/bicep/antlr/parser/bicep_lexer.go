// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

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

type bicepLexer struct {
	*antlr.BaseLexer
	channelNames []string
	modeNames    []string
	// TODO: EOF string
}

var BicepLexerLexerStaticData struct {
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

func biceplexerLexerInit() {
	staticData := &BicepLexerLexerStaticData
	staticData.ChannelNames = []string{
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN",
	}
	staticData.ModeNames = []string{
		"DEFAULT_MODE",
	}
	staticData.LiteralNames = []string{
		"", "", "'@'", "','", "'['", "']'", "'('", "')'", "'.'", "'|'", "':'",
		"'='", "'{'", "'}'", "'param'", "'var'", "'true'", "'false'", "'null'",
		"'resource'", "", "", "", "", "'string'", "'int'", "'bool'",
	}
	staticData.SymbolicNames = []string{
		"", "MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "RESOURCE", "STRING_LEFT_PIECE", "STRING_MIDDLE_PIECE",
		"STRING_RIGHT_PIECE", "STRING_COMPLETE", "STRING", "INT", "BOOL", "IDENTIFIER",
		"NUMBER", "NL", "SPACES", "UNKNOWN",
	}
	staticData.RuleNames = []string{
		"MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "RESOURCE", "STRING_LEFT_PIECE", "STRING_MIDDLE_PIECE",
		"STRING_RIGHT_PIECE", "STRING_COMPLETE", "STRING", "INT", "BOOL", "IDENTIFIER",
		"NUMBER", "NL", "SPACES", "UNKNOWN", "STRINGCHAR", "ESCAPE", "HEX",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 0, 31, 250, 6, -1, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2,
		4, 7, 4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2,
		10, 7, 10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15,
		7, 15, 2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7,
		20, 2, 21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25,
		2, 26, 7, 26, 2, 27, 7, 27, 2, 28, 7, 28, 2, 29, 7, 29, 2, 30, 7, 30, 2,
		31, 7, 31, 2, 32, 7, 32, 2, 33, 7, 33, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 5,
		0, 75, 8, 0, 10, 0, 12, 0, 78, 9, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1,
		1, 2, 1, 2, 1, 3, 1, 3, 1, 4, 1, 4, 1, 5, 1, 5, 1, 6, 1, 6, 1, 7, 1, 7,
		1, 8, 1, 8, 1, 9, 1, 9, 1, 10, 1, 10, 1, 11, 1, 11, 1, 12, 1, 12, 1, 13,
		1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 15, 1,
		15, 1, 15, 1, 15, 1, 15, 1, 16, 1, 16, 1, 16, 1, 16, 1, 16, 1, 16, 1, 17,
		1, 17, 1, 17, 1, 17, 1, 17, 1, 18, 1, 18, 1, 18, 1, 18, 1, 18, 1, 18, 1,
		18, 1, 18, 1, 18, 1, 19, 1, 19, 5, 19, 145, 8, 19, 10, 19, 12, 19, 148,
		9, 19, 1, 19, 1, 19, 1, 19, 1, 20, 1, 20, 5, 20, 155, 8, 20, 10, 20, 12,
		20, 158, 9, 20, 1, 20, 1, 20, 1, 20, 1, 21, 1, 21, 5, 21, 165, 8, 21, 10,
		21, 12, 21, 168, 9, 21, 1, 21, 1, 21, 1, 22, 1, 22, 5, 22, 174, 8, 22,
		10, 22, 12, 22, 177, 9, 22, 1, 22, 1, 22, 1, 23, 1, 23, 1, 23, 1, 23, 1,
		23, 1, 23, 1, 23, 1, 24, 1, 24, 1, 24, 1, 24, 1, 25, 1, 25, 1, 25, 1, 25,
		1, 25, 1, 26, 1, 26, 5, 26, 199, 8, 26, 10, 26, 12, 26, 202, 9, 26, 1,
		27, 4, 27, 205, 8, 27, 11, 27, 12, 27, 206, 1, 27, 1, 27, 4, 27, 211, 8,
		27, 11, 27, 12, 27, 212, 3, 27, 215, 8, 27, 1, 28, 4, 28, 218, 8, 28, 11,
		28, 12, 28, 219, 1, 29, 4, 29, 223, 8, 29, 11, 29, 12, 29, 224, 1, 29,
		1, 29, 1, 30, 1, 30, 1, 31, 1, 31, 3, 31, 233, 8, 31, 1, 32, 1, 32, 1,
		32, 1, 32, 1, 32, 1, 32, 4, 32, 241, 8, 32, 11, 32, 12, 32, 242, 1, 32,
		1, 32, 3, 32, 247, 8, 32, 1, 33, 1, 33, 1, 76, 0, 34, 1, 1, 3, 2, 5, 3,
		7, 4, 9, 5, 11, 6, 13, 7, 15, 8, 17, 9, 19, 10, 21, 11, 23, 12, 25, 13,
		27, 14, 29, 15, 31, 16, 33, 17, 35, 18, 37, 19, 39, 20, 41, 21, 43, 22,
		45, 23, 47, 24, 49, 25, 51, 26, 53, 27, 55, 28, 57, 29, 59, 30, 61, 31,
		63, 0, 65, 0, 67, 0, 1, 0, 8, 3, 0, 65, 90, 95, 95, 97, 122, 4, 0, 48,
		57, 65, 90, 95, 95, 97, 122, 1, 0, 48, 57, 2, 0, 10, 10, 13, 13, 2, 0,
		9, 9, 32, 32, 5, 0, 9, 10, 13, 13, 36, 36, 39, 39, 92, 92, 6, 0, 36, 36,
		39, 39, 92, 92, 110, 110, 114, 114, 116, 116, 3, 0, 48, 57, 65, 70, 97,
		102, 260, 0, 1, 1, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 7, 1,
		0, 0, 0, 0, 9, 1, 0, 0, 0, 0, 11, 1, 0, 0, 0, 0, 13, 1, 0, 0, 0, 0, 15,
		1, 0, 0, 0, 0, 17, 1, 0, 0, 0, 0, 19, 1, 0, 0, 0, 0, 21, 1, 0, 0, 0, 0,
		23, 1, 0, 0, 0, 0, 25, 1, 0, 0, 0, 0, 27, 1, 0, 0, 0, 0, 29, 1, 0, 0, 0,
		0, 31, 1, 0, 0, 0, 0, 33, 1, 0, 0, 0, 0, 35, 1, 0, 0, 0, 0, 37, 1, 0, 0,
		0, 0, 39, 1, 0, 0, 0, 0, 41, 1, 0, 0, 0, 0, 43, 1, 0, 0, 0, 0, 45, 1, 0,
		0, 0, 0, 47, 1, 0, 0, 0, 0, 49, 1, 0, 0, 0, 0, 51, 1, 0, 0, 0, 0, 53, 1,
		0, 0, 0, 0, 55, 1, 0, 0, 0, 0, 57, 1, 0, 0, 0, 0, 59, 1, 0, 0, 0, 0, 61,
		1, 0, 0, 0, 1, 69, 1, 0, 0, 0, 3, 83, 1, 0, 0, 0, 5, 85, 1, 0, 0, 0, 7,
		87, 1, 0, 0, 0, 9, 89, 1, 0, 0, 0, 11, 91, 1, 0, 0, 0, 13, 93, 1, 0, 0,
		0, 15, 95, 1, 0, 0, 0, 17, 97, 1, 0, 0, 0, 19, 99, 1, 0, 0, 0, 21, 101,
		1, 0, 0, 0, 23, 103, 1, 0, 0, 0, 25, 105, 1, 0, 0, 0, 27, 107, 1, 0, 0,
		0, 29, 113, 1, 0, 0, 0, 31, 117, 1, 0, 0, 0, 33, 122, 1, 0, 0, 0, 35, 128,
		1, 0, 0, 0, 37, 133, 1, 0, 0, 0, 39, 142, 1, 0, 0, 0, 41, 152, 1, 0, 0,
		0, 43, 162, 1, 0, 0, 0, 45, 171, 1, 0, 0, 0, 47, 180, 1, 0, 0, 0, 49, 187,
		1, 0, 0, 0, 51, 191, 1, 0, 0, 0, 53, 196, 1, 0, 0, 0, 55, 204, 1, 0, 0,
		0, 57, 217, 1, 0, 0, 0, 59, 222, 1, 0, 0, 0, 61, 228, 1, 0, 0, 0, 63, 232,
		1, 0, 0, 0, 65, 234, 1, 0, 0, 0, 67, 248, 1, 0, 0, 0, 69, 70, 5, 39, 0,
		0, 70, 71, 5, 39, 0, 0, 71, 72, 5, 39, 0, 0, 72, 76, 1, 0, 0, 0, 73, 75,
		9, 0, 0, 0, 74, 73, 1, 0, 0, 0, 75, 78, 1, 0, 0, 0, 76, 77, 1, 0, 0, 0,
		76, 74, 1, 0, 0, 0, 77, 79, 1, 0, 0, 0, 78, 76, 1, 0, 0, 0, 79, 80, 5,
		39, 0, 0, 80, 81, 5, 39, 0, 0, 81, 82, 5, 39, 0, 0, 82, 2, 1, 0, 0, 0,
		83, 84, 5, 64, 0, 0, 84, 4, 1, 0, 0, 0, 85, 86, 5, 44, 0, 0, 86, 6, 1,
		0, 0, 0, 87, 88, 5, 91, 0, 0, 88, 8, 1, 0, 0, 0, 89, 90, 5, 93, 0, 0, 90,
		10, 1, 0, 0, 0, 91, 92, 5, 40, 0, 0, 92, 12, 1, 0, 0, 0, 93, 94, 5, 41,
		0, 0, 94, 14, 1, 0, 0, 0, 95, 96, 5, 46, 0, 0, 96, 16, 1, 0, 0, 0, 97,
		98, 5, 124, 0, 0, 98, 18, 1, 0, 0, 0, 99, 100, 5, 58, 0, 0, 100, 20, 1,
		0, 0, 0, 101, 102, 5, 61, 0, 0, 102, 22, 1, 0, 0, 0, 103, 104, 5, 123,
		0, 0, 104, 24, 1, 0, 0, 0, 105, 106, 5, 125, 0, 0, 106, 26, 1, 0, 0, 0,
		107, 108, 5, 112, 0, 0, 108, 109, 5, 97, 0, 0, 109, 110, 5, 114, 0, 0,
		110, 111, 5, 97, 0, 0, 111, 112, 5, 109, 0, 0, 112, 28, 1, 0, 0, 0, 113,
		114, 5, 118, 0, 0, 114, 115, 5, 97, 0, 0, 115, 116, 5, 114, 0, 0, 116,
		30, 1, 0, 0, 0, 117, 118, 5, 116, 0, 0, 118, 119, 5, 114, 0, 0, 119, 120,
		5, 117, 0, 0, 120, 121, 5, 101, 0, 0, 121, 32, 1, 0, 0, 0, 122, 123, 5,
		102, 0, 0, 123, 124, 5, 97, 0, 0, 124, 125, 5, 108, 0, 0, 125, 126, 5,
		115, 0, 0, 126, 127, 5, 101, 0, 0, 127, 34, 1, 0, 0, 0, 128, 129, 5, 110,
		0, 0, 129, 130, 5, 117, 0, 0, 130, 131, 5, 108, 0, 0, 131, 132, 5, 108,
		0, 0, 132, 36, 1, 0, 0, 0, 133, 134, 5, 114, 0, 0, 134, 135, 5, 101, 0,
		0, 135, 136, 5, 115, 0, 0, 136, 137, 5, 111, 0, 0, 137, 138, 5, 117, 0,
		0, 138, 139, 5, 114, 0, 0, 139, 140, 5, 99, 0, 0, 140, 141, 5, 101, 0,
		0, 141, 38, 1, 0, 0, 0, 142, 146, 5, 39, 0, 0, 143, 145, 3, 63, 31, 0,
		144, 143, 1, 0, 0, 0, 145, 148, 1, 0, 0, 0, 146, 144, 1, 0, 0, 0, 146,
		147, 1, 0, 0, 0, 147, 149, 1, 0, 0, 0, 148, 146, 1, 0, 0, 0, 149, 150,
		5, 36, 0, 0, 150, 151, 5, 123, 0, 0, 151, 40, 1, 0, 0, 0, 152, 156, 5,
		125, 0, 0, 153, 155, 3, 63, 31, 0, 154, 153, 1, 0, 0, 0, 155, 158, 1, 0,
		0, 0, 156, 154, 1, 0, 0, 0, 156, 157, 1, 0, 0, 0, 157, 159, 1, 0, 0, 0,
		158, 156, 1, 0, 0, 0, 159, 160, 5, 36, 0, 0, 160, 161, 5, 123, 0, 0, 161,
		42, 1, 0, 0, 0, 162, 166, 5, 125, 0, 0, 163, 165, 3, 63, 31, 0, 164, 163,
		1, 0, 0, 0, 165, 168, 1, 0, 0, 0, 166, 164, 1, 0, 0, 0, 166, 167, 1, 0,
		0, 0, 167, 169, 1, 0, 0, 0, 168, 166, 1, 0, 0, 0, 169, 170, 5, 39, 0, 0,
		170, 44, 1, 0, 0, 0, 171, 175, 5, 39, 0, 0, 172, 174, 3, 63, 31, 0, 173,
		172, 1, 0, 0, 0, 174, 177, 1, 0, 0, 0, 175, 173, 1, 0, 0, 0, 175, 176,
		1, 0, 0, 0, 176, 178, 1, 0, 0, 0, 177, 175, 1, 0, 0, 0, 178, 179, 5, 39,
		0, 0, 179, 46, 1, 0, 0, 0, 180, 181, 5, 115, 0, 0, 181, 182, 5, 116, 0,
		0, 182, 183, 5, 114, 0, 0, 183, 184, 5, 105, 0, 0, 184, 185, 5, 110, 0,
		0, 185, 186, 5, 103, 0, 0, 186, 48, 1, 0, 0, 0, 187, 188, 5, 105, 0, 0,
		188, 189, 5, 110, 0, 0, 189, 190, 5, 116, 0, 0, 190, 50, 1, 0, 0, 0, 191,
		192, 5, 98, 0, 0, 192, 193, 5, 111, 0, 0, 193, 194, 5, 111, 0, 0, 194,
		195, 5, 108, 0, 0, 195, 52, 1, 0, 0, 0, 196, 200, 7, 0, 0, 0, 197, 199,
		7, 1, 0, 0, 198, 197, 1, 0, 0, 0, 199, 202, 1, 0, 0, 0, 200, 198, 1, 0,
		0, 0, 200, 201, 1, 0, 0, 0, 201, 54, 1, 0, 0, 0, 202, 200, 1, 0, 0, 0,
		203, 205, 7, 2, 0, 0, 204, 203, 1, 0, 0, 0, 205, 206, 1, 0, 0, 0, 206,
		204, 1, 0, 0, 0, 206, 207, 1, 0, 0, 0, 207, 214, 1, 0, 0, 0, 208, 210,
		5, 46, 0, 0, 209, 211, 7, 2, 0, 0, 210, 209, 1, 0, 0, 0, 211, 212, 1, 0,
		0, 0, 212, 210, 1, 0, 0, 0, 212, 213, 1, 0, 0, 0, 213, 215, 1, 0, 0, 0,
		214, 208, 1, 0, 0, 0, 214, 215, 1, 0, 0, 0, 215, 56, 1, 0, 0, 0, 216, 218,
		7, 3, 0, 0, 217, 216, 1, 0, 0, 0, 218, 219, 1, 0, 0, 0, 219, 217, 1, 0,
		0, 0, 219, 220, 1, 0, 0, 0, 220, 58, 1, 0, 0, 0, 221, 223, 7, 4, 0, 0,
		222, 221, 1, 0, 0, 0, 223, 224, 1, 0, 0, 0, 224, 222, 1, 0, 0, 0, 224,
		225, 1, 0, 0, 0, 225, 226, 1, 0, 0, 0, 226, 227, 6, 29, 0, 0, 227, 60,
		1, 0, 0, 0, 228, 229, 9, 0, 0, 0, 229, 62, 1, 0, 0, 0, 230, 233, 8, 5,
		0, 0, 231, 233, 3, 65, 32, 0, 232, 230, 1, 0, 0, 0, 232, 231, 1, 0, 0,
		0, 233, 64, 1, 0, 0, 0, 234, 246, 5, 92, 0, 0, 235, 247, 7, 6, 0, 0, 236,
		237, 5, 117, 0, 0, 237, 238, 5, 123, 0, 0, 238, 240, 1, 0, 0, 0, 239, 241,
		3, 67, 33, 0, 240, 239, 1, 0, 0, 0, 241, 242, 1, 0, 0, 0, 242, 240, 1,
		0, 0, 0, 242, 243, 1, 0, 0, 0, 243, 244, 1, 0, 0, 0, 244, 245, 5, 125,
		0, 0, 245, 247, 1, 0, 0, 0, 246, 235, 1, 0, 0, 0, 246, 236, 1, 0, 0, 0,
		247, 66, 1, 0, 0, 0, 248, 249, 7, 7, 0, 0, 249, 68, 1, 0, 0, 0, 15, 0,
		76, 146, 156, 166, 175, 200, 206, 212, 214, 219, 224, 232, 242, 246, 1,
		6, 0, 0,
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

// bicepLexerInit initializes any static state used to implement bicepLexer. By default the
// static state used to implement the lexer is lazily initialized during the first call to
// NewbicepLexer(). You can call this function if you wish to initialize the static state ahead
// of time.
func BicepLexerInit() {
	staticData := &BicepLexerLexerStaticData
	staticData.once.Do(biceplexerLexerInit)
}

// NewbicepLexer produces a new lexer instance for the optional input antlr.CharStream.
func NewbicepLexer(input antlr.CharStream) *bicepLexer {
	BicepLexerInit()
	l := new(bicepLexer)
	l.BaseLexer = antlr.NewBaseLexer(input)
	staticData := &BicepLexerLexerStaticData
	l.Interpreter = antlr.NewLexerATNSimulator(l, staticData.atn, staticData.decisionToDFA, staticData.PredictionContextCache)
	l.channelNames = staticData.ChannelNames
	l.modeNames = staticData.ModeNames
	l.RuleNames = staticData.RuleNames
	l.LiteralNames = staticData.LiteralNames
	l.SymbolicNames = staticData.SymbolicNames
	l.GrammarFileName = "bicep.g4"
	// TODO: l.EOF = antlr.TokenEOF

	return l
}

// bicepLexer tokens.
const (
	bicepLexerMULTILINE_STRING    = 1
	bicepLexerAT                  = 2
	bicepLexerCOMMA               = 3
	bicepLexerOBRACK              = 4
	bicepLexerCBRACK              = 5
	bicepLexerOPAR                = 6
	bicepLexerCPAR                = 7
	bicepLexerDOT                 = 8
	bicepLexerPIPE                = 9
	bicepLexerCOL                 = 10
	bicepLexerASSIGN              = 11
	bicepLexerOBRACE              = 12
	bicepLexerCBRACE              = 13
	bicepLexerPARAM               = 14
	bicepLexerVAR                 = 15
	bicepLexerTRUE                = 16
	bicepLexerFALSE               = 17
	bicepLexerNULL                = 18
	bicepLexerRESOURCE            = 19
	bicepLexerSTRING_LEFT_PIECE   = 20
	bicepLexerSTRING_MIDDLE_PIECE = 21
	bicepLexerSTRING_RIGHT_PIECE  = 22
	bicepLexerSTRING_COMPLETE     = 23
	bicepLexerSTRING              = 24
	bicepLexerINT                 = 25
	bicepLexerBOOL                = 26
	bicepLexerIDENTIFIER          = 27
	bicepLexerNUMBER              = 28
	bicepLexerNL                  = 29
	bicepLexerSPACES              = 30
	bicepLexerUNKNOWN             = 31
)
