package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// FilesystemSource this type defines a struct with a path to a filesystem source of queries
type FilesystemSource struct {
	Source string
}

const (
	// The default query file name
	QueryFileName   = "query.rego"
	libraryFileName = "library.rego"
	// The default metadata file name
	MetadataFileName  = "metadata.json"
	librariesBasePath = "./assets/libraries/"
)

var (
	currentWorkdir, _ = os.Getwd()
	libraryPath       = filepath.Join(currentWorkdir, librariesBasePath)
)

func getPathToLibrary(platform string) string {
	if strings.Contains(platform, "ansible") {
		return filepath.FromSlash(libraryPath + "/ansible/" + libraryFileName)
	} else if strings.Contains(platform, "cloudformation") {
		return filepath.FromSlash(libraryPath + "/cloudformation/" + libraryFileName)
	} else if strings.Contains(platform, "dockerfile") {
		return filepath.FromSlash(libraryPath + "/dockerfile/" + libraryFileName)
	} else if strings.Contains(platform, "k8s") {
		return filepath.FromSlash(libraryPath + "/k8s/" + libraryFileName)
	} else if strings.Contains(platform, "terraform") {
		return filepath.FromSlash(libraryPath + "/terraform/" + libraryFileName)
	}

	return filepath.FromSlash(libraryPath + "/common/" + libraryFileName)
}

// GetGenericQuery returns the library.rego for the platform passed in the argument
func (s *FilesystemSource) GetGenericQuery(platform string) (string, error) {
	pathToLib := getPathToLibrary(platform)
	content, err := ioutil.ReadFile(pathToLib)

	if err != nil {
		log.Err(err)
	}

	return string(content), err
}

// GetQueries walks a given filesource path returns all queries found in an array of
// QueryMetadata struct
func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	queryDirs := make([]string, 0)
	err := filepath.Walk(s.Source,
		func(p string, f os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if f.IsDir() || f.Name() != QueryFileName {
				return nil
			}

			queryDirs = append(queryDirs, filepath.Dir(p))
			return nil
		})
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	queries := make([]model.QueryMetadata, 0, len(queryDirs))
	for _, queryDir := range queryDirs {
		query, errRQ := ReadQuery(queryDir)
		if errRQ != nil {
			sentry.CaptureException(errRQ)
			log.Err(errRQ).
				Msgf("Query provider failed to read query, query=%s", path.Base(queryDir))

			continue
		}

		queries = append(queries, query)
	}

	return queries, err
}

// ReadQuery reads query's files for a given path and returns a QueryMetadata struct with it's
// content
func ReadQuery(queryDir string) (model.QueryMetadata, error) {
	queryContent, err := ioutil.ReadFile(path.Join(queryDir, QueryFileName))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "failed to read query %s", path.Base(queryDir))
	}

	metadata := ReadMetadata(queryDir)
	platform := getPlatform(queryDir)

	return model.QueryMetadata{
		Query:    path.Base(queryDir),
		Content:  string(queryContent),
		Metadata: metadata,
		Platform: platform,
	}, nil
}

// ReadMetadata read query's metadata file inside the query directory
func ReadMetadata(queryDir string) map[string]interface{} {
	f, err := os.Open(path.Join(queryDir, MetadataFileName))
	if err != nil {
		sentry.CaptureException(err)
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
		sentry.CaptureException(err)
		log.Err(err).
			Msgf("Queries provider can't unmarshal metadata, query=%s", path.Base(queryDir))

		return nil
	}

	return metadata
}

func getPlatform(queryPath string) string {
	if strings.Contains(queryPath, "commonQuery") {
		return "commonQuery"
	} else if strings.Contains(queryPath, "ansible") {
		return "ansible"
	} else if strings.Contains(queryPath, "cloudFormation") {
		return "cloudFormation"
	} else if strings.Contains(queryPath, "dockerfile") {
		return "dockerfile"
	} else if strings.Contains(queryPath, "k8s") {
		return "k8s"
	} else if strings.Contains(queryPath, "terraform") {
		return "terraform"
	}

	return "unknown"
}
