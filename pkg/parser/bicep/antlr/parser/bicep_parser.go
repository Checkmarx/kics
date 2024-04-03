// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // bicep

import (
	"fmt"
	"strconv"
	"sync"

	"github.com/antlr4-go/antlr/v4"
)

// Suppress unused import errors
var _ = fmt.Printf
var _ = strconv.Itoa
var _ = sync.Once{}

type bicepParser struct {
	*antlr.BaseParser
}

var BicepParserStaticData struct {
	once                   sync.Once
	serializedATN          []int32
	LiteralNames           []string
	SymbolicNames          []string
	RuleNames              []string
	PredictionContextCache *antlr.PredictionContextCache
	atn                    *antlr.ATN
	decisionToDFA          []*antlr.DFA
}

func bicepParserInit() {
	staticData := &BicepParserStaticData
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
		"program", "statement", "parameterDecl", "parameterDefaultValue", "variableDecl",
		"resourceDecl", "interpString", "expression", "primaryExpression", "parenthesizedExpression",
		"typeExpression", "literalValue", "object", "objectProperty", "array",
		"arrayItem", "decorator", "decoratorExpression", "functionCall", "argumentList",
		"identifier",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 31, 263, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
		10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15,
		2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7, 20, 1,
		0, 5, 0, 44, 8, 0, 10, 0, 12, 0, 47, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1,
		1, 1, 3, 1, 55, 8, 1, 1, 2, 5, 2, 58, 8, 2, 10, 2, 12, 2, 61, 9, 2, 1,
		2, 1, 2, 1, 2, 1, 2, 3, 2, 67, 8, 2, 1, 2, 1, 2, 1, 2, 3, 2, 72, 8, 2,
		3, 2, 74, 8, 2, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 1, 4, 5, 4, 82, 8, 4, 10,
		4, 12, 4, 85, 9, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 5, 5, 5, 94,
		8, 5, 10, 5, 12, 5, 97, 9, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5,
		1, 6, 1, 6, 1, 6, 1, 6, 5, 6, 110, 8, 6, 10, 6, 12, 6, 113, 9, 6, 1, 6,
		1, 6, 1, 6, 1, 6, 3, 6, 119, 8, 6, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7,
		1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 5, 7, 135, 8, 7, 10, 7,
		12, 7, 138, 9, 7, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 3, 8, 147,
		8, 8, 1, 9, 1, 9, 3, 9, 151, 8, 9, 1, 9, 1, 9, 3, 9, 155, 8, 9, 1, 9, 1,
		9, 1, 10, 1, 10, 1, 10, 5, 10, 162, 8, 10, 10, 10, 12, 10, 165, 9, 10,
		1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 3, 11, 172, 8, 11, 1, 12, 1, 12, 4,
		12, 176, 8, 12, 11, 12, 12, 12, 177, 1, 12, 1, 12, 4, 12, 182, 8, 12, 11,
		12, 12, 12, 183, 5, 12, 186, 8, 12, 10, 12, 12, 12, 189, 9, 12, 3, 12,
		191, 8, 12, 1, 12, 1, 12, 1, 13, 1, 13, 3, 13, 197, 8, 13, 1, 13, 1, 13,
		1, 13, 1, 14, 1, 14, 5, 14, 204, 8, 14, 10, 14, 12, 14, 207, 9, 14, 1,
		14, 5, 14, 210, 8, 14, 10, 14, 12, 14, 213, 9, 14, 1, 14, 1, 14, 1, 15,
		1, 15, 4, 15, 219, 8, 15, 11, 15, 12, 15, 220, 1, 15, 3, 15, 224, 8, 15,
		1, 16, 1, 16, 1, 16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 3, 17, 235,
		8, 17, 1, 18, 1, 18, 1, 18, 3, 18, 240, 8, 18, 1, 18, 3, 18, 243, 8, 18,
		1, 18, 3, 18, 246, 8, 18, 1, 18, 1, 18, 1, 19, 1, 19, 1, 19, 3, 19, 253,
		8, 19, 1, 19, 5, 19, 256, 8, 19, 10, 19, 12, 19, 259, 9, 19, 1, 20, 1,
		20, 1, 20, 0, 1, 14, 21, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24,
		26, 28, 30, 32, 34, 36, 38, 40, 0, 1, 2, 0, 14, 19, 24, 27, 285, 0, 45,
		1, 0, 0, 0, 2, 54, 1, 0, 0, 0, 4, 59, 1, 0, 0, 0, 6, 77, 1, 0, 0, 0, 8,
		83, 1, 0, 0, 0, 10, 95, 1, 0, 0, 0, 12, 118, 1, 0, 0, 0, 14, 120, 1, 0,
		0, 0, 16, 146, 1, 0, 0, 0, 18, 148, 1, 0, 0, 0, 20, 158, 1, 0, 0, 0, 22,
		171, 1, 0, 0, 0, 24, 173, 1, 0, 0, 0, 26, 196, 1, 0, 0, 0, 28, 201, 1,
		0, 0, 0, 30, 216, 1, 0, 0, 0, 32, 225, 1, 0, 0, 0, 34, 234, 1, 0, 0, 0,
		36, 236, 1, 0, 0, 0, 38, 249, 1, 0, 0, 0, 40, 260, 1, 0, 0, 0, 42, 44,
		3, 2, 1, 0, 43, 42, 1, 0, 0, 0, 44, 47, 1, 0, 0, 0, 45, 43, 1, 0, 0, 0,
		45, 46, 1, 0, 0, 0, 46, 48, 1, 0, 0, 0, 47, 45, 1, 0, 0, 0, 48, 49, 5,
		0, 0, 1, 49, 1, 1, 0, 0, 0, 50, 55, 3, 4, 2, 0, 51, 55, 3, 8, 4, 0, 52,
		55, 3, 10, 5, 0, 53, 55, 5, 29, 0, 0, 54, 50, 1, 0, 0, 0, 54, 51, 1, 0,
		0, 0, 54, 52, 1, 0, 0, 0, 54, 53, 1, 0, 0, 0, 55, 3, 1, 0, 0, 0, 56, 58,
		3, 32, 16, 0, 57, 56, 1, 0, 0, 0, 58, 61, 1, 0, 0, 0, 59, 57, 1, 0, 0,
		0, 59, 60, 1, 0, 0, 0, 60, 62, 1, 0, 0, 0, 61, 59, 1, 0, 0, 0, 62, 63,
		5, 14, 0, 0, 63, 73, 3, 40, 20, 0, 64, 66, 3, 20, 10, 0, 65, 67, 3, 6,
		3, 0, 66, 65, 1, 0, 0, 0, 66, 67, 1, 0, 0, 0, 67, 74, 1, 0, 0, 0, 68, 69,
		5, 19, 0, 0, 69, 71, 3, 12, 6, 0, 70, 72, 3, 6, 3, 0, 71, 70, 1, 0, 0,
		0, 71, 72, 1, 0, 0, 0, 72, 74, 1, 0, 0, 0, 73, 64, 1, 0, 0, 0, 73, 68,
		1, 0, 0, 0, 74, 75, 1, 0, 0, 0, 75, 76, 5, 29, 0, 0, 76, 5, 1, 0, 0, 0,
		77, 78, 5, 11, 0, 0, 78, 79, 3, 14, 7, 0, 79, 7, 1, 0, 0, 0, 80, 82, 3,
		32, 16, 0, 81, 80, 1, 0, 0, 0, 82, 85, 1, 0, 0, 0, 83, 81, 1, 0, 0, 0,
		83, 84, 1, 0, 0, 0, 84, 86, 1, 0, 0, 0, 85, 83, 1, 0, 0, 0, 86, 87, 5,
		15, 0, 0, 87, 88, 3, 40, 20, 0, 88, 89, 5, 11, 0, 0, 89, 90, 3, 14, 7,
		0, 90, 91, 5, 29, 0, 0, 91, 9, 1, 0, 0, 0, 92, 94, 3, 32, 16, 0, 93, 92,
		1, 0, 0, 0, 94, 97, 1, 0, 0, 0, 95, 93, 1, 0, 0, 0, 95, 96, 1, 0, 0, 0,
		96, 98, 1, 0, 0, 0, 97, 95, 1, 0, 0, 0, 98, 99, 5, 19, 0, 0, 99, 100, 3,
		40, 20, 0, 100, 101, 3, 12, 6, 0, 101, 102, 5, 11, 0, 0, 102, 103, 3, 24,
		12, 0, 103, 104, 5, 29, 0, 0, 104, 11, 1, 0, 0, 0, 105, 111, 5, 20, 0,
		0, 106, 107, 3, 14, 7, 0, 107, 108, 5, 21, 0, 0, 108, 110, 1, 0, 0, 0,
		109, 106, 1, 0, 0, 0, 110, 113, 1, 0, 0, 0, 111, 109, 1, 0, 0, 0, 111,
		112, 1, 0, 0, 0, 112, 114, 1, 0, 0, 0, 113, 111, 1, 0, 0, 0, 114, 115,
		3, 14, 7, 0, 115, 116, 5, 22, 0, 0, 116, 119, 1, 0, 0, 0, 117, 119, 5,
		23, 0, 0, 118, 105, 1, 0, 0, 0, 118, 117, 1, 0, 0, 0, 119, 13, 1, 0, 0,
		0, 120, 121, 6, 7, -1, 0, 121, 122, 3, 16, 8, 0, 122, 136, 1, 0, 0, 0,
		123, 124, 10, 4, 0, 0, 124, 125, 5, 4, 0, 0, 125, 126, 3, 14, 7, 0, 126,
		127, 5, 5, 0, 0, 127, 135, 1, 0, 0, 0, 128, 129, 10, 3, 0, 0, 129, 130,
		5, 8, 0, 0, 130, 135, 3, 40, 20, 0, 131, 132, 10, 2, 0, 0, 132, 133, 5,
		10, 0, 0, 133, 135, 3, 40, 20, 0, 134, 123, 1, 0, 0, 0, 134, 128, 1, 0,
		0, 0, 134, 131, 1, 0, 0, 0, 135, 138, 1, 0, 0, 0, 136, 134, 1, 0, 0, 0,
		136, 137, 1, 0, 0, 0, 137, 15, 1, 0, 0, 0, 138, 136, 1, 0, 0, 0, 139, 147,
		3, 22, 11, 0, 140, 147, 3, 36, 18, 0, 141, 147, 3, 12, 6, 0, 142, 147,
		5, 1, 0, 0, 143, 147, 3, 28, 14, 0, 144, 147, 3, 24, 12, 0, 145, 147, 3,
		18, 9, 0, 146, 139, 1, 0, 0, 0, 146, 140, 1, 0, 0, 0, 146, 141, 1, 0, 0,
		0, 146, 142, 1, 0, 0, 0, 146, 143, 1, 0, 0, 0, 146, 144, 1, 0, 0, 0, 146,
		145, 1, 0, 0, 0, 147, 17, 1, 0, 0, 0, 148, 150, 5, 6, 0, 0, 149, 151, 5,
		29, 0, 0, 150, 149, 1, 0, 0, 0, 150, 151, 1, 0, 0, 0, 151, 152, 1, 0, 0,
		0, 152, 154, 3, 14, 7, 0, 153, 155, 5, 29, 0, 0, 154, 153, 1, 0, 0, 0,
		154, 155, 1, 0, 0, 0, 155, 156, 1, 0, 0, 0, 156, 157, 5, 7, 0, 0, 157,
		19, 1, 0, 0, 0, 158, 163, 3, 40, 20, 0, 159, 160, 5, 9, 0, 0, 160, 162,
		3, 40, 20, 0, 161, 159, 1, 0, 0, 0, 162, 165, 1, 0, 0, 0, 163, 161, 1,
		0, 0, 0, 163, 164, 1, 0, 0, 0, 164, 21, 1, 0, 0, 0, 165, 163, 1, 0, 0,
		0, 166, 172, 5, 28, 0, 0, 167, 172, 5, 16, 0, 0, 168, 172, 5, 17, 0, 0,
		169, 172, 5, 18, 0, 0, 170, 172, 3, 40, 20, 0, 171, 166, 1, 0, 0, 0, 171,
		167, 1, 0, 0, 0, 171, 168, 1, 0, 0, 0, 171, 169, 1, 0, 0, 0, 171, 170,
		1, 0, 0, 0, 172, 23, 1, 0, 0, 0, 173, 190, 5, 12, 0, 0, 174, 176, 5, 29,
		0, 0, 175, 174, 1, 0, 0, 0, 176, 177, 1, 0, 0, 0, 177, 175, 1, 0, 0, 0,
		177, 178, 1, 0, 0, 0, 178, 187, 1, 0, 0, 0, 179, 181, 3, 26, 13, 0, 180,
		182, 5, 29, 0, 0, 181, 180, 1, 0, 0, 0, 182, 183, 1, 0, 0, 0, 183, 181,
		1, 0, 0, 0, 183, 184, 1, 0, 0, 0, 184, 186, 1, 0, 0, 0, 185, 179, 1, 0,
		0, 0, 186, 189, 1, 0, 0, 0, 187, 185, 1, 0, 0, 0, 187, 188, 1, 0, 0, 0,
		188, 191, 1, 0, 0, 0, 189, 187, 1, 0, 0, 0, 190, 175, 1, 0, 0, 0, 190,
		191, 1, 0, 0, 0, 191, 192, 1, 0, 0, 0, 192, 193, 5, 13, 0, 0, 193, 25,
		1, 0, 0, 0, 194, 197, 3, 40, 20, 0, 195, 197, 3, 12, 6, 0, 196, 194, 1,
		0, 0, 0, 196, 195, 1, 0, 0, 0, 197, 198, 1, 0, 0, 0, 198, 199, 5, 10, 0,
		0, 199, 200, 3, 14, 7, 0, 200, 27, 1, 0, 0, 0, 201, 205, 5, 4, 0, 0, 202,
		204, 5, 29, 0, 0, 203, 202, 1, 0, 0, 0, 204, 207, 1, 0, 0, 0, 205, 203,
		1, 0, 0, 0, 205, 206, 1, 0, 0, 0, 206, 211, 1, 0, 0, 0, 207, 205, 1, 0,
		0, 0, 208, 210, 3, 30, 15, 0, 209, 208, 1, 0, 0, 0, 210, 213, 1, 0, 0,
		0, 211, 209, 1, 0, 0, 0, 211, 212, 1, 0, 0, 0, 212, 214, 1, 0, 0, 0, 213,
		211, 1, 0, 0, 0, 214, 215, 5, 5, 0, 0, 215, 29, 1, 0, 0, 0, 216, 223, 3,
		14, 7, 0, 217, 219, 5, 29, 0, 0, 218, 217, 1, 0, 0, 0, 219, 220, 1, 0,
		0, 0, 220, 218, 1, 0, 0, 0, 220, 221, 1, 0, 0, 0, 221, 224, 1, 0, 0, 0,
		222, 224, 5, 3, 0, 0, 223, 218, 1, 0, 0, 0, 223, 222, 1, 0, 0, 0, 223,
		224, 1, 0, 0, 0, 224, 31, 1, 0, 0, 0, 225, 226, 5, 2, 0, 0, 226, 227, 3,
		34, 17, 0, 227, 228, 5, 29, 0, 0, 228, 33, 1, 0, 0, 0, 229, 235, 3, 36,
		18, 0, 230, 231, 3, 14, 7, 0, 231, 232, 5, 8, 0, 0, 232, 233, 3, 36, 18,
		0, 233, 235, 1, 0, 0, 0, 234, 229, 1, 0, 0, 0, 234, 230, 1, 0, 0, 0, 235,
		35, 1, 0, 0, 0, 236, 237, 3, 40, 20, 0, 237, 242, 5, 6, 0, 0, 238, 240,
		5, 29, 0, 0, 239, 238, 1, 0, 0, 0, 239, 240, 1, 0, 0, 0, 240, 241, 1, 0,
		0, 0, 241, 243, 3, 38, 19, 0, 242, 239, 1, 0, 0, 0, 242, 243, 1, 0, 0,
		0, 243, 245, 1, 0, 0, 0, 244, 246, 5, 29, 0, 0, 245, 244, 1, 0, 0, 0, 245,
		246, 1, 0, 0, 0, 246, 247, 1, 0, 0, 0, 247, 248, 5, 7, 0, 0, 248, 37, 1,
		0, 0, 0, 249, 257, 3, 14, 7, 0, 250, 252, 5, 3, 0, 0, 251, 253, 5, 29,
		0, 0, 252, 251, 1, 0, 0, 0, 252, 253, 1, 0, 0, 0, 253, 254, 1, 0, 0, 0,
		254, 256, 3, 14, 7, 0, 255, 250, 1, 0, 0, 0, 256, 259, 1, 0, 0, 0, 257,
		255, 1, 0, 0, 0, 257, 258, 1, 0, 0, 0, 258, 39, 1, 0, 0, 0, 259, 257, 1,
		0, 0, 0, 260, 261, 7, 0, 0, 0, 261, 41, 1, 0, 0, 0, 32, 45, 54, 59, 66,
		71, 73, 83, 95, 111, 118, 134, 136, 146, 150, 154, 163, 171, 177, 183,
		187, 190, 196, 205, 211, 220, 223, 234, 239, 242, 245, 252, 257,
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

// bicepParserInit initializes any static state used to implement bicepParser. By default the
// static state used to implement the parser is lazily initialized during the first call to
// NewbicepParser(). You can call this function if you wish to initialize the static state ahead
// of time.
func BicepParserInit() {
	staticData := &BicepParserStaticData
	staticData.once.Do(bicepParserInit)
}

// NewbicepParser produces a new parser instance for the optional input antlr.TokenStream.
func NewbicepParser(input antlr.TokenStream) *bicepParser {
	BicepParserInit()
	this := new(bicepParser)
	this.BaseParser = antlr.NewBaseParser(input)
	staticData := &BicepParserStaticData
	this.Interpreter = antlr.NewParserATNSimulator(this, staticData.atn, staticData.decisionToDFA, staticData.PredictionContextCache)
	this.RuleNames = staticData.RuleNames
	this.LiteralNames = staticData.LiteralNames
	this.SymbolicNames = staticData.SymbolicNames
	this.GrammarFileName = "bicep.g4"

	return this
}

// bicepParser tokens.
const (
	bicepParserEOF                 = antlr.TokenEOF
	bicepParserMULTILINE_STRING    = 1
	bicepParserAT                  = 2
	bicepParserCOMMA               = 3
	bicepParserOBRACK              = 4
	bicepParserCBRACK              = 5
	bicepParserOPAR                = 6
	bicepParserCPAR                = 7
	bicepParserDOT                 = 8
	bicepParserPIPE                = 9
	bicepParserCOL                 = 10
	bicepParserASSIGN              = 11
	bicepParserOBRACE              = 12
	bicepParserCBRACE              = 13
	bicepParserPARAM               = 14
	bicepParserVAR                 = 15
	bicepParserTRUE                = 16
	bicepParserFALSE               = 17
	bicepParserNULL                = 18
	bicepParserRESOURCE            = 19
	bicepParserSTRING_LEFT_PIECE   = 20
	bicepParserSTRING_MIDDLE_PIECE = 21
	bicepParserSTRING_RIGHT_PIECE  = 22
	bicepParserSTRING_COMPLETE     = 23
	bicepParserSTRING              = 24
	bicepParserINT                 = 25
	bicepParserBOOL                = 26
	bicepParserIDENTIFIER          = 27
	bicepParserNUMBER              = 28
	bicepParserNL                  = 29
	bicepParserSPACES              = 30
	bicepParserUNKNOWN             = 31
)

// bicepParser rules.
const (
	bicepParserRULE_program                 = 0
	bicepParserRULE_statement               = 1
	bicepParserRULE_parameterDecl           = 2
	bicepParserRULE_parameterDefaultValue   = 3
	bicepParserRULE_variableDecl            = 4
	bicepParserRULE_resourceDecl            = 5
	bicepParserRULE_interpString            = 6
	bicepParserRULE_expression              = 7
	bicepParserRULE_primaryExpression       = 8
	bicepParserRULE_parenthesizedExpression = 9
	bicepParserRULE_typeExpression          = 10
	bicepParserRULE_literalValue            = 11
	bicepParserRULE_object                  = 12
	bicepParserRULE_objectProperty          = 13
	bicepParserRULE_array                   = 14
	bicepParserRULE_arrayItem               = 15
	bicepParserRULE_decorator               = 16
	bicepParserRULE_decoratorExpression     = 17
	bicepParserRULE_functionCall            = 18
	bicepParserRULE_argumentList            = 19
	bicepParserRULE_identifier              = 20
)

// IProgramContext is an interface to support dynamic dispatch.
type IProgramContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	EOF() antlr.TerminalNode
	AllStatement() []IStatementContext
	Statement(i int) IStatementContext

	// IsProgramContext differentiates from other interfaces.
	IsProgramContext()
}

type ProgramContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyProgramContext() *ProgramContext {
	var p = new(ProgramContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_program
	return p
}

func InitEmptyProgramContext(p *ProgramContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_program
}

func (*ProgramContext) IsProgramContext() {}

func NewProgramContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ProgramContext {
	var p = new(ProgramContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_program

	return p
}

func (s *ProgramContext) GetParser() antlr.Parser { return s.parser }

func (s *ProgramContext) EOF() antlr.TerminalNode {
	return s.GetToken(bicepParserEOF, 0)
}

func (s *ProgramContext) AllStatement() []IStatementContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IStatementContext); ok {
			len++
		}
	}

	tst := make([]IStatementContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IStatementContext); ok {
			tst[i] = t.(IStatementContext)
			i++
		}
	}

	return tst
}

func (s *ProgramContext) Statement(i int) IStatementContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IStatementContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IStatementContext)
}

func (s *ProgramContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ProgramContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ProgramContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitProgram(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Program() (localctx IProgramContext) {
	localctx = NewProgramContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 0, bicepParserRULE_program)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(45)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&537444356) != 0 {
		{
			p.SetState(42)
			p.Statement()
		}

		p.SetState(47)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(48)
		p.Match(bicepParserEOF)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IStatementContext is an interface to support dynamic dispatch.
type IStatementContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	ParameterDecl() IParameterDeclContext
	VariableDecl() IVariableDeclContext
	ResourceDecl() IResourceDeclContext
	NL() antlr.TerminalNode

	// IsStatementContext differentiates from other interfaces.
	IsStatementContext()
}

type StatementContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyStatementContext() *StatementContext {
	var p = new(StatementContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_statement
	return p
}

func InitEmptyStatementContext(p *StatementContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_statement
}

func (*StatementContext) IsStatementContext() {}

func NewStatementContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *StatementContext {
	var p = new(StatementContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_statement

	return p
}

func (s *StatementContext) GetParser() antlr.Parser { return s.parser }

func (s *StatementContext) ParameterDecl() IParameterDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IParameterDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IParameterDeclContext)
}

func (s *StatementContext) VariableDecl() IVariableDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IVariableDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IVariableDeclContext)
}

func (s *StatementContext) ResourceDecl() IResourceDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IResourceDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IResourceDeclContext)
}

func (s *StatementContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *StatementContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *StatementContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *StatementContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitStatement(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Statement() (localctx IStatementContext) {
	localctx = NewStatementContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 2, bicepParserRULE_statement)
	p.SetState(54)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(50)
			p.ParameterDecl()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(51)
			p.VariableDecl()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(52)
			p.ResourceDecl()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(53)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IParameterDeclContext is an interface to support dynamic dispatch.
type IParameterDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// GetType_ returns the type_ rule contexts.
	GetType_() IInterpStringContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// SetType_ sets the type_ rule contexts.
	SetType_(IInterpStringContext)

	// Getter signatures
	PARAM() antlr.TerminalNode
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext
	TypeExpression() ITypeExpressionContext
	RESOURCE() antlr.TerminalNode
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext
	InterpString() IInterpStringContext
	ParameterDefaultValue() IParameterDefaultValueContext

	// IsParameterDeclContext differentiates from other interfaces.
	IsParameterDeclContext()
}

type ParameterDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
	type_  IInterpStringContext
}

func NewEmptyParameterDeclContext() *ParameterDeclContext {
	var p = new(ParameterDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parameterDecl
	return p
}

func InitEmptyParameterDeclContext(p *ParameterDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parameterDecl
}

func (*ParameterDeclContext) IsParameterDeclContext() {}

func NewParameterDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ParameterDeclContext {
	var p = new(ParameterDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_parameterDecl

	return p
}

func (s *ParameterDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *ParameterDeclContext) GetName() IIdentifierContext { return s.name }

func (s *ParameterDeclContext) GetType_() IInterpStringContext { return s.type_ }

func (s *ParameterDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *ParameterDeclContext) SetType_(v IInterpStringContext) { s.type_ = v }

func (s *ParameterDeclContext) PARAM() antlr.TerminalNode {
	return s.GetToken(bicepParserPARAM, 0)
}

func (s *ParameterDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *ParameterDeclContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *ParameterDeclContext) TypeExpression() ITypeExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ITypeExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ITypeExpressionContext)
}

func (s *ParameterDeclContext) RESOURCE() antlr.TerminalNode {
	return s.GetToken(bicepParserRESOURCE, 0)
}

func (s *ParameterDeclContext) AllDecorator() []IDecoratorContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IDecoratorContext); ok {
			len++
		}
	}

	tst := make([]IDecoratorContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IDecoratorContext); ok {
			tst[i] = t.(IDecoratorContext)
			i++
		}
	}

	return tst
}

func (s *ParameterDeclContext) Decorator(i int) IDecoratorContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IDecoratorContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IDecoratorContext)
}

func (s *ParameterDeclContext) InterpString() IInterpStringContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IInterpStringContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IInterpStringContext)
}

func (s *ParameterDeclContext) ParameterDefaultValue() IParameterDefaultValueContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IParameterDefaultValueContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IParameterDefaultValueContext)
}

func (s *ParameterDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ParameterDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ParameterDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitParameterDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ParameterDecl() (localctx IParameterDeclContext) {
	localctx = NewParameterDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 4, bicepParserRULE_parameterDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(59)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(56)
			p.Decorator()
		}

		p.SetState(61)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(62)
		p.Match(bicepParserPARAM)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(63)

		var _x = p.Identifier()

		localctx.(*ParameterDeclContext).name = _x
	}
	p.SetState(73)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 5, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(64)
			p.TypeExpression()
		}
		p.SetState(66)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(65)
				p.ParameterDefaultValue()
			}

		}

	case 2:
		{
			p.SetState(68)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(69)

			var _x = p.InterpString()

			localctx.(*ParameterDeclContext).type_ = _x
		}
		p.SetState(71)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(70)
				p.ParameterDefaultValue()
			}

		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(75)
		p.Match(bicepParserNL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IParameterDefaultValueContext is an interface to support dynamic dispatch.
type IParameterDefaultValueContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	ASSIGN() antlr.TerminalNode
	Expression() IExpressionContext

	// IsParameterDefaultValueContext differentiates from other interfaces.
	IsParameterDefaultValueContext()
}

type ParameterDefaultValueContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyParameterDefaultValueContext() *ParameterDefaultValueContext {
	var p = new(ParameterDefaultValueContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parameterDefaultValue
	return p
}

func InitEmptyParameterDefaultValueContext(p *ParameterDefaultValueContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parameterDefaultValue
}

func (*ParameterDefaultValueContext) IsParameterDefaultValueContext() {}

func NewParameterDefaultValueContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ParameterDefaultValueContext {
	var p = new(ParameterDefaultValueContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_parameterDefaultValue

	return p
}

func (s *ParameterDefaultValueContext) GetParser() antlr.Parser { return s.parser }

func (s *ParameterDefaultValueContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *ParameterDefaultValueContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ParameterDefaultValueContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ParameterDefaultValueContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ParameterDefaultValueContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitParameterDefaultValue(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ParameterDefaultValue() (localctx IParameterDefaultValueContext) {
	localctx = NewParameterDefaultValueContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 6, bicepParserRULE_parameterDefaultValue)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(77)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(78)
		p.expression(0)
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IVariableDeclContext is an interface to support dynamic dispatch.
type IVariableDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// Getter signatures
	VAR() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	Expression() IExpressionContext
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext

	// IsVariableDeclContext differentiates from other interfaces.
	IsVariableDeclContext()
}

type VariableDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
}

func NewEmptyVariableDeclContext() *VariableDeclContext {
	var p = new(VariableDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_variableDecl
	return p
}

func InitEmptyVariableDeclContext(p *VariableDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_variableDecl
}

func (*VariableDeclContext) IsVariableDeclContext() {}

func NewVariableDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *VariableDeclContext {
	var p = new(VariableDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_variableDecl

	return p
}

func (s *VariableDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *VariableDeclContext) GetName() IIdentifierContext { return s.name }

func (s *VariableDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *VariableDeclContext) VAR() antlr.TerminalNode {
	return s.GetToken(bicepParserVAR, 0)
}

func (s *VariableDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *VariableDeclContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *VariableDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *VariableDeclContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *VariableDeclContext) AllDecorator() []IDecoratorContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IDecoratorContext); ok {
			len++
		}
	}

	tst := make([]IDecoratorContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IDecoratorContext); ok {
			tst[i] = t.(IDecoratorContext)
			i++
		}
	}

	return tst
}

func (s *VariableDeclContext) Decorator(i int) IDecoratorContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IDecoratorContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IDecoratorContext)
}

func (s *VariableDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *VariableDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *VariableDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitVariableDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) VariableDecl() (localctx IVariableDeclContext) {
	localctx = NewVariableDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 8, bicepParserRULE_variableDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(83)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(80)
			p.Decorator()
		}

		p.SetState(85)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(86)
		p.Match(bicepParserVAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(87)

		var _x = p.Identifier()

		localctx.(*VariableDeclContext).name = _x
	}
	{
		p.SetState(88)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(89)
		p.expression(0)
	}
	{
		p.SetState(90)
		p.Match(bicepParserNL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IResourceDeclContext is an interface to support dynamic dispatch.
type IResourceDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// GetType_ returns the type_ rule contexts.
	GetType_() IInterpStringContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// SetType_ sets the type_ rule contexts.
	SetType_(IInterpStringContext)

	// Getter signatures
	RESOURCE() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext
	InterpString() IInterpStringContext
	Object() IObjectContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext

	// IsResourceDeclContext differentiates from other interfaces.
	IsResourceDeclContext()
}

type ResourceDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
	type_  IInterpStringContext
}

func NewEmptyResourceDeclContext() *ResourceDeclContext {
	var p = new(ResourceDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_resourceDecl
	return p
}

func InitEmptyResourceDeclContext(p *ResourceDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_resourceDecl
}

func (*ResourceDeclContext) IsResourceDeclContext() {}

func NewResourceDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ResourceDeclContext {
	var p = new(ResourceDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_resourceDecl

	return p
}

func (s *ResourceDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *ResourceDeclContext) GetName() IIdentifierContext { return s.name }

func (s *ResourceDeclContext) GetType_() IInterpStringContext { return s.type_ }

func (s *ResourceDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *ResourceDeclContext) SetType_(v IInterpStringContext) { s.type_ = v }

func (s *ResourceDeclContext) RESOURCE() antlr.TerminalNode {
	return s.GetToken(bicepParserRESOURCE, 0)
}

func (s *ResourceDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *ResourceDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *ResourceDeclContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *ResourceDeclContext) InterpString() IInterpStringContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IInterpStringContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IInterpStringContext)
}

func (s *ResourceDeclContext) Object() IObjectContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IObjectContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IObjectContext)
}

func (s *ResourceDeclContext) AllDecorator() []IDecoratorContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IDecoratorContext); ok {
			len++
		}
	}

	tst := make([]IDecoratorContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IDecoratorContext); ok {
			tst[i] = t.(IDecoratorContext)
			i++
		}
	}

	return tst
}

func (s *ResourceDeclContext) Decorator(i int) IDecoratorContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IDecoratorContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IDecoratorContext)
}

func (s *ResourceDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ResourceDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ResourceDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitResourceDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ResourceDecl() (localctx IResourceDeclContext) {
	localctx = NewResourceDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 10, bicepParserRULE_resourceDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(95)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(92)
			p.Decorator()
		}

		p.SetState(97)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(98)
		p.Match(bicepParserRESOURCE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(99)

		var _x = p.Identifier()

		localctx.(*ResourceDeclContext).name = _x
	}
	{
		p.SetState(100)

		var _x = p.InterpString()

		localctx.(*ResourceDeclContext).type_ = _x
	}
	{
		p.SetState(101)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

	{
		p.SetState(102)
		p.Object()
	}

	{
		p.SetState(103)
		p.Match(bicepParserNL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IInterpStringContext is an interface to support dynamic dispatch.
type IInterpStringContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	STRING_LEFT_PIECE() antlr.TerminalNode
	AllExpression() []IExpressionContext
	Expression(i int) IExpressionContext
	STRING_RIGHT_PIECE() antlr.TerminalNode
	AllSTRING_MIDDLE_PIECE() []antlr.TerminalNode
	STRING_MIDDLE_PIECE(i int) antlr.TerminalNode
	STRING_COMPLETE() antlr.TerminalNode

	// IsInterpStringContext differentiates from other interfaces.
	IsInterpStringContext()
}

type InterpStringContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyInterpStringContext() *InterpStringContext {
	var p = new(InterpStringContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_interpString
	return p
}

func InitEmptyInterpStringContext(p *InterpStringContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_interpString
}

func (*InterpStringContext) IsInterpStringContext() {}

func NewInterpStringContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *InterpStringContext {
	var p = new(InterpStringContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_interpString

	return p
}

func (s *InterpStringContext) GetParser() antlr.Parser { return s.parser }

func (s *InterpStringContext) STRING_LEFT_PIECE() antlr.TerminalNode {
	return s.GetToken(bicepParserSTRING_LEFT_PIECE, 0)
}

func (s *InterpStringContext) AllExpression() []IExpressionContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IExpressionContext); ok {
			len++
		}
	}

	tst := make([]IExpressionContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IExpressionContext); ok {
			tst[i] = t.(IExpressionContext)
			i++
		}
	}

	return tst
}

func (s *InterpStringContext) Expression(i int) IExpressionContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *InterpStringContext) STRING_RIGHT_PIECE() antlr.TerminalNode {
	return s.GetToken(bicepParserSTRING_RIGHT_PIECE, 0)
}

func (s *InterpStringContext) AllSTRING_MIDDLE_PIECE() []antlr.TerminalNode {
	return s.GetTokens(bicepParserSTRING_MIDDLE_PIECE)
}

func (s *InterpStringContext) STRING_MIDDLE_PIECE(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserSTRING_MIDDLE_PIECE, i)
}

func (s *InterpStringContext) STRING_COMPLETE() antlr.TerminalNode {
	return s.GetToken(bicepParserSTRING_COMPLETE, 0)
}

func (s *InterpStringContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *InterpStringContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *InterpStringContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitInterpString(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) InterpString() (localctx IInterpStringContext) {
	localctx = NewInterpStringContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 12, bicepParserRULE_interpString)
	var _alt int

	p.SetState(118)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserSTRING_LEFT_PIECE:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(105)
			p.Match(bicepParserSTRING_LEFT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(111)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 8, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
		for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			if _alt == 1 {
				{
					p.SetState(106)
					p.expression(0)
				}
				{
					p.SetState(107)
					p.Match(bicepParserSTRING_MIDDLE_PIECE)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			}
			p.SetState(113)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 8, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}
		{
			p.SetState(114)
			p.expression(0)
		}
		{
			p.SetState(115)
			p.Match(bicepParserSTRING_RIGHT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserSTRING_COMPLETE:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(117)
			p.Match(bicepParserSTRING_COMPLETE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IExpressionContext is an interface to support dynamic dispatch.
type IExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetProperty returns the property rule contexts.
	GetProperty() IIdentifierContext

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// SetProperty sets the property rule contexts.
	SetProperty(IIdentifierContext)

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// Getter signatures
	PrimaryExpression() IPrimaryExpressionContext
	AllExpression() []IExpressionContext
	Expression(i int) IExpressionContext
	OBRACK() antlr.TerminalNode
	CBRACK() antlr.TerminalNode
	DOT() antlr.TerminalNode
	Identifier() IIdentifierContext
	COL() antlr.TerminalNode

	// IsExpressionContext differentiates from other interfaces.
	IsExpressionContext()
}

type ExpressionContext struct {
	antlr.BaseParserRuleContext
	parser   antlr.Parser
	property IIdentifierContext
	name     IIdentifierContext
}

func NewEmptyExpressionContext() *ExpressionContext {
	var p = new(ExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_expression
	return p
}

func InitEmptyExpressionContext(p *ExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_expression
}

func (*ExpressionContext) IsExpressionContext() {}

func NewExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ExpressionContext {
	var p = new(ExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_expression

	return p
}

func (s *ExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *ExpressionContext) GetProperty() IIdentifierContext { return s.property }

func (s *ExpressionContext) GetName() IIdentifierContext { return s.name }

func (s *ExpressionContext) SetProperty(v IIdentifierContext) { s.property = v }

func (s *ExpressionContext) SetName(v IIdentifierContext) { s.name = v }

func (s *ExpressionContext) PrimaryExpression() IPrimaryExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IPrimaryExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IPrimaryExpressionContext)
}

func (s *ExpressionContext) AllExpression() []IExpressionContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IExpressionContext); ok {
			len++
		}
	}

	tst := make([]IExpressionContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IExpressionContext); ok {
			tst[i] = t.(IExpressionContext)
			i++
		}
	}

	return tst
}

func (s *ExpressionContext) Expression(i int) IExpressionContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ExpressionContext) OBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserOBRACK, 0)
}

func (s *ExpressionContext) CBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserCBRACK, 0)
}

func (s *ExpressionContext) DOT() antlr.TerminalNode {
	return s.GetToken(bicepParserDOT, 0)
}

func (s *ExpressionContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *ExpressionContext) COL() antlr.TerminalNode {
	return s.GetToken(bicepParserCOL, 0)
}

func (s *ExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Expression() (localctx IExpressionContext) {
	return p.expression(0)
}

func (p *bicepParser) expression(_p int) (localctx IExpressionContext) {
	var _parentctx antlr.ParserRuleContext = p.GetParserRuleContext()

	_parentState := p.GetState()
	localctx = NewExpressionContext(p, p.GetParserRuleContext(), _parentState)
	var _prevctx IExpressionContext = localctx
	var _ antlr.ParserRuleContext = _prevctx // TODO: To prevent unused variable warning.
	_startState := 14
	p.EnterRecursionRule(localctx, 14, bicepParserRULE_expression, _p)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(121)
		p.PrimaryExpression()
	}

	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(136)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 11, p.GetParserRuleContext())
	if p.HasError() {
		goto errorExit
	}
	for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
		if _alt == 1 {
			if p.GetParseListeners() != nil {
				p.TriggerExitRuleEvent()
			}
			_prevctx = localctx
			p.SetState(134)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 10, p.GetParserRuleContext()) {
			case 1:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(123)

				if !(p.Precpred(p.GetParserRuleContext(), 4)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 4)", ""))
					goto errorExit
				}
				{
					p.SetState(124)
					p.Match(bicepParserOBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(125)
					p.expression(0)
				}
				{
					p.SetState(126)
					p.Match(bicepParserCBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			case 2:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(128)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(129)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(130)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).property = _x
				}

			case 3:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(131)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(132)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(133)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(138)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 11, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.UnrollRecursionContexts(_parentctx)
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IPrimaryExpressionContext is an interface to support dynamic dispatch.
type IPrimaryExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	LiteralValue() ILiteralValueContext
	FunctionCall() IFunctionCallContext
	InterpString() IInterpStringContext
	MULTILINE_STRING() antlr.TerminalNode
	Array() IArrayContext
	Object() IObjectContext
	ParenthesizedExpression() IParenthesizedExpressionContext

	// IsPrimaryExpressionContext differentiates from other interfaces.
	IsPrimaryExpressionContext()
}

type PrimaryExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyPrimaryExpressionContext() *PrimaryExpressionContext {
	var p = new(PrimaryExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_primaryExpression
	return p
}

func InitEmptyPrimaryExpressionContext(p *PrimaryExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_primaryExpression
}

func (*PrimaryExpressionContext) IsPrimaryExpressionContext() {}

func NewPrimaryExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *PrimaryExpressionContext {
	var p = new(PrimaryExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_primaryExpression

	return p
}

func (s *PrimaryExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *PrimaryExpressionContext) LiteralValue() ILiteralValueContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ILiteralValueContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ILiteralValueContext)
}

func (s *PrimaryExpressionContext) FunctionCall() IFunctionCallContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFunctionCallContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFunctionCallContext)
}

func (s *PrimaryExpressionContext) InterpString() IInterpStringContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IInterpStringContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IInterpStringContext)
}

func (s *PrimaryExpressionContext) MULTILINE_STRING() antlr.TerminalNode {
	return s.GetToken(bicepParserMULTILINE_STRING, 0)
}

func (s *PrimaryExpressionContext) Array() IArrayContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IArrayContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IArrayContext)
}

func (s *PrimaryExpressionContext) Object() IObjectContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IObjectContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IObjectContext)
}

func (s *PrimaryExpressionContext) ParenthesizedExpression() IParenthesizedExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IParenthesizedExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IParenthesizedExpressionContext)
}

func (s *PrimaryExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *PrimaryExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *PrimaryExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitPrimaryExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) PrimaryExpression() (localctx IPrimaryExpressionContext) {
	localctx = NewPrimaryExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 16, bicepParserRULE_primaryExpression)
	p.SetState(146)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 12, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(139)
			p.LiteralValue()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(140)
			p.FunctionCall()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(141)
			p.InterpString()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(142)
			p.Match(bicepParserMULTILINE_STRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(143)
			p.Array()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(144)
			p.Object()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(145)
			p.ParenthesizedExpression()
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IParenthesizedExpressionContext is an interface to support dynamic dispatch.
type IParenthesizedExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	OPAR() antlr.TerminalNode
	Expression() IExpressionContext
	CPAR() antlr.TerminalNode
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode

	// IsParenthesizedExpressionContext differentiates from other interfaces.
	IsParenthesizedExpressionContext()
}

type ParenthesizedExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyParenthesizedExpressionContext() *ParenthesizedExpressionContext {
	var p = new(ParenthesizedExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parenthesizedExpression
	return p
}

func InitEmptyParenthesizedExpressionContext(p *ParenthesizedExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_parenthesizedExpression
}

func (*ParenthesizedExpressionContext) IsParenthesizedExpressionContext() {}

func NewParenthesizedExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ParenthesizedExpressionContext {
	var p = new(ParenthesizedExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_parenthesizedExpression

	return p
}

func (s *ParenthesizedExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *ParenthesizedExpressionContext) OPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserOPAR, 0)
}

func (s *ParenthesizedExpressionContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ParenthesizedExpressionContext) CPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserCPAR, 0)
}

func (s *ParenthesizedExpressionContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ParenthesizedExpressionContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ParenthesizedExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ParenthesizedExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ParenthesizedExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitParenthesizedExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ParenthesizedExpression() (localctx IParenthesizedExpressionContext) {
	localctx = NewParenthesizedExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 18, bicepParserRULE_parenthesizedExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(148)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(150)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(149)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(152)
		p.expression(0)
	}
	p.SetState(154)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(153)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(156)
		p.Match(bicepParserCPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// ITypeExpressionContext is an interface to support dynamic dispatch.
type ITypeExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetType_ returns the type_ rule contexts.
	GetType_() IIdentifierContext

	// SetType_ sets the type_ rule contexts.
	SetType_(IIdentifierContext)

	// Getter signatures
	AllIdentifier() []IIdentifierContext
	Identifier(i int) IIdentifierContext
	AllPIPE() []antlr.TerminalNode
	PIPE(i int) antlr.TerminalNode

	// IsTypeExpressionContext differentiates from other interfaces.
	IsTypeExpressionContext()
}

type TypeExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	type_  IIdentifierContext
}

func NewEmptyTypeExpressionContext() *TypeExpressionContext {
	var p = new(TypeExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_typeExpression
	return p
}

func InitEmptyTypeExpressionContext(p *TypeExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_typeExpression
}

func (*TypeExpressionContext) IsTypeExpressionContext() {}

func NewTypeExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *TypeExpressionContext {
	var p = new(TypeExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_typeExpression

	return p
}

func (s *TypeExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *TypeExpressionContext) GetType_() IIdentifierContext { return s.type_ }

func (s *TypeExpressionContext) SetType_(v IIdentifierContext) { s.type_ = v }

func (s *TypeExpressionContext) AllIdentifier() []IIdentifierContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IIdentifierContext); ok {
			len++
		}
	}

	tst := make([]IIdentifierContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IIdentifierContext); ok {
			tst[i] = t.(IIdentifierContext)
			i++
		}
	}

	return tst
}

func (s *TypeExpressionContext) Identifier(i int) IIdentifierContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *TypeExpressionContext) AllPIPE() []antlr.TerminalNode {
	return s.GetTokens(bicepParserPIPE)
}

func (s *TypeExpressionContext) PIPE(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserPIPE, i)
}

func (s *TypeExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *TypeExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *TypeExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitTypeExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) TypeExpression() (localctx ITypeExpressionContext) {
	localctx = NewTypeExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 20, bicepParserRULE_typeExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(158)

		var _x = p.Identifier()

		localctx.(*TypeExpressionContext).type_ = _x
	}
	p.SetState(163)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserPIPE {
		{
			p.SetState(159)
			p.Match(bicepParserPIPE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(160)

			var _x = p.Identifier()

			localctx.(*TypeExpressionContext).type_ = _x
		}

		p.SetState(165)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// ILiteralValueContext is an interface to support dynamic dispatch.
type ILiteralValueContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	NUMBER() antlr.TerminalNode
	TRUE() antlr.TerminalNode
	FALSE() antlr.TerminalNode
	NULL() antlr.TerminalNode
	Identifier() IIdentifierContext

	// IsLiteralValueContext differentiates from other interfaces.
	IsLiteralValueContext()
}

type LiteralValueContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyLiteralValueContext() *LiteralValueContext {
	var p = new(LiteralValueContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_literalValue
	return p
}

func InitEmptyLiteralValueContext(p *LiteralValueContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_literalValue
}

func (*LiteralValueContext) IsLiteralValueContext() {}

func NewLiteralValueContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *LiteralValueContext {
	var p = new(LiteralValueContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_literalValue

	return p
}

func (s *LiteralValueContext) GetParser() antlr.Parser { return s.parser }

func (s *LiteralValueContext) NUMBER() antlr.TerminalNode {
	return s.GetToken(bicepParserNUMBER, 0)
}

func (s *LiteralValueContext) TRUE() antlr.TerminalNode {
	return s.GetToken(bicepParserTRUE, 0)
}

func (s *LiteralValueContext) FALSE() antlr.TerminalNode {
	return s.GetToken(bicepParserFALSE, 0)
}

func (s *LiteralValueContext) NULL() antlr.TerminalNode {
	return s.GetToken(bicepParserNULL, 0)
}

func (s *LiteralValueContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *LiteralValueContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *LiteralValueContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *LiteralValueContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitLiteralValue(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) LiteralValue() (localctx ILiteralValueContext) {
	localctx = NewLiteralValueContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 22, bicepParserRULE_literalValue)
	p.SetState(171)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 16, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(166)
			p.Match(bicepParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(167)
			p.Match(bicepParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(168)
			p.Match(bicepParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(169)
			p.Match(bicepParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(170)
			p.Identifier()
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IObjectContext is an interface to support dynamic dispatch.
type IObjectContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	OBRACE() antlr.TerminalNode
	CBRACE() antlr.TerminalNode
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode
	AllObjectProperty() []IObjectPropertyContext
	ObjectProperty(i int) IObjectPropertyContext

	// IsObjectContext differentiates from other interfaces.
	IsObjectContext()
}

type ObjectContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyObjectContext() *ObjectContext {
	var p = new(ObjectContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_object
	return p
}

func InitEmptyObjectContext(p *ObjectContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_object
}

func (*ObjectContext) IsObjectContext() {}

func NewObjectContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ObjectContext {
	var p = new(ObjectContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_object

	return p
}

func (s *ObjectContext) GetParser() antlr.Parser { return s.parser }

func (s *ObjectContext) OBRACE() antlr.TerminalNode {
	return s.GetToken(bicepParserOBRACE, 0)
}

func (s *ObjectContext) CBRACE() antlr.TerminalNode {
	return s.GetToken(bicepParserCBRACE, 0)
}

func (s *ObjectContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ObjectContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ObjectContext) AllObjectProperty() []IObjectPropertyContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IObjectPropertyContext); ok {
			len++
		}
	}

	tst := make([]IObjectPropertyContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IObjectPropertyContext); ok {
			tst[i] = t.(IObjectPropertyContext)
			i++
		}
	}

	return tst
}

func (s *ObjectContext) ObjectProperty(i int) IObjectPropertyContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IObjectPropertyContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IObjectPropertyContext)
}

func (s *ObjectContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ObjectContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ObjectContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitObject(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Object() (localctx IObjectContext) {
	localctx = NewObjectContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 24, bicepParserRULE_object)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(173)
		p.Match(bicepParserOBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(190)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		p.SetState(175)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(174)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(177)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}
		p.SetState(187)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&262127616) != 0 {
			{
				p.SetState(179)
				p.ObjectProperty()
			}
			p.SetState(181)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)

			for ok := true; ok; ok = _la == bicepParserNL {
				{
					p.SetState(180)
					p.Match(bicepParserNL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

				p.SetState(183)
				p.GetErrorHandler().Sync(p)
				if p.HasError() {
					goto errorExit
				}
				_la = p.GetTokenStream().LA(1)
			}

			p.SetState(189)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	}
	{
		p.SetState(192)
		p.Match(bicepParserCBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IObjectPropertyContext is an interface to support dynamic dispatch.
type IObjectPropertyContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// Getter signatures
	COL() antlr.TerminalNode
	Expression() IExpressionContext
	InterpString() IInterpStringContext
	Identifier() IIdentifierContext

	// IsObjectPropertyContext differentiates from other interfaces.
	IsObjectPropertyContext()
}

type ObjectPropertyContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
}

func NewEmptyObjectPropertyContext() *ObjectPropertyContext {
	var p = new(ObjectPropertyContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_objectProperty
	return p
}

func InitEmptyObjectPropertyContext(p *ObjectPropertyContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_objectProperty
}

func (*ObjectPropertyContext) IsObjectPropertyContext() {}

func NewObjectPropertyContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ObjectPropertyContext {
	var p = new(ObjectPropertyContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_objectProperty

	return p
}

func (s *ObjectPropertyContext) GetParser() antlr.Parser { return s.parser }

func (s *ObjectPropertyContext) GetName() IIdentifierContext { return s.name }

func (s *ObjectPropertyContext) SetName(v IIdentifierContext) { s.name = v }

func (s *ObjectPropertyContext) COL() antlr.TerminalNode {
	return s.GetToken(bicepParserCOL, 0)
}

func (s *ObjectPropertyContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ObjectPropertyContext) InterpString() IInterpStringContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IInterpStringContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IInterpStringContext)
}

func (s *ObjectPropertyContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *ObjectPropertyContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ObjectPropertyContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ObjectPropertyContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitObjectProperty(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ObjectProperty() (localctx IObjectPropertyContext) {
	localctx = NewObjectPropertyContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 26, bicepParserRULE_objectProperty)
	p.EnterOuterAlt(localctx, 1)
	p.SetState(196)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserRESOURCE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER:
		{
			p.SetState(194)

			var _x = p.Identifier()

			localctx.(*ObjectPropertyContext).name = _x
		}

	case bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE:
		{
			p.SetState(195)
			p.InterpString()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(198)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(199)
		p.expression(0)
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IArrayContext is an interface to support dynamic dispatch.
type IArrayContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	OBRACK() antlr.TerminalNode
	CBRACK() antlr.TerminalNode
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode
	AllArrayItem() []IArrayItemContext
	ArrayItem(i int) IArrayItemContext

	// IsArrayContext differentiates from other interfaces.
	IsArrayContext()
}

type ArrayContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyArrayContext() *ArrayContext {
	var p = new(ArrayContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_array
	return p
}

func InitEmptyArrayContext(p *ArrayContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_array
}

func (*ArrayContext) IsArrayContext() {}

func NewArrayContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ArrayContext {
	var p = new(ArrayContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_array

	return p
}

func (s *ArrayContext) GetParser() antlr.Parser { return s.parser }

func (s *ArrayContext) OBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserOBRACK, 0)
}

func (s *ArrayContext) CBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserCBRACK, 0)
}

func (s *ArrayContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ArrayContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ArrayContext) AllArrayItem() []IArrayItemContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IArrayItemContext); ok {
			len++
		}
	}

	tst := make([]IArrayItemContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IArrayItemContext); ok {
			tst[i] = t.(IArrayItemContext)
			i++
		}
	}

	return tst
}

func (s *ArrayContext) ArrayItem(i int) IArrayItemContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IArrayItemContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IArrayItemContext)
}

func (s *ArrayContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ArrayContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ArrayContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitArray(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Array() (localctx IArrayContext) {
	localctx = NewArrayContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 28, bicepParserRULE_array)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(201)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(205)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(202)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(207)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	p.SetState(211)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&530567250) != 0 {
		{
			p.SetState(208)
			p.ArrayItem()
		}

		p.SetState(213)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(214)
		p.Match(bicepParserCBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IArrayItemContext is an interface to support dynamic dispatch.
type IArrayItemContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	Expression() IExpressionContext
	COMMA() antlr.TerminalNode
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode

	// IsArrayItemContext differentiates from other interfaces.
	IsArrayItemContext()
}

type ArrayItemContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyArrayItemContext() *ArrayItemContext {
	var p = new(ArrayItemContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_arrayItem
	return p
}

func InitEmptyArrayItemContext(p *ArrayItemContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_arrayItem
}

func (*ArrayItemContext) IsArrayItemContext() {}

func NewArrayItemContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ArrayItemContext {
	var p = new(ArrayItemContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_arrayItem

	return p
}

func (s *ArrayItemContext) GetParser() antlr.Parser { return s.parser }

func (s *ArrayItemContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ArrayItemContext) COMMA() antlr.TerminalNode {
	return s.GetToken(bicepParserCOMMA, 0)
}

func (s *ArrayItemContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ArrayItemContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ArrayItemContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ArrayItemContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ArrayItemContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitArrayItem(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ArrayItem() (localctx IArrayItemContext) {
	localctx = NewArrayItemContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 30, bicepParserRULE_arrayItem)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(216)
		p.expression(0)
	}
	p.SetState(223)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	switch p.GetTokenStream().LA(1) {
	case bicepParserNL:
		p.SetState(218)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(217)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(220)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	case bicepParserCOMMA:
		{
			p.SetState(222)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserCBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserRESOURCE, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER, bicepParserNUMBER:

	default:
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IDecoratorContext is an interface to support dynamic dispatch.
type IDecoratorContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	AT() antlr.TerminalNode
	DecoratorExpression() IDecoratorExpressionContext
	NL() antlr.TerminalNode

	// IsDecoratorContext differentiates from other interfaces.
	IsDecoratorContext()
}

type DecoratorContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyDecoratorContext() *DecoratorContext {
	var p = new(DecoratorContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_decorator
	return p
}

func InitEmptyDecoratorContext(p *DecoratorContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_decorator
}

func (*DecoratorContext) IsDecoratorContext() {}

func NewDecoratorContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *DecoratorContext {
	var p = new(DecoratorContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_decorator

	return p
}

func (s *DecoratorContext) GetParser() antlr.Parser { return s.parser }

func (s *DecoratorContext) AT() antlr.TerminalNode {
	return s.GetToken(bicepParserAT, 0)
}

func (s *DecoratorContext) DecoratorExpression() IDecoratorExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IDecoratorExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IDecoratorExpressionContext)
}

func (s *DecoratorContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *DecoratorContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *DecoratorContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *DecoratorContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitDecorator(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Decorator() (localctx IDecoratorContext) {
	localctx = NewDecoratorContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 32, bicepParserRULE_decorator)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(225)
		p.Match(bicepParserAT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(226)
		p.DecoratorExpression()
	}
	{
		p.SetState(227)
		p.Match(bicepParserNL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IDecoratorExpressionContext is an interface to support dynamic dispatch.
type IDecoratorExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	FunctionCall() IFunctionCallContext
	Expression() IExpressionContext
	DOT() antlr.TerminalNode

	// IsDecoratorExpressionContext differentiates from other interfaces.
	IsDecoratorExpressionContext()
}

type DecoratorExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyDecoratorExpressionContext() *DecoratorExpressionContext {
	var p = new(DecoratorExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_decoratorExpression
	return p
}

func InitEmptyDecoratorExpressionContext(p *DecoratorExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_decoratorExpression
}

func (*DecoratorExpressionContext) IsDecoratorExpressionContext() {}

func NewDecoratorExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *DecoratorExpressionContext {
	var p = new(DecoratorExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_decoratorExpression

	return p
}

func (s *DecoratorExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *DecoratorExpressionContext) FunctionCall() IFunctionCallContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFunctionCallContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFunctionCallContext)
}

func (s *DecoratorExpressionContext) Expression() IExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *DecoratorExpressionContext) DOT() antlr.TerminalNode {
	return s.GetToken(bicepParserDOT, 0)
}

func (s *DecoratorExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *DecoratorExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *DecoratorExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitDecoratorExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) DecoratorExpression() (localctx IDecoratorExpressionContext) {
	localctx = NewDecoratorExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 34, bicepParserRULE_decoratorExpression)
	p.SetState(234)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 26, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(229)
			p.FunctionCall()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(230)
			p.expression(0)
		}
		{
			p.SetState(231)
			p.Match(bicepParserDOT)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(232)
			p.FunctionCall()
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IFunctionCallContext is an interface to support dynamic dispatch.
type IFunctionCallContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	Identifier() IIdentifierContext
	OPAR() antlr.TerminalNode
	CPAR() antlr.TerminalNode
	ArgumentList() IArgumentListContext
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode

	// IsFunctionCallContext differentiates from other interfaces.
	IsFunctionCallContext()
}

type FunctionCallContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyFunctionCallContext() *FunctionCallContext {
	var p = new(FunctionCallContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_functionCall
	return p
}

func InitEmptyFunctionCallContext(p *FunctionCallContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_functionCall
}

func (*FunctionCallContext) IsFunctionCallContext() {}

func NewFunctionCallContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *FunctionCallContext {
	var p = new(FunctionCallContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_functionCall

	return p
}

func (s *FunctionCallContext) GetParser() antlr.Parser { return s.parser }

func (s *FunctionCallContext) Identifier() IIdentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIdentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIdentifierContext)
}

func (s *FunctionCallContext) OPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserOPAR, 0)
}

func (s *FunctionCallContext) CPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserCPAR, 0)
}

func (s *FunctionCallContext) ArgumentList() IArgumentListContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IArgumentListContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IArgumentListContext)
}

func (s *FunctionCallContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *FunctionCallContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *FunctionCallContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *FunctionCallContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *FunctionCallContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitFunctionCall(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) FunctionCall() (localctx IFunctionCallContext) {
	localctx = NewFunctionCallContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 36, bicepParserRULE_functionCall)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(236)
		p.Identifier()
	}
	{
		p.SetState(237)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(242)
	p.GetErrorHandler().Sync(p)

	if p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 28, p.GetParserRuleContext()) == 1 {
		p.SetState(239)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(238)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(241)
			p.ArgumentList()
		}

	} else if p.HasError() { // JIM
		goto errorExit
	}
	p.SetState(245)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(244)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(247)
		p.Match(bicepParserCPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IArgumentListContext is an interface to support dynamic dispatch.
type IArgumentListContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	AllExpression() []IExpressionContext
	Expression(i int) IExpressionContext
	AllCOMMA() []antlr.TerminalNode
	COMMA(i int) antlr.TerminalNode
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode

	// IsArgumentListContext differentiates from other interfaces.
	IsArgumentListContext()
}

type ArgumentListContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyArgumentListContext() *ArgumentListContext {
	var p = new(ArgumentListContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_argumentList
	return p
}

func InitEmptyArgumentListContext(p *ArgumentListContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_argumentList
}

func (*ArgumentListContext) IsArgumentListContext() {}

func NewArgumentListContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ArgumentListContext {
	var p = new(ArgumentListContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_argumentList

	return p
}

func (s *ArgumentListContext) GetParser() antlr.Parser { return s.parser }

func (s *ArgumentListContext) AllExpression() []IExpressionContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IExpressionContext); ok {
			len++
		}
	}

	tst := make([]IExpressionContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IExpressionContext); ok {
			tst[i] = t.(IExpressionContext)
			i++
		}
	}

	return tst
}

func (s *ArgumentListContext) Expression(i int) IExpressionContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpressionContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpressionContext)
}

func (s *ArgumentListContext) AllCOMMA() []antlr.TerminalNode {
	return s.GetTokens(bicepParserCOMMA)
}

func (s *ArgumentListContext) COMMA(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserCOMMA, i)
}

func (s *ArgumentListContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ArgumentListContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ArgumentListContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ArgumentListContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ArgumentListContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitArgumentList(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ArgumentList() (localctx IArgumentListContext) {
	localctx = NewArgumentListContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 38, bicepParserRULE_argumentList)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(249)
		p.expression(0)
	}
	p.SetState(257)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserCOMMA {
		{
			p.SetState(250)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(252)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(251)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(254)
			p.expression(0)
		}

		p.SetState(259)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IIdentifierContext is an interface to support dynamic dispatch.
type IIdentifierContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	IDENTIFIER() antlr.TerminalNode
	PARAM() antlr.TerminalNode
	RESOURCE() antlr.TerminalNode
	VAR() antlr.TerminalNode
	TRUE() antlr.TerminalNode
	FALSE() antlr.TerminalNode
	NULL() antlr.TerminalNode
	STRING() antlr.TerminalNode
	INT() antlr.TerminalNode
	BOOL() antlr.TerminalNode

	// IsIdentifierContext differentiates from other interfaces.
	IsIdentifierContext()
}

type IdentifierContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyIdentifierContext() *IdentifierContext {
	var p = new(IdentifierContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_identifier
	return p
}

func InitEmptyIdentifierContext(p *IdentifierContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_identifier
}

func (*IdentifierContext) IsIdentifierContext() {}

func NewIdentifierContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *IdentifierContext {
	var p = new(IdentifierContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_identifier

	return p
}

func (s *IdentifierContext) GetParser() antlr.Parser { return s.parser }

func (s *IdentifierContext) IDENTIFIER() antlr.TerminalNode {
	return s.GetToken(bicepParserIDENTIFIER, 0)
}

func (s *IdentifierContext) PARAM() antlr.TerminalNode {
	return s.GetToken(bicepParserPARAM, 0)
}

func (s *IdentifierContext) RESOURCE() antlr.TerminalNode {
	return s.GetToken(bicepParserRESOURCE, 0)
}

func (s *IdentifierContext) VAR() antlr.TerminalNode {
	return s.GetToken(bicepParserVAR, 0)
}

func (s *IdentifierContext) TRUE() antlr.TerminalNode {
	return s.GetToken(bicepParserTRUE, 0)
}

func (s *IdentifierContext) FALSE() antlr.TerminalNode {
	return s.GetToken(bicepParserFALSE, 0)
}

func (s *IdentifierContext) NULL() antlr.TerminalNode {
	return s.GetToken(bicepParserNULL, 0)
}

func (s *IdentifierContext) STRING() antlr.TerminalNode {
	return s.GetToken(bicepParserSTRING, 0)
}

func (s *IdentifierContext) INT() antlr.TerminalNode {
	return s.GetToken(bicepParserINT, 0)
}

func (s *IdentifierContext) BOOL() antlr.TerminalNode {
	return s.GetToken(bicepParserBOOL, 0)
}

func (s *IdentifierContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *IdentifierContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *IdentifierContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitIdentifier(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Identifier() (localctx IIdentifierContext) {
	localctx = NewIdentifierContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 40, bicepParserRULE_identifier)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(260)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&252690432) != 0) {
			p.GetErrorHandler().RecoverInline(p)
		} else {
			p.GetErrorHandler().ReportMatch(p)
			p.Consume()
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

func (p *bicepParser) Sempred(localctx antlr.RuleContext, ruleIndex, predIndex int) bool {
	switch ruleIndex {
	case 7:
		var t *ExpressionContext = nil
		if localctx != nil {
			t = localctx.(*ExpressionContext)
		}
		return p.Expression_Sempred(t, predIndex)

	default:
		panic("No predicate with index: " + fmt.Sprint(ruleIndex))
	}
}

func (p *bicepParser) Expression_Sempred(localctx antlr.RuleContext, predIndex int) bool {
	switch predIndex {
	case 0:
		return p.Precpred(p.GetParserRuleContext(), 4)

	case 1:
		return p.Precpred(p.GetParserRuleContext(), 3)

	case 2:
		return p.Precpred(p.GetParserRuleContext(), 2)

	default:
		panic("No predicate with index: " + fmt.Sprint(predIndex))
	}
}
