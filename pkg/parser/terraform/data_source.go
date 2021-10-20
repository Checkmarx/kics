package terraform

import (
	"encoding/json"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/Checkmarx/kics/pkg/parser/terraform/functions"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hcldec"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/gocty"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

type dataSourcePolicyCondition struct {
	Test     string   `json:"test"`
	Variable string   `json:"variable"`
	Values   []string `json:"values"`
}

type dataSourcePolicyPrincipal struct {
	Type        string   `json:"type"`
	Identifiers []string `json:"identifiers"`
}

type dataSourcePolicyStatement struct {
	Actions       []string                  `json:"actions"`
	Condition     dataSourcePolicyCondition `json:"condition"`
	Effect        string                    `json:"effect"`
	NotActions    []string                  `json:"not_actions"`
	NotPrincipals dataSourcePolicyPrincipal `json:"not_principals"`
	NotResources  []string                  `json:"not_resources"`
	Principals    dataSourcePolicyPrincipal `json:"principals"`
	Resources     []string                  `json:"resources"`
	Sid           string                    `json:"sid"`
}

type dataSourcePolicy struct {
	ID        string                      `json:"id"`
	Statement []dataSourcePolicyStatement `json:"statement"`
	Version   string                      `json:"version"`
}

type dataSource struct {
	Value dataSourcePolicy `json:"value"`
}

type convertedPolicyCondition map[string]map[string][]string
type convertedPolicyPrincipal map[string][]string

type convertedPolicyStatement struct {
	Actions       []string                 `json:"Actions,omitempty"`
	Condition     convertedPolicyCondition `json:"Condition,omitempty"`
	Effect        string                   `json:"Effect,omitempty"`
	NotActions    []string                 `json:"Not_actions,omitempty"`
	NotPrincipals convertedPolicyPrincipal `json:"Not_principals,omitempty"`
	NotResources  []string                 `json:"Not_resources,omitempty"`
	Principals    convertedPolicyPrincipal `json:"Principals,omitempty"`
	Resources     []string                 `json:"Resources,omitempty"`
	Sid           string                   `json:"Sid,omitempty"`
}

type convertedPolicy struct {
	ID        string                     `json:"Id"`
	Statement []convertedPolicyStatement `json:"Statement"`
	Version   string                     `json:"Version"`
}

func getDataSourcePolicy(currentPath string) {
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files to parse data source")
		return
	}
	variablesMap := make(converter.VariableMap)
	jsonMap := make(map[string]map[string]string)
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
			if block.Type == "data" && block.Labels[0] == "aws_iam_policy_document" && len(block.Labels) > 1 {
				policyJSON := parseDataSourceBody(block.Body)
				jsonMap[block.Labels[1]] = map[string]string{
					"json": policyJSON,
				}
			}
		}
	}
	//also needs to infer type correctly here
	variablesMap["aws_iam_policy_document"], err = gocty.ToCtyValue(jsonMap, cty.Map(cty.Map(cty.String)))
	inputVariableMap["data"] = cty.ObjectVal(variablesMap)
}

func decodeDataSourcePolicy(value cty.Value) dataSourcePolicy {
	jsonified, err := ctyjson.Marshal(value, cty.DynamicPseudoType)
	if err != nil {
		return dataSourcePolicy{}
	}
	var data dataSource
	err = json.Unmarshal(jsonified, &data)
	if err != nil {
		return dataSourcePolicy{}
	}
	return data.Value
}

func getPrincipalSpec() *hcldec.ObjectSpec {
	return &hcldec.ObjectSpec{
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
}

func getConditionalSpec() *hcldec.ObjectSpec {
	return &hcldec.ObjectSpec{
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
}

func getStatementSpec() *hcldec.BlockListSpec {
	return &hcldec.BlockListSpec{
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
				Nested:   getPrincipalSpec(),
			},
			"not_principals": &hcldec.BlockSpec{
				TypeName: "not_principals",
				Nested:   getPrincipalSpec(),
			},
			"condition": &hcldec.BlockSpec{
				TypeName: "condition",
				Nested:   getConditionalSpec(),
			},
		},
	}
}

func parseDataSourceBody(body *hclsyntax.Body) string {
	dataSourceSpec := &hcldec.ObjectSpec{
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
		"statement": getStatementSpec(),
	}

	target, _ := hcldec.Decode(body, dataSourceSpec, &hcl.EvalContext{
		Variables: inputVariableMap,
		Functions: functions.TerraformFuncs,
	})
	dataSourceJSON := decodeDataSourcePolicy(target)
	convertedDataSource := convertedPolicy{
		ID:      dataSourceJSON.ID,
		Version: dataSourceJSON.Version,
	}
	statements := make([]convertedPolicyStatement, len(dataSourceJSON.Statement))
	for idx := range dataSourceJSON.Statement {
		convertedCondition := convertedPolicyCondition{
			dataSourceJSON.Statement[idx].Condition.Test: map[string][]string{
				dataSourceJSON.Statement[idx].Condition.Variable: dataSourceJSON.Statement[idx].Condition.Values,
			},
		}

		convertedPrincipal := convertedPolicyPrincipal{
			dataSourceJSON.Statement[idx].Principals.Type: dataSourceJSON.Statement[idx].Principals.Identifiers,
		}

		convertedNotPrincipal := convertedPolicyPrincipal{
			dataSourceJSON.Statement[idx].NotPrincipals.Type: dataSourceJSON.Statement[idx].NotPrincipals.Identifiers,
		}

		convertedStatement := convertedPolicyStatement{
			Actions:       dataSourceJSON.Statement[idx].Actions,
			Effect:        dataSourceJSON.Statement[idx].Effect,
			NotActions:    dataSourceJSON.Statement[idx].NotActions,
			NotResources:  dataSourceJSON.Statement[idx].NotResources,
			Resources:     dataSourceJSON.Statement[idx].Resources,
			Sid:           dataSourceJSON.Statement[idx].Sid,
			Condition:     convertedCondition,
			NotPrincipals: convertedNotPrincipal,
			Principals:    convertedPrincipal,
		}
		//needs to check here if it is converting correctly
		statements = append(statements, convertedStatement)
	}
	convertedDataSource.Statement = statements
	dataSourceConvertedStringfy, err := json.Marshal(convertedDataSource)
	if err != nil {
		return ""
	}
	return string(dataSourceConvertedStringfy)
}
