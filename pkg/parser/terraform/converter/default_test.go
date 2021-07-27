package converter

import (
	"bytes"
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
				"nested_block": {}
			}
		}
	}
}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
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
			"attribute": "value"
		}
	}
}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
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
				"attribute": "value"
			},
			{
				"attribute": "value_two"
			}
		]
	}
}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
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

func TestEvalFunction(t *testing.T) {
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
			want:    `{"block":{"label_one":{"policy":"{\"Id\":\"id\"}","some_number":3}}}`,
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
			want:    `{"block":{"label_one":{"policy":"{\"Id\":\"aws.meuId\"}","some_number":3}}}`,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			file, _ := hclsyntax.ParseConfig([]byte(tt.input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})
			c := converter{bytes: file.Bytes}
			got, err := c.convertBody(file.Body.(*hclsyntax.Body))
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
				"quoted": "\"quoted\"",
				"test3": "${1 + 2}",
				"x": "${-10}",
				"temp": "${1 + 2} %{if local.test2 \u003c 3}\"4\n\"%{endif}",
				"squoted": "'quoted'",
				"y": "${-x}",
				"z": "${-(1 + 4)}",
				"test1": "hello",
				"hyphen-test": 3,
				"test2": 5
			},
			{
				"other": {
					"num": "${local.test2 + 5}",
					"thing": "${[for x in local.arr: x * 2]}",
					"${local.test3}": 4,
					"3": 1,
					"local.test1": 89,
					"a.b.c[\"hi\"][3].*": 3,
					"loop": "This has a for loop: %{for x in local.arr}x,%{endfor}",
					"a.b.c": "True"
				}
			},
			{
				"heredoc": "This is a heredoc template.\nIt references ${local.other.3}\n",
				"simple": "${4 - 2}",
				"cond": "${test3 \u003e 2 ? 1: 0}",
				"heredoc2": "\t\tAnother heredoc, that\n\t\tdoesn't remove indentation\n\t\t${local.other.3}\n\t\t%{if true ? false : true}\"gotcha\"\\n%{else}4%{endif}\n" ` + // nolint
		`}
		],
		"data": {
			"terraform_remote_state": {
				"remote": {
					"backend": "s3",
					"config": {
						"bucket": "bucket-mybucket",
						"key": "mykey",
						"profile": "${var.profile}",
						"region": "us-east-1"
					},
					"policy": "{\"Id\":\"MYBUCKETPOLICY\"}",
					"some_number": 3
				}
			}
		},
		"variable": {
			"profile": {},
			"region": {
				"default": "us-east-1"
			}
		}
	}`

	file, _ := hclsyntax.ParseConfig([]byte(input), "testFileName", hcl.Pos{Byte: 0, Line: 1, Column: 1})

	body, err := DefaultConverted(file, InputVariableMap{})
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	var v map[string]interface{}
	err = json.Unmarshal([]byte(expected), &v)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}

	// expectedValue is the value of expected["data"]["terraform_remote_state"]["remote"]["backend"] which is "s3"
	expectedValue := v["data"].(map[string]interface{})["terraform_remote_state"].(map[string]interface{})["remote"].(map[string]interface{})["backend"] // nolint
	// got is the value of body["data"]["terraform_remote_state"]["remote"]["backend"] and it must be "s3" in this test case
	got := body["data"].(model.Document)["terraform_remote_state"].(model.Document)["remote"].(model.Document)["backend"]

	require.Len(t, body, len(v))
	require.Equal(t, expectedValue, got)
}

func compareTest(t *testing.T, input []byte, expected string) {
	var indented bytes.Buffer
	if err := json.Indent(&indented, input, "", "\t"); err != nil {
		t.Fatal("indent:", err)
	}

	actual := indented.String()
	if actual != expected {
		t.Errorf("Expected:\n%s\n\nGot:\n%s", expected, actual)
	}
}
