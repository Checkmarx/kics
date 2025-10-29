package terraform

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"sync"

	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/converter"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
)

var inputVariableMap = make(converter.VariableMap)

// Cache for directory-level variable resolution
var (
	variableCache      = make(map[string]converter.VariableMap)
	variableCacheMutex sync.RWMutex
	cacheStats         = struct {
		hits   int
		misses int
	}{}
)

func mergeMaps(baseMap, newItems converter.VariableMap) {
	for key, value := range newItems {
		baseMap[key] = value
	}
}

func setInputVariablesDefaultValues(filename string) (converter.VariableMap, error) {
	parsedFile, err := parseFile(filename, false)
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

	defaultValuesMap := make(converter.VariableMap)
	for _, block := range content.Blocks {
		if len(block.Labels) == 0 || block.Labels[0] == "" {
			continue
		}
		attr, _ := block.Body.JustAttributes()
		if len(attr) == 0 {
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

func getInputVariablesFromFile(filename string) (converter.VariableMap, error) {
	parsedFile, err := parseFile(filename, false)
	if err != nil || parsedFile == nil {
		return nil, err
	}
	err = checkTfvarsValid(parsedFile, filename)
	if err != nil {
		return nil, err
	}

	attrs := parsedFile.Body.(*hclsyntax.Body).Attributes
	variables := make(converter.VariableMap)
	for name, attr := range attrs {
		value, _ := attr.Expr.Value(&hcl.EvalContext{})
		variables[name] = value
	}
	return variables, nil
}

// buildVariablesForDirectory scans a directory once and builds the complete variable map
func buildVariablesForDirectory(currentPath, terraformVarsPath string) (converter.VariableMap, error) {
	variablesMap := make(converter.VariableMap)

	// Get all .tf files
	tfFiles, err := filepath.Glob(filepath.Join(currentPath, "*.tf"))
	if err != nil {
		log.Error().Msg("Error getting .tf files")
		return variablesMap, err
	}

	log.Debug().Msgf("[CACHE] Building variable cache for directory %s with %d .tf files", currentPath, len(tfFiles))

	// Process all .tf files for default values
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
			log.Error().Msgf("Error getting values from %s", tfVarsFile)
			log.Err(errInputVariables)
			continue
		}
		mergeMaps(variablesMap, variables)
	}

	// Process custom terraform vars path if provided
	if terraformVarsPath != "" {
		_, err = os.Stat(terraformVarsPath)
		if err != nil {
			log.Trace().Msgf("%s file not found", terraformVarsPath)
		} else {
			variables, errInputVariables := getInputVariablesFromFile(terraformVarsPath)
			if errInputVariables != nil {
				log.Error().Msgf("Error getting values from %s", terraformVarsPath)
				log.Err(errInputVariables)
			} else {
				mergeMaps(variablesMap, variables)
			}
		}
	}

	return variablesMap, nil
}

// getInputVariables now uses caching to avoid rescanning directories
func getInputVariables(currentPath, fileContent, terraformVarsPath string) {
	// Extract terraform vars path from file content if not provided
	if terraformVarsPath == "" {
		terraformVarsPathRegex := regexp.MustCompile(`(?m)^\s*// kics_terraform_vars: ([\w/\\.:-]+)\r?\n`)
		terraformVarsPathMatch := terraformVarsPathRegex.FindStringSubmatch(fileContent)
		if terraformVarsPathMatch != nil {
			terraformVarsPath = terraformVarsPathMatch[1]
			if !strings.Contains(terraformVarsPath, ":") {
				terraformVarsPath = filepath.Join(currentPath, terraformVarsPath)
			}
		}
	}

	// Create a cache key that includes the custom vars path if provided
	cacheKey := currentPath
	if terraformVarsPath != "" {
		cacheKey = currentPath + "|" + terraformVarsPath
	}

	// Try to get from cache first
	variableCacheMutex.RLock()
	if cachedVars, exists := variableCache[cacheKey]; exists {
		variableCacheMutex.RUnlock()
		cacheStats.hits++
		log.Debug().Msgf("[CACHE HIT] Using cached variables for %s (hits: %d, misses: %d)",
			currentPath, cacheStats.hits, cacheStats.misses)
		inputVariableMap["var"] = cty.ObjectVal(cachedVars)
		return
	}
	variableCacheMutex.RUnlock()

	// Cache miss - build variables for this directory
	cacheStats.misses++
	log.Debug().Msgf("[CACHE MISS] Building variables for %s (hits: %d, misses: %d)",
		currentPath, cacheStats.hits, cacheStats.misses)

	variablesMap, err := buildVariablesForDirectory(currentPath, terraformVarsPath)
	if err != nil {
		log.Error().Msgf("Error building variables for directory %s: %v", currentPath, err)
		return
	}

	// Store in cache
	variableCacheMutex.Lock()
	variableCache[cacheKey] = variablesMap
	variableCacheMutex.Unlock()

	inputVariableMap["var"] = cty.ObjectVal(variablesMap)

	// Log cache efficiency periodically
	if (cacheStats.hits+cacheStats.misses)%100 == 0 {
		hitRate := float64(cacheStats.hits) / float64(cacheStats.hits+cacheStats.misses) * 100
		log.Info().Msgf("[CACHE STATS] Hit rate: %.2f%% (hits: %d, misses: %d, cache size: %d)",
			hitRate, cacheStats.hits, cacheStats.misses, len(variableCache))
	}
}
