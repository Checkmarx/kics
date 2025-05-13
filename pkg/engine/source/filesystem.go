package source

import (
	"encoding/json"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/constants"
	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// FilesystemSource this type defines a struct with a path to a filesystem source of queries
// Source is the path to the queries
// Types are the types given by the flag --type for query selection mechanism
type FilesystemSource struct {
	Source              []string
	Types               []string
	CloudProviders      []string
	Library             string
	ExperimentalQueries bool
}

const (
	// QueryFileName The default query file name
	QueryFileName = "query.rego"
	// MetadataFileName The default metadata file name
	MetadataFileName = "metadata.json"
	// LibrariesDefaultBasePath the path to rego libraries
	LibrariesDefaultBasePath = "./assets/libraries"

	emptyInputData = "{}"

	common = "Common"

	kicsDefault = "default"
)

// NewFilesystemSource initializes a NewFilesystemSource with source to queries and types of queries to load
func NewFilesystemSource(source, types, cloudProviders []string, libraryPath string, experimentalQueries bool) *FilesystemSource {
	log.Debug().Msg("source.NewFilesystemSource()")

	if len(types) == 0 {
		types = []string{""}
	}

	if len(cloudProviders) == 0 {
		cloudProviders = []string{""}
	}

	for s := range source {
		source[s] = filepath.FromSlash(source[s])
	}

	return &FilesystemSource{
		Source:              source,
		Types:               types,
		CloudProviders:      cloudProviders,
		Library:             filepath.FromSlash(libraryPath),
		ExperimentalQueries: experimentalQueries,
	}
}

// ListSupportedPlatforms returns a list of supported platforms
func ListSupportedPlatforms() []string {
	keys := make([]string, len(constants.AvailablePlatforms))
	i := 0
	for k := range constants.AvailablePlatforms {
		keys[i] = k
		i++
	}
	sort.Strings(keys)
	return keys
}

// ListSupportedCloudProviders returns a list of supported cloud providers
func ListSupportedCloudProviders() []string {
	return []string{"alicloud", "aws", "azure", "gcp", "nifcloud", "tencentcloud"}
}

func getLibraryInDir(platform, libraryDirPath string) string {
	var libraryFilePath string
	err := filepath.Walk(libraryDirPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if strings.EqualFold(filepath.Base(path), platform+".rego") { // try to find the library file <platform>.rego
			libraryFilePath = path
		}
		return nil
	})
	if err != nil {
		log.Error().Msgf("Failed to analyze path %s: %s", libraryDirPath, err)
	}
	return libraryFilePath
}

func isDefaultLibrary(libraryPath string) bool {
	return filepath.FromSlash(libraryPath) == filepath.FromSlash(LibrariesDefaultBasePath)
}

// GetPathToCustomLibrary - returns the libraries path for a given platform
func GetPathToCustomLibrary(platform, libraryPathFlag string) string {
	libraryFilePath := kicsDefault

	if !isDefaultLibrary(libraryPathFlag) {
		log.Debug().Msgf("Trying to load custom libraries from %s", libraryPathFlag)

		library := getLibraryInDir(platform, libraryPathFlag)
		// found a library named according to the platform
		if library != "" {
			libraryFilePath = library
		}
	}

	return libraryFilePath
}

// GetQueryLibrary returns the library.rego for the platform passed in the argument
func (s *FilesystemSource) GetQueryLibrary(platform string) (RegoLibraries, error) {
	library := GetPathToCustomLibrary(platform, s.Library)
	customLibraryCode := ""
	customLibraryData := emptyInputData

	if library == "" {
		return RegoLibraries{}, errors.New("unable to get libraries path")
	}

	if library != kicsDefault {
		byteContent, err := os.ReadFile(filepath.Clean(library))
		if err != nil {
			return RegoLibraries{}, err
		}
		customLibraryCode = string(byteContent)
		customLibraryData, err = readInputData(strings.TrimSuffix(library, filepath.Ext(library)) + ".json")
		if err != nil {
			log.Debug().Msg(err.Error())
		}
	} else {
		log.Debug().Msgf("Custom library %s not provided. Loading embedded library instead", platform)
	}
	// getting embedded library
	embeddedLibraryCode, errGettingEmbeddedLibrary := assets.GetEmbeddedLibrary(strings.ToLower(platform))
	if errGettingEmbeddedLibrary != nil {
		return RegoLibraries{}, errGettingEmbeddedLibrary
	}

	mergedLibraryCode, errMergeLibs := mergeLibraries(customLibraryCode, embeddedLibraryCode)
	if errMergeLibs != nil {
		return RegoLibraries{}, errMergeLibs
	}

	embeddedLibraryData, errGettingEmbeddedLibraryCode := assets.GetEmbeddedLibraryData(strings.ToLower(platform))
	if errGettingEmbeddedLibraryCode != nil {
		log.Debug().Msgf("Could not open embedded library data for %s platform", platform)
		embeddedLibraryData = emptyInputData
	}
	mergedLibraryData, errMergingLibraryData := MergeInputData(embeddedLibraryData, customLibraryData)
	if errMergingLibraryData != nil {
		log.Debug().Msgf("Could not merge library data for %s platform", platform)
	}

	regoLibrary := RegoLibraries{
		LibraryCode:      mergedLibraryCode,
		LibraryInputData: mergedLibraryData,
	}
	return regoLibrary, nil
}

// CheckType checks if the queries have the type passed as an argument in '--type' flag to be loaded
func (s *FilesystemSource) CheckType(queryPlatform interface{}) bool {
	if queryPlatform.(string) == common {
		return true
	}
	if s.Types[0] != "" {
		for _, t := range s.Types {
			if strings.EqualFold(t, queryPlatform.(string)) {
				return true
			}
		}
		return false
	}
	return true
}

// CheckCloudProvider checks if the queries have the cloud provider passed as an argument in '--cloud-provider' flag to be loaded
func (s *FilesystemSource) CheckCloudProvider(cloudProvider interface{}) bool {
	if cloudProvider != nil {
		if strings.EqualFold(cloudProvider.(string), common) {
			return true
		}
		if s.CloudProviders[0] != "" {
			return strings.Contains(strings.ToUpper(strings.Join(s.CloudProviders, ",")), strings.ToUpper(cloudProvider.(string)))
		}
	}

	if s.CloudProviders[0] == "" {
		return true
	}

	return false
}

func checkQueryInclude(id interface{}, includedQueries []string) bool {
	queryMetadataKey, ok := id.(string)
	if !ok {
		log.Warn().
			Msgf("Can't cast query metadata key = %v", id)
		return false
	}
	for _, includedQuery := range includedQueries {
		if queryMetadataKey == includedQuery {
			return true
		}
	}
	return false
}

func checkQueryExcludeField(id interface{}, excludeQueries []string) bool {
	queryMetadataKey, ok := id.(string)
	if !ok {
		log.Warn().
			Msgf("Can't cast query metadata key = %v", id)
		return false
	}
	for _, excludedQuery := range excludeQueries {
		if strings.EqualFold(queryMetadataKey, excludedQuery) {
			return true
		}
	}
	return false
}

func checkQueryExclude(metadata map[string]interface{}, queryParameters *QueryInspectorParameters) bool {
	return checkQueryExcludeField(metadata["id"], queryParameters.ExcludeQueries.ByIDs) ||
		checkQueryExcludeField(metadata["category"], queryParameters.ExcludeQueries.ByCategories) ||
		checkQueryExcludeField(metadata["severity"], queryParameters.ExcludeQueries.BySeverities) ||
		(!queryParameters.BomQueries && metadata["severity"] == model.SeverityTrace)
}

// GetQueries walks a given filesource path returns all queries found in an array of
// QueryMetadata struct
func (s *FilesystemSource) GetQueries(queryParameters *QueryInspectorParameters) ([]model.QueryMetadata, error) {
	queryDirs, err := s.iterateSources()
	if err != nil {
		return nil, err
	}

	queries := s.iterateQueryDirs(queryDirs, queryParameters)

	return queries, nil
}

func (s *FilesystemSource) iterateSources() ([]string, error) {
	queryDirs := make([]string, 0)

	for _, source := range s.Source {
		err := filepath.Walk(source,
			func(p string, f os.FileInfo, err error) error {
				if err != nil {
					return err
				}

				if f.IsDir() || f.Name() != QueryFileName {
					return nil
				}

				querypathDir := filepath.Dir(p)

				if err == nil {
					queryDirs = append(queryDirs, querypathDir)
				} else if err != nil {
					return errors.Wrap(err, "Failed to get query relative path")
				}

				return nil
			})
		if err != nil {
			return nil, errors.Wrap(err, "failed to get query Source")
		}
	}

	return queryDirs, nil
}

// iterateQueryDirs iterates all query directories and reads the respective queries
func (s *FilesystemSource) iterateQueryDirs(queryDirs []string, queryParameters *QueryInspectorParameters) []model.QueryMetadata {
	queries := make([]model.QueryMetadata, 0, len(queryDirs))

	for _, queryDir := range queryDirs {
		query, errRQ := ReadQuery(queryDir)
		if errRQ != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Message:  fmt.Sprintf("Query provider failed to read query, query=%s", path.Base(queryDir)),
				Err:      errRQ,
				Location: "func GetQueries()",
				FileName: path.Base(queryDir),
			}, true)
			continue
		}

		if query.Experimental && !queryParameters.ExperimentalQueries {
			continue
		}

		if !s.CheckType(query.Metadata["platform"]) {
			continue
		}

		if !s.CheckCloudProvider(query.Metadata["cloudProvider"]) {
			continue
		}

		customInputData, readInputErr := readInputData(filepath.Join(queryParameters.InputDataPath, query.Metadata["id"].(string)+".json"))
		if readInputErr != nil {
			log.Err(errRQ).
				Msgf("failed to read input data, query=%s", path.Base(queryDir))
			continue
		}

		inputData, mergeError := MergeInputData(query.InputData, customInputData)
		if mergeError != nil {
			log.Err(mergeError).
				Msgf("failed to merge input data, query=%s", path.Base(queryDir))
			continue
		}
		query.InputData = inputData

		if len(queryParameters.IncludeQueries.ByIDs) > 0 {
			if checkQueryInclude(query.Metadata["id"], queryParameters.IncludeQueries.ByIDs) {
				queries = append(queries, query)
			}
		} else {
			if checkQueryExclude(query.Metadata, queryParameters) {
				log.Debug().
					Msgf("Excluding query ID: %s category: %s severity: %s", query.Metadata["id"], query.Metadata["category"], query.Metadata["severity"])
				continue
			}

			queries = append(queries, query)
		}
	}
	return queries
}

// validateMetadata prevents panics when KICS queries metadata fields are missing
func validateMetadata(metadata map[string]interface{}) (exist bool, field string) {
	fields := []string{
		"id",
		"platform",
	}
	for _, field = range fields {
		if _, exist = metadata[field]; !exist {
			return
		}
	}
	return
}

// ReadQuery reads query's files for a given path and returns a QueryMetadata struct with its content
func ReadQuery(queryDir string) (model.QueryMetadata, error) {
	queryContent, err := os.ReadFile(filepath.Clean(path.Join(queryDir, QueryFileName))) //nolint:gosec
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "failed to read query %s", path.Base(queryDir))
	}

	metadata, err := ReadMetadata(queryDir)
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "failed to read query %s", path.Base(queryDir))
	}

	if valid, missingField := validateMetadata(metadata); !valid {
		return model.QueryMetadata{}, fmt.Errorf("failed to read metadata field: %s", missingField)
	}

	platform := getPlatform(metadata["platform"].(string))

	inputData, errInputData := readInputData(filepath.Join(queryDir, "data.json"))
	if errInputData != nil {
		log.Err(errInputData).
			Msgf("Query provider failed to read input data, query=%s", path.Base(queryDir))
	}

	aggregation := 1
	if agg, ok := metadata["aggregation"]; ok {
		aggregation = int(agg.(float64))
	}

	experimental := getExperimental(metadata["experimental"])

	return model.QueryMetadata{
		Query:        path.Base(filepath.ToSlash(queryDir)),
		Content:      string(queryContent),
		Metadata:     metadata,
		Platform:     platform,
		InputData:    inputData,
		Aggregation:  aggregation,
		Experimental: experimental,
	}, nil
}

// ReadMetadata read query's metadata file inside the query directory
func ReadMetadata(queryDir string) (map[string]interface{}, error) {
	f, err := os.Open(filepath.Clean(path.Join(queryDir, MetadataFileName)))
	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  fmt.Sprintf("Queries provider can't read metadata, query=%s", path.Base(queryDir)),
			Err:      err,
			Location: "func ReadMetadata()",
			FileName: path.Base(queryDir),
		}, true)

		return nil, err
	}
	defer func() {
		if err := f.Close(); err != nil {
			log.Err(err).
				Msgf("Queries provider can't close file, file=%s", filepath.Clean(path.Join(queryDir, MetadataFileName)))
		}
	}()

	var metadata map[string]interface{}
	if err := json.NewDecoder(f).Decode(&metadata); err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Message:  fmt.Sprintf("Queries provider can't unmarshal metadata, query=%s", path.Base(queryDir)),
			Err:      err,
			Location: "func ReadMetadata()",
			FileName: path.Base(queryDir),
		}, true)

		return nil, err
	}

	return metadata, nil
}

type supportedPlatforms map[string]string

var supPlatforms = &supportedPlatforms{
	"Ansible":                 "ansible",
	"CloudFormation":          "cloudFormation",
	"Common":                  "common",
	"Crossplane":              "crossplane",
	"Dockerfile":              "dockerfile",
	"DockerCompose":           "dockerCompose",
	"Knative":                 "knative",
	"Kubernetes":              "k8s",
	"OpenAPI":                 "openAPI",
	"Terraform":               "terraform",
	"AzureResourceManager":    "azureResourceManager",
	"GRPC":                    "grpc",
	"GoogleDeploymentManager": "googleDeploymentManager",
	"Buildah":                 "buildah",
	"Pulumi":                  "pulumi",
	"ServerlessFW":            "serverlessFW",
	"CICD":                    "cicd",
}

func getPlatform(metadataPlatform string) string {
	if p, ok := (*supPlatforms)[metadataPlatform]; ok {
		return p
	}
	return "unknown"
}

func getExperimental(experimental interface{}) bool {
	readExperimental, _ := experimental.(string)
	if readExperimental == "true" {
		return true
	} else {
		return false
	}
}

func readInputData(inputDataPath string) (string, error) {
	inputData, err := os.ReadFile(filepath.Clean(inputDataPath))
	if err != nil {
		if os.IsNotExist(err) {
			return emptyInputData, nil
		}
		return emptyInputData, errors.Wrapf(err, "failed to read query input data %s", path.Base(inputDataPath))
	}
	return string(inputData), nil
}
