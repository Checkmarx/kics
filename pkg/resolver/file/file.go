package file

import (
	"io/ioutil"
	"os"
	"path/filepath"
)

// Resolver - replace or modifies in-memory content before parsing
type Resolver struct {
	unmarshler    func(fileContent []byte, v any) error
	marshler      func(v any) ([]byte, error)
	ResolvedFiles map[string]ResolvedFile
}

type ResolvedFile struct {
	Path    string
	Content []byte
}

// NewResolver returns a new Resolver
func NewResolver(
	unmarshler func(fileContent []byte, v any) error,
	marshler func(v any) ([]byte, error)) *Resolver {
	return &Resolver{
		unmarshler:    unmarshler,
		marshler:      marshler,
		ResolvedFiles: make(map[string]ResolvedFile),
	}
}

// Resolve - replace or modifies in-memory content before parsing
func (r *Resolver) Resolve(fileContent []byte, path string) *[]byte {
	var obj any
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return &fileContent
	}

	// resolve the paths
	obj, _ = r.walk(obj, path)

	b, err := r.marshler(obj)
	if err != nil {
		return &fileContent
	}

	return &b
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
		if res {
			return val, false
		}
		value[k] = val
	}
	return value, false
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolvePath(value string, filePath string) (any, bool) {
	path := filepath.Join(filepath.Dir(filePath), value)
	_, err := os.Stat(path)
	if err != nil {
		return value, false
	}

	// open the file with the content to replace
	file, err := os.Open(path)
	if err != nil {
		return value, false
	}

	defer file.Close()

	// read the content
	fileContent, err := ioutil.ReadAll(file)
	if err != nil {
		return value, false
	}

	resolvedFile := r.Resolve(fileContent, path)

	// parse the content
	var obj any
	err = r.unmarshler(*resolvedFile, &obj)
	if err != nil {
		return value, false
	}

	r.ResolvedFiles[value] = ResolvedFile{
		Content: fileContent,
		Path:    path,
	}

	return obj, true
}
