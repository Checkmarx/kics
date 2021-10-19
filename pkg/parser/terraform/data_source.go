package terraform

import (
	"fmt"
	"path/filepath"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hcldec"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

var dataSourceSpec = &hcldec.ObjectSpec{
	"id": &hcldec.AttrSpec{
		Name:     "id",
		Type:     cty.String,
		Required: false,
	},
	"version": &hcldec.AttrSpec{
		Name:     "version",
		Type:     cty.String,
		Required: false,
	},
	"statement": statementSpec,
}

var statementSpec = &hcldec.BlockListSpec{
	TypeName: "statement",
	Nested: &hcldec.ObjectSpec{
		"sid": &hcldec.AttrSpec{
			Name:     "sid",
			Type:     cty.String,
			Required: false,
		},
		"effect": &hcldec.AttrSpec{
			Name:     "effect",
			Type:     cty.String,
			Required: false,
		},
		"actions": &hcldec.AttrSpec{
			Name:     "actions",
			Type:     cty.List(cty.String),
			Required: false,
		},
		"not_actions": &hcldec.AttrSpec{
			Name:     "not_actions",
			Type:     cty.List(cty.String),
			Required: false,
		},
		"resources": &hcldec.AttrSpec{
			Name:     "resources",
			Type:     cty.List(cty.String),
			Required: false,
		},
		"not_resources": &hcldec.AttrSpec{
			Name:     "not_resources",
			Type:     cty.List(cty.String),
			Required: false,
		},
		"principals": &hcldec.BlockSpec{
			TypeName: "principals",
			Nested:   principalSpec,
		},
		"not_principals": &hcldec.BlockSpec{
			TypeName: "not_principals",
			Nested:   principalSpec,
		},
		"condition": &hcldec.BlockSpec{
			TypeName: "condition",
			Nested:   conditionSpec,
		},
	},
}

var principalSpec = &hcldec.ObjectSpec{
	"type": &hcldec.AttrSpec{
		Name:     "type",
		Type:     cty.String,
		Required: false,
	},
	"identifiers": &hcldec.AttrSpec{
		Name:     "identifiers ",
		Type:     cty.List(cty.String),
		Required: false,
	},
}

var conditionSpec = &hcldec.ObjectSpec{
	"test": &hcldec.AttrSpec{
		Name:     "test",
		Type:     cty.String,
		Required: false,
	},
	"variable": &hcldec.AttrSpec{
		Name:     "variable",
		Type:     cty.String,
		Required: false,
	},
	"values": &hcldec.AttrSpec{
		Name:     "values",
		Type:     cty.List(cty.String),
		Required: false,
	},
}

func getDataSourcePolicy(currentPath string) {
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files to parse data source")
		return
	}
	for _, tfFile := range tfFiles {
		parsedFile, err := parseFile(tfFile)
		if err != nil {
			continue
		}
		body, ok := parsedFile.Body.(*hclsyntax.Body)
		if !ok {
			continue
		}
		for _, block := range body.Blocks {
			if block.Type == "data" && block.Labels[0] == "aws_iam_policy_document" {
				parseDataSourceBody(block.Body)
			}
		}
	}
}

func decodeCtyToJSON(value cty.Value) []byte {
	jsonified, err := ctyjson.Marshal(value, cty.DynamicPseudoType)
	if err != nil {
		return nil
	}
	return jsonified
}

func parseDataSourceBody(body *hclsyntax.Body) {
	targ, _ := hcldec.Decode(body, dataSourceSpec, &hcl.EvalContext{})
	j := decodeCtyToJSON(targ)
	fmt.Println(string(j))
}
