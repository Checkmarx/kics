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
		"'object'", "'resource'", "", "", "", "", "'string'", "'int'", "'bool'",
		"'if'", "'for'", "'in'", "'?'", "'>'", "'>='", "'<'", "'<='", "'=='",
		"'!='",
	}
	staticData.SymbolicNames = []string{
		"", "MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "OBJECT", "RESOURCE", "STRING_LEFT_PIECE",
		"STRING_MIDDLE_PIECE", "STRING_RIGHT_PIECE", "STRING_COMPLETE", "STRING",
		"INT", "BOOL", "IF", "FOR", "IN", "QMARK", "GT", "GTE", "LT", "LTE",
		"EQ", "NEQ", "IDENTIFIER", "NUMBER", "NL", "SPACES", "UNKNOWN",
	}
	staticData.RuleNames = []string{
		"program", "statement", "parameterDecl", "parameterDefaultValue", "variableDecl",
		"resourceDecl", "ifCondition", "forExpression", "forVariableBlock",
		"forBody", "interpString", "expression", "logicCharacter", "primaryExpression",
		"parenthesizedExpression", "typeExpression", "literalValue", "object",
		"objectProperty", "array", "arrayItem", "decorator", "decoratorExpression",
		"functionCall", "argumentList", "identifier",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 42, 326, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
		10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15,
		2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7, 20, 2,
		21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25, 1, 0,
		5, 0, 54, 8, 0, 10, 0, 12, 0, 57, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1,
		1, 3, 1, 65, 8, 1, 1, 2, 5, 2, 68, 8, 2, 10, 2, 12, 2, 71, 9, 2, 1, 2,
		1, 2, 1, 2, 1, 2, 3, 2, 77, 8, 2, 1, 2, 1, 2, 1, 2, 3, 2, 82, 8, 2, 3,
		2, 84, 8, 2, 1, 2, 1, 2, 1, 3, 1, 3, 1, 3, 1, 4, 5, 4, 92, 8, 4, 10, 4,
		12, 4, 95, 9, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 5, 5, 5, 104, 8,
		5, 10, 5, 12, 5, 107, 9, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3,
		5, 116, 8, 5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 1, 6, 1, 7, 1, 7, 5, 7, 126,
		8, 7, 10, 7, 12, 7, 129, 9, 7, 1, 7, 1, 7, 1, 7, 3, 7, 134, 8, 7, 1, 7,
		1, 7, 1, 7, 1, 7, 1, 7, 5, 7, 141, 8, 7, 10, 7, 12, 7, 144, 9, 7, 1, 7,
		1, 7, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 9, 1, 9, 3, 9, 156, 8, 9,
		1, 10, 1, 10, 1, 10, 1, 10, 5, 10, 162, 8, 10, 10, 10, 12, 10, 165, 9,
		10, 1, 10, 1, 10, 1, 10, 1, 10, 3, 10, 171, 8, 10, 1, 11, 1, 11, 1, 11,
		1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1,
		11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11,
		1, 11, 1, 11, 1, 11, 1, 11, 5, 11, 201, 8, 11, 10, 11, 12, 11, 204, 9,
		11, 1, 12, 1, 12, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13,
		3, 13, 216, 8, 13, 1, 14, 1, 14, 3, 14, 220, 8, 14, 1, 14, 1, 14, 3, 14,
		224, 8, 14, 1, 14, 1, 14, 1, 15, 1, 15, 1, 16, 1, 16, 1, 16, 1, 16, 1,
		16, 3, 16, 235, 8, 16, 1, 17, 1, 17, 4, 17, 239, 8, 17, 11, 17, 12, 17,
		240, 1, 17, 1, 17, 4, 17, 245, 8, 17, 11, 17, 12, 17, 246, 5, 17, 249,
		8, 17, 10, 17, 12, 17, 252, 9, 17, 3, 17, 254, 8, 17, 1, 17, 1, 17, 1,
		18, 1, 18, 3, 18, 260, 8, 18, 1, 18, 1, 18, 1, 18, 1, 19, 1, 19, 5, 19,
		267, 8, 19, 10, 19, 12, 19, 270, 9, 19, 1, 19, 5, 19, 273, 8, 19, 10, 19,
		12, 19, 276, 9, 19, 1, 19, 1, 19, 1, 20, 1, 20, 4, 20, 282, 8, 20, 11,
		20, 12, 20, 283, 1, 20, 3, 20, 287, 8, 20, 1, 21, 1, 21, 1, 21, 1, 21,
		1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 3, 22, 298, 8, 22, 1, 23, 1, 23, 1,
		23, 3, 23, 303, 8, 23, 1, 23, 3, 23, 306, 8, 23, 1, 23, 3, 23, 309, 8,
		23, 1, 23, 1, 23, 1, 24, 1, 24, 1, 24, 3, 24, 316, 8, 24, 1, 24, 5, 24,
		319, 8, 24, 10, 24, 12, 24, 322, 9, 24, 1, 25, 1, 25, 1, 25, 0, 1, 22,
		26, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34,
		36, 38, 40, 42, 44, 46, 48, 50, 0, 2, 1, 0, 32, 37, 3, 0, 14, 20, 25, 27,
		38, 38, 352, 0, 55, 1, 0, 0, 0, 2, 64, 1, 0, 0, 0, 4, 69, 1, 0, 0, 0, 6,
		87, 1, 0, 0, 0, 8, 93, 1, 0, 0, 0, 10, 105, 1, 0, 0, 0, 12, 119, 1, 0,
		0, 0, 14, 123, 1, 0, 0, 0, 16, 147, 1, 0, 0, 0, 18, 155, 1, 0, 0, 0, 20,
		170, 1, 0, 0, 0, 22, 172, 1, 0, 0, 0, 24, 205, 1, 0, 0, 0, 26, 215, 1,
		0, 0, 0, 28, 217, 1, 0, 0, 0, 30, 227, 1, 0, 0, 0, 32, 234, 1, 0, 0, 0,
		34, 236, 1, 0, 0, 0, 36, 259, 1, 0, 0, 0, 38, 264, 1, 0, 0, 0, 40, 279,
		1, 0, 0, 0, 42, 288, 1, 0, 0, 0, 44, 297, 1, 0, 0, 0, 46, 299, 1, 0, 0,
		0, 48, 312, 1, 0, 0, 0, 50, 323, 1, 0, 0, 0, 52, 54, 3, 2, 1, 0, 53, 52,
		1, 0, 0, 0, 54, 57, 1, 0, 0, 0, 55, 53, 1, 0, 0, 0, 55, 56, 1, 0, 0, 0,
		56, 58, 1, 0, 0, 0, 57, 55, 1, 0, 0, 0, 58, 59, 5, 0, 0, 1, 59, 1, 1, 0,
		0, 0, 60, 65, 3, 4, 2, 0, 61, 65, 3, 8, 4, 0, 62, 65, 3, 10, 5, 0, 63,
		65, 5, 40, 0, 0, 64, 60, 1, 0, 0, 0, 64, 61, 1, 0, 0, 0, 64, 62, 1, 0,
		0, 0, 64, 63, 1, 0, 0, 0, 65, 3, 1, 0, 0, 0, 66, 68, 3, 42, 21, 0, 67,
		66, 1, 0, 0, 0, 68, 71, 1, 0, 0, 0, 69, 67, 1, 0, 0, 0, 69, 70, 1, 0, 0,
		0, 70, 72, 1, 0, 0, 0, 71, 69, 1, 0, 0, 0, 72, 73, 5, 14, 0, 0, 73, 83,
		3, 50, 25, 0, 74, 76, 3, 30, 15, 0, 75, 77, 3, 6, 3, 0, 76, 75, 1, 0, 0,
		0, 76, 77, 1, 0, 0, 0, 77, 84, 1, 0, 0, 0, 78, 79, 5, 20, 0, 0, 79, 81,
		3, 20, 10, 0, 80, 82, 3, 6, 3, 0, 81, 80, 1, 0, 0, 0, 81, 82, 1, 0, 0,
		0, 82, 84, 1, 0, 0, 0, 83, 74, 1, 0, 0, 0, 83, 78, 1, 0, 0, 0, 84, 85,
		1, 0, 0, 0, 85, 86, 5, 40, 0, 0, 86, 5, 1, 0, 0, 0, 87, 88, 5, 11, 0, 0,
		88, 89, 3, 22, 11, 0, 89, 7, 1, 0, 0, 0, 90, 92, 3, 42, 21, 0, 91, 90,
		1, 0, 0, 0, 92, 95, 1, 0, 0, 0, 93, 91, 1, 0, 0, 0, 93, 94, 1, 0, 0, 0,
		94, 96, 1, 0, 0, 0, 95, 93, 1, 0, 0, 0, 96, 97, 5, 15, 0, 0, 97, 98, 3,
		50, 25, 0, 98, 99, 5, 11, 0, 0, 99, 100, 3, 22, 11, 0, 100, 101, 5, 40,
		0, 0, 101, 9, 1, 0, 0, 0, 102, 104, 3, 42, 21, 0, 103, 102, 1, 0, 0, 0,
		104, 107, 1, 0, 0, 0, 105, 103, 1, 0, 0, 0, 105, 106, 1, 0, 0, 0, 106,
		108, 1, 0, 0, 0, 107, 105, 1, 0, 0, 0, 108, 109, 5, 20, 0, 0, 109, 110,
		3, 50, 25, 0, 110, 111, 3, 20, 10, 0, 111, 115, 5, 11, 0, 0, 112, 116,
		3, 12, 6, 0, 113, 116, 3, 34, 17, 0, 114, 116, 3, 14, 7, 0, 115, 112, 1,
		0, 0, 0, 115, 113, 1, 0, 0, 0, 115, 114, 1, 0, 0, 0, 116, 117, 1, 0, 0,
		0, 117, 118, 5, 40, 0, 0, 118, 11, 1, 0, 0, 0, 119, 120, 5, 28, 0, 0, 120,
		121, 3, 28, 14, 0, 121, 122, 3, 34, 17, 0, 122, 13, 1, 0, 0, 0, 123, 127,
		5, 4, 0, 0, 124, 126, 5, 40, 0, 0, 125, 124, 1, 0, 0, 0, 126, 129, 1, 0,
		0, 0, 127, 125, 1, 0, 0, 0, 127, 128, 1, 0, 0, 0, 128, 130, 1, 0, 0, 0,
		129, 127, 1, 0, 0, 0, 130, 133, 5, 29, 0, 0, 131, 134, 3, 50, 25, 0, 132,
		134, 3, 16, 8, 0, 133, 131, 1, 0, 0, 0, 133, 132, 1, 0, 0, 0, 134, 135,
		1, 0, 0, 0, 135, 136, 5, 30, 0, 0, 136, 137, 3, 22, 11, 0, 137, 138, 5,
		10, 0, 0, 138, 142, 3, 18, 9, 0, 139, 141, 5, 40, 0, 0, 140, 139, 1, 0,
		0, 0, 141, 144, 1, 0, 0, 0, 142, 140, 1, 0, 0, 0, 142, 143, 1, 0, 0, 0,
		143, 145, 1, 0, 0, 0, 144, 142, 1, 0, 0, 0, 145, 146, 5, 5, 0, 0, 146,
		15, 1, 0, 0, 0, 147, 148, 5, 6, 0, 0, 148, 149, 3, 50, 25, 0, 149, 150,
		5, 3, 0, 0, 150, 151, 3, 50, 25, 0, 151, 152, 5, 7, 0, 0, 152, 17, 1, 0,
		0, 0, 153, 156, 3, 22, 11, 0, 154, 156, 3, 12, 6, 0, 155, 153, 1, 0, 0,
		0, 155, 154, 1, 0, 0, 0, 156, 19, 1, 0, 0, 0, 157, 163, 5, 21, 0, 0, 158,
		159, 3, 22, 11, 0, 159, 160, 5, 22, 0, 0, 160, 162, 1, 0, 0, 0, 161, 158,
		1, 0, 0, 0, 162, 165, 1, 0, 0, 0, 163, 161, 1, 0, 0, 0, 163, 164, 1, 0,
		0, 0, 164, 166, 1, 0, 0, 0, 165, 163, 1, 0, 0, 0, 166, 167, 3, 22, 11,
		0, 167, 168, 5, 23, 0, 0, 168, 171, 1, 0, 0, 0, 169, 171, 5, 24, 0, 0,
		170, 157, 1, 0, 0, 0, 170, 169, 1, 0, 0, 0, 171, 21, 1, 0, 0, 0, 172, 173,
		6, 11, -1, 0, 173, 174, 3, 26, 13, 0, 174, 202, 1, 0, 0, 0, 175, 176, 10,
		6, 0, 0, 176, 177, 5, 31, 0, 0, 177, 178, 3, 22, 11, 0, 178, 179, 5, 10,
		0, 0, 179, 180, 3, 22, 11, 7, 180, 201, 1, 0, 0, 0, 181, 182, 10, 2, 0,
		0, 182, 183, 3, 24, 12, 0, 183, 184, 3, 22, 11, 3, 184, 201, 1, 0, 0, 0,
		185, 186, 10, 7, 0, 0, 186, 187, 5, 4, 0, 0, 187, 188, 3, 22, 11, 0, 188,
		189, 5, 5, 0, 0, 189, 201, 1, 0, 0, 0, 190, 191, 10, 5, 0, 0, 191, 192,
		5, 8, 0, 0, 192, 201, 3, 50, 25, 0, 193, 194, 10, 4, 0, 0, 194, 195, 5,
		10, 0, 0, 195, 201, 3, 50, 25, 0, 196, 197, 10, 3, 0, 0, 197, 198, 5, 10,
		0, 0, 198, 199, 5, 10, 0, 0, 199, 201, 3, 50, 25, 0, 200, 175, 1, 0, 0,
		0, 200, 181, 1, 0, 0, 0, 200, 185, 1, 0, 0, 0, 200, 190, 1, 0, 0, 0, 200,
		193, 1, 0, 0, 0, 200, 196, 1, 0, 0, 0, 201, 204, 1, 0, 0, 0, 202, 200,
		1, 0, 0, 0, 202, 203, 1, 0, 0, 0, 203, 23, 1, 0, 0, 0, 204, 202, 1, 0,
		0, 0, 205, 206, 7, 0, 0, 0, 206, 25, 1, 0, 0, 0, 207, 216, 3, 32, 16, 0,
		208, 216, 3, 46, 23, 0, 209, 216, 3, 20, 10, 0, 210, 216, 5, 1, 0, 0, 211,
		216, 3, 38, 19, 0, 212, 216, 3, 34, 17, 0, 213, 216, 3, 14, 7, 0, 214,
		216, 3, 28, 14, 0, 215, 207, 1, 0, 0, 0, 215, 208, 1, 0, 0, 0, 215, 209,
		1, 0, 0, 0, 215, 210, 1, 0, 0, 0, 215, 211, 1, 0, 0, 0, 215, 212, 1, 0,
		0, 0, 215, 213, 1, 0, 0, 0, 215, 214, 1, 0, 0, 0, 216, 27, 1, 0, 0, 0,
		217, 219, 5, 6, 0, 0, 218, 220, 5, 40, 0, 0, 219, 218, 1, 0, 0, 0, 219,
		220, 1, 0, 0, 0, 220, 221, 1, 0, 0, 0, 221, 223, 3, 22, 11, 0, 222, 224,
		5, 40, 0, 0, 223, 222, 1, 0, 0, 0, 223, 224, 1, 0, 0, 0, 224, 225, 1, 0,
		0, 0, 225, 226, 5, 7, 0, 0, 226, 29, 1, 0, 0, 0, 227, 228, 3, 50, 25, 0,
		228, 31, 1, 0, 0, 0, 229, 235, 5, 39, 0, 0, 230, 235, 5, 16, 0, 0, 231,
		235, 5, 17, 0, 0, 232, 235, 5, 18, 0, 0, 233, 235, 3, 50, 25, 0, 234, 229,
		1, 0, 0, 0, 234, 230, 1, 0, 0, 0, 234, 231, 1, 0, 0, 0, 234, 232, 1, 0,
		0, 0, 234, 233, 1, 0, 0, 0, 235, 33, 1, 0, 0, 0, 236, 253, 5, 12, 0, 0,
		237, 239, 5, 40, 0, 0, 238, 237, 1, 0, 0, 0, 239, 240, 1, 0, 0, 0, 240,
		238, 1, 0, 0, 0, 240, 241, 1, 0, 0, 0, 241, 250, 1, 0, 0, 0, 242, 244,
		3, 36, 18, 0, 243, 245, 5, 40, 0, 0, 244, 243, 1, 0, 0, 0, 245, 246, 1,
		0, 0, 0, 246, 244, 1, 0, 0, 0, 246, 247, 1, 0, 0, 0, 247, 249, 1, 0, 0,
		0, 248, 242, 1, 0, 0, 0, 249, 252, 1, 0, 0, 0, 250, 248, 1, 0, 0, 0, 250,
		251, 1, 0, 0, 0, 251, 254, 1, 0, 0, 0, 252, 250, 1, 0, 0, 0, 253, 238,
		1, 0, 0, 0, 253, 254, 1, 0, 0, 0, 254, 255, 1, 0, 0, 0, 255, 256, 5, 13,
		0, 0, 256, 35, 1, 0, 0, 0, 257, 260, 3, 50, 25, 0, 258, 260, 3, 20, 10,
		0, 259, 257, 1, 0, 0, 0, 259, 258, 1, 0, 0, 0, 260, 261, 1, 0, 0, 0, 261,
		262, 5, 10, 0, 0, 262, 263, 3, 22, 11, 0, 263, 37, 1, 0, 0, 0, 264, 268,
		5, 4, 0, 0, 265, 267, 5, 40, 0, 0, 266, 265, 1, 0, 0, 0, 267, 270, 1, 0,
		0, 0, 268, 266, 1, 0, 0, 0, 268, 269, 1, 0, 0, 0, 269, 274, 1, 0, 0, 0,
		270, 268, 1, 0, 0, 0, 271, 273, 3, 40, 20, 0, 272, 271, 1, 0, 0, 0, 273,
		276, 1, 0, 0, 0, 274, 272, 1, 0, 0, 0, 274, 275, 1, 0, 0, 0, 275, 277,
		1, 0, 0, 0, 276, 274, 1, 0, 0, 0, 277, 278, 5, 5, 0, 0, 278, 39, 1, 0,
		0, 0, 279, 286, 3, 22, 11, 0, 280, 282, 5, 40, 0, 0, 281, 280, 1, 0, 0,
		0, 282, 283, 1, 0, 0, 0, 283, 281, 1, 0, 0, 0, 283, 284, 1, 0, 0, 0, 284,
		287, 1, 0, 0, 0, 285, 287, 5, 3, 0, 0, 286, 281, 1, 0, 0, 0, 286, 285,
		1, 0, 0, 0, 286, 287, 1, 0, 0, 0, 287, 41, 1, 0, 0, 0, 288, 289, 5, 2,
		0, 0, 289, 290, 3, 44, 22, 0, 290, 291, 5, 40, 0, 0, 291, 43, 1, 0, 0,
		0, 292, 298, 3, 46, 23, 0, 293, 294, 3, 22, 11, 0, 294, 295, 5, 8, 0, 0,
		295, 296, 3, 46, 23, 0, 296, 298, 1, 0, 0, 0, 297, 292, 1, 0, 0, 0, 297,
		293, 1, 0, 0, 0, 298, 45, 1, 0, 0, 0, 299, 300, 3, 50, 25, 0, 300, 305,
		5, 6, 0, 0, 301, 303, 5, 40, 0, 0, 302, 301, 1, 0, 0, 0, 302, 303, 1, 0,
		0, 0, 303, 304, 1, 0, 0, 0, 304, 306, 3, 48, 24, 0, 305, 302, 1, 0, 0,
		0, 305, 306, 1, 0, 0, 0, 306, 308, 1, 0, 0, 0, 307, 309, 5, 40, 0, 0, 308,
		307, 1, 0, 0, 0, 308, 309, 1, 0, 0, 0, 309, 310, 1, 0, 0, 0, 310, 311,
		5, 7, 0, 0, 311, 47, 1, 0, 0, 0, 312, 320, 3, 22, 11, 0, 313, 315, 5, 3,
		0, 0, 314, 316, 5, 40, 0, 0, 315, 314, 1, 0, 0, 0, 315, 316, 1, 0, 0, 0,
		316, 317, 1, 0, 0, 0, 317, 319, 3, 22, 11, 0, 318, 313, 1, 0, 0, 0, 319,
		322, 1, 0, 0, 0, 320, 318, 1, 0, 0, 0, 320, 321, 1, 0, 0, 0, 321, 49, 1,
		0, 0, 0, 322, 320, 1, 0, 0, 0, 323, 324, 7, 1, 0, 0, 324, 51, 1, 0, 0,
		0, 36, 55, 64, 69, 76, 81, 83, 93, 105, 115, 127, 133, 142, 155, 163, 170,
		200, 202, 215, 219, 223, 234, 240, 246, 250, 253, 259, 268, 274, 283, 286,
		297, 302, 305, 308, 315, 320,
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
	bicepParserSTRING_LEFT_PIECE   = 21
	bicepParserSTRING_MIDDLE_PIECE = 22
	bicepParserSTRING_RIGHT_PIECE  = 23
	bicepParserSTRING_COMPLETE     = 24
	bicepParserSTRING              = 25
	bicepParserINT                 = 26
	bicepParserBOOL                = 27
	bicepParserIF                  = 28
	bicepParserFOR                 = 29
	bicepParserIN                  = 30
	bicepParserQMARK               = 31
	bicepParserGT                  = 32
	bicepParserGTE                 = 33
	bicepParserLT                  = 34
	bicepParserLTE                 = 35
	bicepParserEQ                  = 36
	bicepParserNEQ                 = 37
	bicepParserIDENTIFIER          = 38
	bicepParserNUMBER              = 39
	bicepParserNL                  = 40
	bicepParserSPACES              = 41
	bicepParserUNKNOWN             = 42
)

// bicepParser rules.
const (
	bicepParserRULE_program                 = 0
	bicepParserRULE_statement               = 1
	bicepParserRULE_parameterDecl           = 2
	bicepParserRULE_parameterDefaultValue   = 3
	bicepParserRULE_variableDecl            = 4
	bicepParserRULE_resourceDecl            = 5
	bicepParserRULE_ifCondition             = 6
	bicepParserRULE_forExpression           = 7
	bicepParserRULE_forVariableBlock        = 8
	bicepParserRULE_forBody                 = 9
	bicepParserRULE_interpString            = 10
	bicepParserRULE_expression              = 11
	bicepParserRULE_logicCharacter          = 12
	bicepParserRULE_primaryExpression       = 13
	bicepParserRULE_parenthesizedExpression = 14
	bicepParserRULE_typeExpression          = 15
	bicepParserRULE_literalValue            = 16
	bicepParserRULE_object                  = 17
	bicepParserRULE_objectProperty          = 18
	bicepParserRULE_array                   = 19
	bicepParserRULE_arrayItem               = 20
	bicepParserRULE_decorator               = 21
	bicepParserRULE_decoratorExpression     = 22
	bicepParserRULE_functionCall            = 23
	bicepParserRULE_argumentList            = 24
	bicepParserRULE_identifier              = 25
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
	p.SetState(55)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1099512725508) != 0 {
		{
			p.SetState(52)
			p.Statement()
		}

		p.SetState(57)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(58)
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
	p.SetState(64)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(60)
			p.ParameterDecl()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(61)
			p.VariableDecl()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(62)
			p.ResourceDecl()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(63)
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
	p.SetState(69)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(66)
			p.Decorator()
		}

		p.SetState(71)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(72)
		p.Match(bicepParserPARAM)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(73)

		var _x = p.Identifier()

		localctx.(*ParameterDeclContext).name = _x
	}
	p.SetState(83)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 5, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(74)
			p.TypeExpression()
		}
		p.SetState(76)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(75)
				p.ParameterDefaultValue()
			}

		}

	case 2:
		{
			p.SetState(78)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(79)

			var _x = p.InterpString()

			localctx.(*ParameterDeclContext).type_ = _x
		}
		p.SetState(81)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(80)
				p.ParameterDefaultValue()
			}

		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(85)
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
		p.SetState(87)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(88)
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
	p.SetState(93)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(90)
			p.Decorator()
		}

		p.SetState(95)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(96)
		p.Match(bicepParserVAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(97)

		var _x = p.Identifier()

		localctx.(*VariableDeclContext).name = _x
	}
	{
		p.SetState(98)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(99)
		p.expression(0)
	}
	{
		p.SetState(100)
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
	p.SetState(105)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(102)
			p.Decorator()
		}

		p.SetState(107)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(108)
		p.Match(bicepParserRESOURCE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(109)

		var _x = p.Identifier()

		localctx.(*ResourceDeclContext).name = _x
	}
	{
		p.SetState(110)

		var _x = p.InterpString()

		localctx.(*ResourceDeclContext).type_ = _x
	}
	{
		p.SetState(111)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(115)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(112)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(113)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(114)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(117)
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
	p.EnterRule(localctx, 12, bicepParserRULE_ifCondition)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(119)
		p.Match(bicepParserIF)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(120)
		p.ParenthesizedExpression()
	}
	{
		p.SetState(121)
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
	p.EnterRule(localctx, 14, bicepParserRULE_forExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(123)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(127)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(124)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(129)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(130)
		p.Match(bicepParserFOR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(133)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER:
		{
			p.SetState(131)

			var _x = p.Identifier()

			localctx.(*ForExpressionContext).item = _x
		}

	case bicepParserOPAR:
		{
			p.SetState(132)
			p.ForVariableBlock()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(135)
		p.Match(bicepParserIN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(136)
		p.expression(0)
	}
	{
		p.SetState(137)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(138)
		p.ForBody()
	}
	p.SetState(142)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(139)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(144)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(145)
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
	p.EnterRule(localctx, 16, bicepParserRULE_forVariableBlock)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(147)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(148)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).item = _x
	}
	{
		p.SetState(149)
		p.Match(bicepParserCOMMA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(150)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).index = _x
	}
	{
		p.SetState(151)
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
	p.EnterRule(localctx, 18, bicepParserRULE_forBody)
	p.SetState(155)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER, bicepParserNUMBER:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(153)

			var _x = p.expression(0)

			localctx.(*ForBodyContext).body = _x
		}

	case bicepParserIF:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(154)
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
	p.EnterRule(localctx, 20, bicepParserRULE_interpString)
	var _alt int

	p.SetState(170)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserSTRING_LEFT_PIECE:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(157)
			p.Match(bicepParserSTRING_LEFT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(163)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 13, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
		for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			if _alt == 1 {
				{
					p.SetState(158)
					p.expression(0)
				}
				{
					p.SetState(159)
					p.Match(bicepParserSTRING_MIDDLE_PIECE)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			}
			p.SetState(165)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 13, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}
		{
			p.SetState(166)
			p.expression(0)
		}
		{
			p.SetState(167)
			p.Match(bicepParserSTRING_RIGHT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserSTRING_COMPLETE:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(169)
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
	_startState := 22
	p.EnterRecursionRule(localctx, 22, bicepParserRULE_expression, _p)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(173)
		p.PrimaryExpression()
	}

	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(202)
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
			if p.GetParseListeners() != nil {
				p.TriggerExitRuleEvent()
			}
			_prevctx = localctx
			p.SetState(200)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 15, p.GetParserRuleContext()) {
			case 1:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(175)

				if !(p.Precpred(p.GetParserRuleContext(), 6)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 6)", ""))
					goto errorExit
				}
				{
					p.SetState(176)
					p.Match(bicepParserQMARK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(177)
					p.expression(0)
				}
				{
					p.SetState(178)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(179)
					p.expression(7)
				}

			case 2:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(181)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(182)
					p.LogicCharacter()
				}
				{
					p.SetState(183)
					p.expression(3)
				}

			case 3:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(185)

				if !(p.Precpred(p.GetParserRuleContext(), 7)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 7)", ""))
					goto errorExit
				}
				{
					p.SetState(186)
					p.Match(bicepParserOBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(187)
					p.expression(0)
				}
				{
					p.SetState(188)
					p.Match(bicepParserCBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			case 4:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(190)

				if !(p.Precpred(p.GetParserRuleContext(), 5)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 5)", ""))
					goto errorExit
				}
				{
					p.SetState(191)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(192)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).property = _x
				}

			case 5:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(193)

				if !(p.Precpred(p.GetParserRuleContext(), 4)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 4)", ""))
					goto errorExit
				}
				{
					p.SetState(194)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(195)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case 6:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(196)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(197)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
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

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(204)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 16, p.GetParserRuleContext())
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
	p.EnterRule(localctx, 24, bicepParserRULE_logicCharacter)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(205)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&270582939648) != 0) {
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
	p.EnterRule(localctx, 26, bicepParserRULE_primaryExpression)
	p.SetState(215)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 17, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(207)
			p.LiteralValue()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(208)
			p.FunctionCall()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(209)
			p.InterpString()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(210)
			p.Match(bicepParserMULTILINE_STRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(211)
			p.Array()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(212)
			p.Object()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(213)
			p.ForExpression()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(214)
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
	p.EnterRule(localctx, 28, bicepParserRULE_parenthesizedExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(217)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(219)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(218)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(221)
		p.expression(0)
	}
	p.SetState(223)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(222)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(225)
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
	p.EnterRule(localctx, 30, bicepParserRULE_typeExpression)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(227)

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
	p.EnterRule(localctx, 32, bicepParserRULE_literalValue)
	p.SetState(234)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 20, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(229)
			p.Match(bicepParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(230)
			p.Match(bicepParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(231)
			p.Match(bicepParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(232)
			p.Match(bicepParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(233)
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
	p.EnterRule(localctx, 34, bicepParserRULE_object)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(236)
		p.Match(bicepParserOBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(253)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		p.SetState(238)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(237)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(240)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}
		p.SetState(250)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&275133743104) != 0 {
			{
				p.SetState(242)
				p.ObjectProperty()
			}
			p.SetState(244)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)

			for ok := true; ok; ok = _la == bicepParserNL {
				{
					p.SetState(243)
					p.Match(bicepParserNL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

				p.SetState(246)
				p.GetErrorHandler().Sync(p)
				if p.HasError() {
					goto errorExit
				}
				_la = p.GetTokenStream().LA(1)
			}

			p.SetState(252)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	}
	{
		p.SetState(255)
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
	p.EnterRule(localctx, 36, bicepParserRULE_objectProperty)
	p.EnterOuterAlt(localctx, 1)
	p.SetState(259)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserOBJECT, bicepParserRESOURCE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIDENTIFIER:
		{
			p.SetState(257)

			var _x = p.Identifier()

			localctx.(*ObjectPropertyContext).name = _x
		}

	case bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE:
		{
			p.SetState(258)
			p.InterpString()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(261)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(262)
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
	p.EnterRule(localctx, 38, bicepParserRULE_array)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(264)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(268)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(265)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(270)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	p.SetState(274)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&824889561170) != 0 {
		{
			p.SetState(271)
			p.ArrayItem()
		}

		p.SetState(276)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(277)
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
	p.EnterRule(localctx, 40, bicepParserRULE_arrayItem)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(279)
		p.expression(0)
	}
	p.SetState(286)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	switch p.GetTokenStream().LA(1) {
	case bicepParserNL:
		p.SetState(281)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(280)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(283)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	case bicepParserCOMMA:
		{
			p.SetState(285)
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
	p.EnterRule(localctx, 42, bicepParserRULE_decorator)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(288)
		p.Match(bicepParserAT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(289)
		p.DecoratorExpression()
	}
	{
		p.SetState(290)
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
	p.EnterRule(localctx, 44, bicepParserRULE_decoratorExpression)
	p.SetState(297)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 30, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(292)
			p.FunctionCall()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(293)
			p.expression(0)
		}
		{
			p.SetState(294)
			p.Match(bicepParserDOT)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(295)
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
	p.EnterRule(localctx, 46, bicepParserRULE_functionCall)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(299)
		p.Identifier()
	}
	{
		p.SetState(300)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(305)
	p.GetErrorHandler().Sync(p)

	if p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 32, p.GetParserRuleContext()) == 1 {
		p.SetState(302)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(301)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(304)
			p.ArgumentList()
		}

	} else if p.HasError() { // JIM
		goto errorExit
	}
	p.SetState(308)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(307)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(310)
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
	p.EnterRule(localctx, 48, bicepParserRULE_argumentList)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(312)
		p.expression(0)
	}
	p.SetState(320)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserCOMMA {
		{
			p.SetState(313)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(315)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(314)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(317)
			p.expression(0)
		}

		p.SetState(322)
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
	p.EnterRule(localctx, 50, bicepParserRULE_identifier)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(323)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&275114868736) != 0) {
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
	case 11:
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
		return p.Precpred(p.GetParserRuleContext(), 6)

	case 1:
		return p.Precpred(p.GetParserRuleContext(), 2)

	case 2:
		return p.Precpred(p.GetParserRuleContext(), 7)

	case 3:
		return p.Precpred(p.GetParserRuleContext(), 5)

	case 4:
		return p.Precpred(p.GetParserRuleContext(), 4)

	case 5:
		return p.Precpred(p.GetParserRuleContext(), 3)

	default:
		panic("No predicate with index: " + fmt.Sprint(predIndex))
	}
}
