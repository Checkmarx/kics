package terraform

import (
	"fmt"
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

func extractLocalDependencies(expr hclsyntax.Expression) []string {
	var deps []string

	hclsyntax.VisitAll(expr, func(node hclsyntax.Node) hcl.Diagnostics {
		if traversal, ok := node.(*hclsyntax.ScopeTraversalExpr); ok {
			if len(traversal.Traversal) > 0 {
				if root, ok := traversal.Traversal[0].(hcl.TraverseRoot); ok {
					if root.Name == "local" && len(traversal.Traversal) > 1 {
						if attr, ok := traversal.Traversal[1].(hcl.TraverseAttr); ok {
							deps = append(deps, attr.Name)
						}
					}
				}
			}
		}
		return nil
	})

	return deps
}

func topologicalSort(graph map[string][]string) ([]string, error) {
	visited := make(map[string]bool)
	recStack := make(map[string]bool)
	var result []string

	var visit func(string) error
	visit = func(node string) error {
		// Check if a node is currently in the recursion stack
		if recStack[node] {
			return fmt.Errorf("cycle detected in locals: local.%s", node)
		}

		// Check if a node has already been visited
		// If not in the recursion stack, we already visited it and skip
		if visited[node] {
			return nil
		}

		// Currently visiting a node
		recStack[node] = true
		for _, dep := range graph[node] {
			if _, exists := graph[dep]; exists {
				if err := visit(dep); err != nil {
					return err
				}
			}
		}

		// Visited the node and dependencies are resolved
		// Remove from recursion stack and mark as visited
		recStack[node] = false
		visited[node] = true
		result = append(result, node)
		return nil
	}

	for node := range graph {
		if !visited[node] {
			if err := visit(node); err != nil {
				return nil, err
			}
		}
	}

	return result, nil
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

	// Collect all locals attributes with duplicate detection
	allLocalsAttrs := make(map[string]*hclsyntax.Attribute)

	for _, tfFile := range tfFiles {
		fileLocals, errExtract := extractLocalsFromFile(tfFile)
		if errExtract != nil {
			log.Error().Msgf("Error extracting locals from %s", tfFile)
			log.Err(errExtract)
			continue
		}

		// Check for duplicate local values
		for name, attr := range fileLocals {
			if existing, exists := allLocalsAttrs[name]; exists {
				log.Error().Msgf("Duplicate local value definition: A local value named '%s' was already defined at %s. Local value names must be unique within a module.",
					name, existing.NameRange.Filename)
				return localsMap, fmt.Errorf("duplicate local value definition: %s", name)
			}
			allLocalsAttrs[name] = attr
		}
	}

	if len(allLocalsAttrs) == 0 {
		return localsMap, nil
	}

	// Build dependency graph
	depGraph := make(map[string][]string)
	for name, attr := range allLocalsAttrs {
		depGraph[name] = extractLocalDependencies(attr.Expr)
	}

	// Topological sort with cycle detection
	evalOrder, err := topologicalSort(depGraph)
	if err != nil {
		log.Error().Msgf("Cycle in locals at %s: %v", currentPath, err)
		return localsMap, err
	}

	// Evaluate in dependency order
	for _, name := range evalOrder {
		attr := allLocalsAttrs[name]
		value, success := evaluateLocal(attr, localsMap)
		if !success {
			log.Warn().Msgf("Could not evaluate local.%s (missing references or evaluation error)", name)
			localsMap[name] = cty.StringVal("${local." + name + "}")
		} else {
			localsMap[name] = value
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
