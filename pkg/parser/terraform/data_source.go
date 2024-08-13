/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package terraform

import (
	"bytes"
	"encoding/json"
	"path/filepath"
	"sync"

	"github.com/Checkmarx/kics/pkg/builder/engine"
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
	Test     string   `json:"test,omitempty"`
	Variable string   `json:"variable,omitempty"`
	Values   []string `json:"values,omitempty"`
}

type dataSourcePolicyPrincipal struct {
	Type        string   `json:"type,omitempty"`
	Identifiers []string `json:"identifiers,omitempty"`
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
	ID        string                     `json:"Id,omitempty"`
	Statement []convertedPolicyStatement `json:"Statement,omitempty"`
	Version   string                     `json:"Version,omitempty"`
}

var mutexData = &sync.Mutex{}

func getDataSourcePolicy(currentPath string) {
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files to parse data source")
		return
	}
	if len(tfFiles) == 0 {
		return
	}
	jsonMap := make(map[string]map[string]string)
	for _, tfFile := range tfFiles {
		parsedFile, parseErr := parseFile(tfFile, true)
		if parseErr != nil {
			log.Debug().Msgf("Error trying to parse file %s for data source.", tfFile)
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
	policyResource := map[string]map[string]map[string]string{
		"aws_iam_policy_document": jsonMap,
	}
	data, err := gocty.ToCtyValue(policyResource, cty.Map(cty.Map(cty.Map(cty.String))))
	if err != nil {
		log.Error().Msgf("Error trying to convert policy to cty value: %s", err)
		return
	}

	mutexData.Lock()
	inputVariableMap["data"] = data
	mutexData.Unlock()
}

func decodeDataSourcePolicy(value cty.Value) dataSourcePolicy {
	jsonified, err := ctyjson.Marshal(value, cty.DynamicPseudoType)
	if err != nil {
		log.Error().Msgf("Error trying to decode data source block: %s", err)
		return dataSourcePolicy{}
	}
	var data dataSource
	err = json.Unmarshal(jsonified, &data)
	if err != nil {
		log.Error().Msgf("Error trying to encode data source json: %s", err)
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
			Name:     "identifiers",
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

	resolveDataResources(body)

	target, decodeErrs := hcldec.Decode(body, dataSourceSpec, &hcl.EvalContext{
		Variables: inputVariableMap,
		Functions: functions.TerraformFuncs,
	})

	// check decode errors
	for _, decErr := range decodeErrs {
		if decErr.Summary != "Unknown variable" {
			log.Debug().Msgf("Error trying to eval data source block: %s", decErr.Summary)
			return ""
		}
		log.Debug().Msg("Dismissed Error when decoding policy: Found unknown variable")
	}

	dataSourceJSON := decodeDataSourcePolicy(target)
	convertedDataSource := convertedPolicy{
		ID:      dataSourceJSON.ID,
		Version: dataSourceJSON.Version,
	}
	statements := make([]convertedPolicyStatement, len(dataSourceJSON.Statement))
	for idx := range dataSourceJSON.Statement {
		var convertedCondition convertedPolicyCondition
		if dataSourceJSON.Statement[idx].Condition.Variable != "" {
			convertedCondition = convertedPolicyCondition{
				dataSourceJSON.Statement[idx].Condition.Test: map[string][]string{
					dataSourceJSON.Statement[idx].Condition.Variable: dataSourceJSON.Statement[idx].Condition.Values,
				},
			}
		}
		var convertedPrincipal convertedPolicyPrincipal
		if dataSourceJSON.Statement[idx].Principals.Type != "" {
			convertedPrincipal = convertedPolicyPrincipal{
				dataSourceJSON.Statement[idx].Principals.Type: dataSourceJSON.Statement[idx].Principals.Identifiers,
			}
		}
		var convertedNotPrincipal convertedPolicyPrincipal
		if dataSourceJSON.Statement[idx].NotPrincipals.Type != "" {
			convertedNotPrincipal = convertedPolicyPrincipal{
				dataSourceJSON.Statement[idx].NotPrincipals.Type: dataSourceJSON.Statement[idx].NotPrincipals.Identifiers,
			}
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
		statements[idx] = convertedStatement
	}
	convertedDataSource.Statement = statements
	buffer := &bytes.Buffer{}
	encoder := json.NewEncoder(buffer)
	encoder.SetEscapeHTML(false)
	err := encoder.Encode(convertedDataSource)
	if err != nil {
		log.Error().Msgf("Error trying to encoding data source json: %s", err)
		return ""
	}
	return buffer.String()
}

// resolveDataResources resolves the data resources expressions into LiteralValueExpr
func resolveDataResources(body *hclsyntax.Body) {
	for _, block := range body.Blocks {
		if resources, ok := block.Body.Attributes["resources"]; ok &&
			block.Type == "statement" {
			resolveTuple(resources.Expr)
		}
	}
}

func resolveTuple(expr hclsyntax.Expression) {
	e := engine.Engine{}
	if v, ok := expr.(*hclsyntax.TupleConsExpr); ok {
		for i, ex := range v.Exprs {
			striExpr, err := e.ExpToString(ex)

			if err != nil {
				log.Error().Msgf("Error trying to ExpToString: %s", err)
			}

			v.Exprs[i] = &hclsyntax.LiteralValueExpr{
				Val:      cty.StringVal(striExpr),
				SrcRange: v.Exprs[i].Range(),
			}
		}
	}
}
