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
	Source string
}

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	files, err := ioutil.ReadDir(s.Source)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	metadatas := make([]model.QueryMetadata, 0, len(files))
	for _, f := range files {
		if strings.HasSuffix(f.Name(), queryExtension) {
			qCode, errReadFile := ioutil.ReadFile(path.Join(s.Source, f.Name()))
			if errReadFile != nil {
				return nil, errors.Wrap(errReadFile, "failed to get query Source")
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
