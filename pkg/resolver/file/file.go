package file

import (
	"io"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/Checkmarx/kics/internal/constants"
	"gopkg.in/yaml.v3"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/utils"
	"github.com/rs/zerolog/log"
)

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

// Resolve - replace or modifies in-memory content before parsing
func (r *Resolver) Resolve(fileContent []byte, path string, resolveCount int) []byte {
	if utils.Contains(filepath.Ext(path), []string{".yml", ".yaml"}) {
		return r.yamlResolve(fileContent, path, resolveCount)
	}
	var obj any
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent
	}

	// resolve the paths
	obj, _ = r.walk(obj, path, resolveCount)

	b, err := r.marshler(obj)
	if err != nil {
		return fileContent
	}

	return b
}

func (r *Resolver) walk(value any, path string, resolveCount int) (any, bool) {
	// go over the value and replace paths with the real content
	switch typedValue := value.(type) {
	case string:
		if filepath.Base(path) != typedValue {
			return r.resolvePath(typedValue, path, resolveCount)
		}
		return value, false
	case []any:
		for i, v := range typedValue {
			typedValue[i], _ = r.walk(v, path, resolveCount)
		}
		return typedValue, false
	case map[string]any:
		return r.handleMap(typedValue, path, resolveCount)
	default:
		return value, false
	}
}

func (r *Resolver) handleMap(value map[string]interface{}, path string, resolveCount int) (any, bool) {
	for k, v := range value {
		val, res := r.walk(v, path, resolveCount)
		// check if it is a ref than everything needs to be changed
		if res && strings.Contains(strings.ToLower(k), "ref") {
			return val, false
		}
		value[k] = val
	}
	return value, false
}

func (r *Resolver) yamlResolve(fileContent []byte, path string, resolveCount int) []byte {
	var obj yaml.Node
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent
	}

	// resolve the paths
	obj, _ = r.yamlWalk(&obj, path, resolveCount)

	if obj.Kind == 1 && len(obj.Content) == 1 {
		obj = *obj.Content[0]
	}

	b, err := r.marshler(obj)
	if err != nil {
		return fileContent
	}

	return b
}

func (r *Resolver) yamlWalk(value *yaml.Node, path string, resolveCount int) (yaml.Node, bool) {
	// go over the value and replace paths with the real conten
	switch value.Kind {
	case yaml.ScalarNode:
		if filepath.Base(path) != value.Value {
			return r.resolveYamlPath(value, path, resolveCount)
		}
		return *value, false
	default:
		for i := range value.Content {
			resolved, ok := r.yamlWalk(value.Content[i], path, resolveCount)
			if ok && i >= 1 {
				if strings.Contains(value.Content[i-1].Value, "ref") { // openapi
					return resolved, false
				}
			}
			value.Content[i] = &resolved
		}
		return *value, false
	}
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolveYamlPath(v *yaml.Node, filePath string, resolveCount int) (yaml.Node, bool) {
	value := v.Value
	if resolveCount > constants.MaxResolvedFiles {
		return *v, false
	}

	value = checkServerlessFileReference(value)

	path := filepath.Join(filepath.Dir(filePath), value)
	_, err := os.Stat(path)
	if err != nil {
		return *v, false
	}

	if !contains(filepath.Ext(path), r.Extension) {
		return *v, false
	}

	// open the file with the content to replace
	file, err := os.Open(filepath.Clean(path))
	if err != nil {
		return *v, false
	}

	defer func(file *os.File) {
		err = file.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close resolved file: %s", path)
		}
	}(file)

	// read the content
	fileContent, err := io.ReadAll(file)
	if err != nil {
		return *v, false
	}

	resolvedFile := r.Resolve(fileContent, path, resolveCount+1)

	// parse the content
	var obj yaml.Node
	err = r.unmarshler(resolvedFile, &obj)
	if err != nil {
		return *v, false
	}

	if obj.Kind == 1 && len(obj.Content) == 1 {
		obj = *obj.Content[0]
	}

	r.ResolvedFiles[value] = model.ResolvedFile{
		Content:      fileContent,
		Path:         path,
		LinesContent: utils.SplitLines(string(fileContent)),
	}

	// Cloudformation !Ref check
	if strings.Contains(strings.ToLower(value), "!ref") {
		return obj, false
	}

	return obj, true
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolvePath(value, filePath string, resolveCount int) (any, bool) {
	if resolveCount > constants.MaxResolvedFiles {
		return value, false
	}
	path := filepath.Join(filepath.Dir(filePath), value)
	_, err := os.Stat(path)
	if err != nil {
		return value, false
	}

	if !contains(filepath.Ext(path), r.Extension) {
		return value, false
	}

	// open the file with the content to replace
	file, err := os.Open(filepath.Clean(path))
	if err != nil {
		return value, false
	}

	defer func(file *os.File) {
		err = file.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close resolved file: %s", path)
		}
	}(file)
	// read the content
	fileContent, err := io.ReadAll(file)
	if err != nil {
		return value, false
	}

	resolvedFile := r.Resolve(fileContent, path, resolveCount+1)

	// parse the content
	var obj any
	err = r.unmarshler(resolvedFile, &obj)
	if err != nil {
		return value, false
	}

	r.ResolvedFiles[value] = model.ResolvedFile{
		Content:      fileContent,
		Path:         path,
		LinesContent: utils.SplitLines(string(fileContent)),
	}
	// Cloudformation !Ref check
	if strings.Contains(strings.ToLower(value), "!ref") {
		return obj, false
	}
	return obj, true
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
