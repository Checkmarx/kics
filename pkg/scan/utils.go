package scan

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/utils"
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

	log.Info().Msgf("Total files in the project: %d", getTotalFiles(allPaths.Path))

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
	err = c.GetQueryPath()
	if err != nil {
		return err
	}
	err = c.getLibraryPath()
	if err != nil {
		return err
	}
	return nil
}

// GetQueryPath gets all the queries paths
func (c *Client) GetQueryPath() error {
	queriesPath := make([]string, 0)
	if c.ScanParams.ChangedDefaultQueryPath {
		for _, queryPath := range c.ScanParams.QueriesPath {
			extractedQueriesPath, errExtractQueries := resolvePath(queryPath, "queries-path")
			if errExtractQueries != nil {
				return errExtractQueries
			}
			queriesPath = append(queriesPath, extractedQueriesPath)
		}
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		defaultQueryPath, errDefaultQueryPath := consoleHelpers.GetDefaultQueryPath(c.ScanParams.QueriesPath[0])
		if errDefaultQueryPath != nil {
			return errors.Wrap(errDefaultQueryPath, "unable to find queries")
		}
		queriesPath = append(queriesPath, defaultQueryPath)
	}
	c.ScanParams.QueriesPath = queriesPath
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
	var err error
	var pathsFlag model.AnalyzedPaths
	excluded := make([]string, 0)

	pathsFlag, err = analyzer.Analyze(paths, types, exclude)
	if err != nil {
		log.Err(err)
		return model.AnalyzedPaths{}, err
	}

	// flag -t was passed but KICS did not find any matching file
	if types[0] != "" && len(pathsFlag.Types) == 0 {
		pathsFlag.Types = append(pathsFlag.Types, types...)
	}

	logLoadingQueriesType(pathsFlag.Types)

	excluded = append(excluded, exclude...)
	excluded = append(excluded, pathsFlag.Exc...)
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
		if strings.Contains(extractionFile, "kics-extract-terraformer") {
			continue
		}
		err := os.RemoveAll(extractionFile)
		if err != nil {
			log.Err(err).Msg("Failed to delete KICS extraction folder")
		}
	}
}

func contributionAppeal(customPrint *consolePrinter.Printer, queriesPath []string) {
	if utils.Contains(filepath.Join("assets", "queries"), queriesPath) {
		msg := "\nAre you using a custom query? If so, feel free to contribute to KICS!\n"
		contributionPage := "Check out how to do it: https://github.com/Checkmarx/kics/blob/master/docs/CONTRIBUTING.md\n"

		fmt.Println(customPrint.ContributionMessage.Sprintf(msg + contributionPage))
	}
}

// printVersionCheck - Prints and logs warning if not using KICS latest version
func printVersionCheck(customPrint *consolePrinter.Printer, s *model.Summary) {
	if !s.LatestVersion.Latest {
		message := fmt.Sprintf("A new version 'v%s' of KICS is available, please consider updating", s.LatestVersion.LatestVersionTag)

		fmt.Println(customPrint.VersionMessage.Sprintf(message))
		log.Warn().Msgf(message)
	}
}

func getTotalFiles(paths []string) int {
	files := 0
	for _, path := range paths {
		if err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if !info.IsDir() {
				files++
			}

			return nil
		}); err != nil {
			log.Error().Msgf("failed to walk path %s: %s", path, err)
		}
	}
	return files
}
