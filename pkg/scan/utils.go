package scan

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/pkg/analyzer"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/model"
	consolePrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

var (
	kuberneterRegex = regexp.MustCompile(`^kuberneter::`)
)

func (c *Client) prepareAndAnalyzePaths(ctx context.Context) (provider.ExtractedPath, error) {
	queryExPaths, libExPaths, err := c.preparePaths()
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	regularPaths, kuberneterPaths := extractPathType(c.ScanParams.Path)

	kuberneterExPaths, err := provider.GetKuberneterSources(ctx, kuberneterPaths, c.ScanParams.OutputPath)
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	regularExPaths, err := provider.GetSources(regularPaths)
	if err != nil {
		return provider.ExtractedPath{}, err
	}

	allPaths := combinePaths(kuberneterExPaths, regularExPaths, queryExPaths, libExPaths)
	if len(allPaths.Path) == 0 {
		return provider.ExtractedPath{}, nil
	}
	log.Info().Msgf("Total files in the project: %d", getTotalFiles(allPaths.Path))

	a := &analyzer.Analyzer{
		Paths:             allPaths.Path,
		Types:             c.ScanParams.Platform,
		ExcludeTypes:      c.ScanParams.ExcludePlatform,
		Exc:               c.ScanParams.ExcludePaths,
		GitIgnoreFileName: ".gitignore",
		ExcludeGitIgnore:  c.ScanParams.ExcludeGitIgnore,
		MaxFileSize:       c.ScanParams.MaxFileSizeFlag,
	}

	pathTypes, errAnalyze := analyzePaths(a)

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

func combinePaths(kuberneter, regular, query, library provider.ExtractedPath) provider.ExtractedPath {
	var combinedPaths provider.ExtractedPath
	paths := make([]string, 0)
	combinedPathsEx := make(map[string]model.ExtractedPathObject)
	paths = append(paths, kuberneter.Path...)
	paths = append(paths, regular.Path...)
	combinedPaths.Path = paths
	for k, v := range regular.ExtractionMap {
		combinedPathsEx[k] = v
	}
	for k, v := range kuberneter.ExtractionMap {
		combinedPathsEx[k] = v
	}
	for k, v := range query.ExtractionMap {
		combinedPathsEx[k] = v
	}
	for k, v := range library.ExtractionMap {
		combinedPathsEx[k] = v
	}

	combinedPaths.ExtractionMap = combinedPathsEx
	return combinedPaths
}

func (c *Client) preparePaths() (queryExtPath, libExtPath provider.ExtractedPath, err error) {
	queryExtPath, err = c.GetQueryPath()
	if err != nil {
		return provider.ExtractedPath{}, provider.ExtractedPath{}, err
	}

	libExtPath, err = c.getLibraryPath()
	if err != nil {
		return queryExtPath, provider.ExtractedPath{}, err
	}

	return queryExtPath, libExtPath, nil
}

// GetQueryPath gets all the queries paths
func (c *Client) GetQueryPath() (provider.ExtractedPath, error) {
	queriesPath := make([]string, 0)
	extPath := provider.ExtractedPath{
		Path:          []string{},
		ExtractionMap: make(map[string]model.ExtractedPathObject),
	}
	if c.ScanParams.ChangedDefaultQueryPath {
		for _, queryPath := range c.ScanParams.QueriesPath {
			extractedPath, errExtractQueries := resolvePath(queryPath, "queries-path")
			if errExtractQueries != nil {
				return extPath, errExtractQueries
			}
			extPath = extractedPath
			queriesPath = append(queriesPath, extractedPath.Path[0])
		}
	} else {
		log.Debug().Msgf("Looking for queries in executable path and in current work directory")
		defaultQueryPath, errDefaultQueryPath := consoleHelpers.GetDefaultQueryPath(c.ScanParams.QueriesPath[0])
		if errDefaultQueryPath != nil {
			return extPath, errors.Wrap(errDefaultQueryPath, "unable to find queries")
		}
		queriesPath = append(queriesPath, defaultQueryPath)
	}
	c.ScanParams.QueriesPath = queriesPath
	return extPath, nil
}

func (c *Client) getLibraryPath() (provider.ExtractedPath, error) {
	extPath := provider.ExtractedPath{
		Path:          []string{},
		ExtractionMap: make(map[string]model.ExtractedPathObject),
	}
	if c.ScanParams.ChangedDefaultLibrariesPath {
		extractedLibrariesPath, errExtractLibraries := resolvePath(c.ScanParams.LibrariesPath, "libraries-path")
		if errExtractLibraries != nil {
			return extPath, errExtractLibraries
		}

		extPath = extractedLibrariesPath
		c.ScanParams.LibrariesPath = extractedLibrariesPath.Path[0]
	}
	return extPath, nil
}

func resolvePath(flagContent, flagName string) (provider.ExtractedPath, error) {
	extractedPath, errExtractPath := provider.GetSources([]string{flagContent})
	if errExtractPath != nil {
		return extractedPath, errExtractPath
	}
	if len(extractedPath.Path) != 1 {
		return extractedPath, fmt.Errorf("could not find a valid path (--%s) on %s", flagName, flagContent)
	}
	log.Debug().Msgf("Trying to load path (--%s) from %s", flagName, flagContent)
	return extractedPath, nil
}

// analyzePaths will analyze the paths to scan to determine which type of queries to load
// and which files should be ignored, it then updates the types and exclude flags variables
// with the results found
func analyzePaths(a *analyzer.Analyzer) (model.AnalyzedPaths, error) {
	var err error
	var pathsFlag model.AnalyzedPaths
	excluded := make([]string, 0)

	pathsFlag, err = analyzer.Analyze(a)
	if err != nil {
		log.Err(err)
		return model.AnalyzedPaths{}, err
	}

	logLoadingQueriesType(pathsFlag.Types)

	excluded = append(excluded, a.Exc...)
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

func extractPathType(paths []string) (regular, kuberneter []string) {
	for _, path := range paths {
		if kuberneterRegex.MatchString(path) {
			kuberneter = append(kuberneter, kuberneterRegex.ReplaceAllString(path, ""))
		} else {
			regular = append(regular, path)
		}
	}
	return
}

func deleteExtractionFolder(extractionMap map[string]model.ExtractedPathObject) {
	for extractionFile := range extractionMap {
		if strings.Contains(extractionFile, "kics-extract-kuberneter") {
			continue
		}
		err := os.RemoveAll(extractionFile)
		if err != nil {
			log.Err(err).Msg("Failed to delete KICS extraction folder")
		}
	}
}

func contributionAppeal(customPrint *consolePrinter.Printer, queriesPath []string) {
	if usingCustomQueries(queriesPath) {
		msg := "\nAre you using a custom query? If so, feel free to contribute to KICS!\n"
		contributionPage := "Check out how to do it: https://github.com/Checkmarx/kics/blob/master/docs/CONTRIBUTING.md\n"

		output := customPrint.ContributionMessage.Sprintf("%s", msg+contributionPage)
		fmt.Println(output)
	}
}

func usingCustomQueries(queriesPath []string) bool {
	return !utils.ContainsInString(filepath.Join("assets", "queries"), queriesPath)
}

// printVersionCheck - Prints and logs warning if not using KICS latest version
func printVersionCheck(customPrint *consolePrinter.Printer, s *model.Summary) {
	if !s.LatestVersion.Latest {
		message := fmt.Sprintf("A new version 'v%s' of KICS is available, please consider updating", s.LatestVersion.LatestVersionTag)

		fmt.Println(customPrint.VersionMessage.Sprintf("%s", message))
		log.Warn().Msgf("%s", message)
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
