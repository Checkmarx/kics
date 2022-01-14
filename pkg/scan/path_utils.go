package scan

import (
	"fmt"
	"os"
	"regexp"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

var terraformerRegex = regexp.MustCompile(`^terraformer::`)

func (c *Client) prepareAndAnalyzePaths() (provider.ExtractedPath, error) {
	err := c.preparePaths()
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	regularPaths, terraformerPaths := extractPathType(c.ScanParams.Path)

	terraformerExPaths, err := provider.GetTerraformerSources(terraformerPaths, c.ScanParams.OutputPath)
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	regularExPaths, err := provider.GetSources(regularPaths)
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	allPaths := combinePaths(terraformerExPaths, regularExPaths)

	pathTypes, errAnalyze :=
		analyzePaths(
			allPaths.Path,
			c.ScanParams.Platform,
			c.ScanParams.ExcludePaths,
		)
	if errAnalyze != nil {
		return provider.ExtractedPath{}, errAnalyze
	}

	if len(pathTypes.Types) == 0 {
		return provider.ExtractedPath{}, nil
	}

	c.ScanParams.Platform = pathTypes.Types
	c.ScanParams.ExcludePaths = pathTypes.Exc

	return allPaths, nil
}

func combinePaths(terraformer, regular provider.ExtractedPath) provider.ExtractedPath {
	var combinedPaths provider.ExtractedPath
	paths := make([]string, 0)
	combinedPathsEx := make(map[string]model.ExtractedPathObject)
	paths = append(paths, terraformer.Path...)
	paths = append(paths, regular.Path...)
	combinedPaths.Path = paths
	for k, v := range regular.ExtractionMap {
		combinedPathsEx[k] = v
	}
	for k, v := range terraformer.ExtractionMap {
		combinedPathsEx[k] = v
	}

	combinedPaths.ExtractionMap = combinedPathsEx
	return combinedPaths
}

func (c *Client) preparePaths() error {
	var err error
	err = c.getQueryPath()
	if err != nil {
		return err
	}
	err = c.getLibraryPath()
	if err != nil {
		return err
	}
	return nil
}

func (c *Client) getQueryPath() error {
	if c.ScanParams.ChangedDefaultQueryPath {
		extractedQueriesPath, errExtractQueries := resolvePath(c.ScanParams.QueriesPath, "queries-path")
		if errExtractQueries != nil {
			return errExtractQueries
		}
		c.ScanParams.QueriesPath = extractedQueriesPath
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		defaultQueryPath, errDefaultQueryPath := consoleHelpers.GetDefaultQueryPath(c.ScanParams.QueriesPath)
		if errDefaultQueryPath != nil {
			return errors.Wrap(errDefaultQueryPath, "unable to find queries")
		}

		c.ScanParams.QueriesPath = defaultQueryPath
	}
	return nil
}

func (c *Client) getLibraryPath() error {
	if c.ScanParams.ChangedDefaultLibrariesPath {
		extractedLibrariesPath, errExtractLibraries := resolvePath(c.ScanParams.LibrariesPath, "libraries-path")
		if errExtractLibraries != nil {
			return errExtractLibraries
		}

		c.ScanParams.LibrariesPath = extractedLibrariesPath
	}
	return nil
}

func resolvePath(flagContent, flagName string) (string, error) {
	extractedPath, errExtractPath := provider.GetSources([]string{flagContent})
	if errExtractPath != nil {
		return "", errExtractPath
	}
	if len(extractedPath.Path) != 1 {
		return "", fmt.Errorf("could not find a valid path (--%s) on %s", flagName, flagContent)
	}
	log.Debug().Msgf("Trying to load path (--%s) from %s", flagName, flagContent)
	return extractedPath.Path[0], nil
}

// analyzePaths will analyze the paths to scan to determine which type of queries to load
// and which files should be ignored, it then updates the types and exclude flags variables
// with the results found
func analyzePaths(paths, types, exclude []string) (model.AnalyzedPaths, error) {
	exc := make([]string, 0)
	var err error
	var pathsFlag model.AnalyzedPaths
	excluded := make([]string, 0)

	if types[0] == "" { // if '--type' flag was given skip file analyzing
		pathsFlag, err = analyzer.Analyze(paths)
		if err != nil {
			log.Err(err)
			return model.AnalyzedPaths{}, err
		}
		logLoadingQueriesType(pathsFlag.Types)
	}
	excluded = append(excluded, exclude...)
	excluded = append(excluded, exc...)
	pathsFlag.Exc = excluded
	return pathsFlag, nil
}

func logLoadingQueriesType(types []string) {
	if len(types) == 0 {
		log.Info().Msg("No queries were loaded")
		return
	}

	log.Info().Msgf("Loading queries of type: %s", strings.Join(types, ", "))
}

func extractPathType(paths []string) (regular, terraformer []string) {
	for _, path := range paths {
		if terraformerRegex.MatchString(path) {
			terraformer = append(terraformer, terraformerRegex.ReplaceAllString(path, ""))
		} else {
			regular = append(regular, path)
		}
	}
	return
}

func deleteExtractionFolder(extractionMap map[string]model.ExtractedPathObject) {
	for extractionFile := range extractionMap {
		err := os.Remove(extractionFile)
		if err != nil {
			log.Err(err).Msg("Failed to delete KICS extraction folder")
		}
	}
}
