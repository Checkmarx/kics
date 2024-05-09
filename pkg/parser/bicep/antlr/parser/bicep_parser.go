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
		"", "", "'@'", "','", "'['", "']'", "'('", "')'", "'.'", "'|'", "",
		"'='", "'{'", "'}'", "'param'", "'var'", "'true'", "'false'", "'null'",
		"'array'", "'object'", "'resource'", "'output'", "'targetScope'", "'import'",
		"'with'", "'as'", "'metadata'", "'existing'", "'type'", "'module'",
		"", "", "", "", "'string'", "'int'", "'bool'", "'if'", "'for'", "'in'",
		"'?'", "'>'", "'>='", "'<'", "'<='", "'=='", "'!='",
	}
	staticData.SymbolicNames = []string{
		"", "MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "ARRAY", "OBJECT", "RESOURCE", "OUTPUT", "TARGET_SCOPE",
		"IMPORT", "WITH", "AS", "METADATA", "EXISTING", "TYPE", "MODULE", "STRING_LEFT_PIECE",
		"STRING_MIDDLE_PIECE", "STRING_RIGHT_PIECE", "STRING_COMPLETE", "STRING",
		"INT", "BOOL", "IF", "FOR", "IN", "QMARK", "GT", "GTE", "LT", "LTE",
		"EQ", "NEQ", "IDENTIFIER", "NUMBER", "NL", "SINGLE_LINE_COMMENT", "MULTI_LINE_COMMENT",
		"SPACES", "UNKNOWN",
	}
	staticData.RuleNames = []string{
		"program", "statement", "parameterDecl", "parameterDefaultValue", "variableDecl",
		"resourceDecl", "outputDecl", "targetScopeDecl", "importDecl", "metadataDecl",
		"typeDecl", "moduleDecl", "ifCondition", "forExpression", "forVariableBlock",
		"forBody", "interpString", "expression", "logicCharacter", "primaryExpression",
		"parenthesizedExpression", "typeExpression", "literalValue", "object",
		"objectProperty", "array", "arrayItem", "decorator", "decoratorExpression",
		"functionCall", "argumentList", "identifier",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 54, 422, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
		10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15,
		2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7, 20, 2,
		21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25, 2, 26,
		7, 26, 2, 27, 7, 27, 2, 28, 7, 28, 2, 29, 7, 29, 2, 30, 7, 30, 2, 31, 7,
		31, 1, 0, 5, 0, 66, 8, 0, 10, 0, 12, 0, 69, 9, 0, 1, 0, 1, 0, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 83, 8, 1, 1, 2,
		5, 2, 86, 8, 2, 10, 2, 12, 2, 89, 9, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 95,
		8, 2, 1, 2, 1, 2, 1, 2, 3, 2, 100, 8, 2, 3, 2, 102, 8, 2, 1, 2, 1, 2, 1,
		3, 1, 3, 1, 3, 1, 4, 5, 4, 110, 8, 4, 10, 4, 12, 4, 113, 9, 4, 1, 4, 1,
		4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 5, 5, 5, 122, 8, 5, 10, 5, 12, 5, 125, 9,
		5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 131, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3,
		5, 137, 8, 5, 1, 5, 1, 5, 1, 6, 5, 6, 142, 8, 6, 10, 6, 12, 6, 145, 9,
		6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 3, 6, 152, 8, 6, 1, 6, 1, 6, 1, 6, 1,
		6, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 8, 5, 8, 164, 8, 8, 10, 8, 12, 8, 167,
		9, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 5, 8, 175, 8, 8, 10, 8, 12, 8,
		178, 9, 8, 1, 8, 1, 8, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 1, 10, 5, 10,
		189, 8, 10, 10, 10, 12, 10, 192, 9, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1,
		10, 1, 10, 1, 11, 5, 11, 201, 8, 11, 10, 11, 12, 11, 204, 9, 11, 1, 11,
		1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 3, 11, 213, 8, 11, 1, 11, 1,
		11, 1, 12, 1, 12, 1, 12, 1, 12, 1, 13, 1, 13, 5, 13, 223, 8, 13, 10, 13,
		12, 13, 226, 9, 13, 1, 13, 1, 13, 1, 13, 3, 13, 231, 8, 13, 1, 13, 1, 13,
		1, 13, 1, 13, 1, 13, 5, 13, 238, 8, 13, 10, 13, 12, 13, 241, 9, 13, 1,
		13, 1, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 15, 1, 15, 3, 15,
		253, 8, 15, 1, 16, 1, 16, 1, 16, 1, 16, 5, 16, 259, 8, 16, 10, 16, 12,
		16, 262, 9, 16, 1, 16, 1, 16, 1, 16, 1, 16, 3, 16, 268, 8, 16, 1, 17, 1,
		17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17,
		1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1,
		17, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17, 297, 8, 17, 10, 17, 12, 17, 300,
		9, 17, 1, 18, 1, 18, 1, 19, 1, 19, 1, 19, 1, 19, 1, 19, 1, 19, 1, 19, 1,
		19, 3, 19, 312, 8, 19, 1, 20, 1, 20, 3, 20, 316, 8, 20, 1, 20, 1, 20, 3,
		20, 320, 8, 20, 1, 20, 1, 20, 1, 21, 1, 21, 1, 22, 1, 22, 1, 22, 1, 22,
		1, 22, 3, 22, 331, 8, 22, 1, 23, 1, 23, 4, 23, 335, 8, 23, 11, 23, 12,
		23, 336, 1, 23, 1, 23, 4, 23, 341, 8, 23, 11, 23, 12, 23, 342, 5, 23, 345,
		8, 23, 10, 23, 12, 23, 348, 9, 23, 3, 23, 350, 8, 23, 1, 23, 1, 23, 1,
		24, 1, 24, 3, 24, 356, 8, 24, 1, 24, 1, 24, 1, 24, 1, 25, 1, 25, 5, 25,
		363, 8, 25, 10, 25, 12, 25, 366, 9, 25, 1, 25, 5, 25, 369, 8, 25, 10, 25,
		12, 25, 372, 9, 25, 1, 25, 1, 25, 1, 26, 1, 26, 4, 26, 378, 8, 26, 11,
		26, 12, 26, 379, 1, 26, 3, 26, 383, 8, 26, 1, 27, 1, 27, 1, 27, 1, 27,
		1, 28, 1, 28, 1, 28, 1, 28, 1, 28, 3, 28, 394, 8, 28, 1, 29, 1, 29, 1,
		29, 3, 29, 399, 8, 29, 1, 29, 3, 29, 402, 8, 29, 1, 29, 3, 29, 405, 8,
		29, 1, 29, 1, 29, 1, 30, 1, 30, 1, 30, 3, 30, 412, 8, 30, 1, 30, 5, 30,
		415, 8, 30, 10, 30, 12, 30, 418, 9, 30, 1, 31, 1, 31, 1, 31, 0, 1, 34,
		32, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34,
		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 0, 2, 1, 0, 42,
		47, 3, 0, 14, 28, 35, 40, 48, 48, 458, 0, 67, 1, 0, 0, 0, 2, 82, 1, 0,
		0, 0, 4, 87, 1, 0, 0, 0, 6, 105, 1, 0, 0, 0, 8, 111, 1, 0, 0, 0, 10, 123,
		1, 0, 0, 0, 12, 143, 1, 0, 0, 0, 14, 157, 1, 0, 0, 0, 16, 165, 1, 0, 0,
		0, 18, 181, 1, 0, 0, 0, 20, 190, 1, 0, 0, 0, 22, 202, 1, 0, 0, 0, 24, 216,
		1, 0, 0, 0, 26, 220, 1, 0, 0, 0, 28, 244, 1, 0, 0, 0, 30, 252, 1, 0, 0,
		0, 32, 267, 1, 0, 0, 0, 34, 269, 1, 0, 0, 0, 36, 301, 1, 0, 0, 0, 38, 311,
		1, 0, 0, 0, 40, 313, 1, 0, 0, 0, 42, 323, 1, 0, 0, 0, 44, 330, 1, 0, 0,
		0, 46, 332, 1, 0, 0, 0, 48, 355, 1, 0, 0, 0, 50, 360, 1, 0, 0, 0, 52, 375,
		1, 0, 0, 0, 54, 384, 1, 0, 0, 0, 56, 393, 1, 0, 0, 0, 58, 395, 1, 0, 0,
		0, 60, 408, 1, 0, 0, 0, 62, 419, 1, 0, 0, 0, 64, 66, 3, 2, 1, 0, 65, 64,
		1, 0, 0, 0, 66, 69, 1, 0, 0, 0, 67, 65, 1, 0, 0, 0, 67, 68, 1, 0, 0, 0,
		68, 70, 1, 0, 0, 0, 69, 67, 1, 0, 0, 0, 70, 71, 5, 0, 0, 1, 71, 1, 1, 0,
		0, 0, 72, 83, 3, 4, 2, 0, 73, 83, 3, 8, 4, 0, 74, 83, 3, 10, 5, 0, 75,
		83, 3, 12, 6, 0, 76, 83, 3, 14, 7, 0, 77, 83, 3, 16, 8, 0, 78, 83, 3, 18,
		9, 0, 79, 83, 3, 20, 10, 0, 80, 83, 3, 22, 11, 0, 81, 83, 5, 50, 0, 0,
		82, 72, 1, 0, 0, 0, 82, 73, 1, 0, 0, 0, 82, 74, 1, 0, 0, 0, 82, 75, 1,
		0, 0, 0, 82, 76, 1, 0, 0, 0, 82, 77, 1, 0, 0, 0, 82, 78, 1, 0, 0, 0, 82,
		79, 1, 0, 0, 0, 82, 80, 1, 0, 0, 0, 82, 81, 1, 0, 0, 0, 83, 3, 1, 0, 0,
		0, 84, 86, 3, 54, 27, 0, 85, 84, 1, 0, 0, 0, 86, 89, 1, 0, 0, 0, 87, 85,
		1, 0, 0, 0, 87, 88, 1, 0, 0, 0, 88, 90, 1, 0, 0, 0, 89, 87, 1, 0, 0, 0,
		90, 91, 5, 14, 0, 0, 91, 101, 3, 62, 31, 0, 92, 94, 3, 42, 21, 0, 93, 95,
		3, 6, 3, 0, 94, 93, 1, 0, 0, 0, 94, 95, 1, 0, 0, 0, 95, 102, 1, 0, 0, 0,
		96, 97, 5, 21, 0, 0, 97, 99, 3, 32, 16, 0, 98, 100, 3, 6, 3, 0, 99, 98,
		1, 0, 0, 0, 99, 100, 1, 0, 0, 0, 100, 102, 1, 0, 0, 0, 101, 92, 1, 0, 0,
		0, 101, 96, 1, 0, 0, 0, 102, 103, 1, 0, 0, 0, 103, 104, 5, 50, 0, 0, 104,
		5, 1, 0, 0, 0, 105, 106, 5, 11, 0, 0, 106, 107, 3, 34, 17, 0, 107, 7, 1,
		0, 0, 0, 108, 110, 3, 54, 27, 0, 109, 108, 1, 0, 0, 0, 110, 113, 1, 0,
		0, 0, 111, 109, 1, 0, 0, 0, 111, 112, 1, 0, 0, 0, 112, 114, 1, 0, 0, 0,
		113, 111, 1, 0, 0, 0, 114, 115, 5, 15, 0, 0, 115, 116, 3, 62, 31, 0, 116,
		117, 5, 11, 0, 0, 117, 118, 3, 34, 17, 0, 118, 119, 5, 50, 0, 0, 119, 9,
		1, 0, 0, 0, 120, 122, 3, 54, 27, 0, 121, 120, 1, 0, 0, 0, 122, 125, 1,
		0, 0, 0, 123, 121, 1, 0, 0, 0, 123, 124, 1, 0, 0, 0, 124, 126, 1, 0, 0,
		0, 125, 123, 1, 0, 0, 0, 126, 127, 5, 21, 0, 0, 127, 128, 3, 62, 31, 0,
		128, 130, 3, 32, 16, 0, 129, 131, 5, 28, 0, 0, 130, 129, 1, 0, 0, 0, 130,
		131, 1, 0, 0, 0, 131, 132, 1, 0, 0, 0, 132, 136, 5, 11, 0, 0, 133, 137,
		3, 24, 12, 0, 134, 137, 3, 46, 23, 0, 135, 137, 3, 26, 13, 0, 136, 133,
		1, 0, 0, 0, 136, 134, 1, 0, 0, 0, 136, 135, 1, 0, 0, 0, 137, 138, 1, 0,
		0, 0, 138, 139, 5, 50, 0, 0, 139, 11, 1, 0, 0, 0, 140, 142, 3, 54, 27,
		0, 141, 140, 1, 0, 0, 0, 142, 145, 1, 0, 0, 0, 143, 141, 1, 0, 0, 0, 143,
		144, 1, 0, 0, 0, 144, 146, 1, 0, 0, 0, 145, 143, 1, 0, 0, 0, 146, 147,
		5, 22, 0, 0, 147, 151, 3, 62, 31, 0, 148, 152, 3, 62, 31, 0, 149, 150,
		5, 21, 0, 0, 150, 152, 3, 32, 16, 0, 151, 148, 1, 0, 0, 0, 151, 149, 1,
		0, 0, 0, 152, 153, 1, 0, 0, 0, 153, 154, 5, 11, 0, 0, 154, 155, 3, 34,
		17, 0, 155, 156, 5, 50, 0, 0, 156, 13, 1, 0, 0, 0, 157, 158, 5, 23, 0,
		0, 158, 159, 5, 11, 0, 0, 159, 160, 3, 34, 17, 0, 160, 161, 5, 50, 0, 0,
		161, 15, 1, 0, 0, 0, 162, 164, 3, 54, 27, 0, 163, 162, 1, 0, 0, 0, 164,
		167, 1, 0, 0, 0, 165, 163, 1, 0, 0, 0, 165, 166, 1, 0, 0, 0, 166, 168,
		1, 0, 0, 0, 167, 165, 1, 0, 0, 0, 168, 169, 5, 24, 0, 0, 169, 176, 3, 32,
		16, 0, 170, 171, 5, 25, 0, 0, 171, 175, 3, 46, 23, 0, 172, 173, 5, 26,
		0, 0, 173, 175, 3, 62, 31, 0, 174, 170, 1, 0, 0, 0, 174, 172, 1, 0, 0,
		0, 175, 178, 1, 0, 0, 0, 176, 174, 1, 0, 0, 0, 176, 177, 1, 0, 0, 0, 177,
		179, 1, 0, 0, 0, 178, 176, 1, 0, 0, 0, 179, 180, 5, 50, 0, 0, 180, 17,
		1, 0, 0, 0, 181, 182, 5, 27, 0, 0, 182, 183, 3, 62, 31, 0, 183, 184, 5,
		11, 0, 0, 184, 185, 3, 34, 17, 0, 185, 186, 5, 50, 0, 0, 186, 19, 1, 0,
		0, 0, 187, 189, 3, 54, 27, 0, 188, 187, 1, 0, 0, 0, 189, 192, 1, 0, 0,
		0, 190, 188, 1, 0, 0, 0, 190, 191, 1, 0, 0, 0, 191, 193, 1, 0, 0, 0, 192,
		190, 1, 0, 0, 0, 193, 194, 5, 29, 0, 0, 194, 195, 3, 62, 31, 0, 195, 196,
		5, 11, 0, 0, 196, 197, 3, 42, 21, 0, 197, 198, 5, 50, 0, 0, 198, 21, 1,
		0, 0, 0, 199, 201, 3, 54, 27, 0, 200, 199, 1, 0, 0, 0, 201, 204, 1, 0,
		0, 0, 202, 200, 1, 0, 0, 0, 202, 203, 1, 0, 0, 0, 203, 205, 1, 0, 0, 0,
		204, 202, 1, 0, 0, 0, 205, 206, 5, 30, 0, 0, 206, 207, 3, 62, 31, 0, 207,
		208, 3, 32, 16, 0, 208, 212, 5, 11, 0, 0, 209, 213, 3, 24, 12, 0, 210,
		213, 3, 46, 23, 0, 211, 213, 3, 26, 13, 0, 212, 209, 1, 0, 0, 0, 212, 210,
		1, 0, 0, 0, 212, 211, 1, 0, 0, 0, 213, 214, 1, 0, 0, 0, 214, 215, 5, 50,
		0, 0, 215, 23, 1, 0, 0, 0, 216, 217, 5, 38, 0, 0, 217, 218, 3, 40, 20,
		0, 218, 219, 3, 46, 23, 0, 219, 25, 1, 0, 0, 0, 220, 224, 5, 4, 0, 0, 221,
		223, 5, 50, 0, 0, 222, 221, 1, 0, 0, 0, 223, 226, 1, 0, 0, 0, 224, 222,
		1, 0, 0, 0, 224, 225, 1, 0, 0, 0, 225, 227, 1, 0, 0, 0, 226, 224, 1, 0,
		0, 0, 227, 230, 5, 39, 0, 0, 228, 231, 3, 62, 31, 0, 229, 231, 3, 28, 14,
		0, 230, 228, 1, 0, 0, 0, 230, 229, 1, 0, 0, 0, 231, 232, 1, 0, 0, 0, 232,
		233, 5, 40, 0, 0, 233, 234, 3, 34, 17, 0, 234, 235, 5, 10, 0, 0, 235, 239,
		3, 30, 15, 0, 236, 238, 5, 50, 0, 0, 237, 236, 1, 0, 0, 0, 238, 241, 1,
		0, 0, 0, 239, 237, 1, 0, 0, 0, 239, 240, 1, 0, 0, 0, 240, 242, 1, 0, 0,
		0, 241, 239, 1, 0, 0, 0, 242, 243, 5, 5, 0, 0, 243, 27, 1, 0, 0, 0, 244,
		245, 5, 6, 0, 0, 245, 246, 3, 62, 31, 0, 246, 247, 5, 3, 0, 0, 247, 248,
		3, 62, 31, 0, 248, 249, 5, 7, 0, 0, 249, 29, 1, 0, 0, 0, 250, 253, 3, 34,
		17, 0, 251, 253, 3, 24, 12, 0, 252, 250, 1, 0, 0, 0, 252, 251, 1, 0, 0,
		0, 253, 31, 1, 0, 0, 0, 254, 260, 5, 31, 0, 0, 255, 256, 3, 34, 17, 0,
		256, 257, 5, 32, 0, 0, 257, 259, 1, 0, 0, 0, 258, 255, 1, 0, 0, 0, 259,
		262, 1, 0, 0, 0, 260, 258, 1, 0, 0, 0, 260, 261, 1, 0, 0, 0, 261, 263,
		1, 0, 0, 0, 262, 260, 1, 0, 0, 0, 263, 264, 3, 34, 17, 0, 264, 265, 5,
		33, 0, 0, 265, 268, 1, 0, 0, 0, 266, 268, 5, 34, 0, 0, 267, 254, 1, 0,
		0, 0, 267, 266, 1, 0, 0, 0, 268, 33, 1, 0, 0, 0, 269, 270, 6, 17, -1, 0,
		270, 271, 3, 38, 19, 0, 271, 298, 1, 0, 0, 0, 272, 273, 10, 6, 0, 0, 273,
		274, 5, 41, 0, 0, 274, 275, 3, 34, 17, 0, 275, 276, 5, 10, 0, 0, 276, 277,
		3, 34, 17, 7, 277, 297, 1, 0, 0, 0, 278, 279, 10, 2, 0, 0, 279, 280, 3,
		36, 18, 0, 280, 281, 3, 34, 17, 3, 281, 297, 1, 0, 0, 0, 282, 283, 10,
		7, 0, 0, 283, 284, 5, 4, 0, 0, 284, 285, 3, 34, 17, 0, 285, 286, 5, 5,
		0, 0, 286, 297, 1, 0, 0, 0, 287, 288, 10, 5, 0, 0, 288, 289, 5, 8, 0, 0,
		289, 297, 3, 62, 31, 0, 290, 291, 10, 4, 0, 0, 291, 292, 5, 8, 0, 0, 292,
		297, 3, 58, 29, 0, 293, 294, 10, 3, 0, 0, 294, 295, 5, 10, 0, 0, 295, 297,
		3, 62, 31, 0, 296, 272, 1, 0, 0, 0, 296, 278, 1, 0, 0, 0, 296, 282, 1,
		0, 0, 0, 296, 287, 1, 0, 0, 0, 296, 290, 1, 0, 0, 0, 296, 293, 1, 0, 0,
		0, 297, 300, 1, 0, 0, 0, 298, 296, 1, 0, 0, 0, 298, 299, 1, 0, 0, 0, 299,
		35, 1, 0, 0, 0, 300, 298, 1, 0, 0, 0, 301, 302, 7, 0, 0, 0, 302, 37, 1,
		0, 0, 0, 303, 312, 3, 44, 22, 0, 304, 312, 3, 58, 29, 0, 305, 312, 3, 32,
		16, 0, 306, 312, 5, 1, 0, 0, 307, 312, 3, 50, 25, 0, 308, 312, 3, 46, 23,
		0, 309, 312, 3, 26, 13, 0, 310, 312, 3, 40, 20, 0, 311, 303, 1, 0, 0, 0,
		311, 304, 1, 0, 0, 0, 311, 305, 1, 0, 0, 0, 311, 306, 1, 0, 0, 0, 311,
		307, 1, 0, 0, 0, 311, 308, 1, 0, 0, 0, 311, 309, 1, 0, 0, 0, 311, 310,
		1, 0, 0, 0, 312, 39, 1, 0, 0, 0, 313, 315, 5, 6, 0, 0, 314, 316, 5, 50,
		0, 0, 315, 314, 1, 0, 0, 0, 315, 316, 1, 0, 0, 0, 316, 317, 1, 0, 0, 0,
		317, 319, 3, 34, 17, 0, 318, 320, 5, 50, 0, 0, 319, 318, 1, 0, 0, 0, 319,
		320, 1, 0, 0, 0, 320, 321, 1, 0, 0, 0, 321, 322, 5, 7, 0, 0, 322, 41, 1,
		0, 0, 0, 323, 324, 3, 62, 31, 0, 324, 43, 1, 0, 0, 0, 325, 331, 5, 49,
		0, 0, 326, 331, 5, 16, 0, 0, 327, 331, 5, 17, 0, 0, 328, 331, 5, 18, 0,
		0, 329, 331, 3, 62, 31, 0, 330, 325, 1, 0, 0, 0, 330, 326, 1, 0, 0, 0,
		330, 327, 1, 0, 0, 0, 330, 328, 1, 0, 0, 0, 330, 329, 1, 0, 0, 0, 331,
		45, 1, 0, 0, 0, 332, 349, 5, 12, 0, 0, 333, 335, 5, 50, 0, 0, 334, 333,
		1, 0, 0, 0, 335, 336, 1, 0, 0, 0, 336, 334, 1, 0, 0, 0, 336, 337, 1, 0,
		0, 0, 337, 346, 1, 0, 0, 0, 338, 340, 3, 48, 24, 0, 339, 341, 5, 50, 0,
		0, 340, 339, 1, 0, 0, 0, 341, 342, 1, 0, 0, 0, 342, 340, 1, 0, 0, 0, 342,
		343, 1, 0, 0, 0, 343, 345, 1, 0, 0, 0, 344, 338, 1, 0, 0, 0, 345, 348,
		1, 0, 0, 0, 346, 344, 1, 0, 0, 0, 346, 347, 1, 0, 0, 0, 347, 350, 1, 0,
		0, 0, 348, 346, 1, 0, 0, 0, 349, 334, 1, 0, 0, 0, 349, 350, 1, 0, 0, 0,
		350, 351, 1, 0, 0, 0, 351, 352, 5, 13, 0, 0, 352, 47, 1, 0, 0, 0, 353,
		356, 3, 62, 31, 0, 354, 356, 3, 32, 16, 0, 355, 353, 1, 0, 0, 0, 355, 354,
		1, 0, 0, 0, 356, 357, 1, 0, 0, 0, 357, 358, 5, 10, 0, 0, 358, 359, 3, 34,
		17, 0, 359, 49, 1, 0, 0, 0, 360, 364, 5, 4, 0, 0, 361, 363, 5, 50, 0, 0,
		362, 361, 1, 0, 0, 0, 363, 366, 1, 0, 0, 0, 364, 362, 1, 0, 0, 0, 364,
		365, 1, 0, 0, 0, 365, 370, 1, 0, 0, 0, 366, 364, 1, 0, 0, 0, 367, 369,
		3, 52, 26, 0, 368, 367, 1, 0, 0, 0, 369, 372, 1, 0, 0, 0, 370, 368, 1,
		0, 0, 0, 370, 371, 1, 0, 0, 0, 371, 373, 1, 0, 0, 0, 372, 370, 1, 0, 0,
		0, 373, 374, 5, 5, 0, 0, 374, 51, 1, 0, 0, 0, 375, 382, 3, 34, 17, 0, 376,
		378, 5, 50, 0, 0, 377, 376, 1, 0, 0, 0, 378, 379, 1, 0, 0, 0, 379, 377,
		1, 0, 0, 0, 379, 380, 1, 0, 0, 0, 380, 383, 1, 0, 0, 0, 381, 383, 5, 3,
		0, 0, 382, 377, 1, 0, 0, 0, 382, 381, 1, 0, 0, 0, 382, 383, 1, 0, 0, 0,
		383, 53, 1, 0, 0, 0, 384, 385, 5, 2, 0, 0, 385, 386, 3, 56, 28, 0, 386,
		387, 5, 50, 0, 0, 387, 55, 1, 0, 0, 0, 388, 394, 3, 58, 29, 0, 389, 390,
		3, 34, 17, 0, 390, 391, 5, 8, 0, 0, 391, 392, 3, 58, 29, 0, 392, 394, 1,
		0, 0, 0, 393, 388, 1, 0, 0, 0, 393, 389, 1, 0, 0, 0, 394, 57, 1, 0, 0,
		0, 395, 396, 3, 62, 31, 0, 396, 401, 5, 6, 0, 0, 397, 399, 5, 50, 0, 0,
		398, 397, 1, 0, 0, 0, 398, 399, 1, 0, 0, 0, 399, 400, 1, 0, 0, 0, 400,
		402, 3, 60, 30, 0, 401, 398, 1, 0, 0, 0, 401, 402, 1, 0, 0, 0, 402, 404,
		1, 0, 0, 0, 403, 405, 5, 50, 0, 0, 404, 403, 1, 0, 0, 0, 404, 405, 1, 0,
		0, 0, 405, 406, 1, 0, 0, 0, 406, 407, 5, 7, 0, 0, 407, 59, 1, 0, 0, 0,
		408, 416, 3, 34, 17, 0, 409, 411, 5, 3, 0, 0, 410, 412, 5, 50, 0, 0, 411,
		410, 1, 0, 0, 0, 411, 412, 1, 0, 0, 0, 412, 413, 1, 0, 0, 0, 413, 415,
		3, 34, 17, 0, 414, 409, 1, 0, 0, 0, 415, 418, 1, 0, 0, 0, 416, 414, 1,
		0, 0, 0, 416, 417, 1, 0, 0, 0, 417, 61, 1, 0, 0, 0, 418, 416, 1, 0, 0,
		0, 419, 420, 7, 1, 0, 0, 420, 63, 1, 0, 0, 0, 45, 67, 82, 87, 94, 99, 101,
		111, 123, 130, 136, 143, 151, 165, 174, 176, 190, 202, 212, 224, 230, 239,
		252, 260, 267, 296, 298, 311, 315, 319, 330, 336, 342, 346, 349, 355, 364,
		370, 379, 382, 393, 398, 401, 404, 411, 416,
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
	bicepParserARRAY               = 19
	bicepParserOBJECT              = 20
	bicepParserRESOURCE            = 21
	bicepParserOUTPUT              = 22
	bicepParserTARGET_SCOPE        = 23
	bicepParserIMPORT              = 24
	bicepParserWITH                = 25
	bicepParserAS                  = 26
	bicepParserMETADATA            = 27
	bicepParserEXISTING            = 28
	bicepParserTYPE                = 29
	bicepParserMODULE              = 30
	bicepParserSTRING_LEFT_PIECE   = 31
	bicepParserSTRING_MIDDLE_PIECE = 32
	bicepParserSTRING_RIGHT_PIECE  = 33
	bicepParserSTRING_COMPLETE     = 34
	bicepParserSTRING              = 35
	bicepParserINT                 = 36
	bicepParserBOOL                = 37
	bicepParserIF                  = 38
	bicepParserFOR                 = 39
	bicepParserIN                  = 40
	bicepParserQMARK               = 41
	bicepParserGT                  = 42
	bicepParserGTE                 = 43
	bicepParserLT                  = 44
	bicepParserLTE                 = 45
	bicepParserEQ                  = 46
	bicepParserNEQ                 = 47
	bicepParserIDENTIFIER          = 48
	bicepParserNUMBER              = 49
	bicepParserNL                  = 50
	bicepParserSINGLE_LINE_COMMENT = 51
	bicepParserMULTI_LINE_COMMENT  = 52
	bicepParserSPACES              = 53
	bicepParserUNKNOWN             = 54
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
	bicepParserRULE_targetScopeDecl         = 7
	bicepParserRULE_importDecl              = 8
	bicepParserRULE_metadataDecl            = 9
	bicepParserRULE_typeDecl                = 10
	bicepParserRULE_moduleDecl              = 11
	bicepParserRULE_ifCondition             = 12
	bicepParserRULE_forExpression           = 13
	bicepParserRULE_forVariableBlock        = 14
	bicepParserRULE_forBody                 = 15
	bicepParserRULE_interpString            = 16
	bicepParserRULE_expression              = 17
	bicepParserRULE_logicCharacter          = 18
	bicepParserRULE_primaryExpression       = 19
	bicepParserRULE_parenthesizedExpression = 20
	bicepParserRULE_typeExpression          = 21
	bicepParserRULE_literalValue            = 22
	bicepParserRULE_object                  = 23
	bicepParserRULE_objectProperty          = 24
	bicepParserRULE_array                   = 25
	bicepParserRULE_arrayItem               = 26
	bicepParserRULE_decorator               = 27
	bicepParserRULE_decoratorExpression     = 28
	bicepParserRULE_functionCall            = 29
	bicepParserRULE_argumentList            = 30
	bicepParserRULE_identifier              = 31
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
	p.SetState(67)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1125901683179524) != 0 {
		{
			p.SetState(64)
			p.Statement()
		}

		p.SetState(69)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(70)
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
	TargetScopeDecl() ITargetScopeDeclContext
	ImportDecl() IImportDeclContext
	MetadataDecl() IMetadataDeclContext
	TypeDecl() ITypeDeclContext
	ModuleDecl() IModuleDeclContext
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

func (s *StatementContext) TargetScopeDecl() ITargetScopeDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ITargetScopeDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ITargetScopeDeclContext)
}

func (s *StatementContext) ImportDecl() IImportDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IImportDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IImportDeclContext)
}

func (s *StatementContext) MetadataDecl() IMetadataDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IMetadataDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IMetadataDeclContext)
}

func (s *StatementContext) TypeDecl() ITypeDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ITypeDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ITypeDeclContext)
}

func (s *StatementContext) ModuleDecl() IModuleDeclContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IModuleDeclContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IModuleDeclContext)
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
	p.SetState(82)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(72)
			p.ParameterDecl()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(73)
			p.VariableDecl()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(74)
			p.ResourceDecl()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(75)
			p.OutputDecl()
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(76)
			p.TargetScopeDecl()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(77)
			p.ImportDecl()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(78)
			p.MetadataDecl()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(79)
			p.TypeDecl()
		}

	case 9:
		p.EnterOuterAlt(localctx, 9)
		{
			p.SetState(80)
			p.ModuleDecl()
		}

	case 10:
		p.EnterOuterAlt(localctx, 10)
		{
			p.SetState(81)
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
	p.SetState(87)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(84)
			p.Decorator()
		}

		p.SetState(89)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(90)
		p.Match(bicepParserPARAM)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(91)

		var _x = p.Identifier()

		localctx.(*ParameterDeclContext).name = _x
	}
	p.SetState(101)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 5, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(92)
			p.TypeExpression()
		}
		p.SetState(94)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(93)
				p.ParameterDefaultValue()
			}

		}

	case 2:
		{
			p.SetState(96)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(97)

			var _x = p.InterpString()

			localctx.(*ParameterDeclContext).type_ = _x
		}
		p.SetState(99)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(98)
				p.ParameterDefaultValue()
			}

		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
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
		p.SetState(105)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(106)
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
	p.SetState(111)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(108)
			p.Decorator()
		}

		p.SetState(113)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(114)
		p.Match(bicepParserVAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(115)

		var _x = p.Identifier()

		localctx.(*VariableDeclContext).name = _x
	}
	{
		p.SetState(116)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(117)
		p.expression(0)
	}
	{
		p.SetState(118)
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
	p.SetState(123)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(120)
			p.Decorator()
		}

		p.SetState(125)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(126)
		p.Match(bicepParserRESOURCE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(127)

		var _x = p.Identifier()

		localctx.(*ResourceDeclContext).name = _x
	}
	{
		p.SetState(128)

		var _x = p.InterpString()

		localctx.(*ResourceDeclContext).type_ = _x
	}
	p.SetState(130)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserEXISTING {
		{
			p.SetState(129)
			p.Match(bicepParserEXISTING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(132)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(136)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(133)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(134)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(135)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(138)
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
	p.SetState(143)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(140)
			p.Decorator()
		}

		p.SetState(145)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(146)
		p.Match(bicepParserOUTPUT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(147)

		var _x = p.Identifier()

		localctx.(*OutputDeclContext).name = _x
	}
	p.SetState(151)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 11, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(148)

			var _x = p.Identifier()

			localctx.(*OutputDeclContext).type1 = _x
		}

	case 2:
		{
			p.SetState(149)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(150)

			var _x = p.InterpString()

			localctx.(*OutputDeclContext).type2 = _x
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(153)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(154)
		p.expression(0)
	}
	{
		p.SetState(155)
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

// ITargetScopeDeclContext is an interface to support dynamic dispatch.
type ITargetScopeDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	TARGET_SCOPE() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	Expression() IExpressionContext
	NL() antlr.TerminalNode

	// IsTargetScopeDeclContext differentiates from other interfaces.
	IsTargetScopeDeclContext()
}

type TargetScopeDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyTargetScopeDeclContext() *TargetScopeDeclContext {
	var p = new(TargetScopeDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_targetScopeDecl
	return p
}

func InitEmptyTargetScopeDeclContext(p *TargetScopeDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_targetScopeDecl
}

func (*TargetScopeDeclContext) IsTargetScopeDeclContext() {}

func NewTargetScopeDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *TargetScopeDeclContext {
	var p = new(TargetScopeDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_targetScopeDecl

	return p
}

func (s *TargetScopeDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *TargetScopeDeclContext) TARGET_SCOPE() antlr.TerminalNode {
	return s.GetToken(bicepParserTARGET_SCOPE, 0)
}

func (s *TargetScopeDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *TargetScopeDeclContext) Expression() IExpressionContext {
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

func (s *TargetScopeDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *TargetScopeDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *TargetScopeDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *TargetScopeDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitTargetScopeDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) TargetScopeDecl() (localctx ITargetScopeDeclContext) {
	localctx = NewTargetScopeDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 14, bicepParserRULE_targetScopeDecl)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(157)
		p.Match(bicepParserTARGET_SCOPE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(158)
		p.Match(bicepParserASSIGN)
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

// IImportDeclContext is an interface to support dynamic dispatch.
type IImportDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetSpecification returns the specification rule contexts.
	GetSpecification() IInterpStringContext

	// GetAlias returns the alias rule contexts.
	GetAlias() IIdentifierContext

	// SetSpecification sets the specification rule contexts.
	SetSpecification(IInterpStringContext)

	// SetAlias sets the alias rule contexts.
	SetAlias(IIdentifierContext)

	// Getter signatures
	IMPORT() antlr.TerminalNode
	NL() antlr.TerminalNode
	InterpString() IInterpStringContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext
	AllWITH() []antlr.TerminalNode
	WITH(i int) antlr.TerminalNode
	AllObject() []IObjectContext
	Object(i int) IObjectContext
	AllAS() []antlr.TerminalNode
	AS(i int) antlr.TerminalNode
	AllIdentifier() []IIdentifierContext
	Identifier(i int) IIdentifierContext

	// IsImportDeclContext differentiates from other interfaces.
	IsImportDeclContext()
}

type ImportDeclContext struct {
	antlr.BaseParserRuleContext
	parser        antlr.Parser
	specification IInterpStringContext
	alias         IIdentifierContext
}

func NewEmptyImportDeclContext() *ImportDeclContext {
	var p = new(ImportDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_importDecl
	return p
}

func InitEmptyImportDeclContext(p *ImportDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_importDecl
}

func (*ImportDeclContext) IsImportDeclContext() {}

func NewImportDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ImportDeclContext {
	var p = new(ImportDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_importDecl

	return p
}

func (s *ImportDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *ImportDeclContext) GetSpecification() IInterpStringContext { return s.specification }

func (s *ImportDeclContext) GetAlias() IIdentifierContext { return s.alias }

func (s *ImportDeclContext) SetSpecification(v IInterpStringContext) { s.specification = v }

func (s *ImportDeclContext) SetAlias(v IIdentifierContext) { s.alias = v }

func (s *ImportDeclContext) IMPORT() antlr.TerminalNode {
	return s.GetToken(bicepParserIMPORT, 0)
}

func (s *ImportDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *ImportDeclContext) InterpString() IInterpStringContext {
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

func (s *ImportDeclContext) AllDecorator() []IDecoratorContext {
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

func (s *ImportDeclContext) Decorator(i int) IDecoratorContext {
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

func (s *ImportDeclContext) AllWITH() []antlr.TerminalNode {
	return s.GetTokens(bicepParserWITH)
}

func (s *ImportDeclContext) WITH(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserWITH, i)
}

func (s *ImportDeclContext) AllObject() []IObjectContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IObjectContext); ok {
			len++
		}
	}

	tst := make([]IObjectContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IObjectContext); ok {
			tst[i] = t.(IObjectContext)
			i++
		}
	}

	return tst
}

func (s *ImportDeclContext) Object(i int) IObjectContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IObjectContext); ok {
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

	return t.(IObjectContext)
}

func (s *ImportDeclContext) AllAS() []antlr.TerminalNode {
	return s.GetTokens(bicepParserAS)
}

func (s *ImportDeclContext) AS(i int) antlr.TerminalNode {
	return s.GetToken(bicepParserAS, i)
}

func (s *ImportDeclContext) AllIdentifier() []IIdentifierContext {
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

func (s *ImportDeclContext) Identifier(i int) IIdentifierContext {
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

func (s *ImportDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ImportDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ImportDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitImportDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ImportDecl() (localctx IImportDeclContext) {
	localctx = NewImportDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 16, bicepParserRULE_importDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(165)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(162)
			p.Decorator()
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
		p.Match(bicepParserIMPORT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(169)

		var _x = p.InterpString()

		localctx.(*ImportDeclContext).specification = _x
	}
	p.SetState(176)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserWITH || _la == bicepParserAS {
		p.SetState(174)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}

		switch p.GetTokenStream().LA(1) {
		case bicepParserWITH:
			{
				p.SetState(170)
				p.Match(bicepParserWITH)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}
			{
				p.SetState(171)
				p.Object()
			}

		case bicepParserAS:
			{
				p.SetState(172)
				p.Match(bicepParserAS)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}
			{
				p.SetState(173)

				var _x = p.Identifier()

				localctx.(*ImportDeclContext).alias = _x
			}

		default:
			p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
			goto errorExit
		}

		p.SetState(178)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(179)
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

// IMetadataDeclContext is an interface to support dynamic dispatch.
type IMetadataDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// Getter signatures
	METADATA() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	Expression() IExpressionContext
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext

	// IsMetadataDeclContext differentiates from other interfaces.
	IsMetadataDeclContext()
}

type MetadataDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
}

func NewEmptyMetadataDeclContext() *MetadataDeclContext {
	var p = new(MetadataDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_metadataDecl
	return p
}

func InitEmptyMetadataDeclContext(p *MetadataDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_metadataDecl
}

func (*MetadataDeclContext) IsMetadataDeclContext() {}

func NewMetadataDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *MetadataDeclContext {
	var p = new(MetadataDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_metadataDecl

	return p
}

func (s *MetadataDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *MetadataDeclContext) GetName() IIdentifierContext { return s.name }

func (s *MetadataDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *MetadataDeclContext) METADATA() antlr.TerminalNode {
	return s.GetToken(bicepParserMETADATA, 0)
}

func (s *MetadataDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *MetadataDeclContext) Expression() IExpressionContext {
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

func (s *MetadataDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *MetadataDeclContext) Identifier() IIdentifierContext {
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

func (s *MetadataDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *MetadataDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *MetadataDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitMetadataDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) MetadataDecl() (localctx IMetadataDeclContext) {
	localctx = NewMetadataDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 18, bicepParserRULE_metadataDecl)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(181)
		p.Match(bicepParserMETADATA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(182)

		var _x = p.Identifier()

		localctx.(*MetadataDeclContext).name = _x
	}
	{
		p.SetState(183)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(184)
		p.expression(0)
	}
	{
		p.SetState(185)
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

// ITypeDeclContext is an interface to support dynamic dispatch.
type ITypeDeclContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// GetName returns the name rule contexts.
	GetName() IIdentifierContext

	// SetName sets the name rule contexts.
	SetName(IIdentifierContext)

	// Getter signatures
	TYPE() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	TypeExpression() ITypeExpressionContext
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext

	// IsTypeDeclContext differentiates from other interfaces.
	IsTypeDeclContext()
}

type TypeDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
}

func NewEmptyTypeDeclContext() *TypeDeclContext {
	var p = new(TypeDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_typeDecl
	return p
}

func InitEmptyTypeDeclContext(p *TypeDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_typeDecl
}

func (*TypeDeclContext) IsTypeDeclContext() {}

func NewTypeDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *TypeDeclContext {
	var p = new(TypeDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_typeDecl

	return p
}

func (s *TypeDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *TypeDeclContext) GetName() IIdentifierContext { return s.name }

func (s *TypeDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *TypeDeclContext) TYPE() antlr.TerminalNode {
	return s.GetToken(bicepParserTYPE, 0)
}

func (s *TypeDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *TypeDeclContext) TypeExpression() ITypeExpressionContext {
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

func (s *TypeDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *TypeDeclContext) Identifier() IIdentifierContext {
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

func (s *TypeDeclContext) AllDecorator() []IDecoratorContext {
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

func (s *TypeDeclContext) Decorator(i int) IDecoratorContext {
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

func (s *TypeDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *TypeDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *TypeDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitTypeDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) TypeDecl() (localctx ITypeDeclContext) {
	localctx = NewTypeDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 20, bicepParserRULE_typeDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(190)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(187)
			p.Decorator()
		}

		p.SetState(192)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(193)
		p.Match(bicepParserTYPE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(194)

		var _x = p.Identifier()

		localctx.(*TypeDeclContext).name = _x
	}
	{
		p.SetState(195)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(196)
		p.TypeExpression()
	}
	{
		p.SetState(197)
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

// IModuleDeclContext is an interface to support dynamic dispatch.
type IModuleDeclContext interface {
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
	MODULE() antlr.TerminalNode
	ASSIGN() antlr.TerminalNode
	NL() antlr.TerminalNode
	Identifier() IIdentifierContext
	InterpString() IInterpStringContext
	IfCondition() IIfConditionContext
	Object() IObjectContext
	ForExpression() IForExpressionContext
	AllDecorator() []IDecoratorContext
	Decorator(i int) IDecoratorContext

	// IsModuleDeclContext differentiates from other interfaces.
	IsModuleDeclContext()
}

type ModuleDeclContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
	name   IIdentifierContext
	type_  IInterpStringContext
}

func NewEmptyModuleDeclContext() *ModuleDeclContext {
	var p = new(ModuleDeclContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_moduleDecl
	return p
}

func InitEmptyModuleDeclContext(p *ModuleDeclContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_moduleDecl
}

func (*ModuleDeclContext) IsModuleDeclContext() {}

func NewModuleDeclContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ModuleDeclContext {
	var p = new(ModuleDeclContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_moduleDecl

	return p
}

func (s *ModuleDeclContext) GetParser() antlr.Parser { return s.parser }

func (s *ModuleDeclContext) GetName() IIdentifierContext { return s.name }

func (s *ModuleDeclContext) GetType_() IInterpStringContext { return s.type_ }

func (s *ModuleDeclContext) SetName(v IIdentifierContext) { s.name = v }

func (s *ModuleDeclContext) SetType_(v IInterpStringContext) { s.type_ = v }

func (s *ModuleDeclContext) MODULE() antlr.TerminalNode {
	return s.GetToken(bicepParserMODULE, 0)
}

func (s *ModuleDeclContext) ASSIGN() antlr.TerminalNode {
	return s.GetToken(bicepParserASSIGN, 0)
}

func (s *ModuleDeclContext) NL() antlr.TerminalNode {
	return s.GetToken(bicepParserNL, 0)
}

func (s *ModuleDeclContext) Identifier() IIdentifierContext {
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

func (s *ModuleDeclContext) InterpString() IInterpStringContext {
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

func (s *ModuleDeclContext) IfCondition() IIfConditionContext {
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

func (s *ModuleDeclContext) Object() IObjectContext {
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

func (s *ModuleDeclContext) ForExpression() IForExpressionContext {
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

func (s *ModuleDeclContext) AllDecorator() []IDecoratorContext {
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

func (s *ModuleDeclContext) Decorator(i int) IDecoratorContext {
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

func (s *ModuleDeclContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ModuleDeclContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ModuleDeclContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitModuleDecl(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) ModuleDecl() (localctx IModuleDeclContext) {
	localctx = NewModuleDeclContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 22, bicepParserRULE_moduleDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(202)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(199)
			p.Decorator()
		}

		p.SetState(204)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(205)
		p.Match(bicepParserMODULE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(206)

		var _x = p.Identifier()

		localctx.(*ModuleDeclContext).name = _x
	}
	{
		p.SetState(207)

		var _x = p.InterpString()

		localctx.(*ModuleDeclContext).type_ = _x
	}
	{
		p.SetState(208)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(212)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(209)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(210)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(211)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(214)
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
	p.EnterRule(localctx, 24, bicepParserRULE_ifCondition)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(216)
		p.Match(bicepParserIF)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(217)
		p.ParenthesizedExpression()
	}
	{
		p.SetState(218)
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
	p.EnterRule(localctx, 26, bicepParserRULE_forExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(220)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(224)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(221)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(226)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(227)
		p.Match(bicepParserFOR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(230)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER:
		{
			p.SetState(228)

			var _x = p.Identifier()

			localctx.(*ForExpressionContext).item = _x
		}

	case bicepParserOPAR:
		{
			p.SetState(229)
			p.ForVariableBlock()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(232)
		p.Match(bicepParserIN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(233)
		p.expression(0)
	}
	{
		p.SetState(234)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(235)
		p.ForBody()
	}
	p.SetState(239)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(236)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(241)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(242)
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
	p.EnterRule(localctx, 28, bicepParserRULE_forVariableBlock)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(244)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(245)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).item = _x
	}
	{
		p.SetState(246)
		p.Match(bicepParserCOMMA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(247)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).index = _x
	}
	{
		p.SetState(248)
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
	p.EnterRule(localctx, 30, bicepParserRULE_forBody)
	p.SetState(252)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 21, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(250)

			var _x = p.expression(0)

			localctx.(*ForBodyContext).body = _x
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(251)
			p.IfCondition()
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
	p.EnterRule(localctx, 32, bicepParserRULE_interpString)
	var _alt int

	p.SetState(267)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserSTRING_LEFT_PIECE:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(254)
			p.Match(bicepParserSTRING_LEFT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(260)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 22, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
		for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			if _alt == 1 {
				{
					p.SetState(255)
					p.expression(0)
				}
				{
					p.SetState(256)
					p.Match(bicepParserSTRING_MIDDLE_PIECE)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			}
			p.SetState(262)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 22, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}
		{
			p.SetState(263)
			p.expression(0)
		}
		{
			p.SetState(264)
			p.Match(bicepParserSTRING_RIGHT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserSTRING_COMPLETE:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(266)
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
	COL() antlr.TerminalNode
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

func (s *ExpressionContext) COL() antlr.TerminalNode {
	return s.GetToken(bicepParserCOL, 0)
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
	_startState := 34
	p.EnterRecursionRule(localctx, 34, bicepParserRULE_expression, _p)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(270)
		p.PrimaryExpression()
	}

	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(298)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 25, p.GetParserRuleContext())
	if p.HasError() {
		goto errorExit
	}
	for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
		if _alt == 1 {
			if p.GetParseListeners() != nil {
				p.TriggerExitRuleEvent()
			}
			_prevctx = localctx
			p.SetState(296)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 24, p.GetParserRuleContext()) {
			case 1:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(272)

				if !(p.Precpred(p.GetParserRuleContext(), 6)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 6)", ""))
					goto errorExit
				}
				{
					p.SetState(273)
					p.Match(bicepParserQMARK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(274)
					p.expression(0)
				}
				{
					p.SetState(275)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(276)
					p.expression(7)
				}

			case 2:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(278)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(279)
					p.LogicCharacter()
				}
				{
					p.SetState(280)
					p.expression(3)
				}

			case 3:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(282)

				if !(p.Precpred(p.GetParserRuleContext(), 7)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 7)", ""))
					goto errorExit
				}
				{
					p.SetState(283)
					p.Match(bicepParserOBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(284)
					p.expression(0)
				}
				{
					p.SetState(285)
					p.Match(bicepParserCBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			case 4:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(287)

				if !(p.Precpred(p.GetParserRuleContext(), 5)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 5)", ""))
					goto errorExit
				}
				{
					p.SetState(288)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(289)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).property = _x
				}

			case 5:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(290)

				if !(p.Precpred(p.GetParserRuleContext(), 4)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 4)", ""))
					goto errorExit
				}
				{
					p.SetState(291)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(292)
					p.FunctionCall()
				}

			case 6:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(293)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(294)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(295)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(300)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 25, p.GetParserRuleContext())
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
	p.EnterRule(localctx, 36, bicepParserRULE_logicCharacter)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(301)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&277076930199552) != 0) {
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
	p.EnterRule(localctx, 38, bicepParserRULE_primaryExpression)
	p.SetState(311)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 26, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(303)
			p.LiteralValue()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(304)
			p.FunctionCall()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(305)
			p.InterpString()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(306)
			p.Match(bicepParserMULTILINE_STRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(307)
			p.Array()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(308)
			p.Object()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(309)
			p.ForExpression()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(310)
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
	p.EnterRule(localctx, 40, bicepParserRULE_parenthesizedExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(313)
		p.Match(bicepParserOPAR)
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
	p.SetState(319)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(318)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(321)
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
	p.EnterRule(localctx, 42, bicepParserRULE_typeExpression)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(323)

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
	p.EnterRule(localctx, 44, bicepParserRULE_literalValue)
	p.SetState(330)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 29, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(325)
			p.Match(bicepParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(326)
			p.Match(bicepParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(327)
			p.Match(bicepParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(328)
			p.Match(bicepParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(329)
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
	p.EnterRule(localctx, 46, bicepParserRULE_object)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(332)
		p.Match(bicepParserOBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(349)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		p.SetState(334)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(333)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(336)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}
		p.SetState(346)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&283659504435200) != 0 {
			{
				p.SetState(338)
				p.ObjectProperty()
			}
			p.SetState(340)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)

			for ok := true; ok; ok = _la == bicepParserNL {
				{
					p.SetState(339)
					p.Match(bicepParserNL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

				p.SetState(342)
				p.GetErrorHandler().Sync(p)
				if p.HasError() {
					goto errorExit
				}
				_la = p.GetTokenStream().LA(1)
			}

			p.SetState(348)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	}
	{
		p.SetState(351)
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
	p.EnterRule(localctx, 48, bicepParserRULE_objectProperty)
	p.EnterOuterAlt(localctx, 1)
	p.SetState(355)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER:
		{
			p.SetState(353)

			var _x = p.Identifier()

			localctx.(*ObjectPropertyContext).name = _x
		}

	case bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE:
		{
			p.SetState(354)
			p.InterpString()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(357)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(358)
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
	p.EnterRule(localctx, 50, bicepParserRULE_array)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(360)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(364)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(361)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(366)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	p.SetState(370)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&846609457860690) != 0 {
		{
			p.SetState(367)
			p.ArrayItem()
		}

		p.SetState(372)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(373)
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
	p.EnterRule(localctx, 52, bicepParserRULE_arrayItem)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(375)
		p.expression(0)
	}
	p.SetState(382)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	switch p.GetTokenStream().LA(1) {
	case bicepParserNL:
		p.SetState(377)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(376)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(379)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	case bicepParserCOMMA:
		{
			p.SetState(381)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserCBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER, bicepParserNUMBER:

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
	p.EnterRule(localctx, 54, bicepParserRULE_decorator)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(384)
		p.Match(bicepParserAT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(385)
		p.DecoratorExpression()
	}
	{
		p.SetState(386)
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
	p.EnterRule(localctx, 56, bicepParserRULE_decoratorExpression)
	p.SetState(393)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 39, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(388)
			p.FunctionCall()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(389)
			p.expression(0)
		}
		{
			p.SetState(390)
			p.Match(bicepParserDOT)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(391)
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
	p.EnterRule(localctx, 58, bicepParserRULE_functionCall)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(395)
		p.Identifier()
	}
	{
		p.SetState(396)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(401)
	p.GetErrorHandler().Sync(p)

	if p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 41, p.GetParserRuleContext()) == 1 {
		p.SetState(398)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(397)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(400)
			p.ArgumentList()
		}

	} else if p.HasError() { // JIM
		goto errorExit
	}
	p.SetState(404)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(403)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(406)
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
	p.EnterRule(localctx, 60, bicepParserRULE_argumentList)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(408)
		p.expression(0)
	}
	p.SetState(416)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserCOMMA {
		{
			p.SetState(409)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(411)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(410)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(413)
			p.expression(0)
		}

		p.SetState(418)
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
	IMPORT() antlr.TerminalNode
	WITH() antlr.TerminalNode
	AS() antlr.TerminalNode
	METADATA() antlr.TerminalNode
	PARAM() antlr.TerminalNode
	RESOURCE() antlr.TerminalNode
	OUTPUT() antlr.TerminalNode
	EXISTING() antlr.TerminalNode
	VAR() antlr.TerminalNode
	IF() antlr.TerminalNode
	FOR() antlr.TerminalNode
	IN() antlr.TerminalNode
	TRUE() antlr.TerminalNode
	FALSE() antlr.TerminalNode
	NULL() antlr.TerminalNode
	TARGET_SCOPE() antlr.TerminalNode
	STRING() antlr.TerminalNode
	INT() antlr.TerminalNode
	BOOL() antlr.TerminalNode
	ARRAY() antlr.TerminalNode
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

func (s *IdentifierContext) IMPORT() antlr.TerminalNode {
	return s.GetToken(bicepParserIMPORT, 0)
}

func (s *IdentifierContext) WITH() antlr.TerminalNode {
	return s.GetToken(bicepParserWITH, 0)
}

func (s *IdentifierContext) AS() antlr.TerminalNode {
	return s.GetToken(bicepParserAS, 0)
}

func (s *IdentifierContext) METADATA() antlr.TerminalNode {
	return s.GetToken(bicepParserMETADATA, 0)
}

func (s *IdentifierContext) PARAM() antlr.TerminalNode {
	return s.GetToken(bicepParserPARAM, 0)
}

func (s *IdentifierContext) RESOURCE() antlr.TerminalNode {
	return s.GetToken(bicepParserRESOURCE, 0)
}

func (s *IdentifierContext) OUTPUT() antlr.TerminalNode {
	return s.GetToken(bicepParserOUTPUT, 0)
}

func (s *IdentifierContext) EXISTING() antlr.TerminalNode {
	return s.GetToken(bicepParserEXISTING, 0)
}

func (s *IdentifierContext) VAR() antlr.TerminalNode {
	return s.GetToken(bicepParserVAR, 0)
}

func (s *IdentifierContext) IF() antlr.TerminalNode {
	return s.GetToken(bicepParserIF, 0)
}

func (s *IdentifierContext) FOR() antlr.TerminalNode {
	return s.GetToken(bicepParserFOR, 0)
}

func (s *IdentifierContext) IN() antlr.TerminalNode {
	return s.GetToken(bicepParserIN, 0)
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

func (s *IdentifierContext) TARGET_SCOPE() antlr.TerminalNode {
	return s.GetToken(bicepParserTARGET_SCOPE, 0)
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

func (s *IdentifierContext) ARRAY() antlr.TerminalNode {
	return s.GetToken(bicepParserARRAY, 0)
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
	p.EnterRule(localctx, 62, bicepParserRULE_identifier)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(419)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&283640177082368) != 0) {
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
	case 17:
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
