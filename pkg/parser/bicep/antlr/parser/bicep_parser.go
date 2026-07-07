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
		"'?'", "'>'", "'>='", "'<'", "'<='", "'=='", "'!='", "'=>'",
	}
	staticData.SymbolicNames = []string{
		"", "MULTILINE_STRING", "AT", "COMMA", "OBRACK", "CBRACK", "OPAR", "CPAR",
		"DOT", "PIPE", "COL", "ASSIGN", "OBRACE", "CBRACE", "PARAM", "VAR",
		"TRUE", "FALSE", "NULL", "ARRAY", "OBJECT", "RESOURCE", "OUTPUT", "TARGET_SCOPE",
		"IMPORT", "WITH", "AS", "METADATA", "EXISTING", "TYPE", "MODULE", "STRING_LEFT_PIECE",
		"STRING_MIDDLE_PIECE", "STRING_RIGHT_PIECE", "STRING_COMPLETE", "STRING",
		"INT", "BOOL", "IF", "FOR", "IN", "QMARK", "GT", "GTE", "LT", "LTE",
		"EQ", "NEQ", "ARROW", "IDENTIFIER", "NUMBER", "NL", "SINGLE_LINE_COMMENT",
		"MULTI_LINE_COMMENT", "SPACES", "UNKNOWN",
	}
	staticData.RuleNames = []string{
		"program", "statement", "targetScopeDecl", "importDecl", "metadataDecl",
		"parameterDecl", "parameterDefaultValue", "typeDecl", "variableDecl",
		"resourceDecl", "moduleDecl", "outputDecl", "ifCondition", "forExpression",
		"forVariableBlock", "forBody", "interpString", "expression", "lambdaExpression",
		"logicCharacter", "primaryExpression", "parenthesizedExpression", "typeExpression",
		"literalValue", "object", "objectProperty", "array", "arrayItem", "decorator",
		"decoratorExpression", "functionCall", "argumentList", "identifier",
		"comment",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 55, 440, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7,
		10, 2, 11, 7, 11, 2, 12, 7, 12, 2, 13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15,
		2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7, 19, 2, 20, 7, 20, 2,
		21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25, 2, 26,
		7, 26, 2, 27, 7, 27, 2, 28, 7, 28, 2, 29, 7, 29, 2, 30, 7, 30, 2, 31, 7,
		31, 2, 32, 7, 32, 2, 33, 7, 33, 1, 0, 5, 0, 70, 8, 0, 10, 0, 12, 0, 73,
		9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 3, 1, 87, 8, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 5, 3, 95, 8,
		3, 10, 3, 12, 3, 98, 9, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 5, 3, 106,
		8, 3, 10, 3, 12, 3, 109, 9, 3, 1, 3, 1, 3, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4,
		1, 4, 1, 5, 5, 5, 120, 8, 5, 10, 5, 12, 5, 123, 9, 5, 1, 5, 1, 5, 1, 5,
		1, 5, 3, 5, 129, 8, 5, 1, 5, 1, 5, 1, 5, 3, 5, 134, 8, 5, 3, 5, 136, 8,
		5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 1, 7, 5, 7, 144, 8, 7, 10, 7, 12, 7, 147,
		9, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 7, 1, 8, 5, 8, 156, 8, 8, 10, 8,
		12, 8, 159, 9, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 9, 5, 9, 168,
		8, 9, 10, 9, 12, 9, 171, 9, 9, 1, 9, 1, 9, 1, 9, 1, 9, 3, 9, 177, 8, 9,
		1, 9, 1, 9, 1, 9, 1, 9, 3, 9, 183, 8, 9, 1, 9, 1, 9, 1, 10, 5, 10, 188,
		8, 10, 10, 10, 12, 10, 191, 9, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1,
		10, 1, 10, 3, 10, 200, 8, 10, 1, 10, 1, 10, 1, 11, 5, 11, 205, 8, 11, 10,
		11, 12, 11, 208, 9, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 11, 3, 11, 215,
		8, 11, 1, 11, 1, 11, 1, 11, 1, 11, 1, 12, 1, 12, 1, 12, 1, 12, 1, 13, 1,
		13, 5, 13, 227, 8, 13, 10, 13, 12, 13, 230, 9, 13, 1, 13, 1, 13, 1, 13,
		3, 13, 235, 8, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 5, 13, 242, 8, 13,
		10, 13, 12, 13, 245, 9, 13, 1, 13, 1, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1,
		14, 1, 14, 1, 15, 1, 15, 3, 15, 257, 8, 15, 1, 16, 1, 16, 1, 16, 1, 16,
		5, 16, 263, 8, 16, 10, 16, 12, 16, 266, 9, 16, 1, 16, 1, 16, 1, 16, 1,
		16, 3, 16, 272, 8, 16, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17,
		1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1,
		17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17,
		301, 8, 17, 10, 17, 12, 17, 304, 9, 17, 1, 18, 1, 18, 3, 18, 308, 8, 18,
		1, 18, 1, 18, 3, 18, 312, 8, 18, 1, 18, 1, 18, 1, 18, 1, 19, 1, 19, 1,
		20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 3, 20, 328,
		8, 20, 1, 21, 1, 21, 3, 21, 332, 8, 21, 1, 21, 1, 21, 3, 21, 336, 8, 21,
		1, 21, 1, 21, 1, 22, 1, 22, 1, 23, 1, 23, 1, 23, 1, 23, 1, 23, 3, 23, 347,
		8, 23, 1, 24, 1, 24, 4, 24, 351, 8, 24, 11, 24, 12, 24, 352, 1, 24, 1,
		24, 4, 24, 357, 8, 24, 11, 24, 12, 24, 358, 5, 24, 361, 8, 24, 10, 24,
		12, 24, 364, 9, 24, 3, 24, 366, 8, 24, 1, 24, 1, 24, 1, 25, 1, 25, 3, 25,
		372, 8, 25, 1, 25, 1, 25, 1, 25, 1, 26, 1, 26, 5, 26, 379, 8, 26, 10, 26,
		12, 26, 382, 9, 26, 1, 26, 5, 26, 385, 8, 26, 10, 26, 12, 26, 388, 9, 26,
		1, 26, 1, 26, 1, 27, 1, 27, 4, 27, 394, 8, 27, 11, 27, 12, 27, 395, 1,
		27, 3, 27, 399, 8, 27, 1, 28, 1, 28, 1, 28, 1, 28, 1, 29, 1, 29, 1, 29,
		1, 29, 1, 29, 3, 29, 410, 8, 29, 1, 30, 1, 30, 1, 30, 3, 30, 415, 8, 30,
		1, 30, 3, 30, 418, 8, 30, 1, 30, 3, 30, 421, 8, 30, 1, 30, 1, 30, 1, 31,
		1, 31, 1, 31, 3, 31, 428, 8, 31, 1, 31, 5, 31, 431, 8, 31, 10, 31, 12,
		31, 434, 9, 31, 1, 32, 1, 32, 1, 33, 1, 33, 1, 33, 0, 1, 34, 34, 0, 2,
		4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40,
		42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 0, 3, 1, 0, 42, 47,
		3, 0, 14, 30, 35, 40, 49, 49, 1, 0, 52, 53, 477, 0, 71, 1, 0, 0, 0, 2,
		86, 1, 0, 0, 0, 4, 88, 1, 0, 0, 0, 6, 96, 1, 0, 0, 0, 8, 112, 1, 0, 0,
		0, 10, 121, 1, 0, 0, 0, 12, 139, 1, 0, 0, 0, 14, 145, 1, 0, 0, 0, 16, 157,
		1, 0, 0, 0, 18, 169, 1, 0, 0, 0, 20, 189, 1, 0, 0, 0, 22, 206, 1, 0, 0,
		0, 24, 220, 1, 0, 0, 0, 26, 224, 1, 0, 0, 0, 28, 248, 1, 0, 0, 0, 30, 256,
		1, 0, 0, 0, 32, 271, 1, 0, 0, 0, 34, 273, 1, 0, 0, 0, 36, 311, 1, 0, 0,
		0, 38, 316, 1, 0, 0, 0, 40, 327, 1, 0, 0, 0, 42, 329, 1, 0, 0, 0, 44, 339,
		1, 0, 0, 0, 46, 346, 1, 0, 0, 0, 48, 348, 1, 0, 0, 0, 50, 371, 1, 0, 0,
		0, 52, 376, 1, 0, 0, 0, 54, 391, 1, 0, 0, 0, 56, 400, 1, 0, 0, 0, 58, 409,
		1, 0, 0, 0, 60, 411, 1, 0, 0, 0, 62, 424, 1, 0, 0, 0, 64, 435, 1, 0, 0,
		0, 66, 437, 1, 0, 0, 0, 68, 70, 3, 2, 1, 0, 69, 68, 1, 0, 0, 0, 70, 73,
		1, 0, 0, 0, 71, 69, 1, 0, 0, 0, 71, 72, 1, 0, 0, 0, 72, 74, 1, 0, 0, 0,
		73, 71, 1, 0, 0, 0, 74, 75, 5, 0, 0, 1, 75, 1, 1, 0, 0, 0, 76, 87, 3, 4,
		2, 0, 77, 87, 3, 6, 3, 0, 78, 87, 3, 8, 4, 0, 79, 87, 3, 10, 5, 0, 80,
		87, 3, 14, 7, 0, 81, 87, 3, 16, 8, 0, 82, 87, 3, 18, 9, 0, 83, 87, 3, 20,
		10, 0, 84, 87, 3, 22, 11, 0, 85, 87, 5, 51, 0, 0, 86, 76, 1, 0, 0, 0, 86,
		77, 1, 0, 0, 0, 86, 78, 1, 0, 0, 0, 86, 79, 1, 0, 0, 0, 86, 80, 1, 0, 0,
		0, 86, 81, 1, 0, 0, 0, 86, 82, 1, 0, 0, 0, 86, 83, 1, 0, 0, 0, 86, 84,
		1, 0, 0, 0, 86, 85, 1, 0, 0, 0, 87, 3, 1, 0, 0, 0, 88, 89, 5, 23, 0, 0,
		89, 90, 5, 11, 0, 0, 90, 91, 3, 34, 17, 0, 91, 92, 5, 51, 0, 0, 92, 5,
		1, 0, 0, 0, 93, 95, 3, 56, 28, 0, 94, 93, 1, 0, 0, 0, 95, 98, 1, 0, 0,
		0, 96, 94, 1, 0, 0, 0, 96, 97, 1, 0, 0, 0, 97, 99, 1, 0, 0, 0, 98, 96,
		1, 0, 0, 0, 99, 100, 5, 24, 0, 0, 100, 107, 3, 32, 16, 0, 101, 102, 5,
		25, 0, 0, 102, 106, 3, 48, 24, 0, 103, 104, 5, 26, 0, 0, 104, 106, 3, 64,
		32, 0, 105, 101, 1, 0, 0, 0, 105, 103, 1, 0, 0, 0, 106, 109, 1, 0, 0, 0,
		107, 105, 1, 0, 0, 0, 107, 108, 1, 0, 0, 0, 108, 110, 1, 0, 0, 0, 109,
		107, 1, 0, 0, 0, 110, 111, 5, 51, 0, 0, 111, 7, 1, 0, 0, 0, 112, 113, 5,
		27, 0, 0, 113, 114, 3, 64, 32, 0, 114, 115, 5, 11, 0, 0, 115, 116, 3, 34,
		17, 0, 116, 117, 5, 51, 0, 0, 117, 9, 1, 0, 0, 0, 118, 120, 3, 56, 28,
		0, 119, 118, 1, 0, 0, 0, 120, 123, 1, 0, 0, 0, 121, 119, 1, 0, 0, 0, 121,
		122, 1, 0, 0, 0, 122, 124, 1, 0, 0, 0, 123, 121, 1, 0, 0, 0, 124, 125,
		5, 14, 0, 0, 125, 135, 3, 64, 32, 0, 126, 128, 3, 44, 22, 0, 127, 129,
		3, 12, 6, 0, 128, 127, 1, 0, 0, 0, 128, 129, 1, 0, 0, 0, 129, 136, 1, 0,
		0, 0, 130, 131, 5, 21, 0, 0, 131, 133, 3, 32, 16, 0, 132, 134, 3, 12, 6,
		0, 133, 132, 1, 0, 0, 0, 133, 134, 1, 0, 0, 0, 134, 136, 1, 0, 0, 0, 135,
		126, 1, 0, 0, 0, 135, 130, 1, 0, 0, 0, 136, 137, 1, 0, 0, 0, 137, 138,
		5, 51, 0, 0, 138, 11, 1, 0, 0, 0, 139, 140, 5, 11, 0, 0, 140, 141, 3, 34,
		17, 0, 141, 13, 1, 0, 0, 0, 142, 144, 3, 56, 28, 0, 143, 142, 1, 0, 0,
		0, 144, 147, 1, 0, 0, 0, 145, 143, 1, 0, 0, 0, 145, 146, 1, 0, 0, 0, 146,
		148, 1, 0, 0, 0, 147, 145, 1, 0, 0, 0, 148, 149, 5, 29, 0, 0, 149, 150,
		3, 64, 32, 0, 150, 151, 5, 11, 0, 0, 151, 152, 3, 44, 22, 0, 152, 153,
		5, 51, 0, 0, 153, 15, 1, 0, 0, 0, 154, 156, 3, 56, 28, 0, 155, 154, 1,
		0, 0, 0, 156, 159, 1, 0, 0, 0, 157, 155, 1, 0, 0, 0, 157, 158, 1, 0, 0,
		0, 158, 160, 1, 0, 0, 0, 159, 157, 1, 0, 0, 0, 160, 161, 5, 15, 0, 0, 161,
		162, 3, 64, 32, 0, 162, 163, 5, 11, 0, 0, 163, 164, 3, 34, 17, 0, 164,
		165, 5, 51, 0, 0, 165, 17, 1, 0, 0, 0, 166, 168, 3, 56, 28, 0, 167, 166,
		1, 0, 0, 0, 168, 171, 1, 0, 0, 0, 169, 167, 1, 0, 0, 0, 169, 170, 1, 0,
		0, 0, 170, 172, 1, 0, 0, 0, 171, 169, 1, 0, 0, 0, 172, 173, 5, 21, 0, 0,
		173, 174, 3, 64, 32, 0, 174, 176, 3, 32, 16, 0, 175, 177, 5, 28, 0, 0,
		176, 175, 1, 0, 0, 0, 176, 177, 1, 0, 0, 0, 177, 178, 1, 0, 0, 0, 178,
		182, 5, 11, 0, 0, 179, 183, 3, 24, 12, 0, 180, 183, 3, 48, 24, 0, 181,
		183, 3, 26, 13, 0, 182, 179, 1, 0, 0, 0, 182, 180, 1, 0, 0, 0, 182, 181,
		1, 0, 0, 0, 183, 184, 1, 0, 0, 0, 184, 185, 5, 51, 0, 0, 185, 19, 1, 0,
		0, 0, 186, 188, 3, 56, 28, 0, 187, 186, 1, 0, 0, 0, 188, 191, 1, 0, 0,
		0, 189, 187, 1, 0, 0, 0, 189, 190, 1, 0, 0, 0, 190, 192, 1, 0, 0, 0, 191,
		189, 1, 0, 0, 0, 192, 193, 5, 30, 0, 0, 193, 194, 3, 64, 32, 0, 194, 195,
		3, 32, 16, 0, 195, 199, 5, 11, 0, 0, 196, 200, 3, 24, 12, 0, 197, 200,
		3, 48, 24, 0, 198, 200, 3, 26, 13, 0, 199, 196, 1, 0, 0, 0, 199, 197, 1,
		0, 0, 0, 199, 198, 1, 0, 0, 0, 200, 201, 1, 0, 0, 0, 201, 202, 5, 51, 0,
		0, 202, 21, 1, 0, 0, 0, 203, 205, 3, 56, 28, 0, 204, 203, 1, 0, 0, 0, 205,
		208, 1, 0, 0, 0, 206, 204, 1, 0, 0, 0, 206, 207, 1, 0, 0, 0, 207, 209,
		1, 0, 0, 0, 208, 206, 1, 0, 0, 0, 209, 210, 5, 22, 0, 0, 210, 214, 3, 64,
		32, 0, 211, 215, 3, 64, 32, 0, 212, 213, 5, 21, 0, 0, 213, 215, 3, 32,
		16, 0, 214, 211, 1, 0, 0, 0, 214, 212, 1, 0, 0, 0, 215, 216, 1, 0, 0, 0,
		216, 217, 5, 11, 0, 0, 217, 218, 3, 34, 17, 0, 218, 219, 5, 51, 0, 0, 219,
		23, 1, 0, 0, 0, 220, 221, 5, 38, 0, 0, 221, 222, 3, 42, 21, 0, 222, 223,
		3, 48, 24, 0, 223, 25, 1, 0, 0, 0, 224, 228, 5, 4, 0, 0, 225, 227, 5, 51,
		0, 0, 226, 225, 1, 0, 0, 0, 227, 230, 1, 0, 0, 0, 228, 226, 1, 0, 0, 0,
		228, 229, 1, 0, 0, 0, 229, 231, 1, 0, 0, 0, 230, 228, 1, 0, 0, 0, 231,
		234, 5, 39, 0, 0, 232, 235, 3, 64, 32, 0, 233, 235, 3, 28, 14, 0, 234,
		232, 1, 0, 0, 0, 234, 233, 1, 0, 0, 0, 235, 236, 1, 0, 0, 0, 236, 237,
		5, 40, 0, 0, 237, 238, 3, 34, 17, 0, 238, 239, 5, 10, 0, 0, 239, 243, 3,
		30, 15, 0, 240, 242, 5, 51, 0, 0, 241, 240, 1, 0, 0, 0, 242, 245, 1, 0,
		0, 0, 243, 241, 1, 0, 0, 0, 243, 244, 1, 0, 0, 0, 244, 246, 1, 0, 0, 0,
		245, 243, 1, 0, 0, 0, 246, 247, 5, 5, 0, 0, 247, 27, 1, 0, 0, 0, 248, 249,
		5, 6, 0, 0, 249, 250, 3, 64, 32, 0, 250, 251, 5, 3, 0, 0, 251, 252, 3,
		64, 32, 0, 252, 253, 5, 7, 0, 0, 253, 29, 1, 0, 0, 0, 254, 257, 3, 34,
		17, 0, 255, 257, 3, 24, 12, 0, 256, 254, 1, 0, 0, 0, 256, 255, 1, 0, 0,
		0, 257, 31, 1, 0, 0, 0, 258, 264, 5, 31, 0, 0, 259, 260, 3, 34, 17, 0,
		260, 261, 5, 32, 0, 0, 261, 263, 1, 0, 0, 0, 262, 259, 1, 0, 0, 0, 263,
		266, 1, 0, 0, 0, 264, 262, 1, 0, 0, 0, 264, 265, 1, 0, 0, 0, 265, 267,
		1, 0, 0, 0, 266, 264, 1, 0, 0, 0, 267, 268, 3, 34, 17, 0, 268, 269, 5,
		33, 0, 0, 269, 272, 1, 0, 0, 0, 270, 272, 5, 34, 0, 0, 271, 258, 1, 0,
		0, 0, 271, 270, 1, 0, 0, 0, 272, 33, 1, 0, 0, 0, 273, 274, 6, 17, -1, 0,
		274, 275, 3, 40, 20, 0, 275, 302, 1, 0, 0, 0, 276, 277, 10, 6, 0, 0, 277,
		278, 5, 41, 0, 0, 278, 279, 3, 34, 17, 0, 279, 280, 5, 10, 0, 0, 280, 281,
		3, 34, 17, 7, 281, 301, 1, 0, 0, 0, 282, 283, 10, 2, 0, 0, 283, 284, 3,
		38, 19, 0, 284, 285, 3, 34, 17, 3, 285, 301, 1, 0, 0, 0, 286, 287, 10,
		7, 0, 0, 287, 288, 5, 4, 0, 0, 288, 289, 3, 34, 17, 0, 289, 290, 5, 5,
		0, 0, 290, 301, 1, 0, 0, 0, 291, 292, 10, 5, 0, 0, 292, 293, 5, 8, 0, 0,
		293, 301, 3, 64, 32, 0, 294, 295, 10, 4, 0, 0, 295, 296, 5, 8, 0, 0, 296,
		301, 3, 60, 30, 0, 297, 298, 10, 3, 0, 0, 298, 299, 5, 10, 0, 0, 299, 301,
		3, 64, 32, 0, 300, 276, 1, 0, 0, 0, 300, 282, 1, 0, 0, 0, 300, 286, 1,
		0, 0, 0, 300, 291, 1, 0, 0, 0, 300, 294, 1, 0, 0, 0, 300, 297, 1, 0, 0,
		0, 301, 304, 1, 0, 0, 0, 302, 300, 1, 0, 0, 0, 302, 303, 1, 0, 0, 0, 303,
		35, 1, 0, 0, 0, 304, 302, 1, 0, 0, 0, 305, 307, 5, 6, 0, 0, 306, 308, 3,
		62, 31, 0, 307, 306, 1, 0, 0, 0, 307, 308, 1, 0, 0, 0, 308, 309, 1, 0,
		0, 0, 309, 312, 5, 7, 0, 0, 310, 312, 3, 64, 32, 0, 311, 305, 1, 0, 0,
		0, 311, 310, 1, 0, 0, 0, 312, 313, 1, 0, 0, 0, 313, 314, 5, 48, 0, 0, 314,
		315, 3, 34, 17, 0, 315, 37, 1, 0, 0, 0, 316, 317, 7, 0, 0, 0, 317, 39,
		1, 0, 0, 0, 318, 328, 3, 46, 23, 0, 319, 328, 3, 60, 30, 0, 320, 328, 3,
		32, 16, 0, 321, 328, 5, 1, 0, 0, 322, 328, 3, 52, 26, 0, 323, 328, 3, 48,
		24, 0, 324, 328, 3, 26, 13, 0, 325, 328, 3, 42, 21, 0, 326, 328, 3, 36,
		18, 0, 327, 318, 1, 0, 0, 0, 327, 319, 1, 0, 0, 0, 327, 320, 1, 0, 0, 0,
		327, 321, 1, 0, 0, 0, 327, 322, 1, 0, 0, 0, 327, 323, 1, 0, 0, 0, 327,
		324, 1, 0, 0, 0, 327, 325, 1, 0, 0, 0, 327, 326, 1, 0, 0, 0, 328, 41, 1,
		0, 0, 0, 329, 331, 5, 6, 0, 0, 330, 332, 5, 51, 0, 0, 331, 330, 1, 0, 0,
		0, 331, 332, 1, 0, 0, 0, 332, 333, 1, 0, 0, 0, 333, 335, 3, 34, 17, 0,
		334, 336, 5, 51, 0, 0, 335, 334, 1, 0, 0, 0, 335, 336, 1, 0, 0, 0, 336,
		337, 1, 0, 0, 0, 337, 338, 5, 7, 0, 0, 338, 43, 1, 0, 0, 0, 339, 340, 3,
		64, 32, 0, 340, 45, 1, 0, 0, 0, 341, 347, 5, 50, 0, 0, 342, 347, 5, 16,
		0, 0, 343, 347, 5, 17, 0, 0, 344, 347, 5, 18, 0, 0, 345, 347, 3, 64, 32,
		0, 346, 341, 1, 0, 0, 0, 346, 342, 1, 0, 0, 0, 346, 343, 1, 0, 0, 0, 346,
		344, 1, 0, 0, 0, 346, 345, 1, 0, 0, 0, 347, 47, 1, 0, 0, 0, 348, 365, 5,
		12, 0, 0, 349, 351, 5, 51, 0, 0, 350, 349, 1, 0, 0, 0, 351, 352, 1, 0,
		0, 0, 352, 350, 1, 0, 0, 0, 352, 353, 1, 0, 0, 0, 353, 362, 1, 0, 0, 0,
		354, 356, 3, 50, 25, 0, 355, 357, 5, 51, 0, 0, 356, 355, 1, 0, 0, 0, 357,
		358, 1, 0, 0, 0, 358, 356, 1, 0, 0, 0, 358, 359, 1, 0, 0, 0, 359, 361,
		1, 0, 0, 0, 360, 354, 1, 0, 0, 0, 361, 364, 1, 0, 0, 0, 362, 360, 1, 0,
		0, 0, 362, 363, 1, 0, 0, 0, 363, 366, 1, 0, 0, 0, 364, 362, 1, 0, 0, 0,
		365, 350, 1, 0, 0, 0, 365, 366, 1, 0, 0, 0, 366, 367, 1, 0, 0, 0, 367,
		368, 5, 13, 0, 0, 368, 49, 1, 0, 0, 0, 369, 372, 3, 64, 32, 0, 370, 372,
		3, 32, 16, 0, 371, 369, 1, 0, 0, 0, 371, 370, 1, 0, 0, 0, 372, 373, 1,
		0, 0, 0, 373, 374, 5, 10, 0, 0, 374, 375, 3, 34, 17, 0, 375, 51, 1, 0,
		0, 0, 376, 380, 5, 4, 0, 0, 377, 379, 5, 51, 0, 0, 378, 377, 1, 0, 0, 0,
		379, 382, 1, 0, 0, 0, 380, 378, 1, 0, 0, 0, 380, 381, 1, 0, 0, 0, 381,
		386, 1, 0, 0, 0, 382, 380, 1, 0, 0, 0, 383, 385, 3, 54, 27, 0, 384, 383,
		1, 0, 0, 0, 385, 388, 1, 0, 0, 0, 386, 384, 1, 0, 0, 0, 386, 387, 1, 0,
		0, 0, 387, 389, 1, 0, 0, 0, 388, 386, 1, 0, 0, 0, 389, 390, 5, 5, 0, 0,
		390, 53, 1, 0, 0, 0, 391, 398, 3, 34, 17, 0, 392, 394, 5, 51, 0, 0, 393,
		392, 1, 0, 0, 0, 394, 395, 1, 0, 0, 0, 395, 393, 1, 0, 0, 0, 395, 396,
		1, 0, 0, 0, 396, 399, 1, 0, 0, 0, 397, 399, 5, 3, 0, 0, 398, 393, 1, 0,
		0, 0, 398, 397, 1, 0, 0, 0, 398, 399, 1, 0, 0, 0, 399, 55, 1, 0, 0, 0,
		400, 401, 5, 2, 0, 0, 401, 402, 3, 58, 29, 0, 402, 403, 5, 51, 0, 0, 403,
		57, 1, 0, 0, 0, 404, 410, 3, 60, 30, 0, 405, 406, 3, 34, 17, 0, 406, 407,
		5, 8, 0, 0, 407, 408, 3, 60, 30, 0, 408, 410, 1, 0, 0, 0, 409, 404, 1,
		0, 0, 0, 409, 405, 1, 0, 0, 0, 410, 59, 1, 0, 0, 0, 411, 412, 3, 64, 32,
		0, 412, 417, 5, 6, 0, 0, 413, 415, 5, 51, 0, 0, 414, 413, 1, 0, 0, 0, 414,
		415, 1, 0, 0, 0, 415, 416, 1, 0, 0, 0, 416, 418, 3, 62, 31, 0, 417, 414,
		1, 0, 0, 0, 417, 418, 1, 0, 0, 0, 418, 420, 1, 0, 0, 0, 419, 421, 5, 51,
		0, 0, 420, 419, 1, 0, 0, 0, 420, 421, 1, 0, 0, 0, 421, 422, 1, 0, 0, 0,
		422, 423, 5, 7, 0, 0, 423, 61, 1, 0, 0, 0, 424, 432, 3, 34, 17, 0, 425,
		427, 5, 3, 0, 0, 426, 428, 5, 51, 0, 0, 427, 426, 1, 0, 0, 0, 427, 428,
		1, 0, 0, 0, 428, 429, 1, 0, 0, 0, 429, 431, 3, 34, 17, 0, 430, 425, 1,
		0, 0, 0, 431, 434, 1, 0, 0, 0, 432, 430, 1, 0, 0, 0, 432, 433, 1, 0, 0,
		0, 433, 63, 1, 0, 0, 0, 434, 432, 1, 0, 0, 0, 435, 436, 7, 1, 0, 0, 436,
		65, 1, 0, 0, 0, 437, 438, 7, 2, 0, 0, 438, 67, 1, 0, 0, 0, 47, 71, 86,
		96, 105, 107, 121, 128, 133, 135, 145, 157, 169, 176, 182, 189, 199, 206,
		214, 228, 234, 243, 256, 264, 271, 300, 302, 307, 311, 327, 331, 335, 346,
		352, 358, 362, 365, 371, 380, 386, 395, 398, 409, 414, 417, 420, 427, 432,
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
	bicepParserARROW               = 48
	bicepParserIDENTIFIER          = 49
	bicepParserNUMBER              = 50
	bicepParserNL                  = 51
	bicepParserSINGLE_LINE_COMMENT = 52
	bicepParserMULTI_LINE_COMMENT  = 53
	bicepParserSPACES              = 54
	bicepParserUNKNOWN             = 55
)

// bicepParser rules.
const (
	bicepParserRULE_program                 = 0
	bicepParserRULE_statement               = 1
	bicepParserRULE_targetScopeDecl         = 2
	bicepParserRULE_importDecl              = 3
	bicepParserRULE_metadataDecl            = 4
	bicepParserRULE_parameterDecl           = 5
	bicepParserRULE_parameterDefaultValue   = 6
	bicepParserRULE_typeDecl                = 7
	bicepParserRULE_variableDecl            = 8
	bicepParserRULE_resourceDecl            = 9
	bicepParserRULE_moduleDecl              = 10
	bicepParserRULE_outputDecl              = 11
	bicepParserRULE_ifCondition             = 12
	bicepParserRULE_forExpression           = 13
	bicepParserRULE_forVariableBlock        = 14
	bicepParserRULE_forBody                 = 15
	bicepParserRULE_interpString            = 16
	bicepParserRULE_expression              = 17
	bicepParserRULE_lambdaExpression        = 18
	bicepParserRULE_logicCharacter          = 19
	bicepParserRULE_primaryExpression       = 20
	bicepParserRULE_parenthesizedExpression = 21
	bicepParserRULE_typeExpression          = 22
	bicepParserRULE_literalValue            = 23
	bicepParserRULE_object                  = 24
	bicepParserRULE_objectProperty          = 25
	bicepParserRULE_array                   = 26
	bicepParserRULE_arrayItem               = 27
	bicepParserRULE_decorator               = 28
	bicepParserRULE_decoratorExpression     = 29
	bicepParserRULE_functionCall            = 30
	bicepParserRULE_argumentList            = 31
	bicepParserRULE_identifier              = 32
	bicepParserRULE_comment                 = 33
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
	p.SetState(71)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&2251801590022148) != 0 {
		{
			p.SetState(68)
			p.Statement()
		}

		p.SetState(73)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(74)
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
	TargetScopeDecl() ITargetScopeDeclContext
	ImportDecl() IImportDeclContext
	MetadataDecl() IMetadataDeclContext
	ParameterDecl() IParameterDeclContext
	TypeDecl() ITypeDeclContext
	VariableDecl() IVariableDeclContext
	ResourceDecl() IResourceDeclContext
	ModuleDecl() IModuleDeclContext
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
	p.SetState(86)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(76)
			p.TargetScopeDecl()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(77)
			p.ImportDecl()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(78)
			p.MetadataDecl()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(79)
			p.ParameterDecl()
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(80)
			p.TypeDecl()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(81)
			p.VariableDecl()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(82)
			p.ResourceDecl()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(83)
			p.ModuleDecl()
		}

	case 9:
		p.EnterOuterAlt(localctx, 9)
		{
			p.SetState(84)
			p.OutputDecl()
		}

	case 10:
		p.EnterOuterAlt(localctx, 10)
		{
			p.SetState(85)
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
	p.EnterRule(localctx, 4, bicepParserRULE_targetScopeDecl)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(88)
		p.Match(bicepParserTARGET_SCOPE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(89)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(90)
		p.expression(0)
	}
	{
		p.SetState(91)
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
	p.EnterRule(localctx, 6, bicepParserRULE_importDecl)
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
		p.Match(bicepParserIMPORT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(100)

		var _x = p.InterpString()

		localctx.(*ImportDeclContext).specification = _x
	}
	p.SetState(107)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserWITH || _la == bicepParserAS {
		p.SetState(105)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}

		switch p.GetTokenStream().LA(1) {
		case bicepParserWITH:
			{
				p.SetState(101)
				p.Match(bicepParserWITH)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}
			{
				p.SetState(102)
				p.Object()
			}

		case bicepParserAS:
			{
				p.SetState(103)
				p.Match(bicepParserAS)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}
			{
				p.SetState(104)

				var _x = p.Identifier()

				localctx.(*ImportDeclContext).alias = _x
			}

		default:
			p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
			goto errorExit
		}

		p.SetState(109)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(110)
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
	p.EnterRule(localctx, 8, bicepParserRULE_metadataDecl)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(112)
		p.Match(bicepParserMETADATA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(113)

		var _x = p.Identifier()

		localctx.(*MetadataDeclContext).name = _x
	}
	{
		p.SetState(114)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(115)
		p.expression(0)
	}
	{
		p.SetState(116)
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
	p.EnterRule(localctx, 10, bicepParserRULE_parameterDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(121)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(118)
			p.Decorator()
		}

		p.SetState(123)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(124)
		p.Match(bicepParserPARAM)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(125)

		var _x = p.Identifier()

		localctx.(*ParameterDeclContext).name = _x
	}
	p.SetState(135)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 8, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(126)
			p.TypeExpression()
		}
		p.SetState(128)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(127)
				p.ParameterDefaultValue()
			}

		}

	case 2:
		{
			p.SetState(130)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(131)

			var _x = p.InterpString()

			localctx.(*ParameterDeclContext).type_ = _x
		}
		p.SetState(133)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserASSIGN {
			{
				p.SetState(132)
				p.ParameterDefaultValue()
			}

		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(137)
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
	p.EnterRule(localctx, 12, bicepParserRULE_parameterDefaultValue)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(139)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(140)
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
	p.EnterRule(localctx, 14, bicepParserRULE_typeDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(145)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(142)
			p.Decorator()
		}

		p.SetState(147)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(148)
		p.Match(bicepParserTYPE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(149)

		var _x = p.Identifier()

		localctx.(*TypeDeclContext).name = _x
	}
	{
		p.SetState(150)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(151)
		p.TypeExpression()
	}
	{
		p.SetState(152)
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
	p.EnterRule(localctx, 16, bicepParserRULE_variableDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(157)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(154)
			p.Decorator()
		}

		p.SetState(159)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(160)
		p.Match(bicepParserVAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(161)

		var _x = p.Identifier()

		localctx.(*VariableDeclContext).name = _x
	}
	{
		p.SetState(162)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(163)
		p.expression(0)
	}
	{
		p.SetState(164)
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
	p.EnterRule(localctx, 18, bicepParserRULE_resourceDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(169)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(166)
			p.Decorator()
		}

		p.SetState(171)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(172)
		p.Match(bicepParserRESOURCE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(173)

		var _x = p.Identifier()

		localctx.(*ResourceDeclContext).name = _x
	}
	{
		p.SetState(174)

		var _x = p.InterpString()

		localctx.(*ResourceDeclContext).type_ = _x
	}
	p.SetState(176)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserEXISTING {
		{
			p.SetState(175)
			p.Match(bicepParserEXISTING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(178)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(182)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(179)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(180)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(181)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(184)
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
	p.EnterRule(localctx, 20, bicepParserRULE_moduleDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(189)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(186)
			p.Decorator()
		}

		p.SetState(191)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(192)
		p.Match(bicepParserMODULE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(193)

		var _x = p.Identifier()

		localctx.(*ModuleDeclContext).name = _x
	}
	{
		p.SetState(194)

		var _x = p.InterpString()

		localctx.(*ModuleDeclContext).type_ = _x
	}
	{
		p.SetState(195)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(199)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserIF:
		{
			p.SetState(196)
			p.IfCondition()
		}

	case bicepParserOBRACE:
		{
			p.SetState(197)
			p.Object()
		}

	case bicepParserOBRACK:
		{
			p.SetState(198)
			p.ForExpression()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(201)
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
	p.EnterRule(localctx, 22, bicepParserRULE_outputDecl)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(206)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserAT {
		{
			p.SetState(203)
			p.Decorator()
		}

		p.SetState(208)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(209)
		p.Match(bicepParserOUTPUT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(210)

		var _x = p.Identifier()

		localctx.(*OutputDeclContext).name = _x
	}
	p.SetState(214)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 17, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(211)

			var _x = p.Identifier()

			localctx.(*OutputDeclContext).type1 = _x
		}

	case 2:
		{
			p.SetState(212)
			p.Match(bicepParserRESOURCE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(213)

			var _x = p.InterpString()

			localctx.(*OutputDeclContext).type2 = _x
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}
	{
		p.SetState(216)
		p.Match(bicepParserASSIGN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(217)
		p.expression(0)
	}
	{
		p.SetState(218)
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
		p.SetState(220)
		p.Match(bicepParserIF)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(221)
		p.ParenthesizedExpression()
	}
	{
		p.SetState(222)
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
		p.SetState(224)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(228)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(225)
			p.Match(bicepParserNL)
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
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(231)
		p.Match(bicepParserFOR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(234)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserTYPE, bicepParserMODULE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER:
		{
			p.SetState(232)

			var _x = p.Identifier()

			localctx.(*ForExpressionContext).item = _x
		}

	case bicepParserOPAR:
		{
			p.SetState(233)
			p.ForVariableBlock()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(236)
		p.Match(bicepParserIN)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(237)
		p.expression(0)
	}
	{
		p.SetState(238)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(239)
		p.ForBody()
	}
	p.SetState(243)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(240)
			p.Match(bicepParserNL)
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
	}
	{
		p.SetState(246)
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
		p.SetState(248)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(249)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).item = _x
	}
	{
		p.SetState(250)
		p.Match(bicepParserCOMMA)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(251)

		var _x = p.Identifier()

		localctx.(*ForVariableBlockContext).index = _x
	}
	{
		p.SetState(252)
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
	p.SetState(256)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 21, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(254)

			var _x = p.expression(0)

			localctx.(*ForBodyContext).body = _x
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(255)
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

	p.SetState(271)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserSTRING_LEFT_PIECE:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(258)
			p.Match(bicepParserSTRING_LEFT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(264)
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
					p.SetState(259)
					p.expression(0)
				}
				{
					p.SetState(260)
					p.Match(bicepParserSTRING_MIDDLE_PIECE)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			}
			p.SetState(266)
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
			p.SetState(267)
			p.expression(0)
		}
		{
			p.SetState(268)
			p.Match(bicepParserSTRING_RIGHT_PIECE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserSTRING_COMPLETE:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(270)
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
		p.SetState(274)
		p.PrimaryExpression()
	}

	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(302)
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
			p.SetState(300)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 24, p.GetParserRuleContext()) {
			case 1:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(276)

				if !(p.Precpred(p.GetParserRuleContext(), 6)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 6)", ""))
					goto errorExit
				}
				{
					p.SetState(277)
					p.Match(bicepParserQMARK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(278)
					p.expression(0)
				}
				{
					p.SetState(279)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(280)
					p.expression(7)
				}

			case 2:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(282)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(283)
					p.LogicCharacter()
				}
				{
					p.SetState(284)
					p.expression(3)
				}

			case 3:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(286)

				if !(p.Precpred(p.GetParserRuleContext(), 7)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 7)", ""))
					goto errorExit
				}
				{
					p.SetState(287)
					p.Match(bicepParserOBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(288)
					p.expression(0)
				}
				{
					p.SetState(289)
					p.Match(bicepParserCBRACK)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			case 4:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(291)

				if !(p.Precpred(p.GetParserRuleContext(), 5)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 5)", ""))
					goto errorExit
				}
				{
					p.SetState(292)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(293)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).property = _x
				}

			case 5:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(294)

				if !(p.Precpred(p.GetParserRuleContext(), 4)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 4)", ""))
					goto errorExit
				}
				{
					p.SetState(295)
					p.Match(bicepParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(296)
					p.FunctionCall()
				}

			case 6:
				localctx = NewExpressionContext(p, _parentctx, _parentState)
				p.PushNewRecursionContext(localctx, _startState, bicepParserRULE_expression)
				p.SetState(297)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(298)
					p.Match(bicepParserCOL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(299)

					var _x = p.Identifier()

					localctx.(*ExpressionContext).name = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(304)
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

// ILambdaExpressionContext is an interface to support dynamic dispatch.
type ILambdaExpressionContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	ARROW() antlr.TerminalNode
	Expression() IExpressionContext
	OPAR() antlr.TerminalNode
	CPAR() antlr.TerminalNode
	Identifier() IIdentifierContext
	ArgumentList() IArgumentListContext

	// IsLambdaExpressionContext differentiates from other interfaces.
	IsLambdaExpressionContext()
}

type LambdaExpressionContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyLambdaExpressionContext() *LambdaExpressionContext {
	var p = new(LambdaExpressionContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_lambdaExpression
	return p
}

func InitEmptyLambdaExpressionContext(p *LambdaExpressionContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_lambdaExpression
}

func (*LambdaExpressionContext) IsLambdaExpressionContext() {}

func NewLambdaExpressionContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *LambdaExpressionContext {
	var p = new(LambdaExpressionContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_lambdaExpression

	return p
}

func (s *LambdaExpressionContext) GetParser() antlr.Parser { return s.parser }

func (s *LambdaExpressionContext) ARROW() antlr.TerminalNode {
	return s.GetToken(bicepParserARROW, 0)
}

func (s *LambdaExpressionContext) Expression() IExpressionContext {
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

func (s *LambdaExpressionContext) OPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserOPAR, 0)
}

func (s *LambdaExpressionContext) CPAR() antlr.TerminalNode {
	return s.GetToken(bicepParserCPAR, 0)
}

func (s *LambdaExpressionContext) Identifier() IIdentifierContext {
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

func (s *LambdaExpressionContext) ArgumentList() IArgumentListContext {
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

func (s *LambdaExpressionContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *LambdaExpressionContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *LambdaExpressionContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitLambdaExpression(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) LambdaExpression() (localctx ILambdaExpressionContext) {
	localctx = NewLambdaExpressionContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 36, bicepParserRULE_lambdaExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(311)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserOPAR:
		{
			p.SetState(305)
			p.Match(bicepParserOPAR)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(307)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1691035998605394) != 0 {
			{
				p.SetState(306)
				p.ArgumentList()
			}

		}
		{
			p.SetState(309)
			p.Match(bicepParserCPAR)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserTYPE, bicepParserMODULE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER:
		{
			p.SetState(310)
			p.Identifier()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(313)
		p.Match(bicepParserARROW)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(314)
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
	p.EnterRule(localctx, 38, bicepParserRULE_logicCharacter)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(316)
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
	LambdaExpression() ILambdaExpressionContext

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

func (s *PrimaryExpressionContext) LambdaExpression() ILambdaExpressionContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ILambdaExpressionContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ILambdaExpressionContext)
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
	p.EnterRule(localctx, 40, bicepParserRULE_primaryExpression)
	p.SetState(327)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 28, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(318)
			p.LiteralValue()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(319)
			p.FunctionCall()
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(320)
			p.InterpString()
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(321)
			p.Match(bicepParserMULTILINE_STRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(322)
			p.Array()
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(323)
			p.Object()
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(324)
			p.ForExpression()
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(325)
			p.ParenthesizedExpression()
		}

	case 9:
		p.EnterOuterAlt(localctx, 9)
		{
			p.SetState(326)
			p.LambdaExpression()
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
	p.EnterRule(localctx, 42, bicepParserRULE_parenthesizedExpression)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(329)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(331)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(330)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(333)
		p.expression(0)
	}
	p.SetState(335)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(334)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(337)
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
	p.EnterRule(localctx, 44, bicepParserRULE_typeExpression)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(339)

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
	p.EnterRule(localctx, 46, bicepParserRULE_literalValue)
	p.SetState(346)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 31, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(341)
			p.Match(bicepParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(342)
			p.Match(bicepParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(343)
			p.Match(bicepParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(344)
			p.Match(bicepParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(345)
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
	p.EnterRule(localctx, 48, bicepParserRULE_object)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(348)
		p.Match(bicepParserOBRACE)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(365)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		p.SetState(350)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(349)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(352)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}
		p.SetState(362)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&565136091758592) != 0 {
			{
				p.SetState(354)
				p.ObjectProperty()
			}
			p.SetState(356)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)

			for ok := true; ok; ok = _la == bicepParserNL {
				{
					p.SetState(355)
					p.Match(bicepParserNL)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

				p.SetState(358)
				p.GetErrorHandler().Sync(p)
				if p.HasError() {
					goto errorExit
				}
				_la = p.GetTokenStream().LA(1)
			}

			p.SetState(364)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	}
	{
		p.SetState(367)
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
	p.EnterRule(localctx, 50, bicepParserRULE_objectProperty)
	p.EnterOuterAlt(localctx, 1)
	p.SetState(371)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserTYPE, bicepParserMODULE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER:
		{
			p.SetState(369)

			var _x = p.Identifier()

			localctx.(*ObjectPropertyContext).name = _x
		}

	case bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE:
		{
			p.SetState(370)
			p.InterpString()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	{
		p.SetState(373)
		p.Match(bicepParserCOL)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(374)
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
	p.EnterRule(localctx, 52, bicepParserRULE_array)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(376)
		p.Match(bicepParserOBRACK)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(380)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserNL {
		{
			p.SetState(377)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

		p.SetState(382)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	p.SetState(386)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for (int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1691035998605394) != 0 {
		{
			p.SetState(383)
			p.ArrayItem()
		}

		p.SetState(388)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)
	}
	{
		p.SetState(389)
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
	p.EnterRule(localctx, 54, bicepParserRULE_arrayItem)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(391)
		p.expression(0)
	}
	p.SetState(398)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	switch p.GetTokenStream().LA(1) {
	case bicepParserNL:
		p.SetState(393)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		for ok := true; ok; ok = _la == bicepParserNL {
			{
				p.SetState(392)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

			p.SetState(395)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}
			_la = p.GetTokenStream().LA(1)
		}

	case bicepParserCOMMA:
		{
			p.SetState(397)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case bicepParserMULTILINE_STRING, bicepParserOBRACK, bicepParserCBRACK, bicepParserOPAR, bicepParserOBRACE, bicepParserPARAM, bicepParserVAR, bicepParserTRUE, bicepParserFALSE, bicepParserNULL, bicepParserARRAY, bicepParserOBJECT, bicepParserRESOURCE, bicepParserOUTPUT, bicepParserTARGET_SCOPE, bicepParserIMPORT, bicepParserWITH, bicepParserAS, bicepParserMETADATA, bicepParserEXISTING, bicepParserTYPE, bicepParserMODULE, bicepParserSTRING_LEFT_PIECE, bicepParserSTRING_COMPLETE, bicepParserSTRING, bicepParserINT, bicepParserBOOL, bicepParserIF, bicepParserFOR, bicepParserIN, bicepParserIDENTIFIER, bicepParserNUMBER:

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
	p.EnterRule(localctx, 56, bicepParserRULE_decorator)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(400)
		p.Match(bicepParserAT)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(401)
		p.DecoratorExpression()
	}
	{
		p.SetState(402)
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
	p.EnterRule(localctx, 58, bicepParserRULE_decoratorExpression)
	p.SetState(409)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 41, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(404)
			p.FunctionCall()
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(405)
			p.expression(0)
		}
		{
			p.SetState(406)
			p.Match(bicepParserDOT)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(407)
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
	p.EnterRule(localctx, 60, bicepParserRULE_functionCall)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(411)
		p.Identifier()
	}
	{
		p.SetState(412)
		p.Match(bicepParserOPAR)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	p.SetState(417)
	p.GetErrorHandler().Sync(p)

	if p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 43, p.GetParserRuleContext()) == 1 {
		p.SetState(414)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(413)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(416)
			p.ArgumentList()
		}

	} else if p.HasError() { // JIM
		goto errorExit
	}
	p.SetState(420)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	if _la == bicepParserNL {
		{
			p.SetState(419)
			p.Match(bicepParserNL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	}
	{
		p.SetState(422)
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
	p.EnterRule(localctx, 62, bicepParserRULE_argumentList)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(424)
		p.expression(0)
	}
	p.SetState(432)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_la = p.GetTokenStream().LA(1)

	for _la == bicepParserCOMMA {
		{
			p.SetState(425)
			p.Match(bicepParserCOMMA)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(427)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_la = p.GetTokenStream().LA(1)

		if _la == bicepParserNL {
			{
				p.SetState(426)
				p.Match(bicepParserNL)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}

		}
		{
			p.SetState(429)
			p.expression(0)
		}

		p.SetState(434)
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
	MODULE() antlr.TerminalNode
	OUTPUT() antlr.TerminalNode
	EXISTING() antlr.TerminalNode
	TYPE() antlr.TerminalNode
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

func (s *IdentifierContext) MODULE() antlr.TerminalNode {
	return s.GetToken(bicepParserMODULE, 0)
}

func (s *IdentifierContext) OUTPUT() antlr.TerminalNode {
	return s.GetToken(bicepParserOUTPUT, 0)
}

func (s *IdentifierContext) EXISTING() antlr.TerminalNode {
	return s.GetToken(bicepParserEXISTING, 0)
}

func (s *IdentifierContext) TYPE() antlr.TerminalNode {
	return s.GetToken(bicepParserTYPE, 0)
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
	p.EnterRule(localctx, 64, bicepParserRULE_identifier)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(435)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&565116764405760) != 0) {
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

// ICommentContext is an interface to support dynamic dispatch.
type ICommentContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	SINGLE_LINE_COMMENT() antlr.TerminalNode
	MULTI_LINE_COMMENT() antlr.TerminalNode

	// IsCommentContext differentiates from other interfaces.
	IsCommentContext()
}

type CommentContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyCommentContext() *CommentContext {
	var p = new(CommentContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_comment
	return p
}

func InitEmptyCommentContext(p *CommentContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = bicepParserRULE_comment
}

func (*CommentContext) IsCommentContext() {}

func NewCommentContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *CommentContext {
	var p = new(CommentContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = bicepParserRULE_comment

	return p
}

func (s *CommentContext) GetParser() antlr.Parser { return s.parser }

func (s *CommentContext) SINGLE_LINE_COMMENT() antlr.TerminalNode {
	return s.GetToken(bicepParserSINGLE_LINE_COMMENT, 0)
}

func (s *CommentContext) MULTI_LINE_COMMENT() antlr.TerminalNode {
	return s.GetToken(bicepParserMULTI_LINE_COMMENT, 0)
}

func (s *CommentContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *CommentContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *CommentContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case bicepVisitor:
		return t.VisitComment(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *bicepParser) Comment() (localctx ICommentContext) {
	localctx = NewCommentContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 66, bicepParserRULE_comment)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(437)
		_la = p.GetTokenStream().LA(1)

		if !(_la == bicepParserSINGLE_LINE_COMMENT || _la == bicepParserMULTI_LINE_COMMENT) {
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
