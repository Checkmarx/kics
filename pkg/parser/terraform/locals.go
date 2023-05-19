package terraform

import (
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/parser/terraform/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
)

func setLocalsValues(filename string) (converter.VariableMap, error) {
	parsedFile, err := parseFile(filename, false)
	if err != nil || parsedFile == nil {
		return nil, err
	}
	content, _, _ := parsedFile.Body.PartialContent(&hcl.BodySchema{
		Blocks: []hcl.BlockHeaderSchema{
			{
				Type: "locals",
			},
		},
	})

	localValuesMap := make(converter.VariableMap)
	for _, block := range content.Blocks {
		if block.Body == nil {
			continue
		}
		attr, _ := block.Body.JustAttributes()
		if len(attr) == 0 {
			continue
		}
		for _, attribute := range attr {
			localValue, _ := attribute.Expr.Value(nil)
			localValuesMap[attribute.Name] = localValue
		}
	}
	return localValuesMap, nil
}

func getLocals(currentPath string, referencedVariablesMap converter.VariableMap) {
	localsMap := make(converter.VariableMap)
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files")
	}
	for _, tfFile := range tfFiles {
		variables, errDefaultValues := setLocalsValues(tfFile)
		if errDefaultValues != nil {
			log.Error().Msgf("Error getting default values from %s", tfFile)
			log.Err(errDefaultValues)
			continue
		}
		mergeMaps(localsMap, variables)
	}

	referencedVariablesMap["local"] = cty.ObjectVal(localsMap)
}
