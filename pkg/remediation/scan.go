package remediation

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/kics"
	"github.com/Checkmarx/kics/v2/pkg/minified"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/scan"
	"github.com/open-policy-agent/opa/v1/topdown"

	"github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/parser"
	buildahParser "github.com/Checkmarx/kics/v2/pkg/parser/buildah"
	dockerParser "github.com/Checkmarx/kics/v2/pkg/parser/docker"
	protoParser "github.com/Checkmarx/kics/v2/pkg/parser/grpc"
	jsonParser "github.com/Checkmarx/kics/v2/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/v2/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/open-policy-agent/opa/v1/rego"
	"github.com/rs/zerolog/log"
)

const terraformExtension = ".tf"

type runQueryInfo struct {
	payload   model.Documents
	query     *engine.PreparedQuery
	inspector *engine.Inspector
	tmpFile   string
	files     model.FileMetadatas
}

// scanTmpFile scans a temporary file against a specific query
func scanTmpFile(
	tmpFile, queryID string,
	remediated []byte,
	openAPIResolveReferences bool,
	maxResolverDepth int) ([]model.Vulnerability, error) {
	// get payload
	files, err := getPayload(tmpFile, remediated, openAPIResolveReferences, maxResolverDepth)

	if err != nil {
		log.Err(err)
		return []model.Vulnerability{}, err
	}

	if len(files) == 0 {
		log.Error().Msg("failed to get payload")
		return []model.Vulnerability{}, errors.New("failed to get payload")
	}

	payload := files.Combine(false)

	// init scan
	inspector, err := initScan(queryID)

	if err != nil {
		log.Err(err)
		return []model.Vulnerability{}, err
	}

	// load query
	query, err := loadQuery(inspector, queryID)

	if err != nil {
		log.Err(err)
		return []model.Vulnerability{}, err
	}

	// run query
	info := &runQueryInfo{
		payload:   payload,
		query:     query,
		inspector: inspector,
		tmpFile:   tmpFile,
		files:     files,
	}

	return runQuery(info), nil
}

// getPayload gets the payload of a file
func getPayload(filePath string, content []byte, openAPIResolveReferences bool, maxResolverDepth int) (model.FileMetadatas, error) {
	ext, _ := utils.GetExtension(filePath)
	var p []*parser.Parser
	var err error

	switch ext {
	case ".dockerfile", "Dockerfile", "possibleDockerfile", ".ubi8", ".debian":
		p, err = parser.NewBuilder().Add(&dockerParser.Parser{}).Build([]string{""}, []string{""})

	case terraformExtension:
		p, err = parser.NewBuilder().Add(terraformParser.NewDefault()).Build([]string{""}, []string{""})

	case ".proto":
		p, err = parser.NewBuilder().Add(&protoParser.Parser{}).Build([]string{""}, []string{""})

	case ".yaml", ".yml":
		p, err = parser.NewBuilder().Add(&yamlParser.Parser{}).Build([]string{""}, []string{""})

	case ".json":
		p, err = parser.NewBuilder().Add(&jsonParser.Parser{}).Build([]string{""}, []string{""})

	case ".sh":
		p, err = parser.NewBuilder().Add(&buildahParser.Parser{}).Build([]string{""}, []string{""})
	}

	if err != nil {
		log.Error().Msgf("failed to get parser: %s", err)
		return model.FileMetadatas{}, err
	}

	if len(p) == 0 {
		log.Info().Msg("failed to get parser")
		return model.FileMetadatas{}, errors.New("failed to get parser")
	}

	isMinified := minified.IsMinified(filePath, content)
	documents, er := p[0].Parse(filePath, content, openAPIResolveReferences, isMinified, maxResolverDepth)

	if er != nil {
		log.Error().Msgf("failed to parse file '%s': %s", filePath, er)
		return model.FileMetadatas{}, er
	}

	var files model.FileMetadatas

	for _, document := range documents.Docs {
		_, err = json.Marshal(document)
		if err != nil {
			continue
		}

		file := model.FileMetadata{
			FilePath:          filePath,
			Document:          kics.PrepareScanDocument(document, documents.Kind),
			LineInfoDocument:  document,
			Commands:          p[0].CommentsCommands(filePath, content),
			OriginalData:      string(content),
			LinesOriginalData: utils.SplitLines(string(content)),
			IsMinified:        documents.IsMinified,
		}

		files = append(files, file)
	}

	return files, nil
}

// runQuery runs a query and returns its results
func runQuery(r *runQueryInfo) []model.Vulnerability {
	queryExecTimeout := time.Duration(flags.GetIntFlag(flags.QueryExecTimeoutFlag)) * time.Second

	timeoutCtx, cancel := context.WithTimeout(context.Background(), queryExecTimeout)
	defer cancel()

	options := []rego.EvalOption{rego.EvalInput(r.payload)}

	results, err := r.query.OpaQuery.Eval(timeoutCtx, options...)

	if err != nil {
		if topdown.IsCancel(err) {
			log.Err(err)
		}

		log.Err(err)
	}

	ctx := context.Background()

	queryCtx := &engine.QueryContext{
		Ctx:           ctx,
		Query:         r.query,
		BaseScanPaths: []string{r.tmpFile},
		Files:         r.files.ToMap(),
	}

	timeoutCtxToDecode, cancelDecode := context.WithTimeout(context.Background(), queryExecTimeout)
	defer cancelDecode()
	decoded, err := r.inspector.DecodeQueryResults(queryCtx, timeoutCtxToDecode, results)

	if err != nil {
		log.Err(err)
	}

	return decoded
}

func initScan(queryID string) (*engine.Inspector, error) {
	scanParams := &scan.Parameters{
		QueriesPath:         flags.GetMultiStrFlag(flags.QueriesPath),
		Platform:            flags.GetMultiStrFlag(flags.TypeFlag),
		CloudProvider:       flags.GetMultiStrFlag(flags.CloudProviderFlag),
		LibrariesPath:       flags.GetStrFlag(flags.LibrariesPath),
		PreviewLines:        flags.GetIntFlag(flags.PreviewLinesFlag),
		QueryExecTimeout:    flags.GetIntFlag(flags.QueryExecTimeoutFlag),
		ExperimentalQueries: flags.GetBoolFlag(flags.ExperimentalQueriesFlag),
	}

	c := &scan.Client{
		ScanParams: scanParams,
	}

	_, err := c.GetQueryPath()
	if err != nil {
		log.Err(err)
		return &engine.Inspector{}, err
	}

	queriesSource := source.NewFilesystemSource(
		c.ScanParams.QueriesPath,
		c.ScanParams.Platform,
		c.ScanParams.CloudProvider,
		c.ScanParams.LibrariesPath,
		c.ScanParams.ExperimentalQueries)

	includeQueries := source.IncludeQueries{
		ByIDs: []string{queryID},
	}

	queryFilter := source.QueryInspectorParameters{
		IncludeQueries: includeQueries,
	}

	t, err := tracker.NewTracker(c.ScanParams.PreviewLines)
	if err != nil {
		log.Err(err)
		return &engine.Inspector{}, err
	}

	ctx := context.Background()

	inspector, err := engine.NewInspector(ctx,
		queriesSource,
		engine.DefaultVulnerabilityBuilder,
		t,
		&queryFilter,
		make(map[string]bool),
		c.ScanParams.QueryExecTimeout,
		c.ScanParams.UseOldSeverities,
		false,
		c.ScanParams.ParallelScanFlag,
		c.ScanParams.KicsComputeNewSimID,
	)

	return inspector, err
}

func loadQuery(inspector *engine.Inspector, queryID string) (*engine.PreparedQuery, error) {
	if len(inspector.QueryLoader.QueriesMetadata) == 1 {
		queryOpa, err := inspector.QueryLoader.LoadQuery(context.Background(), &inspector.QueryLoader.QueriesMetadata[0])

		if err != nil {
			log.Err(err)
			return &engine.PreparedQuery{}, err
		}

		query := &engine.PreparedQuery{
			OpaQuery: *queryOpa,
			Metadata: inspector.QueryLoader.QueriesMetadata[0],
		}

		return query, nil
	}

	return &engine.PreparedQuery{}, errors.New("unable to load query" + queryID)
}
