package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const queryExtension = ".rego"
const metadataFileSuffix = ".metadata.json"

type FilesystemSource struct {
	Source string
}

type info struct {
	dir  string
	file os.FileInfo
}

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	infos := make([]info, 0)
	err := filepath.Walk(s.Source,
		func(p string, f os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if f.IsDir() || !strings.HasSuffix(f.Name(), queryExtension) {
				return nil
			}

			infos = append(infos, info{
				dir:  path.Dir(p),
				file: f,
			})
			return nil
		})
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	queries := make([]model.QueryMetadata, 0, len(infos))
	for _, info := range infos {
		query, errRQ := ReadQuery(info.dir, info.file.Name())
		if errRQ != nil {
			log.Err(errRQ).
				Msgf("Query provider failed to read query, query=%s", info.file.Name())

			continue
		}

		queries = append(queries, query)
	}

	return queries, err
}

func ReadQuery(source, queryName string) (model.QueryMetadata, error) {
	queryContent, err := ioutil.ReadFile(path.Join(source, queryName))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "metadata not found %s", queryName)
	}

	filer := getQueryFilter(string(queryContent))
	metadata := readMetadata(source, queryName)

	return model.QueryMetadata{
		FileName: queryName,
		Content:  string(queryContent),
		Filter:   filer,
		Metadata: metadata,
	}, nil
}

func readMetadata(source, queryName string) map[string]interface{} {
	fileName := strings.Replace(queryName, queryExtension, metadataFileSuffix, 1)
	f, err := os.Open(path.Join(source, fileName))
	if err != nil {
		if os.IsNotExist(err) {
			log.Warn().
				Msgf("Queries provider can't find metadata, query=%s", queryName)

			return nil
		}

		log.Err(err).
			Msgf("Queries provider can't read metadata, query=%s", queryName)

		return nil
	}

	var metadata map[string]interface{}
	if err := json.NewDecoder(f).Decode(&metadata); err != nil {
		log.Err(err).
			Msgf("Queries provider can't unmarshal metadata, query=%s", queryName)

		return nil
	}

	return metadata
}

func getQueryFilter(query string) string {
	var re = regexp.MustCompile(`^SupportedResources\s*=\s*"([^"]+)"\s*$`)

	match := re.FindStringSubmatch(query)
	if match != nil {
		return match[1]
	}

	return "$"
}
