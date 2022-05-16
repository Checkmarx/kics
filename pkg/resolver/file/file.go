package file

import (
	"io/ioutil"
	"os"
	"path/filepath"
)

// Resolver - replace or modifies in-memory content before parsing
type Resolver struct {
	unmarshler func(fileContent []byte, v interface{}) error
	marshler   func(v interface{}) ([]byte, error)
	filepath   string
}

// NewResolver returns a new Resolver
func NewResolver(
	filepath string,
	unmarshler func(fileContent []byte, v interface{}) error,
	marshler func(v interface{}) ([]byte, error)) *Resolver {
	return &Resolver{
		unmarshler: unmarshler,
		marshler:   marshler,
		filepath:   filepath,
	}
}

// Resolve - replace or modifies in-memory content before parsing
func (r *Resolver) Resolve(fileContent []byte) *[]byte {
	var obj interface{}
	err := r.unmarshler(fileContent, &obj)
	if err != nil {
		return &fileContent
	}

	// resolve the paths
	obj = r.walk(&obj)

	b, err := r.marshler(obj)
	if err != nil {
		return &fileContent
	}

	return &b
}

func (r *Resolver) walk(value interface{}) interface{} {
	// go over the value and replace paths with the real content
	switch typedValue := value.(type) {
	case string:
		return r.resolvePath(typedValue)
	case []interface{}:
		for i, v := range typedValue {
			typedValue[i] = r.walk(v)
		}
		return typedValue
	case map[string]interface{}:
		for k, v := range typedValue {
			typedValue[k] = r.walk(v)
		}
		return typedValue
	case interface{}:
		return typedValue
	}

	return value
}

// isPath returns true if the value is a valid path
func (r *Resolver) resolvePath(value string) interface{} {
	path := filepath.Join(filepath.Dir(r.filepath), value)
	_, err := os.Stat(path)
	if err != nil {
		return value
	}

	// open the file with the content to replace
	file, err := os.Open(path)
	if err != nil {
		return value
	}

	defer file.Close()

	// read the content
	fileContent, err := ioutil.ReadAll(file)
	if err != nil {
		return value
	}

	// parse the content
	var obj interface{}
	err = r.unmarshler(fileContent, &obj)
	if err != nil {
		return value
	}

	return obj
}
