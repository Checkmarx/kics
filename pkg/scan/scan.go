package scan

import (
	"context"
	"fmt"
	"os"
	"strings"

	"github.com/Checkmarx/kics/assets"
	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/pkg/analyzer"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/engine/secrets"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/resolver"
	"github.com/Checkmarx/kics/pkg/resolver/helm"
	"github.com/Checkmarx/kics/pkg/scanner"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

func (c *Client) scan(ctx context.Context) (*Results, error) {
	progressBar := c.ProBarBuilder.BuildCircle("Preparing Scan Assets: ")
	progressBar.Start()

	extractedPaths, err := c.prepareAndAnalyzePaths()
	if err != nil {
		log.Err(err)
		return nil, err
	}

	querySource := source.NewFilesystemSource(
		c.ScanParams.QueriesPath,
		c.ScanParams.Type,
		c.ScanParams.CloudProvider,
		c.ScanParams.LibrariesPath)

	queryFilter := c.createQueryFilter()

	inspector, err := engine.NewInspector(ctx,
		querySource,
		engine.DefaultVulnerabilityBuilder,
		c.Tracker,
		queryFilter,
		c.ExcludeResultsMap,
		c.ScanParams.QueryExecTimeout,
	)
	if err != nil {
		return nil, err
	}

	secretsRegexRulesContent, err := getSecretsRegexRules(c.ScanParams.SecretsRegexesPath)
	if err != nil {
		return nil, err
	}

	secretsInspector, err := secrets.NewInspector(
		ctx,
		c.ExcludeResultsMap,
		c.Tracker,
		queryFilter,
		c.ScanParams.DisableSecrets,
		c.ScanParams.QueryExecTimeout,
		secretsRegexRulesContent,
	)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	services, err := c.createService(
		inspector,
		secretsInspector,
		extractedPaths.Path,
		c.Tracker,
		c.Storage,
		querySource,
	)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	progressBar.Close()

	if err = scanner.PrepareAndScan(ctx, c.ScanParams.ScanID, *c.ProBarBuilder, services); err != nil {
		log.Err(err)
		return nil, err
	}

	failedQueries := inspector.GetFailedQueries()

	if err != nil {
		return nil, err
	}

	results, err := c.Storage.GetVulnerabilities(ctx, c.ScanParams.ScanID)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	files, err := c.Storage.GetFiles(ctx, c.ScanParams.ScanID)
	if err != nil {
		log.Err(err)
		return nil, err
	}

	return &Results{
		Results:        results,
		ExtractedPaths: extractedPaths,
		Files:          files,
		FailedQueries:  failedQueries,
	}, nil
}

type Results struct {
	Results        []model.Vulnerability
	ExtractedPaths provider.ExtractedPath
	Files          model.FileMetadatas
	FailedQueries  map[string]error
}

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
			c.ScanParams.Type,
			c.ScanParams.ExcludePaths,
		)
	if errAnalyze != nil {
		return extractedPaths, errAnalyze
	}

	c.ScanParams.Type = newTypeFlagValue
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
		log.Info().Msgf("Loading queries of type: %s", strings.Join(types, ", "))
	}
	exclude = append(exclude, exc...)
	return types, exclude, nil
}

func getExcludeResultsMap(excludeResults []string) map[string]bool {
	excludeResultsMap := make(map[string]bool)
	for _, er := range excludeResults {
		excludeResultsMap[er] = true
	}
	return excludeResultsMap
}

func getSecretsRegexRules(regexRulesPath string) (regexRulesContent string, err error) {
	if len(regexRulesPath) > 0 {
		b, err := os.ReadFile(regexRulesPath)
		if err != nil {
			return regexRulesContent, err
		}
		regexRulesContent = string(b)
	} else {
		regexRulesContent = assets.SecretsQueryRegexRulesJSON
	}

	return regexRulesContent, nil
}

func (c *Client) createQueryFilter() *source.QueryInspectorParameters {
	excludeQueries := source.ExcludeQueries{
		ByIDs:        c.ScanParams.ExcludeQueries,
		ByCategories: c.ScanParams.ExcludeCategories,
		BySeverities: c.ScanParams.ExcludeSeverities,
	}

	includeQueries := source.IncludeQueries{
		ByIDs: c.ScanParams.IncludeQueries,
	}

	queryFilter := source.QueryInspectorParameters{
		IncludeQueries: includeQueries,
		ExcludeQueries: excludeQueries,
		InputDataPath:  c.ScanParams.InputData,
	}

	return &queryFilter
}

func (c *Client) createService(
	inspector *engine.Inspector,
	secretsInspector *secrets.Inspector,
	paths []string,
	t kics.Tracker,
	store kics.Storage,
	querySource *source.FilesystemSource) ([]*kics.Service, error) {
	filesSource, err := c.getFileSystemSourceProvider(paths)
	if err != nil {
		return nil, err
	}

	combinedParser, err := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build(querySource.Types, querySource.CloudProviders)
	if err != nil {
		return nil, err
	}

	// combinedResolver to be used to resolve files and templates
	combinedResolver, err := resolver.NewBuilder().
		Add(&helm.Resolver{}).
		Build()
	if err != nil {
		return nil, err
	}

	services := make([]*kics.Service, 0, len(combinedParser))

	for _, parser := range combinedParser {
		services = append(
			services,
			&kics.Service{
				SourceProvider:   filesSource,
				Storage:          store,
				Parser:           parser,
				Inspector:        inspector,
				SecretsInspector: secretsInspector,
				Tracker:          t,
				Resolver:         combinedResolver,
			},
		)
	}
	return services, nil
}

func (c *Client) getFileSystemSourceProvider(paths []string) (*provider.FileSystemSourceProvider, error) {
	var excludePaths []string
	if c.ScanParams.PayloadPath != "" {
		excludePaths = append(excludePaths, c.ScanParams.PayloadPath)
	}

	if len(c.ScanParams.ExcludePaths) > 0 {
		excludePaths = append(excludePaths, c.ScanParams.ExcludePaths...)
	}

	filesSource, err := provider.NewFileSystemSourceProvider(paths, excludePaths)
	if err != nil {
		return nil, err
	}
	return filesSource, nil
}
