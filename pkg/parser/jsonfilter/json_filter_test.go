package jsonfilter

import (
	"bytes"
	"encoding/json"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/parser/jsonfilter/parser"
	"github.com/antlr4-go/antlr/v4"
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
				Op: parser.AND,
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
				Op: parser.AND,
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
				Op: parser.OR,
				Left: parser.FilterExp{
					Op: parser.AND,
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
				Op: parser.OR,
				Left: parser.FilterSelector{
					Selector: "$.user.email",
					Op:       "=",
					Value:    "\"John.Stiles@example.com\"",
				},
				Right: parser.FilterExp{
					Op: parser.AND,
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
				Op: parser.AND,
				Left: parser.FilterExp{
					Op: parser.OR,
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
				Op: parser.OR,
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
				Op: parser.AND,
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
	{
		name:  "expr_three_selectors_and_without_parenthesis",
		input: `{ $.userIdentity.type = "Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != "AwsServiceEvent" }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.AND,
				Left: parser.FilterExp{
					Op: parser.AND,
					Left: parser.FilterSelector{
						Selector: "$.userIdentity.type",
						Op:       "=",
						Value:    "\"Root\"",
					},
					Right: parser.FilterSelector{
						Selector: "$.userIdentity.invokedBy",
						Op:       "NOT",
						Value:    "EXISTS",
					},
				},
				Right: parser.FilterSelector{
					Selector: "$.eventType",
					Op:       "!=",
					Value:    "\"AwsServiceEvent\"",
				},
			},
		},
		wantErr: false,
	},
	{
		name:  "expr_two_selectors_and_with_parenthesis_unquoted_quoted_strings",
		input: `{ ($.eventName = ConsoleLogin) && ($.errorMessage = "Failed authentication") }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.AND,
				Left: parser.FilterSelector{
					Selector: "$.eventName",
					Op:       "=",
					Value:    "ConsoleLogin",
				},
				Right: parser.FilterSelector{
					Selector: "$.errorMessage",
					Op:       "=",
					Value:    "\"Failed authentication\"",
				},
			},
		},
	},
	{
		name:  "expr_two_selectors_and_with_parenthesis_unquoted_unquoted_strings",
		input: `{ ($.eventSource = "kms.amazonaws.com") && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.AND,
				Left: parser.FilterSelector{
					Selector: "$.eventSource",
					Op:       "=",
					Value:    "\"kms.amazonaws.com\"",
				},
				Right: parser.FilterExp{
					Op: parser.OR,
					Left: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "DisableKey",
					},
					Right: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "ScheduleKeyDeletion",
					},
				},
			},
		},
	},
	{
		name: "expr_multiple_or_parenthesis",
		input: `{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||` +
			`($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||` +
			`($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||` +
			`($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||` +
			`($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.OR,
				Left: parser.FilterExp{
					Op: parser.OR,
					Left: parser.FilterExp{
						Op: parser.OR,
						Left: parser.FilterExp{
							Op: parser.OR,
							Left: parser.FilterExp{
								Op: parser.OR,
								Left: parser.FilterExp{
									Op: parser.OR,
									Left: parser.FilterExp{
										Op: parser.OR,
										Left: parser.FilterExp{
											Op: parser.OR,
											Left: parser.FilterExp{
												Op: parser.OR,
												Left: parser.FilterExp{
													Op: parser.OR,
													Left: parser.FilterExp{
														Op: parser.OR,
														Left: parser.FilterExp{
															Op: parser.OR,
															Left: parser.FilterExp{
																Op: parser.OR,
																Left: parser.FilterExp{
																	Op: parser.OR,
																	Left: parser.FilterExp{
																		Op: parser.OR,
																		Left: parser.FilterSelector{
																			Selector: "$.eventName",
																			Op:       "=",
																			Value:    "DeleteGroupPolicy",
																		},
																		Right: parser.FilterSelector{
																			Selector: "$.eventName",
																			Op:       "=",
																			Value:    "DeleteRolePolicy",
																		},
																	},
																	Right: parser.FilterSelector{
																		Selector: "$.eventName",
																		Op:       "=",
																		Value:    "DeleteUserPolicy",
																	},
																},
																Right: parser.FilterSelector{
																	Selector: "$.eventName",
																	Op:       "=",
																	Value:    "PutGroupPolicy",
																},
															},
															Right: parser.FilterSelector{
																Selector: "$.eventName",
																Op:       "=",
																Value:    "PutRolePolicy",
															},
														},
														Right: parser.FilterSelector{
															Selector: "$.eventName",
															Op:       "=",
															Value:    "PutUserPolicy",
														},
													},
													Right: parser.FilterSelector{
														Selector: "$.eventName",
														Op:       "=",
														Value:    "CreatePolicy",
													},
												},
												Right: parser.FilterSelector{
													Selector: "$.eventName",
													Op:       "=",
													Value:    "DeletePolicy",
												},
											},
											Right: parser.FilterSelector{
												Selector: "$.eventName",
												Op:       "=",
												Value:    "CreatePolicyVersion",
											},
										},
										Right: parser.FilterSelector{
											Selector: "$.eventName",
											Op:       "=",
											Value:    "DeletePolicyVersion",
										},
									},
									Right: parser.FilterSelector{
										Selector: "$.eventName",
										Op:       "=",
										Value:    "AttachRolePolicy",
									},
								},
								Right: parser.FilterSelector{
									Selector: "$.eventName",
									Op:       "=",
									Value:    "DetachRolePolicy",
								},
							},
							Right: parser.FilterSelector{
								Selector: "$.eventName",
								Op:       "=",
								Value:    "AttachUserPolicy",
							},
						},
						Right: parser.FilterSelector{
							Selector: "$.eventName",
							Op:       "=",
							Value:    "DetachUserPolicy",
						},
					},
					Right: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "AttachGroupPolicy",
					},
				},
				Right: parser.FilterSelector{
					Selector: "$.eventName",
					Op:       "=",
					Value:    "DetachGroupPolicy",
				},
			},
		},
	},
	{
		name: "expr_multiple_and_or_parenthesis",
		input: `{ ($.eventSource = "s3.amazonaws.com") &&` +
			`(($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) ||` +
			`($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) ||` +
			`($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) ||` +
			`($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) ||` +
			`($.eventName = DeleteBucketReplication)) }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.AND,
				Left: parser.FilterSelector{
					Selector: "$.eventSource",
					Op:       "=",
					Value:    "\"s3.amazonaws.com\"",
				},
				Right: parser.FilterExp{
					Op: parser.OR,
					Left: parser.FilterExp{
						Op: parser.OR,
						Left: parser.FilterExp{
							Op: parser.OR,
							Left: parser.FilterExp{
								Op: parser.OR,
								Left: parser.FilterExp{
									Op: parser.OR,
									Left: parser.FilterExp{
										Op: parser.OR,
										Left: parser.FilterExp{
											Op: parser.OR,
											Left: parser.FilterExp{
												Op: parser.OR,
												Left: parser.FilterSelector{
													Selector: "$.eventName",
													Op:       "=",
													Value:    "PutBucketAcl",
												},
												Right: parser.FilterSelector{
													Selector: "$.eventName",
													Op:       "=",
													Value:    "PutBucketPolicy",
												},
											},
											Right: parser.FilterSelector{
												Selector: "$.eventName",
												Op:       "=",
												Value:    "PutBucketCors",
											},
										},
										Right: parser.FilterSelector{
											Selector: "$.eventName",
											Op:       "=",
											Value:    "PutBucketLifecycle",
										},
									},
									Right: parser.FilterSelector{
										Selector: "$.eventName",
										Op:       "=",
										Value:    "PutBucketReplication",
									},
								},
								Right: parser.FilterSelector{
									Selector: "$.eventName",
									Op:       "=",
									Value:    "DeleteBucketPolicy",
								},
							},
							Right: parser.FilterSelector{
								Selector: "$.eventName",
								Op:       "=",
								Value:    "DeleteBucketCors",
							},
						},
						Right: parser.FilterSelector{
							Selector: "$.eventName",
							Op:       "=",
							Value:    "DeleteBucketLifecycle",
						},
					},
					Right: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "DeleteBucketReplication",
					},
				},
			},
		},
	},
	{
		name: "expr_multiple_and_or_parenthesis_2",
		input: `{ ($.eventSource = "config.amazonaws.com") && (($.eventName=StopConfigurationRecorder)||` +
			`($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.AND,
				Left: parser.FilterSelector{
					Selector: "$.eventSource",
					Op:       "=",
					Value:    "\"config.amazonaws.com\"",
				},
				Right: parser.FilterExp{
					Op: parser.OR,
					Left: parser.FilterExp{
						Op: parser.OR,
						Left: parser.FilterExp{
							Op: parser.OR,
							Left: parser.FilterSelector{
								Selector: "$.eventName",
								Op:       "=",
								Value:    "StopConfigurationRecorder",
							},
							Right: parser.FilterSelector{
								Selector: "$.eventName",
								Op:       "=",
								Value:    "DeleteDeliveryChannel",
							},
						},
						Right: parser.FilterSelector{
							Selector: "$.eventName",
							Op:       "=",
							Value:    "PutDeliveryChannel",
						},
					},
					Right: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "PutConfigurationRecorder",
					},
				},
			},
		},
	},
	{
		name: "expr_multiple_or_parenthesis_3",
		input: `{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) ||` +
			`($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) ||` +
			`($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}`,
		expected: parser.AWSJSONFilter{
			FilterExpression: parser.FilterExp{
				Op: parser.OR,
				Left: parser.FilterExp{
					Op: parser.OR,
					Left: parser.FilterExp{
						Op: parser.OR,
						Left: parser.FilterExp{
							Op: parser.OR,
							Left: parser.FilterExp{
								Op: parser.OR,
								Left: parser.FilterSelector{
									Selector: "$.eventName",
									Op:       "=",
									Value:    "AuthorizeSecurityGroupIngress",
								},
								Right: parser.FilterSelector{
									Selector: "$.eventName",
									Op:       "=",
									Value:    "AuthorizeSecurityGroupEgress",
								},
							},
							Right: parser.FilterSelector{
								Selector: "$.eventName",
								Op:       "=",
								Value:    "RevokeSecurityGroupIngress",
							},
						},
						Right: parser.FilterSelector{
							Selector: "$.eventName",
							Op:       "=",
							Value:    "RevokeSecurityGroupEgress",
						},
					},
					Right: parser.FilterSelector{
						Selector: "$.eventName",
						Op:       "=",
						Value:    "CreateSecurityGroup",
					},
				},
				Right: parser.FilterSelector{
					Selector: "$.eventName",
					Op:       "=",
					Value:    "DeleteSecurityGroup",
				},
			},
		},
	},
}

func TestJSONFilterExpressions(t *testing.T) {
	for _, tc := range inputs {
		t.Run(tc.name, func(t *testing.T) {
			is := antlr.NewInputStream(tc.input)
			lexer := parser.NewJSONFilterLexer(is)
			lexer.RemoveErrorListeners()

			stream := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
			errorListener := parser.NewCustomErrorListener()
			lexer.AddErrorListener(errorListener)

			p := parser.NewJSONFilterParser(stream)
			p.RemoveErrorListeners()
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
			} else {
				require.True(t, errorListener.HasErrors(), "test[%s] Expected error but got none", tc.name)
			}
		})
	}
}

func TestMarshallJSONFilterExpressions(t *testing.T) {
	inputs := []struct {
		name  string
		input string
		want  string
	}{
		{
			name:  "expr_single_selector",
			input: `{$.eventName = CreateDeliveryChannel}`,
			want: `{"_kics_filter_expr":{"_selector":"$.eventName","_op":"=","_value":"CreateDeliveryChannel"}}
`,
		},
		{
			name:  "expr_two_selectors_and_with_parenthesis_unquoted_quoted_strings",
			input: `{ ($.eventName = ConsoleLogin) && ($.errorMessage = "Failed authentication") }`,
			want: `{"_kics_filter_expr":{"_op":"&&","_left":{"_selector":"$.eventName","_op":"=","_value":"ConsoleLogin"},"_right":{"_selector":"$.errorMessage","_op":"=","_value":"\"Failed authentication\""}}}
`,
		},
		{
			name:  "expr_three_selectors_and_without_parenthesis",
			input: `{ $.userIdentity.type = "Root" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != "AwsServiceEvent" }`,
			want: `{"_kics_filter_expr":{"_op":"&&","_left":{"_op":"&&","_left":{"_selector":"$.userIdentity.type","_op":"=","_value":"\"Root\""},"_right":{"_selector":"$.userIdentity.invokedBy","_op":"NOT","_value":"EXISTS"}},"_right":{"_selector":"$.eventType","_op":"!=","_value":"\"AwsServiceEvent\""}}}
`,
		},
		{
			name: "expr_multiple_or",
			input: `{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) ||` +
				`($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) ||` +
				`($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}`,
			want: `{"_kics_filter_expr":{"_op":"||","_left":{"_op":"||","_left":{"_op":"||","_left":{"_op":"||","_left":{"_op":"||","_left":{"_selector":"$.eventName","_op":"=","_value":"AuthorizeSecurityGroupIngress"},"_right":{"_selector":"$.eventName","_op":"=","_value":"AuthorizeSecurityGroupEgress"}},"_right":{"_selector":"$.eventName","_op":"=","_value":"RevokeSecurityGroupIngress"}},"_right":{"_selector":"$.eventName","_op":"=","_value":"RevokeSecurityGroupEgress"}},"_right":{"_selector":"$.eventName","_op":"=","_value":"CreateSecurityGroup"}},"_right":{"_selector":"$.eventName","_op":"=","_value":"DeleteSecurityGroup"}}}
`,
		},
	}
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

		visitor := parser.NewJSONFilterPrinterVisitor()
		expTree := visitor.VisitAll(tree)

		buf := new(bytes.Buffer)
		encoder := json.NewEncoder(buf)
		encoder.SetEscapeHTML(false)
		err := encoder.Encode(expTree)
		require.NoError(t, err)

		got := buf.String()
		require.Equal(t, tc.want, got, "test[%s] JSON encoded expression tree is not as expected", tc.name)
	}
}
