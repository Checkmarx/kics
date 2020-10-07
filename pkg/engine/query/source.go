package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const queryFileName = "query.rego"
const metadataFileName = "metadata.json"

type FilesystemSource struct {
	Source string
}

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	queryDirs := make([]string, 0)
	err := filepath.Walk(s.Source,
		func(p string, f os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if f.IsDir() || f.Name() != queryFileName {
				return nil
			}

			queryDirs = append(queryDirs, path.Dir(p))
			return nil
		})
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	queries := make([]model.QueryMetadata, 0, len(queryDirs))
	for _, queryDir := range queryDirs {
		query, errRQ := ReadQuery(queryDir)
		if errRQ != nil {
			log.Err(errRQ).
				Msgf("Query provider failed to read query, query=%s", path.Base(queryDir))

			continue
		}

		queries = append(queries, query)
	}

	return queries, err
}

func ReadQuery(queryDir string) (model.QueryMetadata, error) {
	queryContent, err := ioutil.ReadFile(path.Join(queryDir, queryFileName))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "metadata not found %s", path.Base(queryDir))
	}

	metadata := readMetadata(queryDir)

	return model.QueryMetadata{
		Query:    path.Base(queryDir),
		Content:  string(queryContent),
		Metadata: metadata,
	}, nil
}

func readMetadata(queryDir string) map[string]interface{} {
	f, err := os.Open(path.Join(queryDir, metadataFileName))
	if err != nil {
		if os.IsNotExist(err) {
			log.Warn().
				Msgf("Queries provider can't find metadata, query=%s", path.Base(queryDir))

			return nil
		}

		log.Err(err).
			Msgf("Queries provider can't read metadata, query=%s", path.Base(queryDir))

		return nil
	}

	var metadata map[string]interface{}
	if err := json.NewDecoder(f).Decode(&metadata); err != nil {
		log.Err(err).
			Msgf("Queries provider can't unmarshal metadata, query=%s", path.Base(queryDir))

		return nil
	}

	return metadata
}
