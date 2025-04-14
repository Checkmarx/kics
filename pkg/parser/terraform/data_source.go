package terraform

import (
	"bytes"
	"encoding/json"
	"path/filepath"
	"strings"
	"sync"

	"github.com/Checkmarx/kics/v2/pkg/builder/engine"
	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/functions"
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
	jsonUnified, err := ctyjson.Marshal(value, cty.DynamicPseudoType)
	if err != nil {
		log.Error().Msgf("Error trying to decode data source block: %s", err)
		return dataSourcePolicy{}
	}
	var data dataSource
	err = json.Unmarshal(jsonUnified, &data)
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
	paths := extractVariablePathsFromBody(body)
	grouped := groupPathsByRoot(paths)

	for rootVar, subPaths := range grouped {
		inputVariableMap[rootVar] = buildNestedPathMapWithIdentifier(subPaths)
	}

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

// groupsPathsByRoot groups paths by their root variable (first element of the path)
// allowing us to group paths that share the same root for further processing.
func groupPathsByRoot(paths [][]string) map[string][][]string {
	grouped := make(map[string][][]string)
	for _, path := range paths {
		if len(path) == 0 {
			continue
		}
		root := path[0]
		grouped[root] = append(grouped[root], path[1:])
	}
	return grouped
}

// buildNestedPathMapWithIdentifier constructs a nested map from the variables paths,
// where the key is the first part of the path and the values is the remaining paths.
func buildNestedPathMapWithIdentifier(paths [][]string) cty.Value {
	root := map[string]cty.Value{}

	for _, path := range paths {
		if len(path) == 0 {
			continue
		}

		value := cty.StringVal(strings.Join(path, "."))
		for i := len(path) - 1; i >= 0; i-- {
			value = cty.ObjectVal(map[string]cty.Value{
				path[i]: value,
			})
		}

		for k, v := range value.AsValueMap() {
			if existing, exists := root[k]; exists {
				merged := mergeObjects(existing, v)
				root[k] = merged
			} else {
				root[k] = v
			}
		}
	}

	return cty.ObjectVal(root)
}

// mergeObjects merges two cty objects. If the objects have shared keys,
// their nested fields are recursively merged.
func mergeObjects(a, b cty.Value) cty.Value {
	if !a.Type().IsObjectType() || !b.Type().IsObjectType() {
		return b
	}

	merged := map[string]cty.Value{}
	for k, v := range a.AsValueMap() {
		merged[k] = v
	}
	for k, v := range b.AsValueMap() {
		if existing, ok := merged[k]; ok {
			merged[k] = mergeObjects(existing, v)
		} else {
			merged[k] = v
		}
	}
	return cty.ObjectVal(merged)
}

// extractVariablePathsFromBody parses the HCL body and extracts variable paths.
// It walks through the body, extracting paths and returning them as an array of string slices.
func extractVariablePathsFromBody(body *hclsyntax.Body) [][]string {
	var paths [][]string

	for _, attr := range body.Attributes {
		paths = append(paths, extractPathsFromExpr(attr.Expr)...)
	}
	for _, block := range body.Blocks {
		paths = append(paths, extractVariablePathsFromBody(block.Body)...)
	}

	return paths
}

// extractPathsFromExpr handles the expression traversal and path extraction.
func extractPathsFromExpr(expr hclsyntax.Expression) [][]string {
	var paths [][]string

	switch e := expr.(type) {
	case *hclsyntax.ScopeTraversalExpr:
		var path []string
		for _, part := range e.Traversal {
			switch p := part.(type) {
			case hcl.TraverseRoot:
				path = append(path, p.Name)
			case hcl.TraverseAttr:
				path = append(path, p.Name)
			}
		}
		if len(path) > 0 {
			paths = append(paths, path)
		}
	case *hclsyntax.TupleConsExpr:
		for _, p := range e.Exprs {
			paths = append(paths, extractPathsFromExpr(p)...)
		}
	}

	return paths
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
