package scan

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func (c *Client) prepareAndAnalyzePaths() (extractedPaths provider.ExtractedPath, err error) {
	err = c.preparePaths()
	if err != nil {
		return extractedPaths, err
	}

	extractedPaths, err = provider.GetSources(c.ScanParams.Path)
	if err != nil {
		return extractedPaths, err
	}

	newTypeFlagValue, newExcludePathsFlagValue, errAnalyze :=
		analyzePaths(
			extractedPaths.Path,
			c.ScanParams.Platform,
			c.ScanParams.ExcludePaths,
		)
	if errAnalyze != nil {
		return extractedPaths, errAnalyze
	}

	if len(newTypeFlagValue) == 0 {
		return provider.ExtractedPath{}, nil
	}

	c.ScanParams.Platform = newTypeFlagValue
	c.ScanParams.ExcludePaths = newExcludePathsFlagValue

	return extractedPaths, nil
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
func analyzePaths(paths, types, exclude []string) (typesRes, excludeRes []string, errRes error) {
	var err error
	exc := make([]string, 0)
	if types[0] == "" { // if '--type' flag was given skip file analyzing
		types, exc, err = analyzer.Analyze(paths)
		if err != nil {
			log.Err(err)
			return []string{}, []string{}, err
		}
		logLoadingQueriesType(types)
	}
	exclude = append(exclude, exc...)
	return types, exclude, nil
}

func logLoadingQueriesType(types []string) {
	if len(types) == 0 {
		log.Info().Msg("No queries were loaded")
		return
	}

	log.Info().Msgf("Loading queries of type: %s", strings.Join(types, ", "))
}

func deleteExtractionFolder(extractionMap map[string]model.ExtractedPathObject) {
	for extractionFile := range extractionMap {
		err := os.Remove(extractionFile)
		if err != nil {
			log.Err(err).Msg("Failed to delete KICS extraction folder")
		}
	}
}

func contributionAppeal(printer *consoleHelpers.Printer, queriesPath string) {
	if !strings.Contains(queriesPath, filepath.Join("assets", "queries")) {
		msg := "\nAre you using a custom query? If so, feel free to contribute to KICS!\n"
		contributionPage := "Check out how to do it: https://github.com/Checkmarx/kics/blob/master/docs/CONTRIBUTING.md\n"

		fmt.Println(printer.ContributionMessage.Sprintf(msg + contributionPage))
	}
}

// printVersionCheck - Prints and logs warning if not using KICS latest version
func printVersionCheck(printer *consoleHelpers.Printer, s *model.Summary) {
	if !s.LatestVersion.Latest {
		message := fmt.Sprintf("A new version 'v%s' of KICS is available, please consider updating", s.LatestVersion.LatestVersionTag)

		fmt.Println(printer.VersionMessage.Sprintf(message))
		log.Warn().Msgf(message)
	}
}
