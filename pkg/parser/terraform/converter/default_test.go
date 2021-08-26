package converter

import (
	"encoding/json"
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/stretchr/testify/require"
	"github.com/zclconf/go-cty/cty"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

// TestLabelsWithNestedBlock tests the functions [DefaultConverted] and all the methods called by them (test with nested block)
func TestLabelsWithNestedBlock(t *testing.T) {
	input := `
block "label_one" "label_two" {
	nested_block { }
}`

	expected := `{
	"block": {
		"label_one": {
			"label_two": {
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 2
					},
					"_kics_nested_block": {
						"_kics_line": 3
					}
				},
				"nested_block": {
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 3
						}
					}
				}
			}
		}
	},
	"_kics_lines": {
		"_kics__default": {
			"_kics_line": 0
		},
		"_kics_block": {
			"_kics_line": 2
		}
	}
}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	require.NoError(t, err)
	compareJSONLine(t, body, expected)
}

func TestArrayBlock(t *testing.T) {
	input := `
block "label_one" "label_two" {
	default = [
      {
        id = "name1"
        attribute = "a"
      },
      {
        id = "name2"
        attribute = "a,b"
      },
      {
        id = "name3"
        attribute = "d"
      }
  ]
}`

	expected := `{
		"_kics_lines": {
			"_kics__default": {
				"_kics_line": 0
			},
			"_kics_block": {
				"_kics_line": 2
			}
		},
		"block": {
			"label_one": {
				"label_two": {
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 2
						},
						"_kics_default": {
							"_kics_arr": [
								{
									"_kics__default": {
										"_kics_line": 5
									},
									"_kics_attribute": {
										"_kics_line": 6
									},
									"_kics_id": {
										"_kics_line": 5
									}
								},
								{
									"_kics__default": {
										"_kics_line": 9
									},
									"_kics_attribute": {
										"_kics_line": 10
									},
									"_kics_id": {
										"_kics_line": 9
									}
								},
								{
									"_kics__default": {
										"_kics_line": 13
									},
									"_kics_attribute": {
										"_kics_line": 14
									},
									"_kics_id": {
										"_kics_line": 13
									}
								}
							],
							"_kics_line": 3
						}
					},
					"default": [
						{
							"attribute": "a",
							"id": "name1"
						},
						{
							"attribute": "a,b",
							"id": "name2"
						},
						{
							"attribute": "d",
							"id": "name3"
						}
					]
				}
			}
		}
	}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	require.NoError(t, err)
	compareJSONLine(t, body, expected)
}

func compareJSONLine(t *testing.T, test1 interface{}, test2 string) {
	stringefiedJSON, err := json.Marshal(&test1)
	require.NoError(t, err)
	require.JSONEq(t, test2, string(stringefiedJSON))
}

// TestLabelsWithNestedBlock tests the functions [DefaultConverted] and all the methods called by them (test with single block)
func TestSingleBlock(t *testing.T) {
	input := `
block "label_one" {
	attribute = "value"
}
`

	expected := `{
		"block": {
			"label_one": {
				"attribute": "value",
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 2
					},
					"_kics_attribute": {
						"_kics_line": 3
					}
				}
			}
		},
		"_kics_lines": {
			"_kics__default": {
				"_kics_line": 0
			},
			"_kics_block": {
				"_kics_line": 2
			}
		}
	}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	require.NoError(t, err)
	compareJSONLine(t, body, expected)
}

// TestMultipleBlocks tests the functions [DefaultConverted] and all the methods called by them (test with multiple blocks)
func TestMultipleBlocks(t *testing.T) {
	input := `
block "label_one" {
	attribute = "value"
}
block "label_one" {
	attribute = "value_two"
}
`

	expected := `{
		"block": {
			"label_one": [
				{
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 2
						},
						"_kics_attribute": {
							"_kics_line": 3
						}
					},
					"attribute": "value"
				},
				{
					"attribute": "value_two",
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 5
						},
						"_kics_attribute": {
							"_kics_line": 6
						}
					}
				}
			]
		},
		"_kics_lines": {
			"_kics__default": {
				"_kics_line": 0
			},
			"_kics_block": {
				"_kics_line": 5
			}
		}
	}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	require.NoError(t, err)
	compareJSONLine(t, body, expected)
}

// TestInputVariables tests if it is replacing variables
func TestInputVariables(t *testing.T) {
	input := `
block "label_one" {
	attribute = "${var.test}"
	attribute1 = var.test
	attribute2 = "${var.test}-concat"
}
`

	expected := map[string]string{
		"attribute":  "my-test",
		"attribute1": "my-test",
		"attribute2": "my-test-concat",
	}

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{
		"var": cty.ObjectVal(map[string]cty.Value{
			"test": cty.StringVal("my-test"),
		}),
	})
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	for key, value := range expected {
		t.Run(fmt.Sprintf("body['block']['label_one'][%s] should be equal to %s", key, value), func(t *testing.T) {
			gotValue := ""
			if token, ok := body["block"].(model.Document)["label_one"].(model.Document)[key].(ctyjson.SimpleJSONValue); ok {
				gotValue = token.Value.AsString()
			} else {
				gotValue = body["block"].(model.Document)["label_one"].(model.Document)[key].(string)
			}

			require.Equal(t, value, gotValue)
		})
	}
}

func TestEvalFunction(t *testing.T) { //nolint
	type funcTest struct {
		name    string
		input   string
		want    string
		wantErr bool
	}
	tests := []funcTest{
		{
			name: "should evaluate without problems",
			input: `
block "label_one" {
	policy = jsonencode({
    	Id      = "id"
	})
	some_number = max(max(1,3),2)
}
`,
			want: `{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_block": {
					"_kics_line": 2
				  }
				},
				"block": {
				  "label_one": {
					"_kics_lines": {
					  "_kics__default": {
						"_kics_line": 2
					  },
					  "_kics_policy": {
						"_kics_line": 3
					  },
					  "_kics_some_number": {
						"_kics_line": 6
					  }
					},
					"policy": "{\"Id\":\"id\"}",
					"some_number": 3
				  }
				}
			  }
			  `,
			wantErr: false,
		},
		{
			name: "should evaluate after mocking variable",
			input: `
block "label_one" {
	policy = jsonencode({
    	Id      = aws.meuId
	})
	some_number = max(max(1,3),2)
}
`,
			want: `{
				"_kics_lines": {
				  "_kics__default": {
					"_kics_line": 0
				  },
				  "_kics_block": {
					"_kics_line": 2
				  }
				},
				"block": {
				  "label_one": {
					"_kics_lines": {
					  "_kics__default": {
						"_kics_line": 2
					  },
					  "_kics_policy": {
						"_kics_line": 3
					  },
					  "_kics_some_number": {
						"_kics_line": 6
					  }
					},
					"policy": "{\"Id\":\"aws.meuId\"}",
					"some_number": 3
				  }
				}
			  }
			  `,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			file, _ := hclsyntax.ParseConfig([]byte(tt.input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})
			c := converter{bytes: file.Bytes}
			got, err := c.convertBody(file.Body.(*hclsyntax.Body), 0)
			fmt.Println(err)
			require.True(t, (err != nil) == tt.wantErr)
			gotJSON, _ := json.Marshal(got)
			var wantJSON model.Document
			_ = json.Unmarshal([]byte(tt.want), &wantJSON)
			_ = json.Unmarshal(gotJSON, &got)
			require.Equal(t, wantJSON, got)
		})
	}
}

// TestLabelsWithNestedBlock tests the functions [DefaultConverted] and all the methods called by them
func TestConversion(t *testing.T) { // nolint
	const input = `
locals {
	test3 = 1 + 2
	test1 = "hello"
	test2 = 5
	arr = [1, 2, 3, 4]
	hyphen-test = 3
	temp = "${1 + 2} %{if local.test2 < 3}\"4\n\"%{endif}"
	temp2 = "${"hi"} there"
		quoted = "\"quoted\""
		squoted = "'quoted'"
	x = -10
	y = -x
	z = -(1 + 4)
}
locals {
	other = {
		num = local.test2 + 5
		thing = [for x in local.arr: x * 2]
		"${local.test3}" = 4
		3 = 1
		"local.test1" = 89
		"a.b.c[\"hi\"][3].*" = 3
		loop = "This has a for loop: %{for x in local.arr}x,%{endfor}"
		a.b.c = "True"
	}
}
locals {
	heredoc = <<-EOF
		This is a heredoc template.
		It references ${local.other.3}
	EOF
	simple = "${4 - 2}"
	cond = test3 > 2 ? 1: 0
	heredoc2 = <<EOF
		Another heredoc, that
		doesn't remove indentation
		${local.other.3}
		%{if true ? false : true}"gotcha"\n%{else}4%{endif}
	EOF
}
data "terraform_remote_state" "remote" {
	backend = "s3"
	config = {
		profile = var.profile
		region  = var.region
		bucket  = "${var.bucket}-mybucket"
		key     = "mykey"
	}
	policy = jsonencode({
    	Id      = "MYBUCKETPOLICY"
	})
	some_number = max(max(1,3),2)
}
variable "profile" {}
variable "region" {
	default = "us-east-1"
}
`

	const expected = `{
		"locals": [
			{
				"arr": [
					1,
					2,
					3,
					4
				],
				"temp2": "hi there",
				"x": -10,
				"squoted": "'quoted'",
				"hyphen-test": 3,
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 2
					},
					"_kics_arr": {
						"_kics_line": 6,
						"_kics_arr": [
							{
								"_kics__default": {
									"_kics_line": 6
								}
							},
							{
								"_kics__default": {
									"_kics_line": 6
								}
							},
							{
								"_kics__default": {
									"_kics_line": 6
								}
							},
							{
								"_kics__default": {
									"_kics_line": 6
								}
							}
						]
					},
					"_kics_hyphen-test": {
						"_kics_line": 7
					},
					"_kics_quoted": {
						"_kics_line": 10
					},
					"_kics_squoted": {
						"_kics_line": 11
					},
					"_kics_temp": {
						"_kics_line": 8
					},
					"_kics_temp2": {
						"_kics_line": 9
					},
					"_kics_test1": {
						"_kics_line": 4
					},
					"_kics_test2": {
						"_kics_line": 5
					},
					"_kics_test3": {
						"_kics_line": 3
					},
					"_kics_x": {
						"_kics_line": 12
					},
					"_kics_y": {
						"_kics_line": 13
					},
					"_kics_z": {
						"_kics_line": 14
					}
				},
				"quoted": "\"quoted\"",
				"y": "${-x}",
				"z": -5,
				"test3": 3,
				"test1": "hello",
				"test2": 5,
				"temp": "${1 + 2} %{if local.test2 \u003c 3}\"4\n\"%{endif}"
			},
			{
				"other": {
					"a.b.c": "True",
					"num": "${local.test2 + 5}",
					"thing": "${[for x in local.arr: x * 2]}",
					"${local.test3}": 4,
					"3": 1,
					"local.test1": 89,
					"a.b.c[\"hi\"][3].*": 3,
					"loop": "This has a for loop: %{for x in local.arr}x,%{endfor}"
				},
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 16
					},
					"_kics_other": {
						"_kics_line": 17
					}
				}
			},
			{
				"heredoc2": "\t\tAnother heredoc, that\n\t\tdoesn't remove indentation\n\t\t${local.other.3}\n\t\t%{if true ? false : true}\"gotcha\"\\n%{else}4%{endif}\n",` + // nolint
		`"_kics_lines": {
					"_kics__default": {
						"_kics_line": 28
					},
					"_kics_cond": {
						"_kics_line": 34
					},
					"_kics_heredoc": {
						"_kics_line": 29
					},
					"_kics_heredoc2": {
						"_kics_line": 35
					},
					"_kics_simple": {
						"_kics_line": 33
					}
				},
				"heredoc": "This is a heredoc template.\nIt references ${local.other.3}\n",
				"simple": 2,
				"cond": "${test3 \u003e 2 ? 1: 0}"
			}
		],
		"data": {
			"terraform_remote_state": {
				"remote": {
					"some_number": 3,
					"_kics_lines": {
						"_kics__default": {
							"_kics_line": 42
						},
						"_kics_backend": {
							"_kics_line": 43
						},
						"_kics_config": {
							"_kics_line": 44
						},
						"_kics_policy": {
							"_kics_line": 50
						},
						"_kics_some_number": {
							"_kics_line": 53
						}
					},
					"backend": "s3",
					"config": {
						"profile": "${var.profile}",
						"region": "${var.region}",
						"bucket": "${var.bucket}-mybucket",
						"key": "mykey"
					},
					"policy": "{\"Id\":\"MYBUCKETPOLICY\"}"
				}
			}
		},
		"variable": {
			"profile": {
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 55
					}
				}
			},
			"region": {
				"default": "us-east-1",
				"_kics_lines": {
					"_kics__default": {
						"_kics_line": 56
					},
					"_kics_default": {
						"_kics_line": 57
					}
				}
			}
		},
		"_kics_lines": {
			"_kics__default": {
				"_kics_line": 0
			},
			"_kics_data": {
				"_kics_line": 42
			},
			"_kics_locals": {
				"_kics_line": 28
			},
			"_kics_variable": {
				"_kics_line": 56
			}
		}
	}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	require.NoError(t, err)
	compareJSONLine(t, body, expected)
}
