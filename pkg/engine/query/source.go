package query

import (
	"io/ioutil"
	"path"
	"regexp"
	"strings"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
)

const queryExtension = ".q"

type FilesystemSource struct {
	source string
}

func NewFilesystemSource(source string) *FilesystemSource {
	return &FilesystemSource{
		source: source,
	}
}

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	files, err := ioutil.ReadDir(s.source)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query source")
	}

	metadatas := make([]model.QueryMetadata, 0, len(files))
	for _, f := range files {
		if strings.HasSuffix(f.Name(), queryExtension) {
			qCode, errReadFile := ioutil.ReadFile(path.Join(s.source, f.Name()))
			if errReadFile != nil {
				return nil, errors.Wrap(errReadFile, "failed to get query source")
			}

			metadatas = append(metadatas, model.QueryMetadata{
				FileName: f.Name(),
				Content:  string(qCode),
				Filter:   getQueryFilter(string(qCode)),
			})
		}
	}

	return metadatas, err
}

func getQueryFilter(query string) string {
	var re = regexp.MustCompile(`\n#CxPragma:\s*"([^"]+)"\s*\n`)

	match := re.FindStringSubmatch(query)
	if match != nil {
		return match[1]
	}

	return "$"
}
