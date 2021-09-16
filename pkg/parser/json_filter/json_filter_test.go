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
	expected parser.AWSJSONFilter
	wantErr  bool
}{
	{
		name:     "empty",
		input:    "",
		expected: parser.AWSJSONFilter{},
		wantErr:  true,
	},
	{
		name:     "empty_curly_braces",
		input:    "{}",
		expected: parser.AWSJSONFilter{},
		wantErr:  true,
	},
	{
		name:     "invalid_operator",
		input:    `{$.eventType % "ConsoleLogin"}`,
		expected: parser.AWSJSONFilter{},
		wantErr:  true,
	},
	{
		name:  "simple_selector_equal_string",
		input: `{ $.eventType = "UpdateTrail" }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.eventType",
				Op:       "=",
				Value:    "\"UpdateTrail\"",
			},
		},
		wantErr: false,
	},
	{
		name:  "simple_selector_not_string_with_wildcard",
		input: `{ $.sourceIPAddress != 123.123.* }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.sourceIPAddress",
				Op:       "!=",
				Value:    "123.123.*",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_wildcard_and_not_string",
		input: `{ $.eventType = "*" && $.sourceIPAddress != 123.123.*}`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "&&",
				Left: parser.FilterSelector{
					Selector: "$.eventType",
					Op:       "=",
					Value:    "\"*\"",
				},
				Right: parser.FilterSelector{
					Selector: "$.sourceIPAddress",
					Op:       "!=",
					Value:    "123.123.*",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_array_idx_match_string",
		input: `{ $.arrayKey[0] = "value" }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.arrayKey[0]",
				Op:       "=",
				Value:    "\"value\"",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_array_idx_prop_match_int",
		input: `{ $.objectList[1].id = 2 }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.objectList[1].id",
				Op:       "=",
				Value:    "2",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_unary_op_is_null",
		input: `{ $.SomeObject IS NULL }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.SomeObject",
				Op:       "IS",
				Value:    "NULL",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_unary_op_not_exists",
		input: `{ $.SomeOtherObject NOT EXISTS }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.SomeOtherObject",
				Op:       "NOT",
				Value:    "EXISTS",
			},
		},
		wantErr: false,
	},
	{
		name:  "selector_unary_op_is_true",
		input: `{ $.ThisFlag IS TRUE }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterSelector{
				Selector: "$.ThisFlag",
				Op:       "IS",
				Value:    "TRUE",
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_and_parenthesis_and",
		input: `{ ($.user.id = 1) && ($.users[0].email = "John.Doe@example.com") }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "&&",
				Left: parser.FilterSelector{
					Selector: "$.user.id",
					Op:       "=",
					Value:    "1",
				},
				Right: parser.FilterSelector{
					Selector: "$.users[0].email",
					Op:       "=",
					Value:    "\"John.Doe@example.com\"",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_and_sub_parenthesis",
		input: `{ ($.user.id = 2 && $.users[0].email = "nonmatch") || $.actions[2] = "GET" }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "||",
				Left: parser.FilterExp{
					Op: "&&",
					Left: parser.FilterSelector{
						Selector: "$.user.id",
						Op:       "=",
						Value:    "2",
					},
					Right: parser.FilterSelector{
						Selector: "$.users[0].email",
						Op:       "=",
						Value:    "\"nonmatch\"",
					},
				},
				Right: parser.FilterSelector{
					Selector: "$.actions[2]",
					Op:       "=",
					Value:    "\"GET\"",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_or",
		input: `{ $.user.email = "John.Stiles@example.com" || $.coordinates[0][1] = nonmatch && $.actions[2] = nomatch }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "||",
				Left: parser.FilterSelector{
					Selector: "$.user.email",
					Op:       "=",
					Value:    "\"John.Stiles@example.com\"",
				},
				Right: parser.FilterExp{
					Op: "&&",
					Left: parser.FilterSelector{
						Selector: "$.coordinates[0][1]",
						Op:       "=",
						Value:    "nonmatch",
					},
					Right: parser.FilterSelector{
						Selector: "$.actions[2]",
						Op:       "=",
						Value:    "nomatch",
					},
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_or_and_parenthesis",
		input: `{ ($.user.email = "John.Stiles@example.com" || $.coordinates[0][1] = nonmatch) && $.actions[2] = nomatch }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "&&",
				Left: parser.FilterExp{
					Op: "||",
					Left: parser.FilterSelector{
						Selector: "$.user.email",
						Op:       "=",
						Value:    "\"John.Stiles@example.com\"",
					},
					Right: parser.FilterSelector{
						Selector: "$.coordinates[0][1]",
						Op:       "=",
						Value:    "nonmatch",
					},
				},
				Right: parser.FilterSelector{
					Selector: "$.actions[2]",
					Op:       "=",
					Value:    "nomatch",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_or_simple_parenthesis",
		input: `{ ($.errorCode = "*UnauthorizedOperation") || ($.errorCode = "AccessDenied*") }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "||",
				Left: parser.FilterSelector{
					Selector: "$.errorCode",
					Op:       "=",
					Value:    "\"*UnauthorizedOperation\"",
				},
				Right: parser.FilterSelector{
					Selector: "$.errorCode",
					Op:       "=",
					Value:    "\"AccessDenied*\"",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_and_simple_parenthesis",
		input: `{ ($.eventName = "ConsoleLogin") && ($.additionalEventData.MFAUsed != "Yes") }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: "&&",
				Left: parser.FilterSelector{
					Selector: "$.eventName",
					Op:       "=",
					Value:    "\"ConsoleLogin\"",
				},
				Right: parser.FilterSelector{
					Selector: "$.additionalEventData.MFAUsed",
					Op:       "!=",
					Value:    "\"Yes\"",
				},
			},
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
			got := visitor.VisitAll(tree)

			if !reflect.DeepEqual(tc.expected, got) {
				t.Errorf("test[%s]:\ninput    %v\nexpected %v\ngot      %v", tc.name, tc.input, tc.expected, got)
			}
			continue
		}

		require.True(t, errorListener.HasErrors(), "test[%s] Expected error but got none", tc.name)
	}
}
