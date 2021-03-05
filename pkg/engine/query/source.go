package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// FilesystemSource this type defines a struct with a path to a filesystem source of queries
// Source is the path to the queries
// Types are the types given by the flag --type for query selection mechanism
type FilesystemSource struct {
	Source         string
	Types          []string
	ExcludeQueries []string
}

const (
	// QueryFileName The default query file name
	QueryFileName = "query.rego"
	// MetadataFileName The default metadata file name
	MetadataFileName = "metadata.json"
	// LibraryFileName The default library file name
	LibraryFileName = "library.rego"
	// LibrariesDefaultBasePath the path to rego libraries
	LibrariesDefaultBasePath = "./assets/libraries/"
)

var (
	supportedPlatforms = map[string]string{
		"Ansible":        "ansible",
		"CloudFormation": "cloudformation",
		"Dockerfile":     "dockerfile",
		"Kubernetes":     "k8s",
		"Terraform":      "terraform",
	}
)

// NewFilesystemSource initializes a NewFilesystemSource with source to queries and types of queries to load
func NewFilesystemSource(source string, types []string) *FilesystemSource {
	if len(types) == 0 {
		types = []string{""}
	}
	return &FilesystemSource{
		Source: filepath.FromSlash(source),
		Types:  types,
	}
}

// ListSupportedPlatforms returns a list of supported platforms
func ListSupportedPlatforms() []string {
	keys := make([]string, len(supportedPlatforms))
	i := 0
	for k := range supportedPlatforms {
		keys[i] = k
		i++
	}
	sort.Strings(keys)
	return keys
}

// GetPathToLibrary returns the libraries path for a given platform
func GetPathToLibrary(platform, relativeBasePath string) string {
	var libraryPath string
	if strings.LastIndex(relativeBasePath, filepath.FromSlash("/queries")) > -1 {
		libraryPath = relativeBasePath[:strings.LastIndex(relativeBasePath, filepath.FromSlash("/queries"))] + filepath.FromSlash("/libraries")
	} else {
		libraryPath = filepath.Join(relativeBasePath, LibrariesDefaultBasePath)
	}

	libraryFilePath := filepath.FromSlash(libraryPath + "/common/" + LibraryFileName)

	for _, supPlatform := range supportedPlatforms {
		if strings.Contains(strings.ToUpper(platform), strings.ToUpper(supPlatform)) {
			libraryFilePath = filepath.FromSlash(libraryPath + "/" + supPlatform + "/" + LibraryFileName)
			break
		}
	}

	return libraryFilePath
}

// GetGenericQuery returns the library.rego for the platform passed in the argument
func (s *FilesystemSource) GetGenericQuery(platform string) (string, error) {
	pathToLib := GetPathToLibrary(platform, s.Source)

	content, err := ioutil.ReadFile(filepath.Clean(pathToLib))
	if err != nil {
		log.Err(err)
	}

	return string(content), err
}

// CheckType checks if the queries have the type passed as an argument in '--type' flag to be loaded
func (s *FilesystemSource) CheckType(queryPlatform interface{}) bool {
	if queryPlatform.(string) == "Common" {
		return true
	}
	if s.Types[0] != "" {
		return strings.Contains(strings.ToUpper(strings.Join(s.Types, ",")), strings.ToUpper(queryPlatform.(string)))
	}
	return true
}

func checkQueryExclude(id interface{}, excludeQueries []string) bool {
	queryID := id.(string)
	for _, excludeID := range excludeQueries {
		if queryID == excludeID {
			return true
		}
	}
	return false
}

// GetQueries walks a given filesource path returns all queries found in an array of
// QueryMetadata struct
func (s *FilesystemSource) GetQueries(excludeQueries []string) ([]model.QueryMetadata, error) {
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

		if !s.CheckType(query.Metadata["platform"]) {
			continue
		}
		if checkQueryExclude(query.Metadata["id"], excludeQueries) {
			continue
		}

		queries = append(queries, query)
	}

	return queries, err
}

// ReadQuery reads query's files for a given path and returns a QueryMetadata struct with it's
// content
func ReadQuery(queryDir string) (model.QueryMetadata, error) {
	queryContent, err := ioutil.ReadFile(filepath.Clean(path.Join(queryDir, QueryFileName)))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "failed to read query %s", path.Base(queryDir))
	}

	metadata := ReadMetadata(queryDir)
	platform := getPlatform(queryDir)

	aggregation := 1
	if agg, ok := metadata["aggregation"]; ok {
		aggregation = int(agg.(float64))
	}

	return model.QueryMetadata{
		Query:       path.Base(filepath.ToSlash(queryDir)),
		Content:     string(queryContent),
		Metadata:    metadata,
		Platform:    platform,
		Aggregation: aggregation,
	}, nil
}

// ReadMetadata read query's metadata file inside the query directory
func ReadMetadata(queryDir string) map[string]interface{} {
	f, err := os.Open(filepath.Clean(path.Join(queryDir, MetadataFileName)))
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
	if strings.Contains(queryPath, "common") {
		return "common"
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
