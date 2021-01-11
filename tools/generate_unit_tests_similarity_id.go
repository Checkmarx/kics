package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/query"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser"
	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
	"github.com/Checkmarx/kics/pkg/source"
	"github.com/rs/zerolog"
)

const (
	allQueriesPath           = "../assets/queries/"
	unitTestSamplesDir       = "test"
	expectedPositiveFilename = "positive_expected_result.json"
	metadataFilename         = "metadata.json"
)

type positiveExpectedVulnerability struct {
	SimilarityID string         `json:"similarityID"`
	QueryName    string         `json:"queryName"`
	Severity     model.Severity `json:"severity"`
	Line         int            `json:"line"`
}

var computedSimIDCounter = 0
var filesReplacedCounter = 0

// Small tool for helping with precompute all the samples' similarity IDS
// Those should be used by the unit tests during the TestQueries scenario
func main() {
	fmt.Println("--- Precompute all samples similarity IDs ---")

	ctx := context.Background()

	err := filepath.Walk(filepath.FromSlash(allQueriesPath),
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				fmt.Printf("failure accessing a path %q: %v\n", path, err)
				return err
			}
			if info.Name() == metadataFilename {
				triggerScanAndPreComputeSimilarityID(ctx, path)
			}
			return nil
		})
	if err != nil {
		log.Err(err)
		log.Fatal()
	}

	fmt.Println("\n\n--- Summary ---")
	fmt.Printf("Computed similary ids: %d\n", computedSimIDCounter)
	fmt.Printf("Files replaced: %d\n", filesReplacedCounter)
}

func scanDir(ctx context.Context, directoryPath string) ([]model.Vulnerability, error) {
	zerolog.SetGlobalLevel(zerolog.InfoLevel)
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})

	querySource := &query.FilesystemSource{
		Source: directoryPath,
	}

	t := &tracker.CITracker{}
	inspector, err := engine.NewInspector(ctx, querySource, engine.DefaultVulnerabilityBuilder, t)
	if err != nil {
		log.Err(err)
		log.Fatal()
	}

	var excludeFiles []string

	filesSource, err := source.NewFileSystemSourceProvider(directoryPath, excludeFiles)
	if err != nil {
		log.Err(err)
		log.Fatal()
	}

	combinedParser := parser.NewBuilder().
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build()

	store := storage.NewMemoryStorage()

	service := &kics.Service{
		SourceProvider: filesSource,
		Storage:        store,
		Parser:         combinedParser,
		Inspector:      inspector,
		Tracker:        t,
	}

	if scanErr := service.StartScan(ctx, "UnitTestScanID"); scanErr != nil {
		log.Err(scanErr)
		log.Fatal()
	}

	return store.GetVulnerabilities(ctx, "")
}

func updatePositiveResults(positiveResults []positiveExpectedVulnerability, path string) {
	positiveExpectedResultsPath := filepath.Dir(path) +
		string(os.PathSeparator) +
		unitTestSamplesDir +
		string(os.PathSeparator) +
		expectedPositiveFilename

	content, err := ioutil.ReadFile(positiveExpectedResultsPath)
	if err != nil {
		log.Err(err)
		log.Fatal()
	}

	var expectedVulnerabilities []positiveExpectedVulnerability
	err = json.Unmarshal(content, &expectedVulnerabilities)
	if err != nil {
		log.Err(err)
		log.Fatal()
	}

	for _, result := range positiveResults {
		for idx := range expectedVulnerabilities {
			if result.Line == expectedVulnerabilities[idx].Line {
				expectedVulnerabilities[idx].SimilarityID = result.SimilarityID
			}
		}
	}

	file, _ := json.MarshalIndent(expectedVulnerabilities, "", "    ")
	file = append(file, []byte("\n")...)

	err = ioutil.WriteFile(positiveExpectedResultsPath, file, 0644)
	filesReplacedCounter++
	if err != nil {
		log.Err(err)
		log.Fatal()
	}
}

func triggerScanAndPreComputeSimilarityID(ctx context.Context, path string) {
	fmt.Printf("--- Scanning samples: %q\n", filepath.Dir(path))
	vulnerabilities, err := scanDir(ctx, filepath.Dir(path))

	if err != nil {
		log.Fatal()
	}

	var positiveResults = make([]positiveExpectedVulnerability, 0)

	for _, vuln := range vulnerabilities {

		similarityID, err := engine.ComputeSimilarityID(
			vuln.FileName,
			vuln.QueryID,
			vuln.SearchKey,
			vuln.SearchValue)

		computedSimIDCounter++

		positiveResults = append(positiveResults, positiveExpectedVulnerability{
			SimilarityID: *similarityID,
			Line:         vuln.Line,
			QueryName:    vuln.QueryName,
			Severity:     vuln.Severity,
		})

		if err != nil {
			log.Err(err)
			log.Fatal()
		}
	}
	fmt.Println()

	updatePositiveResults(positiveResults, path)
}
