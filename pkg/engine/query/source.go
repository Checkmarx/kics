package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
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

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	files, err := ioutil.ReadDir(s.Source)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	queries := make([]model.QueryMetadata, 0, len(files))
	for _, f := range files {
		if strings.HasSuffix(f.Name(), queryExtension) {
			query, errRQ := ReadQuery(s.Source, f.Name())
			if errRQ != nil {
				log.Err(errRQ).
					Str("fileName", f.Name()).
					Msgf("failed to read query %s", f.Name())

				continue
			}

			queries = append(queries, query)
		}
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
				Str("fileName", queryName).
				Msgf("metadata for query '%s' doesn't exist", queryName)

			return nil
		}

		log.Err(err).
			Str("fileName", queryName).
			Msgf("can't read metadata for query '%s'", queryName)

		return nil
	}

	var metadata map[string]interface{}
	if err := json.NewDecoder(f).Decode(&metadata); err != nil {
		log.Err(err).
			Str("fileName", queryName).
			Msgf("can't json decode metadata for query '%s'", queryName)

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
