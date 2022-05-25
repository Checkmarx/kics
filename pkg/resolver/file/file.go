package file

import (
	"io"
	"os"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

// Resolver - replace or modifies in-memory content before parsing
type Resolver struct {
	unmarshler    func(fileContent []byte, v any) error
	marshler      func(v any) ([]byte, error)
	ResolvedFiles map[string]model.ResolvedFile
}

// NewResolver returns a new Resolver
func NewResolver(
	unmarshler func(fileContent []byte, v any) error,
	marshler func(v any) ([]byte, error)) *Resolver {
	return &Resolver{
		unmarshler:    unmarshler,
		marshler:      marshler,
		ResolvedFiles: make(map[string]model.ResolvedFile),
	}
}

// Resolve - replace or modifies in-memory content before parsing
func (r *Resolver) Resolve(fileContent []byte, path string) []byte {
	var obj any
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return fileContent
	}

	// resolve the paths
	obj, _ = r.walk(obj, path)

	b, err := r.marshler(obj)
	if err != nil {
		return fileContent
	}

	return b
}

func (r *Resolver) walk(value any, path string) (any, bool) {
	// go over the value and replace paths with the real content
	switch typedValue := value.(type) {
	case string:
		return r.resolvePath(typedValue, path)
	case []any:
		for i, v := range typedValue {
			typedValue[i], _ = r.walk(v, path)
		}
		return typedValue, false
	case map[string]any:
		return r.handleMap(typedValue, path)
	default:
		return value, false
	}
}

func (r *Resolver) handleMap(value map[string]interface{}, path string) (any, bool) {
	for k, v := range value {
		val, res := r.walk(v, path)
		// check if it is a ref than everything needs to be changed
		if res && strings.Contains(strings.ToLower(k), "ref") {
			return val, false
		}
		value[k] = val
	}
	return value, false
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolvePath(value, filePath string) (any, bool) {
	path := filepath.Join(filepath.Dir(filePath), value)
	_, err := os.Stat(path)
	if err != nil {
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

	resolvedFile := r.Resolve(fileContent, path)

	// parse the content
	var obj any
	err = r.unmarshler(resolvedFile, &obj)
	if err != nil {
		return value, false
	}

	r.ResolvedFiles[value] = model.ResolvedFile{
		Content: fileContent,
		Path:    path,
	}

	// Cloudformation !Ref check
	if strings.Contains(strings.ToLower(value), "!ref") {
		return obj, false
	}

	return obj, true
}
