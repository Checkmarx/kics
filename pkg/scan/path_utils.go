package scan

import (
	"fmt"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func (c *Client) prepareAndAnalyzePaths() (extractedPaths provider.ExtractedPath, ext []string, err error) {
	err = c.preparePaths()
	if err != nil {
		return extractedPaths, []string{}, err
	}

	extractedPaths, err = provider.GetSources(c.ScanParams.Path)
	if err != nil {
		return extractedPaths, []string{}, err
	}

	analyzerResp, errAnalyze :=
		analyzePaths(
			extractedPaths.Path,
			c.ScanParams.Platform,
			c.ScanParams.ExcludePaths,
		)
	if errAnalyze != nil {
		return extractedPaths, []string{}, errAnalyze
	}

	if len(analyzerResp.Types) == 0 {
		return provider.ExtractedPath{}, []string{}, nil
	}

	c.ScanParams.Platform = analyzerResp.Types
	c.ScanParams.ExcludePaths = analyzerResp.Unwanted

	return extractedPaths, analyzerResp.Ext, nil
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
func analyzePaths(paths, types, exclude []string) (response model.AnalizerResult, errRes error) {
	var err error
	resp := model.AnalizerResult{}
	if types[0] == "" { // if '--type' flag was given skip file analyzing
		resp, err = analyzer.Analyze(paths)
		if err != nil {
			log.Err(err)
			return model.AnalizerResult{}, err
		}
		logLoadingQueriesType(resp.Types)
	}
	resp.Unwanted = append(resp.Unwanted, exclude...)
	resp.Types = types
	return resp, nil
}

func logLoadingQueriesType(types []string) {
	if len(types) == 0 {
		log.Info().Msg("No queries were loaded")
		return
	}

	log.Info().Msgf("Loading queries of type: %s", strings.Join(types, ", "))
}
