package file

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/analyzer"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

// ResolvedFile - used for caching the already resolved files
type ResolvedFile struct {
	fileContent        []byte
	resolvedFileObject any
}

// Resolver - replace or modifies in-memory content before parsing
type Resolver struct {
	unmarshler    func(fileContent []byte, v any) error
	marshler      func(v any) ([]byte, error)
	ResolvedFiles map[string]model.ResolvedFile
	Extension     []string
}

// NewResolver returns a new Resolver
func NewResolver(
	unmarshler func(fileContent []byte, v any) error,
	marshler func(v any) ([]byte, error),
	ext []string) *Resolver {
	return &Resolver{
		unmarshler:    unmarshler,
		marshler:      marshler,
		ResolvedFiles: make(map[string]model.ResolvedFile),
		Extension:     ext,
	}
}

func isOpenAPI(fileContent []byte) bool {
	regexToRun :=
		[]*regexp.Regexp{analyzer.OpenAPIRegexInfo,
			analyzer.OpenAPIRegexPath,
			analyzer.OpenAPIRegex}
	for _, regex := range regexToRun {
		if !regex.Match(fileContent) {
			return false
		}
	}
	return true
}

// Resolve - replace or modifies in-memory content before parsing
func (r *Resolver) Resolve(fileContent []byte, path string,
	resolveCount, maxResolverDepth int, resolvedFilesCache map[string]ResolvedFile,
	resolveReferences bool) []byte {
	// handle panic during resolve process
	defer func() {
		if r := recover(); r != nil {
			err := fmt.Errorf("panic: %v", r)
			log.Err(err).Msg("Recovered from panic during resolve of file " + path)
		}
	}()

	if !resolveReferences && isOpenAPI(fileContent) {
		return fileContent
	}

	if utils.Contains(filepath.Ext(path), []string{".yml", ".yaml"}) {
		return r.yamlResolve(fileContent, path, resolveCount, maxResolverDepth, resolvedFilesCache, resolveReferences)
	}
	var obj any
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent
	}

	// resolve the paths
	obj, _ = r.walk(fileContent, obj, obj, path, resolveCount, maxResolverDepth, resolvedFilesCache, false, resolveReferences)

	b, err := json.MarshalIndent(obj, "", "")
	if err == nil {
		return b
	}

	return fileContent
}

func (r *Resolver) walk(
	originalFileContent []byte,
	fullObject interface{},
	value any,
	path string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	refBool, resolveReferences bool) (any, bool) {
	// go over the value and replace paths with the real content
	switch typedValue := value.(type) {
	case string:
		if filepath.Base(path) != typedValue {
			return r.resolvePath(
				originalFileContent, fullObject, typedValue, path, resolveCount,
				maxResolverDepth, resolvedFilesCache, refBool, resolveReferences)
		}
		return value, false
	case []any:
		for i, v := range typedValue {
			typedValue[i], _ = r.walk(
				originalFileContent, fullObject, v, path, resolveCount,
				maxResolverDepth, resolvedFilesCache, refBool, resolveReferences)
		}
		return typedValue, false
	case map[string]any:
		return r.handleMap(
			originalFileContent, fullObject, typedValue, path, resolveCount,
			maxResolverDepth, resolvedFilesCache, resolveReferences)
	default:
		return value, false
	}
}

func (r *Resolver) handleMap(
	originalFileContent []byte,
	fullObject interface{},
	value map[string]interface{},
	path string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	resolveReferences bool,
) (any, bool) {
	for k, v := range value {
		isRef := strings.Contains(strings.ToLower(k), "$ref")
		val, res := r.walk(originalFileContent, fullObject, v, path, resolveCount, maxResolverDepth, resolvedFilesCache, isRef, resolveReferences)
		// check if it is a ref then add new details
		if valMap, ok := val.(map[string]interface{}); (ok || !res) && isRef {
			// Create RefMetadata and add it to the resolved value map
			if valMap == nil {
				valMap = make(map[string]interface{})
			}
			valMap["RefMetadata"] = make(map[string]interface{})
			valMap["RefMetadata"].(map[string]interface{})["$ref"] = v
			valMap["RefMetadata"].(map[string]interface{})["alone"] = len(value) == 1
			return valMap, false
		}
		if isRef && res {
			return val, false
		}
		value[k] = val
	}
	return value, false
}

func (r *Resolver) yamlResolve(fileContent []byte, path string,
	resolveCount, maxResolverDepth int, resolvedFilesCache map[string]ResolvedFile,
	resolveReferences bool) []byte {
	var obj yaml.Node
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent
	}

	fullObjectCopy := obj

	// resolve the paths
	obj, _ = r.yamlWalk(
		fileContent, &fullObjectCopy, &obj, path, resolveCount,
		maxResolverDepth, resolvedFilesCache, false, resolveReferences, false)

	if obj.Kind == 1 && len(obj.Content) == 1 {
		obj = *obj.Content[0]
	}

	b, err := r.marshler(obj)
	if err != nil {
		return fileContent
	}

	return b
}

func (r *Resolver) yamlWalk(
	originalFileContent []byte,
	fullObject *yaml.Node,
	value *yaml.Node,
	path string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	refBool, resolveReferences, ansibleVars bool) (yaml.Node, bool) {
	// go over the value and replace paths with the real content
	switch value.Kind {
	case yaml.ScalarNode:
		if filepath.Base(path) != value.Value {
			return r.resolveYamlPath(originalFileContent, fullObject,
				value, path,
				resolveCount, maxResolverDepth, resolvedFilesCache,
				refBool, resolveReferences, ansibleVars)
		}
		return *value, false
	default:
		refBool := false
		ansibleVars := false
		for i := range value.Content {
			if i >= 1 {
				refBool = strings.Contains(value.Content[i-1].Value, "$ref")
				ansibleVars = strings.Contains(value.Content[i-1].Value, "include_vars")
			}
			resolved, ok := r.yamlWalk(originalFileContent, fullObject,
				value.Content[i], path,
				resolveCount, maxResolverDepth, resolvedFilesCache,
				refBool, resolveReferences, ansibleVars)

			if i >= 1 && refBool && (resolved.Kind == yaml.MappingNode || !ok) {
				// Create RefMetadata and add it to yaml Node
				if !ok {
					resolved = yaml.Node{
						Kind: yaml.MappingNode,
					}
				}
				originalValueNode := &yaml.Node{
					Kind:  yaml.ScalarNode,
					Value: "$ref",
				}
				refAloneKeyNode := &yaml.Node{
					Kind:  yaml.ScalarNode,
					Value: "alone",
				}
				refAloneValueNode := &yaml.Node{
					Kind:  yaml.ScalarNode,
					Value: strconv.FormatBool(len(value.Content) == 2),
				}
				refMetadataKeyNode := &yaml.Node{
					Kind:  yaml.ScalarNode,
					Value: "RefMetadata",
				}
				refMetadataValueNode := &yaml.Node{
					Kind: yaml.MappingNode,
				}
				refMetadataValueNode.Content = append(refMetadataValueNode.Content,
					originalValueNode, value.Content[i], refAloneKeyNode, refAloneValueNode)
				resolved.Content = append(resolved.Content, refMetadataKeyNode, refMetadataValueNode)

				return resolved, false
			}
			value.Content[i] = &resolved
		}
		return *value, false
	}
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolveYamlPath(
	originalFileContent []byte,
	fullObject *yaml.Node,
	v *yaml.Node,
	filePath string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	refBool, resolveReferences, ansibleVars bool) (yaml.Node, bool) {
	value := v.Value
	if resolveCount >= maxResolverDepth || (strings.HasPrefix(value, "#") && !refBool) || (value == "#" && refBool) {
		return *v, false
	}
	var splitPath []string
	var obj *yaml.Node
	sameFileResolve := false
	if strings.HasPrefix(value, "#") { // same file resolve
		sameFileResolve = true
		path := filePath + value
		splitPath = strings.Split(path, "#") // splitting by removing the section to look for in the file
		obj = fullObject
	} else { // external file resolve
		value = checkServerlessFileReference(value)

		exists, path, onlyFilePath, filename := findFilePath(filepath.Dir(filePath), value, ansibleVars, r.Extension)
		if !exists {
			return *v, false
		}

		// Check if file has already been resolved, if not resolve it and save it for future references
		if _, ok := resolvedFilesCache[filename]; !ok {
			if ret, isError := r.resolveFile(
				value, onlyFilePath, resolveCount, maxResolverDepth,
				resolvedFilesCache, true, resolveReferences); isError {
				if retYaml, yamlNode := ret.(yaml.Node); yamlNode {
					return retYaml, false
				} else {
					return *v, false
				}
			}
		}

		r.ResolvedFiles[getPathFromString(value)] = model.ResolvedFile{
			Content:      resolvedFilesCache[filename].fileContent,
			Path:         path,
			LinesContent: utils.SplitLines(string(resolvedFilesCache[filename].fileContent)),
		}

		node, _ := resolvedFilesCache[filename].resolvedFileObject.(yaml.Node)
		obj = &node

		if strings.Contains(strings.ToLower(value), "!ref") { // Cloudformation !Ref check
			return *obj, false
		}
		if !strings.Contains(path, "#") {
			return *obj, true
		}
	}

	return r.returnResolveYamlPathValue(splitPath, sameFileResolve, filePath, originalFileContent, obj, v)
}

func (r *Resolver) returnResolveYamlPathValue(
	splitPath []string,
	sameFileResolve bool,
	filePath string,
	originalFileContent []byte,
	obj, v *yaml.Node) (yaml.Node, bool) {
	if len(splitPath) > 1 {
		if sameFileResolve {
			r.ResolvedFiles[filePath] = model.ResolvedFile{
				Content:      originalFileContent,
				Path:         filePath,
				LinesContent: utils.SplitLines(string(originalFileContent)),
			}
		}
		section, err := findSectionYaml(obj, splitPath[1])
		// Check if there was an error finding the section or if the reference is circular
		if err == nil && !checkIfCircularYaml(v.Value, &section) {
			return section, true
		}
	}
	return *v, false
}

func (r *Resolver) resolveFile(
	value string,
	filePath string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	yamlResolve, resolveReferences bool) (any, bool) {
	// open the file with the content to replace
	file, err := os.Open(filepath.Clean(filePath))
	if err != nil {
		return value, true
	}

	defer func(file *os.File) {
		err = file.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close resolved file: %s", filePath)
		}
	}(file)
	// read the content
	fileContent, _ := io.ReadAll(file)

	resolvedFile := r.Resolve(fileContent, filePath, resolveCount+1, maxResolverDepth, resolvedFilesCache, resolveReferences)

	if yamlResolve {
		var obj yaml.Node

		err = r.unmarshler(resolvedFile, &obj) // parse the content
		if err != nil {
			return value, true
		}

		if obj.Kind == 1 && len(obj.Content) == 1 {
			obj = *obj.Content[0]
		}

		resolvedFilesCache[filePath] = ResolvedFile{fileContent, obj}
	} else {
		var obj any
		err = r.unmarshler(resolvedFile, &obj) // parse the content
		if err != nil {
			return value, true
		}

		resolvedFilesCache[filePath] = ResolvedFile{fileContent, obj}
	}

	return nil, false
}

func getPathFromString(path string) string {
	lastIndex := strings.LastIndex(path, "#")
	if lastIndex == -1 {
		return path
	}
	return path[:lastIndex]
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolvePath(
	originalFileContent []byte,
	fullObject interface{},
	value, filePath string,
	resolveCount, maxResolverDepth int,
	resolvedFilesCache map[string]ResolvedFile,
	refBool bool, resolveReferences bool) (any, bool) {
	if resolveCount >= maxResolverDepth || (strings.HasPrefix(value, "#") && !refBool) || (value == "#" && refBool) {
		return value, false
	}
	var splitPath []string
	var obj any
	sameFileResolve := false
	if strings.HasPrefix(value, "#") { // same file resolve
		sameFileResolve = true
		path := filePath + value
		splitPath = strings.Split(path, "#") // splitting by removing the section to look for in the file
		obj = fullObject
	} else { // external file resolve
		path := filepath.Join(filepath.Dir(filePath), value)
		splitPath = strings.Split(path, "#") // splitting by removing the section to look for in the file

		// index 0 contains the path of the file while the other indexes contain the sections (e.g. path = "./definitions.json#User/schema")
		onlyFilePath := splitPath[0]
		_, err := os.Stat(onlyFilePath)

		if err != nil || !contains(filepath.Ext(onlyFilePath), r.Extension) {
			return value, false
		}

		// Check if file has already been resolved, if not resolve it and save it for future references
		if _, ok := resolvedFilesCache[onlyFilePath]; !ok {
			if ret, isError := r.resolveFile(
				value, onlyFilePath, resolveCount, maxResolverDepth,
				resolvedFilesCache, false, resolveReferences); isError {
				return ret, false
			}
		}

		r.ResolvedFiles[getPathFromString(value)] = model.ResolvedFile{
			Content:      resolvedFilesCache[onlyFilePath].fileContent,
			Path:         path,
			LinesContent: utils.SplitLines(string(resolvedFilesCache[onlyFilePath].fileContent)),
		}

		obj = resolvedFilesCache[onlyFilePath].resolvedFileObject

		// Cloudformation !Ref check
		if strings.Contains(strings.ToLower(value), "!ref") || len(splitPath) == 1 {
			return obj, false
		}
	}
	return r.resolvePathReturnValue(value, filePath, splitPath, sameFileResolve, originalFileContent, obj)
}

func (r *Resolver) resolvePathReturnValue(
	value, filePath string,
	splitPath []string,
	sameFileResolve bool,
	originalFileContent []byte,
	obj any) (any, bool) {
	if len(splitPath) > 1 {
		if sameFileResolve {
			r.ResolvedFiles[filePath] = model.ResolvedFile{
				Content:      originalFileContent,
				Path:         filePath,
				LinesContent: utils.SplitLines(string(originalFileContent)),
			}
		}
		section, err := findSection(obj, splitPath[1])
		// Check if there was an error finding the section or if the reference is circular
		if err != nil || checkIfCircular(value, section) {
			return value, false
		}
		if sectionMap, ok := section.(map[string]interface{}); ok {
			newSectionMap := make(map[string]interface{})
			for k, v := range sectionMap {
				newSectionMap[k] = v
			}
			section = newSectionMap
		}

		return section, true
	}
	return value, false
}

func findSectionYaml(object *yaml.Node, sectionsString string) (yaml.Node, error) {
	object = object.Content[0]
	sectionsString = strings.ReplaceAll(sectionsString, "\\", "/")
	sections := strings.Split(sectionsString[1:], "/")
	for _, section := range sections {
		found := false
		for index, node := range object.Content {
			if node.Value == section {
				object = object.Content[index+1]
				found = true
				break
			}
		}
		if !found {
			return *object, errors.New("section not present in file")
		}
	}
	return *object, nil
}

func checkIfCircularYaml(circularValue string, yamlSection *yaml.Node) bool {
	if len(yamlSection.Content) == 0 {
		return false
	}
	for index := 0; index < len(yamlSection.Content)-1; index += 1 {
		// if there is a reference to the same value that was resolved it is a circular definition
		if yamlSection.Content[index].Value == "$ref" && yamlSection.Content[index+1].Value == circularValue {
			return true
		} else if checkIfCircularYaml(circularValue, yamlSection.Content[index]) {
			return true
		}
	}
	return checkIfCircularYaml(circularValue, yamlSection.Content[len(yamlSection.Content)-1])
}

func findSection(object interface{}, sectionsString string) (interface{}, error) {
	sectionsString = strings.ReplaceAll(sectionsString, "\\", "/")
	sections := strings.Split(sectionsString[1:], "/")
	for _, section := range sections {
		if sectionObjectTemp, ok := object.(map[string]interface{}); ok {
			if sectionObject, ok := sectionObjectTemp[section]; ok {
				object = sectionObject
			} else {
				return object, errors.New("section not present in file")
			}
		} else {
			return object, errors.New("section not of map type")
		}
	}
	return object, nil
}

func checkIfCircular(circularValue string, section interface{}) bool {
	sectionAsMap, okMap := section.(map[string]interface{})
	sectionAsList, okList := section.([]interface{})
	if !okList && !okMap {
		return false
	}
	if okMap {
		for key, val := range sectionAsMap {
			// if there is a reference to the same value that was resolved it is a circular definition
			if key == "$ref" && val == circularValue {
				return true
			} else if checkIfCircular(circularValue, val) {
				return true
			}
		}
	} else {
		for _, listSection := range sectionAsList {
			if checkIfCircular(circularValue, listSection) {
				return true
			}
		}
	}
	return false
}

func contains(elem string, list []string) bool {
	for _, e := range list {
		if elem == e {
			return true
		}
	}
	return false
}

func checkServerlessFileReference(value string) string {
	re := regexp.MustCompile(`^\${file\((.*\.(yaml|yml))\)}$`)
	matches := re.FindStringSubmatch(value)
	if len(matches) > 1 {
		return matches[1]
	}
	return value
}

func findFilePath(
	folderPath, filename string,
	ansibleVars bool,
	extensions []string) (exists bool, path, onlyFilePath, cleanFilePath string) {
	path = filepath.Join(folderPath, filename)
	if ansibleVars {
		if exists, ansibleVarsPath := findAnsibleVarsPath(folderPath, filename); !exists {
			return false, "", "", ""
		} else {
			path = ansibleVarsPath
		}
	} else if _, err := os.Stat(path); err != nil {
		return false, "", "", ""
	}

	if !contains(filepath.Ext(path), extensions) {
		return false, "", "", ""
	}

	onlyFilePath = getPathFromString(path)
	return true, path, onlyFilePath, filepath.Clean(onlyFilePath)
}

func findAnsibleVarsPath(folderPath, filename string) (exists bool, ansibleVarsPath string) {
	possiblePaths := []string{
		filepath.Join(folderPath, "vars", filename),
		filepath.Join(folderPath, filename),
	}

	for _, path := range possiblePaths {
		if _, err := os.Stat(path); err == nil {
			return true, path
		}
	}

	return false, ""
}
