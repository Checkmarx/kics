package terraform

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
)

var inputVariableMap = make(converter.InputVariableMap)

func mergeMaps(baseMap, newItems converter.InputVariableMap) {
	for key, value := range newItems {
		baseMap[key] = value
	}
}

func parseFile(filename string) (*hcl.File, error) {
	file, err := os.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	parsedFile, _ := hclsyntax.ParseConfig(file, filename, hcl.Pos{Line: 1, Column: 1})

	return parsedFile, nil
}

func setInputVariablesDefaultValues(filename string) (converter.InputVariableMap, error) {
	parsedFile, err := parseFile(filename)
	if err != nil || parsedFile == nil {
		return nil, err
	}
	content, _, _ := parsedFile.Body.PartialContent(&hcl.BodySchema{
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type:       "variable",
				LabelNames: []string{"name"},
			},
		},
	})
	defaultValuesMap := make(converter.InputVariableMap)
	for _, block := range content.Blocks {
		if len(block.Labels) == 0 || block.Labels[0] == "" {
			continue
		}
		attr, _ := block.Body.JustAttributes()
		if attr == nil || len(attr) == 0 {
			continue
		}
		if defaultValue, exists := attr["default"]; exists {
			defaultVar, _ := defaultValue.Expr.Value(nil)
			defaultValuesMap[block.Labels[0]] = defaultVar
		}
	}
	return defaultValuesMap, nil
}

func checkTfvarsValid(f *hcl.File, filename string) error {
	content, _, _ := f.Body.PartialContent(&hcl.BodySchema{
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type:       "variable",
				LabelNames: []string{"name"},
			},
		},
	})
	if len(content.Blocks) > 0 {
		return fmt.Errorf("failed to get variables from %s, .tfvars file is used to assing values not to declare new variables", filename)
	}
	return nil
}

func getInputVariablesFromFile(filename string) (converter.InputVariableMap, error) {
	parsedFile, err := parseFile(filename)
	if err != nil || parsedFile == nil {
		return nil, err
	}
	err = checkTfvarsValid(parsedFile, filename)
	if err != nil {
		return nil, err
	}

	attrs := parsedFile.Body.(*hclsyntax.Body).Attributes
	variables := make(converter.InputVariableMap)
	for name, attr := range attrs {
		value, _ := attr.Expr.Value(&hcl.EvalContext{})
		variables[name] = value
	}
	return variables, nil
}

func getInputVariables(currentPath string) {
	variablesMap := make(converter.InputVariableMap)
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files")
	}
	for _, tfFile := range tfFiles {
		variables, errDefaultValues := setInputVariablesDefaultValues(tfFile)
		if errDefaultValues != nil {
			log.Error().Msgf("Error getting default values from %s", tfFile)
			log.Err(errDefaultValues)
			continue
		}
		mergeMaps(variablesMap, variables)
	}
	tfVarsFiles, err := filepath.Glob(filepath.Join(currentPath, "*.auto.tfvars"))
	if err != nil {
		log.Error().Msg("Error getting .auto.tfvars files")
	}

	_, err = os.Stat(filepath.Join(currentPath, "terraform.tfvars"))
	if err != nil {
		log.Trace().Msgf("terraform.tfvars not found on %s", currentPath)
	} else {
		tfVarsFiles = append(tfVarsFiles, filepath.Join(currentPath, "terraform.tfvars"))
	}

	for _, tfVarsFile := range tfVarsFiles {
		variables, errInputVariables := getInputVariablesFromFile(tfVarsFile)
		if errInputVariables != nil {
			log.Error().Msgf("Error getting values from %s", tfVarsFiles)
			log.Err(errInputVariables)
			continue
		}
		mergeMaps(variablesMap, variables)
	}
	inputVariableMap["var"] = cty.ObjectVal(variablesMap)
}
