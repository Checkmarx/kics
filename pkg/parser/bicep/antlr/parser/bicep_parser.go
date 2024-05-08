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
		"'object'", "'resource'", "'output'", "'existing'", "", "", "", "",
		"'string'", "'int'", "'bool'", "'if'", "'for'", "'in'", "'?'", "'>'",
		"'>='", "'<'", "'<='", "'=='", "'!='",
	}
	staticData.SymbolicNames = []string{
		"", "MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "OBJECT", "RESOURCE", "OUTPUT", "EXISTING",
		"STRING_LEFT_PIECE", "STRING_MIDDLE_PIECE", "STRING_RIGHT_PIECE", "STRING_COMPLETE",
		"STRING", "INT", "BOOL", "IF", "FOR", "IN", "QMARK", "GT", "GTE", "LT",
		"LTE", "EQ", "NEQ", "IDENTIFIER", "NUMBER", "NL", "SINGLE_LINE_COMMENT",
		"MULTI_LINE_COMMENT", "SPACES", "UNKNOWN",
	}
	staticData.RuleNames = []string{
		"program", "statement", "parameterDecl", "parameterDefaultValue", "variableDecl",
		"resourceDecl", "outputDecl", "ifCondition", "forExpression", "forVariableBlock",
		"forBody", "interpString", "expression", "logicCharacter", "primaryExpression",
		"parenthesizedExpression", "typeExpression", "literalValue", "object",
		"objectProperty", "array", "arrayItem", "decorator", "decoratorExpression",
		"functionCall", "argumentList", "identifier",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 46, 352, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
		10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15,
		2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7, 20, 2,
		21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25, 2, 26,
		7, 26, 1, 0, 5, 0, 56, 8, 0, 10, 0, 12, 0, 59, 9, 0, 1, 0, 1, 0, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 68, 8, 1, 1, 2, 5, 2, 71, 8, 2, 10, 2, 12,
		2, 74, 9, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 80, 8, 2, 1, 2, 1, 2, 1, 2,
		3, 2, 85, 8, 2, 3, 2, 87, 8, 2, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 1, 4, 5,
		4, 95, 8, 4, 10, 4, 12, 4, 98, 9, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4,
		1, 5, 5, 5, 107, 8, 5, 10, 5, 12, 5, 110, 9, 5, 1, 5, 1, 5, 1, 5, 1, 5,
		3, 5, 116, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 122, 8, 5, 1, 5, 1, 5, 1,
		6, 5, 6, 127, 8, 6, 10, 6, 12, 6, 130, 9, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1,
		6, 3, 6, 137, 8, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 1,
		8, 1, 8, 5, 8, 149, 8, 8, 10, 8, 12, 8, 152, 9, 8, 1, 8, 1, 8, 1, 8, 3,
		8, 157, 8, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 5, 8, 164, 8, 8, 10, 8, 12,
		8, 167, 9, 8, 1, 8, 1, 8, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 1, 10, 1,
		10, 3, 10, 179, 8, 10, 1, 11, 1, 11, 1, 11, 1, 11, 5, 11, 185, 8, 11, 10,
		11, 12, 11, 188, 9, 11, 1, 11, 1, 11, 1, 11, 1, 11, 3, 11, 194, 8, 11,
		1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1,
		12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12,
		1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 5,
		12, 227, 8, 12, 10, 12, 12, 12, 230, 9, 12, 1, 13, 1, 13, 1, 14, 1, 14,
		1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 242, 8, 14, 1, 15, 1,
		15, 3, 15, 246, 8, 15, 1, 15, 1, 15, 3, 15, 250, 8, 15, 1, 15, 1, 15, 1,
		16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 3, 17, 261, 8, 17, 1, 18,
		1, 18, 4, 18, 265, 8, 18, 11, 18, 12, 18, 266, 1, 18, 1, 18, 4, 18, 271,
		8, 18, 11, 18, 12, 18, 272, 5, 18, 275, 8, 18, 10, 18, 12, 18, 278, 9,
		18, 3, 18, 280, 8, 18, 1, 18, 1, 18, 1, 19, 1, 19, 3, 19, 286, 8, 19, 1,
		19, 1, 19, 1, 19, 1, 20, 1, 20, 5, 20, 293, 8, 20, 10, 20, 12, 20, 296,
		9, 20, 1, 20, 5, 20, 299, 8, 20, 10, 20, 12, 20, 302, 9, 20, 1, 20, 1,
		20, 1, 21, 1, 21, 4, 21, 308, 8, 21, 11, 21, 12, 21, 309, 1, 21, 3, 21,
		313, 8, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 23, 1, 23, 1, 23, 1, 23, 1,
		23, 3, 23, 324, 8, 23, 1, 24, 1, 24, 1, 24, 3, 24, 329, 8, 24, 1, 24, 3,
		24, 332, 8, 24, 1, 24, 3, 24, 335, 8, 24, 1, 24, 1, 24, 1, 25, 1, 25, 1,
		25, 3, 25, 342, 8, 25, 1, 25, 5, 25, 345, 8, 25, 10, 25, 12, 25, 348, 9,
		25, 1, 26, 1, 26, 1, 26, 0, 1, 24, 27, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
		20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 0,
		2, 1, 0, 34, 39, 3, 0, 14, 20, 27, 29, 40, 40, 382, 0, 57, 1, 0, 0, 0,
		2, 67, 1, 0, 0, 0, 4, 72, 1, 0, 0, 0, 6, 90, 1, 0, 0, 0, 8, 96, 1, 0, 0,
		0, 10, 108, 1, 0, 0, 0, 12, 128, 1, 0, 0, 0, 14, 142, 1, 0, 0, 0, 16, 146,
		1, 0, 0, 0, 18, 170, 1, 0, 0, 0, 20, 178, 1, 0, 0, 0, 22, 193, 1, 0, 0,
		0, 24, 195, 1, 0, 0, 0, 26, 231, 1, 0, 0, 0, 28, 241, 1, 0, 0, 0, 30, 243,
		1, 0, 0, 0, 32, 253, 1, 0, 0, 0, 34, 260, 1, 0, 0, 0, 36, 262, 1, 0, 0,
		0, 38, 285, 1, 0, 0, 0, 40, 290, 1, 0, 0, 0, 42, 305, 1, 0, 0, 0, 44, 314,
		1, 0, 0, 0, 46, 323, 1, 0, 0, 0, 48, 325, 1, 0, 0, 0, 50, 338, 1, 0, 0,
		0, 52, 349, 1, 0, 0, 0, 54, 56, 3, 2, 1, 0, 55, 54, 1, 0, 0, 0, 56, 59,
		1, 0, 0, 0, 57, 55, 1, 0, 0, 0, 57, 58, 1, 0, 0, 0, 58, 60, 1, 0, 0, 0,
		59, 57, 1, 0, 0, 0, 60, 61, 5, 0, 0, 1, 61, 1, 1, 0, 0, 0, 62, 68, 3, 4,
		2, 0, 63, 68, 3, 8, 4, 0, 64, 68, 3, 10, 5, 0, 65, 68, 3, 12, 6, 0, 66,
		68, 5, 42, 0, 0, 67, 62, 1, 0, 0, 0, 67, 63, 1, 0, 0, 0, 67, 64, 1, 0,
		0, 0, 67, 65, 1, 0, 0, 0, 67, 66, 1, 0, 0, 0, 68, 3, 1, 0, 0, 0, 69, 71,
		3, 44, 22, 0, 70, 69, 1, 0, 0, 0, 71, 74, 1, 0, 0, 0, 72, 70, 1, 0, 0,
		0, 72, 73, 1, 0, 0, 0, 73, 75, 1, 0, 0, 0, 74, 72, 1, 0, 0, 0, 75, 76,
		5, 14, 0, 0, 76, 86, 3, 52, 26, 0, 77, 79, 3, 32, 16, 0, 78, 80, 3, 6,
		3, 0, 79, 78, 1, 0, 0, 0, 79, 80, 1, 0, 0, 0, 80, 87, 1, 0, 0, 0, 81, 82,
		5, 20, 0, 0, 82, 84, 3, 22, 11, 0, 83, 85, 3, 6, 3, 0, 84, 83, 1, 0, 0,
		0, 84, 85, 1, 0, 0, 0, 85, 87, 1, 0, 0, 0, 86, 77, 1, 0, 0, 0, 86, 81,
		1, 0, 0, 0, 87, 88, 1, 0, 0, 0, 88, 89, 5, 42, 0, 0, 89, 5, 1, 0, 0, 0,
		90, 91, 5, 11, 0, 0, 91, 92, 3, 24, 12, 0, 92, 7, 1, 0, 0, 0, 93, 95, 3,
		44, 22, 0, 94, 93, 1, 0, 0, 0, 95, 98, 1, 0, 0, 0, 96, 94, 1, 0, 0, 0,
		96, 97, 1, 0, 0, 0, 97, 99, 1, 0, 0, 0, 98, 96, 1, 0, 0, 0, 99, 100, 5,
		15, 0, 0, 100, 101, 3, 52, 26, 0, 101, 102, 5, 11, 0, 0, 102, 103, 3, 24,
		12, 0, 103, 104, 5, 42, 0, 0, 104, 9, 1, 0, 0, 0, 105, 107, 3, 44, 22,
		0, 106, 105, 1, 0, 0, 0, 107, 110, 1, 0, 0, 0, 108, 106, 1, 0, 0, 0, 108,
		109, 1, 0, 0, 0, 109, 111, 1, 0, 0, 0, 110, 108, 1, 0, 0, 0, 111, 112,
		5, 20, 0, 0, 112, 113, 3, 52, 26, 0, 113, 115, 3, 22, 11, 0, 114, 116,
		5, 22, 0, 0, 115, 114, 1, 0, 0, 0, 115, 116, 1, 0, 0, 0, 116, 117, 1, 0,
		0, 0, 117, 121, 5, 11, 0, 0, 118, 122, 3, 14, 7, 0, 119, 122, 3, 36, 18,
		0, 120, 122, 3, 16, 8, 0, 121, 118, 1, 0, 0, 0, 121, 119, 1, 0, 0, 0, 121,
		120, 1, 0, 0, 0, 122, 123, 1, 0, 0, 0, 123, 124, 5, 42, 0, 0, 124, 11,
		1, 0, 0, 0, 125, 127, 3, 44, 22, 0, 126, 125, 1, 0, 0, 0, 127, 130, 1,
		0, 0, 0, 128, 126, 1, 0, 0, 0, 128, 129, 1, 0, 0, 0, 129, 131, 1, 0, 0,
		0, 130, 128, 1, 0, 0, 0, 131, 132, 5, 21, 0, 0, 132, 136, 3, 52, 26, 0,
		133, 137, 3, 52, 26, 0, 134, 135, 5, 20, 0, 0, 135, 137, 3, 22, 11, 0,
		136, 133, 1, 0, 0, 0, 136, 134, 1, 0, 0, 0, 137, 138, 1, 0, 0, 0, 138,
		139, 5, 11, 0, 0, 139, 140, 3, 24, 12, 0, 140, 141, 5, 42, 0, 0, 141, 13,
		1, 0, 0, 0, 142, 143, 5, 30, 0, 0, 143, 144, 3, 30, 15, 0, 144, 145, 3,
		36, 18, 0, 145, 15, 1, 0, 0, 0, 146, 150, 5, 4, 0, 0, 147, 149, 5, 42,
		0, 0, 148, 147, 1, 0, 0, 0, 149, 152, 1, 0, 0, 0, 150, 148, 1, 0, 0, 0,
		150, 151, 1, 0, 0, 0, 151, 153, 1, 0, 0, 0, 152, 150, 1, 0, 0, 0, 153,
		156, 5, 31, 0, 0, 154, 157, 3, 52, 26, 0, 155, 157, 3, 18, 9, 0, 156, 154,
		1, 0, 0, 0, 156, 155, 1, 0, 0, 0, 157, 158, 1, 0, 0, 0, 158, 159, 5, 32,
		0, 0, 159, 160, 3, 24, 12, 0, 160, 161, 5, 10, 0, 0, 161, 165, 3, 20, 10,
		0, 162, 164, 5, 42, 0, 0, 163, 162, 1, 0, 0, 0, 164, 167, 1, 0, 0, 0, 165,
		163, 1, 0, 0, 0, 165, 166, 1, 0, 0, 0, 166, 168, 1, 0, 0, 0, 167, 165,
		1, 0, 0, 0, 168, 169, 5, 5, 0, 0, 169, 17, 1, 0, 0, 0, 170, 171, 5, 6,
		0, 0, 171, 172, 3, 52, 26, 0, 172, 173, 5, 3, 0, 0, 173, 174, 3, 52, 26,
		0, 174, 175, 5, 7, 0, 0, 175, 19, 1, 0, 0, 0, 176, 179, 3, 24, 12, 0, 177,
		179, 3, 14, 7, 0, 178, 176, 1, 0, 0, 0, 178, 177, 1, 0, 0, 0, 179, 21,
		1, 0, 0, 0, 180, 186, 5, 23, 0, 0, 181, 182, 3, 24, 12, 0, 182, 183, 5,
		24, 0, 0, 183, 185, 1, 0, 0, 0, 184, 181, 1, 0, 0, 0, 185, 188, 1, 0, 0,
		0, 186, 184, 1, 0, 0, 0, 186, 187, 1, 0, 0, 0, 187, 189, 1, 0, 0, 0, 188,
		186, 1, 0, 0, 0, 189, 190, 3, 24, 12, 0, 190, 191, 5, 25, 0, 0, 191, 194,
		1, 0, 0, 0, 192, 194, 5, 26, 0, 0, 193, 180, 1, 0, 0, 0, 193, 192, 1, 0,
		0, 0, 194, 23, 1, 0, 0, 0, 195, 196, 6, 12, -1, 0, 196, 197, 3, 28, 14,
		0, 197, 228, 1, 0, 0, 0, 198, 199, 10, 7, 0, 0, 199, 200, 5, 33, 0, 0,
		200, 201, 3, 24, 12, 0, 201, 202, 5, 10, 0, 0, 202, 203, 3, 24, 12, 8,
		203, 227, 1, 0, 0, 0, 204, 205, 10, 2, 0, 0, 205, 206, 3, 26, 13, 0, 206,
		207, 3, 24, 12, 3, 207, 227, 1, 0, 0, 0, 208, 209, 10, 8, 0, 0, 209, 210,
		5, 4, 0, 0, 210, 211, 3, 24, 12, 0, 211, 212, 5, 5, 0, 0, 212, 227, 1,
		0, 0, 0, 213, 214, 10, 6, 0, 0, 214, 215, 5, 8, 0, 0, 215, 227, 3, 52,
		26, 0, 216, 217, 10, 5, 0, 0, 217, 218, 5, 8, 0, 0, 218, 227, 3, 48, 24,
		0, 219, 220, 10, 4, 0, 0, 220, 221, 5, 10, 0, 0, 221, 227, 3, 52, 26, 0,
		222, 223, 10, 3, 0, 0, 223, 224, 5, 10, 0, 0, 224, 225, 5, 10, 0, 0, 225,
		227, 3, 52, 26, 0, 226, 198, 1, 0, 0, 0, 226, 204, 1, 0, 0, 0, 226, 208,
		1, 0, 0, 0, 226, 213, 1, 0, 0, 0, 226, 216, 1, 0, 0, 0, 226, 219, 1, 0,
		0, 0, 226, 222, 1, 0, 0, 0, 227, 230, 1, 0, 0, 0, 228, 226, 1, 0, 0, 0,
		228, 229, 1, 0, 0, 0, 229, 25, 1, 0, 0, 0, 230, 228, 1, 0, 0, 0, 231, 232,
		7, 0, 0, 0, 232, 27, 1, 0, 0, 0, 233, 242, 3, 34, 17, 0, 234, 242, 3, 48,
		24, 0, 235, 242, 3, 22, 11, 0, 236, 242, 5, 1, 0, 0, 237, 242, 3, 40, 20,
		0, 238, 242, 3, 36, 18, 0, 239, 242, 3, 16, 8, 0, 240, 242, 3, 30, 15,
		0, 241, 233, 1, 0, 0, 0, 241, 234, 1, 0, 0, 0, 241, 235, 1, 0, 0, 0, 241,
		236, 1, 0, 0, 0, 241, 237, 1, 0, 0, 0, 241, 238, 1, 0, 0, 0, 241, 239,
		1, 0, 0, 0, 241, 240, 1, 0, 0, 0, 242, 29, 1, 0, 0, 0, 243, 245, 5, 6,
		0, 0, 244, 246, 5, 42, 0, 0, 245, 244, 1, 0, 0, 0, 245, 246, 1, 0, 0, 0,
		246, 247, 1, 0, 0, 0, 247, 249, 3, 24, 12, 0, 248, 250, 5, 42, 0, 0, 249,
		248, 1, 0, 0, 0, 249, 250, 1, 0, 0, 0, 250, 251, 1, 0, 0, 0, 251, 252,
		5, 7, 0, 0, 252, 31, 1, 0, 0, 0, 253, 254, 3, 52, 26, 0, 254, 33, 1, 0,
		0, 0, 255, 261, 5, 41, 0, 0, 256, 261, 5, 16, 0, 0, 257, 261, 5, 17, 0,
		0, 258, 261, 5, 18, 0, 0, 259, 261, 3, 52, 26, 0, 260, 255, 1, 0, 0, 0,
		260, 256, 1, 0, 0, 0, 260, 257, 1, 0, 0, 0, 260, 258, 1, 0, 0, 0, 260,
		259, 1, 0, 0, 0, 261, 35, 1, 0, 0, 0, 262, 279, 5, 12, 0, 0, 263, 265,
		5, 42, 0, 0, 264, 263, 1, 0, 0, 0, 265, 266, 1, 0, 0, 0, 266, 264, 1, 0,
		0, 0, 266, 267, 1, 0, 0, 0, 267, 276, 1, 0, 0, 0, 268, 270, 3, 38, 19,
		0, 269, 271, 5, 42, 0, 0, 270, 269, 1, 0, 0, 0, 271, 272, 1, 0, 0, 0, 272,
		270, 1, 0, 0, 0, 272, 273, 1, 0, 0, 0, 273, 275, 1, 0, 0, 0, 274, 268,
		1, 0, 0, 0, 275, 278, 1, 0, 0, 0, 276, 274, 1, 0, 0, 0, 276, 277, 1, 0,
		0, 0, 277, 280, 1, 0, 0, 0, 278, 276, 1, 0, 0, 0, 279, 264, 1, 0, 0, 0,
		279, 280, 1, 0, 0, 0, 280, 281, 1, 0, 0, 0, 281, 282, 5, 13, 0, 0, 282,
		37, 1, 0, 0, 0, 283, 286, 3, 52, 26, 0, 284, 286, 3, 22, 11, 0, 285, 283,
		1, 0, 0, 0, 285, 284, 1, 0, 0, 0, 286, 287, 1, 0, 0, 0, 287, 288, 5, 10,
		0, 0, 288, 289, 3, 24, 12, 0, 289, 39, 1, 0, 0, 0, 290, 294, 5, 4, 0, 0,
		291, 293, 5, 42, 0, 0, 292, 291, 1, 0, 0, 0, 293, 296, 1, 0, 0, 0, 294,
		292, 1, 0, 0, 0, 294, 295, 1, 0, 0, 0, 295, 300, 1, 0, 0, 0, 296, 294,
		1, 0, 0, 0, 297, 299, 3, 42, 21, 0, 298, 297, 1, 0, 0, 0, 299, 302, 1,
		0, 0, 0, 300, 298, 1, 0, 0, 0, 300, 301, 1, 0, 0, 0, 301, 303, 1, 0, 0,
		0, 302, 300, 1, 0, 0, 0, 303, 304, 5, 5, 0, 0, 304, 41, 1, 0, 0, 0, 305,
		312, 3, 24, 12, 0, 306, 308, 5, 42, 0, 0, 307, 306, 1, 0, 0, 0, 308, 309,
		1, 0, 0, 0, 309, 307, 1, 0, 0, 0, 309, 310, 1, 0, 0, 0, 310, 313, 1, 0,
		0, 0, 311, 313, 5, 3, 0, 0, 312, 307, 1, 0, 0, 0, 312, 311, 1, 0, 0, 0,
		312, 313, 1, 0, 0, 0, 313, 43, 1, 0, 0, 0, 314, 315, 5, 2, 0, 0, 315, 316,
		3, 46, 23, 0, 316, 317, 5, 42, 0, 0, 317, 45, 1, 0, 0, 0, 318, 324, 3,
		48, 24, 0, 319, 320, 3, 24, 12, 0, 320, 321, 5, 8, 0, 0, 321, 322, 3, 48,
		24, 0, 322, 324, 1, 0, 0, 0, 323, 318, 1, 0, 0, 0, 323, 319, 1, 0, 0, 0,
		324, 47, 1, 0, 0, 0, 325, 326, 3, 52, 26, 0, 326, 331, 5, 6, 0, 0, 327,
		329, 5, 42, 0, 0, 328, 327, 1, 0, 0, 0, 328, 329, 1, 0, 0, 0, 329, 330,
		1, 0, 0, 0, 330, 332, 3, 50, 25, 0, 331, 328, 1, 0, 0, 0, 331, 332, 1,
		0, 0, 0, 332, 334, 1, 0, 0, 0, 333, 335, 5, 42, 0, 0, 334, 333, 1, 0, 0,
		0, 334, 335, 1, 0, 0, 0, 335, 336, 1, 0, 0, 0, 336, 337, 5, 7, 0, 0, 337,
		49, 1, 0, 0, 0, 338, 346, 3, 24, 12, 0, 339, 341, 5, 3, 0, 0, 340, 342,
		5, 42, 0, 0, 341, 340, 1, 0, 0, 0, 341, 342, 1, 0, 0, 0, 342, 343, 1, 0,
		0, 0, 343, 345, 3, 24, 12, 0, 344, 339, 1, 0, 0, 0, 345, 348, 1, 0, 0,
		0, 346, 344, 1, 0, 0, 0, 346, 347, 1, 0, 0, 0, 347, 51, 1, 0, 0, 0, 348,
		346, 1, 0, 0, 0, 349, 350, 7, 1, 0, 0, 350, 53, 1, 0, 0, 0, 39, 57, 67,
		72, 79, 84, 86, 96, 108, 115, 121, 128, 136, 150, 156, 165, 178, 186, 193,
		226, 228, 241, 245, 249, 260, 266, 272, 276, 279, 285, 294, 300, 309, 312,
		323, 328, 331, 334, 341, 346,
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
	bicepParserOBJECT              = 19
	bicepParserRESOURCE            = 20
	bicepParserOUTPUT              = 21
	bicepParserEXISTING            = 22
	bicepParserSTRING_LEFT_PIECE   = 23
	bicepParserSTRING_MIDDLE_PIECE = 24
	bicepParserSTRING_RIGHT_PIECE  = 25
	bicepParserSTRING_COMPLETE     = 26
	bicepParserSTRING              = 27
	bicepParserINT                 = 28
	bicepParserBOOL                = 29
	bicepParserIF                  = 30
	bicepParserFOR                 = 31
	bicepParserIN                  = 32
	bicepParserQMARK               = 33
	bicepParserGT                  = 34
	bicepParserGTE                 = 35
	bicepParserLT                  = 36
	bicepParserLTE                 = 37
	bicepParserEQ                  = 38
	bicepParserNEQ                 = 39
	bicepParserIDENTIFIER          = 40
	bicepParserNUMBER              = 41
	bicepParserNL                  = 42
	bicepParserSINGLE_LINE_COMMENT = 43
	bicepParserMULTI_LINE_COMMENT  = 44
	bicepParserSPACES              = 45
	bicepParserUNKNOWN             = 46
)

// bicepParser rules.
const (
	bicepParserRULE_program                 = 0
	bicepParserRULE_statement               = 1
	bicepParserRULE_parameterDecl           = 2
	bicepParserRULE_parameterDefaultValue   = 3
	bicepParserRULE_variableDecl            = 4
	bicepParserRULE_resourceDecl            = 5
	bicepParserRULE_outputDecl              = 6
	bicepParserRULE_ifCondition             = 7
	bicepParserRULE_forExpression           = 8
	bicepParserRULE_forVariableBlock        = 9
	bicepParserRULE_forBody                 = 10
	bicepParserRULE_interpString            = 11
	bicepParserRULE_expression              = 12
	bicepParserRULE_logicCharacter          = 13
	bicepParserRULE_primaryExpression       = 14
	bicepParserRULE_parenthesizedExpression = 15
	bicepParserRULE_typeExpression          = 16
	bicepParserRULE_literalValue            = 17
	bicepParserRULE_object                  = 18
	bicepParserRULE_objectProperty          = 19
	bicepParserRULE_array                   = 20
	bicepParserRULE_arrayItem               = 21
	bicepParserRULE_decorator               = 22
	bicepParserRULE_decoratorExpression     = 23
	bicepParserRULE_functionCall            = 24
	bicepParserRULE_argumentList            = 25
	bicepParserRULE_identifier              = 26
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
	p.SetState(57)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&4398049705988) != 0 {
		{
			p.SetState(54)
			p.Statement()
		}

		p.SetState(59)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(60)
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
	OutputDecl() IOutputDeclContext
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

func (s *StatementContext) OutputDecl() IOutputDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IOutputDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IOutputDeclContext)
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
	p.SetState(67)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(62)
			p.ParameterDecl()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(63)
			p.VariableDecl()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(64)
			p.ResourceDecl()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(65)
			p.OutputDecl()
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(66)
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
	p.SetState(72)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(69)
			p.Decorator()
		}

		p.SetState(74)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(75)
		p.Match(bicepParserPARAM)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(76)

		var _x = p.Identifier()

		localctx.(*ParameterDeclContext).name = _x
	}
	p.SetState(86)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 5, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(77)
			p.TypeExpression()
		}
		p.SetState(79)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(78)
				p.ParameterDefaultValue()
			}

		}

	case 2:
		{
			p.SetState(81)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(82)

			var _x = p.InterpString()

			localctx.(*ParameterDeclContext).type_ = _x
		}
		p.SetState(84)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(83)
				p.ParameterDefaultValue()
			}

		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(88)
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
		p.SetState(90)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(91)
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
	p.SetState(96)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(93)
			p.Decorator()
		}

		p.SetState(98)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(99)
		p.Match(bicepParserVAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(100)

		var _x = p.Identifier()

		localctx.(*VariableDeclContext).name = _x
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
		p.expression(0)
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
	IfCondition() IIfConditionContext
	Object() IObjectContext
	ForExpression() IForExpressionContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext
	EXISTING() antlr.TerminalNode

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

func (s *ResourceDeclContext) IfCondition() IIfConditionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIfConditionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIfConditionContext)
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

func (s *ResourceDeclContext) ForExpression() IForExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IForExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IForExpressionContext)
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

func (s *ResourceDeclContext) EXISTING() antlr.TerminalNode {
	return s.GetToken(bicepParserEXISTING, 0)
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
	p.SetState(108)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(105)
			p.Decorator()
		}

		p.SetState(110)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(111)
		p.Match(bicepParserRESOURCE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(112)

		var _x = p.Identifier()

		localctx.(*ResourceDeclContext).name = _x
	}
	{
		p.SetState(113)

		var _x = p.InterpString()

		localctx.(*ResourceDeclContext).type_ = _x
	}
	p.SetState(115)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserEXISTING {
		{
			p.SetState(114)
			p.Match(bicepParserEXISTING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(117)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(121)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(118)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(119)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(120)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(123)
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

// IOutputDeclContext is an interface to support dynamic dispatch.
type IOutputDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// GetType1 returns the type1 rule contexts.
	GetType1() IIdentifierContext

	// GetType2 returns the type2 rule contexts.
	GetType2() IInterpStringContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// SetType1 sets the type1 rule contexts.
	SetType1(IIdentifierContext)

	// SetType2 sets the type2 rule contexts.
	SetType2(IInterpStringContext)

	// Getter signatures
	OUTPUT() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	Expression() IExpressionContext
	NL() antlr.TerminalNode
	AllIdentifier() []IIdentifierContext
	Identifier(i int) IIdentifierContext
	RESOURCE() antlr.TerminalNode
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext
	InterpString() IInterpStringContext

	// IsOutputDeclContext differentiates from other interfaces.
	IsOutputDeclContext()
}

type OutputDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
	type1  IIdentifierContext
	type2  IInterpStringContext
}

func NewEmptyOutputDeclContext() *OutputDeclContext {
	var p = new(OutputDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_outputDecl
	return p
}

func InitEmptyOutputDeclContext(p *OutputDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_outputDecl
}

func (*OutputDeclContext) IsOutputDeclContext() {}

func NewOutputDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *OutputDeclContext {
	var p = new(OutputDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_outputDecl

	return p
}

func (s *OutputDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *OutputDeclContext) GetName() IIdentifierContext { return s.name }

func (s *OutputDeclContext) GetType1() IIdentifierContext { return s.type1 }

func (s *OutputDeclContext) GetType2() IInterpStringContext { return s.type2 }

func (s *OutputDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *OutputDeclContext) SetType1(v IIdentifierContext) { s.type1 = v }

func (s *OutputDeclContext) SetType2(v IInterpStringContext) { s.type2 = v }

func (s *OutputDeclContext) OUTPUT() antlr.TerminalNode {
	return s.GetToken(bicepParserOUTPUT, 0)
}

func (s *OutputDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *OutputDeclContext) Expression() IExpressionContext {
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

func (s *OutputDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *OutputDeclContext) AllIdentifier() []IIdentifierContext {
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

func (s *OutputDeclContext) Identifier(i int) IIdentifierContext {
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

func (s *OutputDeclContext) RESOURCE() antlr.TerminalNode {
	return s.GetToken(bicepParserRESOURCE, 0)
}

func (s *OutputDeclContext) AllDecorator() []IDecoratorContext {
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

func (s *OutputDeclContext) Decorator(i int) IDecoratorContext {
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

func (s *OutputDeclContext) InterpString() IInterpStringContext {
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

func (s *OutputDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *OutputDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *OutputDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitOutputDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) OutputDecl() (localctx IOutputDeclContext) {
	localctx = NewOutputDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 12, bicepParserRULE_outputDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(128)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(125)
			p.Decorator()
		}

		p.SetState(130)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(131)
		p.Match(bicepParserOUTPUT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(132)

		var _x = p.Identifier()

		localctx.(*OutputDeclContext).name = _x
	}
	p.SetState(136)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 11, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(133)

			var _x = p.Identifier()

			localctx.(*OutputDeclContext).type1 = _x
		}

	case 2:
		{
			p.SetState(134)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(135)

			var _x = p.InterpString()

			localctx.(*OutputDeclContext).type2 = _x
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(138)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(139)
		p.expression(0)
	}
	{
		p.SetState(140)
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

// IIfConditionContext is an interface to support dynamic dispatch.
type IIfConditionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	IF() antlr.TerminalNode
	ParenthesizedExpression() IParenthesizedExpressionContext
	Object() IObjectContext

	// IsIfConditionContext differentiates from other interfaces.
	IsIfConditionContext()
}

type IfConditionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyIfConditionContext() *IfConditionContext {
	var p = new(IfConditionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_ifCondition
	return p
}

func InitEmptyIfConditionContext(p *IfConditionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_ifCondition
}

func (*IfConditionContext) IsIfConditionContext() {}

func NewIfConditionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *IfConditionContext {
	var p = new(IfConditionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_ifCondition

	return p
}

func (s *IfConditionContext) GetParser() antlr.Parser { return s.parser }

func (s *IfConditionContext) IF() antlr.TerminalNode {
	return s.GetToken(bicepParserIF, 0)
}

func (s *IfConditionContext) ParenthesizedExpression() IParenthesizedExpressionContext {
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

func (s *IfConditionContext) Object() IObjectContext {
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

func (s *IfConditionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *IfConditionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *IfConditionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitIfCondition(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) IfCondition() (localctx IIfConditionContext) {
	localctx = NewIfConditionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 14, bicepParserRULE_ifCondition)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(142)
		p.Match(bicepParserIF)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(143)
		p.ParenthesizedExpression()
	}
	{
		p.SetState(144)
		p.Object()
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

// IForExpressionContext is an interface to support dynamic dispatch.
type IForExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetItem returns the item rule contexts.
	GetItem() IIdentifierContext

	// SetItem sets the item rule contexts.
	SetItem(IIdentifierContext)

	// Getter signatures
	OBRACK() antlr.TerminalNode
	FOR() antlr.TerminalNode
	IN() antlr.TerminalNode
	Expression() IExpressionContext
	COL() antlr.TerminalNode
	ForBody() IForBodyContext
	CBRACK() antlr.TerminalNode
	ForVariableBlock() IForVariableBlockContext
	AllNL() []antlr.TerminalNode
	NL(i int) antlr.TerminalNode
	Identifier() IIdentifierContext

	// IsForExpressionContext differentiates from other interfaces.
	IsForExpressionContext()
}

type ForExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	item   IIdentifierContext
}

func NewEmptyForExpressionContext() *ForExpressionContext {
	var p = new(ForExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forExpression
	return p
}

func InitEmptyForExpressionContext(p *ForExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forExpression
}

func (*ForExpressionContext) IsForExpressionContext() {}

func NewForExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ForExpressionContext {
	var p = new(ForExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_forExpression

	return p
}

func (s *ForExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *ForExpressionContext) GetItem() IIdentifierContext { return s.item }

func (s *ForExpressionContext) SetItem(v IIdentifierContext) { s.item = v }

func (s *ForExpressionContext) OBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserOBRACK, 0)
}

func (s *ForExpressionContext) FOR() antlr.TerminalNode {
	return s.GetToken(bicepParserFOR, 0)
}

func (s *ForExpressionContext) IN() antlr.TerminalNode {
	return s.GetToken(bicepParserIN, 0)
}

func (s *ForExpressionContext) Expression() IExpressionContext {
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

func (s *ForExpressionContext) COL() antlr.TerminalNode {
	return s.GetToken(bicepParserCOL, 0)
}

func (s *ForExpressionContext) ForBody() IForBodyContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IForBodyContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IForBodyContext)
}

func (s *ForExpressionContext) CBRACK() antlr.TerminalNode {
	return s.GetToken(bicepParserCBRACK, 0)
}

func (s *ForExpressionContext) ForVariableBlock() IForVariableBlockContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IForVariableBlockContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IForVariableBlockContext)
}

func (s *ForExpressionContext) AllNL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserNL)
}

func (s *ForExpressionContext) NL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserNL, i)
}

func (s *ForExpressionContext) Identifier() IIdentifierContext {
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

func (s *ForExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ForExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ForExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitForExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ForExpression() (localctx IForExpressionContext) {
	localctx = NewForExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 16, bicepParserRULE_forExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(146)
		p.Match(bicepParserOBRACK)
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

	for _la == bicepParserNL {
		{
			p.SetState(147)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(152)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(153)
		p.Match(bicepParserFOR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(156)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER:
		{
			p.SetState(154)

			var _x = p.Identifier()

			localctx.(*ForExpressionContext).item = _x
		}

	case bicepParserOPAR:
		{
			p.SetState(155)
			p.ForVariableBlock()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(158)
		p.Match(bicepParserIN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(159)
		p.expression(0)
	}
	{
		p.SetState(160)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(161)
		p.ForBody()
	}
	p.SetState(165)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(162)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(167)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(168)
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

// IForVariableBlockContext is an interface to support dynamic dispatch.
type IForVariableBlockContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetItem returns the item rule contexts.
	GetItem() IIdentifierContext

	// GetIndex returns the index rule contexts.
	GetIndex() IIdentifierContext

	// SetItem sets the item rule contexts.
	SetItem(IIdentifierContext)

	// SetIndex sets the index rule contexts.
	SetIndex(IIdentifierContext)

	// Getter signatures
	OPAR() antlr.TerminalNode
	COMMA() antlr.TerminalNode
	CPAR() antlr.TerminalNode
	AllIdentifier() []IIdentifierContext
	Identifier(i int) IIdentifierContext

	// IsForVariableBlockContext differentiates from other interfaces.
	IsForVariableBlockContext()
}

type ForVariableBlockContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	item   IIdentifierContext
	index  IIdentifierContext
}

func NewEmptyForVariableBlockContext() *ForVariableBlockContext {
	var p = new(ForVariableBlockContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forVariableBlock
	return p
}

func InitEmptyForVariableBlockContext(p *ForVariableBlockContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forVariableBlock
}

func (*ForVariableBlockContext) IsForVariableBlockContext() {}

func NewForVariableBlockContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ForVariableBlockContext {
	var p = new(ForVariableBlockContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_forVariableBlock

	return p
}

func (s *ForVariableBlockContext) GetParser() antlr.Parser { return s.parser }

func (s *ForVariableBlockContext) GetItem() IIdentifierContext { return s.item }

func (s *ForVariableBlockContext) GetIndex() IIdentifierContext { return s.index }

func (s *ForVariableBlockContext) SetItem(v IIdentifierContext) { s.item = v }

func (s *ForVariableBlockContext) SetIndex(v IIdentifierContext) { s.index = v }

func (s *ForVariableBlockContext) OPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserOPAR, 0)
}

func (s *ForVariableBlockContext) COMMA() antlr.TerminalNode {
	return s.GetToken(bicepParserCOMMA, 0)
}

func (s *ForVariableBlockContext) CPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserCPAR, 0)
}

func (s *ForVariableBlockContext) AllIdentifier() []IIdentifierContext {
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

func (s *ForVariableBlockContext) Identifier(i int) IIdentifierContext {
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

func (s *ForVariableBlockContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ForVariableBlockContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ForVariableBlockContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitForVariableBlock(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ForVariableBlock() (localctx IForVariableBlockContext) {
	localctx = NewForVariableBlockContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 18, bicepParserRULE_forVariableBlock)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(170)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(171)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).item = _x
	}
	{
		p.SetState(172)
		p.Match(bicepParserCOMMA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(173)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).index = _x
	}
	{
		p.SetState(174)
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

// IForBodyContext is an interface to support dynamic dispatch.
type IForBodyContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetBody returns the body rule contexts.
	GetBody() IExpressionContext

	// SetBody sets the body rule contexts.
	SetBody(IExpressionContext)

	// Getter signatures
	Expression() IExpressionContext
	IfCondition() IIfConditionContext

	// IsForBodyContext differentiates from other interfaces.
	IsForBodyContext()
}

type ForBodyContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	body   IExpressionContext
}

func NewEmptyForBodyContext() *ForBodyContext {
	var p = new(ForBodyContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forBody
	return p
}

func InitEmptyForBodyContext(p *ForBodyContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_forBody
}

func (*ForBodyContext) IsForBodyContext() {}

func NewForBodyContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ForBodyContext {
	var p = new(ForBodyContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_forBody

	return p
}

func (s *ForBodyContext) GetParser() antlr.Parser { return s.parser }

func (s *ForBodyContext) GetBody() IExpressionContext { return s.body }

func (s *ForBodyContext) SetBody(v IExpressionContext) { s.body = v }

func (s *ForBodyContext) Expression() IExpressionContext {
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

func (s *ForBodyContext) IfCondition() IIfConditionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IIfConditionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IIfConditionContext)
}

func (s *ForBodyContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ForBodyContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ForBodyContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitForBody(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ForBody() (localctx IForBodyContext) {
	localctx = NewForBodyContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 20, bicepParserRULE_forBody)
	p.SetState(178)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER, bicepParserNUMBER:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(176)

			var _x = p.expression(0)

			localctx.(*ForBodyContext).body = _x
		}

	case bicepParserIF:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(177)
			p.IfCondition()
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
	p.EnterRule(localctx, 22, bicepParserRULE_interpString)
	var _alt int

	p.SetState(193)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserSTRING_LEFT_PIECE:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(180)
			p.Match(bicepParserSTRING_LEFT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(186)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 16, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
		for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			if _alt == 1 {
				{
					p.SetState(181)
					p.expression(0)
				}
				{
					p.SetState(182)
					p.Match(bicepParserSTRING_MIDDLE_PIECE)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			}
			p.SetState(188)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 16, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}
		{
			p.SetState(189)
			p.expression(0)
		}
		{
			p.SetState(190)
			p.Match(bicepParserSTRING_RIGHT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserSTRING_COMPLETE:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(192)
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
	QMARK() antlr.TerminalNode
	AllCOL() []antlr.TerminalNode
	COL(i int) antlr.TerminalNode
	LogicCharacter() ILogicCharacterContext
	OBRACK() antlr.TerminalNode
	CBRACK() antlr.TerminalNode
	DOT() antlr.TerminalNode
	Identifier() IIdentifierContext
	FunctionCall() IFunctionCallContext

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

func (s *ExpressionContext) QMARK() antlr.TerminalNode {
	return s.GetToken(bicepParserQMARK, 0)
}

func (s *ExpressionContext) AllCOL() []antlr.TerminalNode {
	return s.GetTokens(bicepParserCOL)
}

func (s *ExpressionContext) COL(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserCOL, i)
}

func (s *ExpressionContext) LogicCharacter() ILogicCharacterContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ILogicCharacterContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ILogicCharacterContext)
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

func (s *ExpressionContext) FunctionCall() IFunctionCallContext {
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
	_startState := 24
	p.EnterRecursionRule(localctx, 24, bicepParserRULE_expression, _p)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(196)
		p.PrimaryExpression()
	}

	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(228)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 19, p.GetParserRuleContext())
	if p.HasError() {
		goto errorExit
	}
	for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
		if _alt == 1 {
			if p.GetParseListeners() != nil {
				p.TriggerExitRuleEvent()
			}
			_prevctx = localctx
			p.SetState(226)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 18, p.GetParserRuleContext()) {
			case 1:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(198)

				if !(p.Precpred(p.GetParserRuleContext(), 7)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 7)", ""))
					goto errorExit
				}
				{
					p.SetState(199)
					p.Match(bicepParserQMARK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(200)
					p.expression(0)
				}
				{
					p.SetState(201)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(202)
					p.expression(8)
				}

			case 2:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(204)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(205)
					p.LogicCharacter()
				}
				{
					p.SetState(206)
					p.expression(3)
				}

			case 3:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(208)

				if !(p.Precpred(p.GetParserRuleContext(), 8)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 8)", ""))
					goto errorExit
				}
				{
					p.SetState(209)
					p.Match(bicepParserOBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(210)
					p.expression(0)
				}
				{
					p.SetState(211)
					p.Match(bicepParserCBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			case 4:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(213)

				if !(p.Precpred(p.GetParserRuleContext(), 6)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 6)", ""))
					goto errorExit
				}
				{
					p.SetState(214)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(215)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).property = _x
				}

			case 5:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(216)

				if !(p.Precpred(p.GetParserRuleContext(), 5)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 5)", ""))
					goto errorExit
				}
				{
					p.SetState(217)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(218)
					p.FunctionCall()
				}

			case 6:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(219)

				if !(p.Precpred(p.GetParserRuleContext(), 4)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 4)", ""))
					goto errorExit
				}
				{
					p.SetState(220)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(221)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case 7:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(222)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(223)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(224)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(225)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(230)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 19, p.GetParserRuleContext())
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

// ILogicCharacterContext is an interface to support dynamic dispatch.
type ILogicCharacterContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	GT() antlr.TerminalNode
	GTE() antlr.TerminalNode
	LT() antlr.TerminalNode
	LTE() antlr.TerminalNode
	EQ() antlr.TerminalNode
	NEQ() antlr.TerminalNode

	// IsLogicCharacterContext differentiates from other interfaces.
	IsLogicCharacterContext()
}

type LogicCharacterContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyLogicCharacterContext() *LogicCharacterContext {
	var p = new(LogicCharacterContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_logicCharacter
	return p
}

func InitEmptyLogicCharacterContext(p *LogicCharacterContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_logicCharacter
}

func (*LogicCharacterContext) IsLogicCharacterContext() {}

func NewLogicCharacterContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *LogicCharacterContext {
	var p = new(LogicCharacterContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_logicCharacter

	return p
}

func (s *LogicCharacterContext) GetParser() antlr.Parser { return s.parser }

func (s *LogicCharacterContext) GT() antlr.TerminalNode {
	return s.GetToken(bicepParserGT, 0)
}

func (s *LogicCharacterContext) GTE() antlr.TerminalNode {
	return s.GetToken(bicepParserGTE, 0)
}

func (s *LogicCharacterContext) LT() antlr.TerminalNode {
	return s.GetToken(bicepParserLT, 0)
}

func (s *LogicCharacterContext) LTE() antlr.TerminalNode {
	return s.GetToken(bicepParserLTE, 0)
}

func (s *LogicCharacterContext) EQ() antlr.TerminalNode {
	return s.GetToken(bicepParserEQ, 0)
}

func (s *LogicCharacterContext) NEQ() antlr.TerminalNode {
	return s.GetToken(bicepParserNEQ, 0)
}

func (s *LogicCharacterContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *LogicCharacterContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *LogicCharacterContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitLogicCharacter(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) LogicCharacter() (localctx ILogicCharacterContext) {
	localctx = NewLogicCharacterContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 26, bicepParserRULE_logicCharacter)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(231)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1082331758592) != 0) {
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
	ForExpression() IForExpressionContext
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

func (s *PrimaryExpressionContext) ForExpression() IForExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IForExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IForExpressionContext)
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
	p.EnterRule(localctx, 28, bicepParserRULE_primaryExpression)
	p.SetState(241)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 20, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(233)
			p.LiteralValue()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(234)
			p.FunctionCall()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(235)
			p.InterpString()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(236)
			p.Match(bicepParserMULTILINE_STRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(237)
			p.Array()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(238)
			p.Object()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(239)
			p.ForExpression()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(240)
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
	p.EnterRule(localctx, 30, bicepParserRULE_parenthesizedExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(243)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
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
		p.expression(0)
	}
	p.SetState(249)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(248)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(251)
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
	Identifier() IIdentifierContext

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

func (s *TypeExpressionContext) Identifier() IIdentifierContext {
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
	p.EnterRule(localctx, 32, bicepParserRULE_typeExpression)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(253)

		var _x = p.Identifier()

		localctx.(*TypeExpressionContext).type_ = _x
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
	p.EnterRule(localctx, 34, bicepParserRULE_literalValue)
	p.SetState(260)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 23, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(255)
			p.Match(bicepParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(256)
			p.Match(bicepParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(257)
			p.Match(bicepParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(258)
			p.Match(bicepParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(259)
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
	p.EnterRule(localctx, 36, bicepParserRULE_object)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(262)
		p.Match(bicepParserOBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(279)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		p.SetState(264)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(263)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(266)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}
		p.SetState(276)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1100528730112) != 0 {
			{
				p.SetState(268)
				p.ObjectProperty()
			}
			p.SetState(270)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)

			for ok := true; ok; ok = _la == bicepParserNL {
				{
					p.SetState(269)
					p.Match(bicepParserNL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

				p.SetState(272)
				p.GetErrorHandler().Sync(p)
				if p.HasError() {
					goto errorExit
				}
				_la = p.GetTokenStream().LA(1)
			}

			p.SetState(278)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	}
	{
		p.SetState(281)
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
	p.EnterRule(localctx, 38, bicepParserRULE_objectProperty)
	p.EnterOuterAlt(localctx, 1)
	p.SetState(285)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER:
		{
			p.SetState(283)

			var _x = p.Identifier()

			localctx.(*ObjectPropertyContext).name = _x
		}

	case bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE:
		{
			p.SetState(284)
			p.InterpString()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(287)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(288)
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
	p.EnterRule(localctx, 40, bicepParserRULE_array)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(290)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(294)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(291)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(296)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	p.SetState(300)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&3299551989842) != 0 {
		{
			p.SetState(297)
			p.ArrayItem()
		}

		p.SetState(302)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(303)
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
	p.EnterRule(localctx, 42, bicepParserRULE_arrayItem)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(305)
		p.expression(0)
	}
	p.SetState(312)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	switch p.GetTokenStream().LA(1) {
	case bicepParserNL:
		p.SetState(307)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(306)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(309)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	case bicepParserCOMMA:
		{
			p.SetState(311)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserCBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER, bicepParserNUMBER:

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
	p.EnterRule(localctx, 44, bicepParserRULE_decorator)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(314)
		p.Match(bicepParserAT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(315)
		p.DecoratorExpression()
	}
	{
		p.SetState(316)
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
	p.EnterRule(localctx, 46, bicepParserRULE_decoratorExpression)
	p.SetState(323)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 33, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(318)
			p.FunctionCall()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(319)
			p.expression(0)
		}
		{
			p.SetState(320)
			p.Match(bicepParserDOT)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(321)
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
	p.EnterRule(localctx, 48, bicepParserRULE_functionCall)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(325)
		p.Identifier()
	}
	{
		p.SetState(326)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(331)
	p.GetErrorHandler().Sync(p)

	if p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 35, p.GetParserRuleContext()) == 1 {
		p.SetState(328)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(327)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(330)
			p.ArgumentList()
		}

	} else if p.HasError() { // JIM
		goto errorExit
	}
	p.SetState(334)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(333)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(336)
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
	p.EnterRule(localctx, 50, bicepParserRULE_argumentList)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(338)
		p.expression(0)
	}
	p.SetState(346)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserCOMMA {
		{
			p.SetState(339)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(341)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(340)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(343)
			p.expression(0)
		}

		p.SetState(348)
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
	OBJECT() antlr.TerminalNode

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

func (s *IdentifierContext) OBJECT() antlr.TerminalNode {
	return s.GetToken(bicepParserOBJECT, 0)
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
	p.EnterRule(localctx, 52, bicepParserRULE_identifier)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(349)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1100453232640) != 0) {
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
	case 12:
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
		return p.Precpred(p.GetParserRuleContext(), 7)

	case 1:
		return p.Precpred(p.GetParserRuleContext(), 2)

	case 2:
		return p.Precpred(p.GetParserRuleContext(), 8)

	case 3:
		return p.Precpred(p.GetParserRuleContext(), 6)

	case 4:
		return p.Precpred(p.GetParserRuleContext(), 5)

	case 5:
		return p.Precpred(p.GetParserRuleContext(), 4)

	case 6:
		return p.Precpred(p.GetParserRuleContext(), 3)

	default:
		panic("No predicate with index: " + fmt.Sprint(predIndex))
	}
}
