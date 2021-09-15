package json_filter

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/parser/json_filter/parser"
	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/stretchr/testify/require"
)

var inputs = []struct {
	name     string
	input    string
	expected parser.FilterNode
	wantErr  bool
}{
	{
		name:     "empty",
		input:    "",
		expected: parser.FilterNode{},
		wantErr:  true,
	},
	{
		name:     "empty_curly_braces",
		input:    "{}",
		expected: parser.FilterNode{},
		wantErr:  true,
	},
	{
		name:     "invalid_operator",
		input:    `{$.eventType % "ConsoleLogin"}`,
		expected: parser.FilterNode{},
		wantErr:  true,
	},
	{
		name:  "simple_selector_equal_string",
		input: `{ $.eventType = "UpdateTrail" }`,
		expected: parser.FilterNode{
			"_selector": "$.eventType",
			"_op":       "=",
			"_value":    "\"UpdateTrail\"",
		},
		wantErr: false,
	},
	{
		name:  "simple_selector_not_string_with_wildcard",
		input: `{ $.sourceIPAddress != 123.123.* }`,
		expected: parser.FilterNode{
			"_selector": "$.sourceIPAddress",
			"_op":       "!=",
			"_value":    "123.123.*",
		},
		wantErr: false,
	},
	{
		name:  "selector_wildcard_and_not_string",
		input: `{ $.eventType = "*" && $.sourceIPAddress != 123.123.*}`,
		expected: parser.FilterNode{
			"_op": "&&",
			"_left": parser.FilterNode{
				"_selector": "$.eventType",
				"_op":       "=",
				"_value":    "\"*\"",
			},
			"_right": parser.FilterNode{
				"_selector": "$.sourceIPAddress",
				"_op":       "!=",
				"_value":    "123.123.*",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_array_idx_match_string",
		input: `{ $.arrayKey[0] = "value" }`,
		expected: parser.FilterNode{
			"_selector": "$.arrayKey[0]",
			"_op":       "=",
			"_value":    "\"value\"",
		},
		wantErr: false,
	},
	{
		name:  "selector_array_idx_prop_match_int",
		input: `{ $.objectList[1].id = 2 }`,
		expected: parser.FilterNode{
			"_selector": "$.objectList[1].id",
			"_op":       "=",
			"_value":    "2",
		},
		wantErr: false,
	},
	{
		name:  "selector_unary_op_is_null",
		input: `{ $.SomeObject IS NULL }`,
		expected: parser.FilterNode{
			"_selector": "$.objectList[1].id",
			"_op":       "IS NULL",
			"_value":    "",
		},
		wantErr: false,
	},
}

func TestJSONFilterExpressions(t *testing.T) {
	for _, tc := range inputs {
		is := antlr.NewInputStream(tc.input)
		lexer := parser.NewJSONFilterLexer(is)
		lexer.RemoveErrorListeners()

		stream := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
		errorListener := parser.NewCustomErrorListener()
		lexer.AddErrorListener(errorListener)

		p := parser.NewJSONFilterParser(stream)
		p.AddErrorListener(errorListener)
		p.BuildParseTrees = true
		tree := p.Awsjsonfilter()

		if !tc.wantErr {
			require.False(t, errorListener.HasErrors(), "test[%s] Expected no error but got one", tc.name)

			visitor := parser.NewJSONFilterPrinterVisitor()
			got := visitor.Visit(tree)

			if !reflect.DeepEqual(tc.expected, got) {
				t.Errorf("test[%s]:\nexpected %v\ngot %v", tc.name, tc.expected, got)
			}
			continue
		}

		require.True(t, errorListener.HasErrors(), "test[%s] Expected error but got none", tc.name)
	}
}
