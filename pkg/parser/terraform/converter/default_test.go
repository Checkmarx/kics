package converter

import (
	"bytes"
	"encoding/json"
	"testing"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
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
