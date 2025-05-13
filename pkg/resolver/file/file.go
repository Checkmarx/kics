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

	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/analyzer"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
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

type ResolvingStatus struct {
	CurrentDepth          int
	MaxDepth              int
	ResolvedFilesCache    map[string]ResolvedFile
	CurrentResolutionPath []string
	ResolveReferences     bool
}

func (r *ResolvingStatus) checkCircularPath(filePath string) bool {
	if len(r.CurrentResolutionPath) != 0 {
		for _, path := range r.CurrentResolutionPath {
			if path == filePath {
				return true
			}
		}
	}
	return false
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
// returns the resolved file content, and a boolean indicating if the file can be cached
func (r *Resolver) Resolve(fileContent []byte, path string, resolvingStatus ResolvingStatus) ([]byte, bool) {
	// handle panic during resolve process
	defer func() {
		if r := recover(); r != nil {
			err := fmt.Errorf("panic: %v", r)
			log.Err(err).Msg("Recovered from panic during resolve of file " + path)
		}
	}()

	if !resolvingStatus.ResolveReferences && isOpenAPI(fileContent) {
		return fileContent, true
	}

	if utils.Contains(filepath.Ext(path), []string{".yml", ".yaml"}) {
		return r.yamlResolve(fileContent, path, resolvingStatus)
	}
	var obj any
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent, true
	}

	// resolve the paths
	obj, _, canBeCached := r.walk(fileContent, obj, obj, path, resolvingStatus, false)

	b, err := json.MarshalIndent(obj, "", "")
	if err == nil {
		return b, true
	}

	return fileContent, canBeCached
}

func (r *Resolver) walk(
	originalFileContent []byte,
	fullObject interface{},
	value any,
	path string,
	resolvingStatus ResolvingStatus,
	refBool bool) (_ any, validOpenAPISectionRef, canBeCached bool) {
	// go over the value and replace paths with the real content
	switch typedValue := value.(type) {
	case string:
		// check if the value is not the same as the path - avoid direct cycle
		if filepath.Base(path) != filepath.Clean(typedValue) {
			return r.resolvePath(originalFileContent, fullObject, typedValue, path, resolvingStatus, refBool)
		}
		return value, false, true
	case []any:
		canBeCachedAll := true
		for i, v := range typedValue {
			var itemCacheable bool
			typedValue[i], _, itemCacheable = r.walk(
				originalFileContent, fullObject, v, path, resolvingStatus, refBool)
			if !itemCacheable {
				canBeCachedAll = false
			}
		}
		return typedValue, false, canBeCachedAll
	case map[string]any:
		return r.handleMap(
			originalFileContent, fullObject, typedValue, path, resolvingStatus)
	default:
		return value, false, true
	}
}

func (r *Resolver) handleMap(
	originalFileContent []byte,
	fullObject interface{},
	value map[string]interface{},
	path string,
	resolvingStatus ResolvingStatus,
) (_ any, validOpenAPISectionRef, canBeCached bool) {
	canBeCachedAll := true
	for k, v := range value {
		isRef := strings.Contains(strings.ToLower(k), constants.Reference)
		val, res, itemCanBeCached := r.walk(originalFileContent, fullObject, v, path, resolvingStatus, isRef)

		if !itemCanBeCached {
			canBeCachedAll = false
		}

		// check if it is a ref then add new details
		if valMap, ok := val.(map[string]interface{}); (ok || !res) && isRef {
			// Create RefMetadata and add it to the resolved value map
			if valMap == nil {
				valMap = make(map[string]interface{})
			}
			valMap["RefMetadata"] = map[string]interface{}{
				constants.Reference: v,
				"alone":             len(value) == 1,
			}
			return valMap, false, canBeCachedAll
		}

		if isRef {
			return val, false, true
		}
		value[k] = val
	}

	return value, false, canBeCachedAll
}

func (r *Resolver) yamlResolve(fileContent []byte, path string, resolvingStatus ResolvingStatus) ([]byte, bool) {
	var obj yaml.Node
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent, true
	}

	fullObjectCopy := obj

	// resolve the paths
	obj, _, canBeCached := r.yamlWalk(fileContent, &fullObjectCopy, &obj, path, resolvingStatus, false, false)
	if obj.Kind == 1 && len(obj.Content) == 1 {
		obj = *obj.Content[0]
	}

	b, err := r.marshler(obj)
	if err != nil {
		return fileContent, true
	}

	return b, canBeCached
}

func (r *Resolver) yamlWalk(
	originalFileContent []byte,
	fullObject *yaml.Node,
	value *yaml.Node,
	path string,
	resolvingStatus ResolvingStatus,
	refBool, ansibleVars bool) (_ yaml.Node, validOpenAPISectionRef, canBeCached bool) {
	// go over the value and replace paths with the real content
	switch value.Kind {
	case yaml.ScalarNode:
		// check if the value is not the same as the path - avoid direct cycle
		if filepath.Base(path) != filepath.Clean(value.Value) {
			return r.resolveYamlPath(originalFileContent, fullObject,
				value, path, resolvingStatus,
				refBool, ansibleVars)
		}
		return *value, false, true
	default:
		refBool := false
		ansibleVars := false
		for i := range value.Content {
			if i >= 1 {
				refBool = strings.Contains(value.Content[i-1].Value, constants.Reference)
				ansibleVars = strings.Contains(value.Content[i-1].Value, "include_vars")
			}
			resolved, ok, canBeCached := r.yamlWalk(originalFileContent, fullObject,
				value.Content[i], path, resolvingStatus, refBool, ansibleVars)

			if i >= 1 && refBool && (resolved.Kind == yaml.MappingNode || !ok) {
				// Create RefMetadata and add it to yaml Node
				if !ok {
					resolved = yaml.Node{
						Kind: yaml.MappingNode,
					}
				}
				originalValueNode := &yaml.Node{
					Kind:  yaml.ScalarNode,
					Value: constants.Reference,
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

				return resolved, false, canBeCached
			}
			value.Content[i] = &resolved
		}
		return *value, false, true
	}
}

//nolint:gocyclo
func (r *Resolver) resolveYamlPath(
	originalFileContent []byte, fullObject *yaml.Node,
	v *yaml.Node, filePath string,
	resolvingStatus ResolvingStatus,
	refBool, ansibleVars bool,
) (_ yaml.Node, validOpenAPISectionRef, canBeCached bool) {
	var splitPath []string
	var obj *yaml.Node
	var sameFileResolve bool
	value := v.Value

	if resolvingStatus.CurrentDepth >= resolvingStatus.MaxDepth ||
		(strings.HasPrefix(value, "#") && !refBool) ||
		(value == "#" && refBool) {
		return *v, false, true
	}

	// same file resolve openAPI
	// e.g. #/components/schemas/User
	if strings.HasPrefix(value, "#") {
		sameFileResolve = true
		path := filePath + value

		// splitting by removing the section to look for in the file
		// index 0 contains the path of the file while the other indexes contain the sections
		// e.g. ./definitions.json#User/schema
		splitPath = strings.Split(path, "#")
		obj = fullObject
	} else { // external file resolve
		value = checkServerlessFileReference(value)

		exists, path, onlyFilePath, filename := findFilePath(filepath.Dir(filePath), value, ansibleVars, r.Extension)
		if !exists {
			return *v, false, true
		}

		canBeCached := true // track if the file can be cached - resolution broken by circular reference won't be cached

		// Check if file has already been resolved, if not resolve it and save it for future references
		if _, ok := resolvingStatus.ResolvedFilesCache[filename]; !ok {
			// check circular reference before resolving the file
			if checkCircularReference(filepath.Clean(filePath), filename, &resolvingStatus) {
				return *v, false, false
			}

			ret, isError, canBeCachedFromResolve := r.resolveFile(value, onlyFilePath, resolvingStatus, true)
			if isError {
				if retYaml, yamlNode := ret.(yaml.Node); yamlNode {
					return retYaml, false, canBeCachedFromResolve
				} else {
					return *v, false, canBeCachedFromResolve
				}
			} else if !canBeCachedFromResolve { // if the file can be cached
				canBeCached = canBeCachedFromResolve
			}
		}

		if canBeCached {
			r.ResolvedFiles[getPathFromString(value)] = model.ResolvedFile{
				Content:      resolvingStatus.ResolvedFilesCache[filename].fileContent,
				Path:         path,
				LinesContent: utils.SplitLines(string(resolvingStatus.ResolvedFilesCache[filename].fileContent)),
			}
		}

		node, _ := resolvingStatus.ResolvedFilesCache[filename].resolvedFileObject.(yaml.Node)
		obj = &node

		if strings.Contains(strings.ToLower(value), "!ref") { // Cloudformation !Ref check
			return *obj, false, canBeCached
		}
		if !strings.Contains(path, "#") { // is not OpenAPI section
			// Clear ResolvedFilesCache to force re-resolution of all files
			for key := range resolvingStatus.ResolvedFilesCache {
				delete(resolvingStatus.ResolvedFilesCache, key)
			}
			return *obj, true, canBeCached
		}
	}

	return r.returnResolveYamlPathValue(splitPath, sameFileResolve, filePath, originalFileContent, obj, v)
}

func checkCircularReference(currentFilePath, path string, rStatus *ResolvingStatus) bool {
	if currentFilePath == path { // direct cyclic reference
		return false
	} else if rStatus.checkCircularPath(path) { // check for circular reference
		return true
	}
	// add the current file to the resolution path to check for circular reference
	rStatus.CurrentResolutionPath = append(rStatus.CurrentResolutionPath, currentFilePath)
	return false
}

func (r *Resolver) returnResolveYamlPathValue(
	splitPath []string,
	sameFileResolve bool,
	filePath string,
	originalFileContent []byte,
	obj, v *yaml.Node) (_ yaml.Node, validOpenAPISectionRef, canBeCached bool) {
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
			return section, true, true
		}
	}
	return *v, false, true
}

func (r *Resolver) resolveFile(
	value string,
	filePath string,
	resolvingStatus ResolvingStatus,
	yamlResolve bool) (_ any, isError, canBeCached bool) {
	// open the file with the content to replace
	file, err := os.Open(filepath.Clean(filePath))
	if err != nil {
		return value, true, false
	}

	defer func(file *os.File) {
		err = file.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close resolved file: %s", filePath)
		}
	}(file)
	// read the content
	fileContent, _ := io.ReadAll(file)

	resolvingStatus.CurrentDepth++
	resolvedFile, canBeCached := r.Resolve(fileContent, filePath, resolvingStatus)

	if yamlResolve {
		var obj yaml.Node

		err = r.unmarshler(resolvedFile, &obj) // parse the content
		if err != nil {
			return value, true, false
		}

		if obj.Kind == 1 && len(obj.Content) == 1 {
			obj = *obj.Content[0]
		}

		if canBeCached { // the file may not be cached if it is a circular reference
			resolvingStatus.ResolvedFilesCache[filePath] = ResolvedFile{fileContent, obj}
		}
	} else {
		var obj any
		err = r.unmarshler(resolvedFile, &obj) // parse the content
		if err != nil {
			return value, true, true
		}

		resolvingStatus.ResolvedFilesCache[filePath] = ResolvedFile{fileContent, obj}
	}

	return nil, false, true
}

func getPathFromString(path string) string {
	lastIndex := strings.LastIndex(path, "#")
	if lastIndex == -1 {
		return path
	}
	return path[:lastIndex]
}

//nolint:gocyclo
func (r *Resolver) resolvePath(
	originalFileContent []byte,
	fullObject interface{},
	value, filePath string,
	resolvingStatus ResolvingStatus, refBool bool,
) (_ any, validOpenAPISectionRef, canBeCached bool) {
	var splitPath []string
	var obj any
	var sameFileResolve bool

	if resolvingStatus.CurrentDepth >= resolvingStatus.MaxDepth ||
		(strings.HasPrefix(value, "#") && !refBool) ||
		(value == "#" && refBool) {
		return value, false, true
	}

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
			return value, false, true
		}

		canBeCached := true // track if the file can be cached - resolution broken by circular reference won't be cached
		// Check if file has already been resolved, if not resolve it and save it for future references
		if _, ok := resolvingStatus.ResolvedFilesCache[onlyFilePath]; !ok {
			if checkCircularReference(filepath.Clean(filePath), onlyFilePath, &resolvingStatus) {
				return value, false, false
			}

			ret, isError, canBeCachedFromResolve := r.resolveFile(value, onlyFilePath, resolvingStatus, false)
			if isError {
				return ret, false, canBeCachedFromResolve
			}
			canBeCached = canBeCachedFromResolve
		}

		if canBeCached {
			r.ResolvedFiles[getPathFromString(value)] = model.ResolvedFile{
				Content:      resolvingStatus.ResolvedFilesCache[onlyFilePath].fileContent,
				Path:         path,
				LinesContent: utils.SplitLines(string(resolvingStatus.ResolvedFilesCache[onlyFilePath].fileContent)),
			}
		}

		obj = resolvingStatus.ResolvedFilesCache[onlyFilePath].resolvedFileObject

		// Cloudformation !Ref check
		if strings.Contains(strings.ToLower(value), "!ref") || len(splitPath) == 1 {
			// Clear ResolvedFilesCache to force re-resolution of all files
			for key := range resolvingStatus.ResolvedFilesCache {
				delete(resolvingStatus.ResolvedFilesCache, key)
			}
			return obj, false, canBeCached
		}
	}
	return r.resolvePathReturnValue(value, filePath, splitPath, sameFileResolve, originalFileContent, obj, resolvingStatus.MaxDepth)
}

func (r *Resolver) resolvePathReturnValue(
	value, filePath string,
	splitPath []string,
	sameFileResolve bool,
	originalFileContent []byte,
	obj any,
	maxResolverDepth int) (_ any, validOpenAPISectionRef, canBeCached bool) {
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
		if err != nil || checkIfCircular(value, section, maxResolverDepth) {
			return value, false, true
		}
		if sectionMap, ok := section.(map[string]interface{}); ok {
			newSectionMap := make(map[string]interface{})
			for k, v := range sectionMap {
				newSectionMap[k] = v
			}
			section = newSectionMap
		}

		return section, true, true
	}
	return value, false, true
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
		if yamlSection.Content[index].Value == constants.Reference && yamlSection.Content[index+1].Value == circularValue {
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

func checkIfCircular(circularValue string, section interface{}, maxResolverDepth int) bool {
	if maxResolverDepth > 0 {
		sectionAsMap, okMap := section.(map[string]interface{})
		sectionAsList, okList := section.([]interface{})
		if !okList && !okMap {
			return false
		}
		if okMap {
			for key, val := range sectionAsMap {
				// if there is a reference to the same value that was resolved it is a circular definition
				if key == constants.Reference && val == circularValue {
					return true
				} else if checkIfCircular(circularValue, val, maxResolverDepth-1) {
					return true
				}
			}
		} else {
			for _, listSection := range sectionAsList {
				if checkIfCircular(circularValue, listSection, maxResolverDepth-1) {
					return true
				}
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
