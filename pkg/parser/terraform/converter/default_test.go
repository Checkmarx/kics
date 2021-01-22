package converter

import (
	"bytes"
	"encoding/json"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/stretchr/testify/require"
)

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

	body, _, err := DefaultConverted(file)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
}

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

	body, _, err := DefaultConverted(file)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
}

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

	body, _, err := DefaultConverted(file)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	inputMarsheld, err := json.Marshal(body)
	if err != nil {
		t.Errorf("Error Marshling: %s", err)
	}
	compareTest(t, inputMarsheld, expected)
}

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
		bucket  = "mybucket"
		key     = "mykey"
	}
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
						"bucket": "mybucket",
						"key": "mykey",
						"profile": "${var.profile}",
						"region": "${var.region}"
					}
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

	body, _, err := DefaultConverted(file)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}
	var v map[string]interface{}
	err = json.Unmarshal([]byte(expected), &v)
	if err != nil {
		t.Fatal("parse bytes:", err)
	}

	require.Len(t, body, len(v))
	require.Equal(t, v["data"].(map[string]interface{})["terraform_remote_state"].(map[string]interface{})["remote"].(map[string]interface{})["backend"], // nolint
		body["data"].(model.Document)["terraform_remote_state"].(model.Document)["remote"].(model.Document)["backend"])
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
