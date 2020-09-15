package query

import (
	"io/ioutil"
	"path"
	"regexp"
	"strings"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const queryExtension = ".rego"
const metadataFileSuffix = ".metadata.json"
const metadataPlaceholder = "#{metadata}"

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
					Msg("failed to read query file")

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

	metadataFileName := strings.Replace(queryName, queryExtension, metadataFileSuffix, 1)
	metadataContent, err := ioutil.ReadFile(path.Join(source, metadataFileName))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "metadata not found %s", metadataFileName)
	}

	formattedMetadata, err := formatMetadata(string(metadataContent))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrap(err, "failed to format metadata")
	}

	queryContentWithMetadata := strings.ReplaceAll(string(queryContent), metadataPlaceholder, formattedMetadata)

	return model.QueryMetadata{
		FileName: queryName,
		Content:  queryContentWithMetadata,
		Filter:   getQueryFilter(string(queryContent)),
	}, nil
}

func formatMetadata(content string) (string, error) {
	lines := strings.Split(content, "\n")

	return strings.Join(lines[1:len(lines)-1], "\n"), nil
}

func getQueryFilter(query string) string {
	var re = regexp.MustCompile(`^SupportedResources\s*=\s*"([^"]+)"\s*$`)

	match := re.FindStringSubmatch(query)
	if match != nil {
		return match[1]
	}

	return "$"
}
