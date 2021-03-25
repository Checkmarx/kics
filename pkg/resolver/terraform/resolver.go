package terraform

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
)

// Resolver is an instance of the terraform resolver
type Resolver struct {
}

type InputVariableMap map[string]hclsyntax.Expression

func getInputVariables(currentPath string) (InputVariableMap, error) {
	terraformFilepath := filepath.Join(currentPath, "terraform.tfvars")
	file, err := os.ReadFile(terraformFilepath)
	if err != nil {
		return nil, err
	}
	var f *hcl.File
	if strings.HasSuffix(terraformFilepath, ".json") {
		// f, _ = hcljson.Parse(file, terraformFilepath)
		if f == nil || f.Body == nil {
			return nil, nil
		}
	} else {
		f, _ = hclsyntax.ParseConfig(file, terraformFilepath, hcl.Pos{Line: 1, Column: 1})
		if f == nil || f.Body == nil {
			return nil, nil
		}
	}

	err = checkTfvarsValid(f, terraformFilepath)
	if err != nil {
		return nil, err
	}

	attrs := f.Body.(*hclsyntax.Body).Attributes
	variables := make(InputVariableMap)
	for name, attr := range attrs {
		variables[name] = attr.Expr
	}
	return variables, nil
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

// Resolve will replace terraform variables and return its content ready for parsing
func (r *Resolver) Resolve(filePath string) (model.ResolvedFiles, error) {
	var rfiles = model.ResolvedFiles{}
	return rfiles, nil
}

// SupportedTypes returns the supported fileKinds for this resolver
func (r *Resolver) SupportedTypes() []model.FileKind {
	return []model.FileKind{model.KindTerraform}
}
