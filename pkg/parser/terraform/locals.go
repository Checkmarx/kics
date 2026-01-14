package terraform

import (
	"maps"
	"path/filepath"
	"sync"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"

	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/converter"
	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/functions"
)

// Cache for directory-level locals resolution
var (
	localsCache      = make(map[string]converter.VariableMap)
	localsCacheMutex sync.RWMutex
)

// extractLocalsFromFile extracts all locals blocks from a single .tf file
func extractLocalsFromFile(filename string) (map[string]*hclsyntax.Attribute, error) {
	localsAttrs := make(map[string]*hclsyntax.Attribute)

	parsedFile, err := parseFile(filename, false)
	if err != nil || parsedFile == nil {
		return nil, err
	}

	body, ok := parsedFile.Body.(*hclsyntax.Body)
	if !ok {
		return localsAttrs, nil
	}

	// Extract all locals blocks from this file
	for _, block := range body.Blocks {
		if block.Type == "locals" {
			maps.Copy(localsAttrs, block.Body.Attributes)
		}
	}

	return localsAttrs, nil
}

func evaluateLocal(attr *hclsyntax.Attribute, localsMap converter.VariableMap) (cty.Value, bool) {
	evalCtx := &hcl.EvalContext{
		Variables: make(map[string]cty.Value),
		Functions: functions.TerraformFuncs,
	}

	maps.Copy(evalCtx.Variables, inputVariableMap)

	if len(localsMap) > 0 {
		evalCtx.Variables["local"] = cty.ObjectVal(localsMap)
	}

	value, diags := attr.Expr.Value(evalCtx)
	if diags.HasErrors() {
		return cty.NilVal, false
	}

	return value, true
}

// buildLocalsForDirectory scans all .tf files in a directory once and builds the complete locals map
func buildLocalsForDirectory(currentPath string) (converter.VariableMap, error) {
	localsMap := make(converter.VariableMap)

	// Get all .tf files in the directory
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files")
		return localsMap, err
	}

	if len(tfFiles) == 0 {
		return localsMap, nil
	}

	// collect all locals attributes from all files in the directory
	allLocalsAttrs := make(map[string]*hclsyntax.Attribute)

	for _, tfFile := range tfFiles {
		fileLocals, errExtract := extractLocalsFromFile(tfFile)
		if errExtract != nil {
			log.Error().Msgf("Error extracting locals from %s", tfFile)
			log.Err(errExtract)
			continue
		}

		maps.Copy(allLocalsAttrs, fileLocals)
	}

	if len(allLocalsAttrs) == 0 {
		return localsMap, nil
	}

	// Locals can reference other locals, so we evaluate in multiple passes
	maxIterations := len(allLocalsAttrs) + 1
	evaluated := make(map[string]bool)

	for range maxIterations {
		madeProgress := false

		for name, attr := range allLocalsAttrs {
			if evaluated[name] {
				continue
			}

			value, success := evaluateLocal(attr, localsMap)
			if !success {
				continue
			}

			localsMap[name] = value
			evaluated[name] = true
			madeProgress = true
		}

		if len(evaluated) == len(allLocalsAttrs) {
			break
		}

		// No progress made - circular dependencies or missing references
		if !madeProgress {
			// Store unevaluated locals as placeholders
			for name := range allLocalsAttrs {
				if !evaluated[name] {
					log.Debug().Msgf("Could not evaluate local.%s in %s", name, currentPath)
					localsMap[name] = cty.StringVal("${local." + name + "}")
				}
			}
			break
		}
	}

	return localsMap, nil
}

// getLocals extracts locals from all .tf files in the directory and caches the result
func getLocals(currentPath string) {
	localsCacheMutex.RLock()
	if cachedLocals, exists := localsCache[currentPath]; exists {
		localsCacheMutex.RUnlock()
		if len(cachedLocals) > 0 {
			inputVariableMap["local"] = cty.ObjectVal(cachedLocals)
		}
		return
	}
	localsCacheMutex.RUnlock()

	// Cache miss - build locals for this directory
	localsMap, err := buildLocalsForDirectory(currentPath)
	if err != nil {
		log.Error().Msgf("Error building locals for directory %s: %v", currentPath, err)
		return
	}

	localsCacheMutex.Lock()
	localsCache[currentPath] = localsMap
	localsCacheMutex.Unlock()

	if len(localsMap) > 0 {
		inputVariableMap["local"] = cty.ObjectVal(localsMap)
	}
}
