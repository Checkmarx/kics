package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// ── Metadata ──────────────────────────────────────────────────────────────────

type Metadata struct {
	ID string `json:"id"`
}

// ── Scan result structures ────────────────────────────────────────────────────

type ScanFile struct {
	FileName      string `json:"file_name"`
	SimilarityID  string `json:"similarity_id"`
	Line          int    `json:"line"`
	ResourceType  string `json:"resource_type"`
	ResourceName  string `json:"resource_name"`
	SearchLine    int    `json:"search_line"`
	SearchValue   string `json:"search_value"`
	ExpectedValue string `json:"expected_value"`
	ActualValue   string `json:"actual_value"`
}

type Query struct {
	QueryName string     `json:"query_name"`
	Severity  string     `json:"severity"`
	Files     []ScanFile `json:"files"`
}

type ScanResult struct {
	Queries []Query `json:"queries"`
}

// ── Output structure ──────────────────────────────────────────────────────────

type ExpectedResult struct {
	QueryName     string `json:"queryName"`
	Severity      string `json:"severity"`
	Line          int    `json:"line"`
	Filename      string `json:"filename"`
	ResourceType  string `json:"resourceType"`
	ResourceName  string `json:"resourceName"`
	SearchLine    int    `json:"searchLine"`
	SearchValue   string `json:"search_value"`
	ExpectedValue string `json:"expected_value"`
	ActualValue   string `json:"actual_value"`
	ResourceNameS string `json:"resource_name"`
	ResourceTypeS string `json:"resource_type"`
	SimilarityID  string `json:"similarityID"`
}

// ── Entry point ───────────────────────────────────────────────────────────────

func main() {
	// The script must be executed from the KICS project root.
	// e.g.:  go run .github/scripts/generate-expected-results/main.go
	root, err := os.Getwd()
	if err != nil {
		fatalf("getting working directory: %v", err)
	}

	queriesRoot := filepath.Join(root, "assets", "queries")

	if _, err := os.Stat(queriesRoot); os.IsNotExist(err) {
		fatalf("queries directory not found at %s — make sure you run this script from the KICS project root", queriesRoot)
	}

	fmt.Printf("🔍  Scanning queries under: %s\n\n", queriesRoot)

	err = filepath.Walk(queriesRoot, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip 'common' directories entirely.
		if info.IsDir() && info.Name() == "common" {
			fmt.Printf("⏭️   Skipping common dir: %s\n", path)
			return filepath.SkipDir
		}

		if !info.IsDir() {
			return nil
		}

		// A query directory must contain both query.rego and metadata.json.
		if !fileExists(filepath.Join(path, "query.rego")) ||
			!fileExists(filepath.Join(path, "metadata.json")) {
			return nil
		}

		fmt.Printf("✅  Found query: %s\n", path)
		if err := processQuery(root, path); err != nil {
			fmt.Fprintf(os.Stderr, "❌  Error processing %s: %v\n", path, err)
		}
		// Always skip going deeper once a query directory is found.
		return filepath.SkipDir
	})

	if err != nil {
		fatalf("walking queries directory: %v", err)
	}

	fmt.Println("\n🎉  Done!")
}

// ── Per-query processing ──────────────────────────────────────────────────────

func processQuery(root, queryDir string) error {
	// 1. Read the query ID from metadata.json.
	metaPath := filepath.Join(queryDir, "metadata.json")
	metaBytes, err := os.ReadFile(metaPath)
	if err != nil {
		return fmt.Errorf("reading metadata.json: %w", err)
	}

	var meta Metadata
	if err := json.Unmarshal(metaBytes, &meta); err != nil {
		return fmt.Errorf("parsing metadata.json: %w", err)
	}

	if meta.ID == "" {
		return fmt.Errorf("metadata.json has an empty 'id' field")
	}

	// 2. Build relative paths (relative to KICS root) for use in the command.
	relQueryDir, err := filepath.Rel(root, queryDir)
	if err != nil {
		return fmt.Errorf("computing relative path: %w", err)
	}

	relTestDir     := filepath.Join(relQueryDir, "test")
	relResultsDir  := filepath.Join(relQueryDir, "results")
	relPayloadsFile := filepath.Join(relQueryDir, "payloads", "all_payloads.json")

	// 3. Create results/ and payloads/ directories if they don't exist yet.
	if err := os.MkdirAll(filepath.Join(queryDir, "results"), 0o755); err != nil {
		return fmt.Errorf("creating results dir: %w", err)
	}

	if err := os.MkdirAll(filepath.Join(queryDir, "payloads"), 0o755); err != nil {
		return fmt.Errorf("creating payloads dir: %w", err)
	}

	// 4. Run the KICS scan from the project root.
	//    go run .\cmd\console\main.go scan
	//        -p  <test dir>
	//        -o  <results dir>
	//        --output-name all_results.json
	//        -i  <query id>
	//        -d  <payloads file>
	//        -v
	//        --experimental-queries
	mainGoPath := filepath.Join("cmd", "console", "main.go")

	cmd := exec.Command(
		"go", "run", mainGoPath,
		"scan",
		"-p", relTestDir,
		"-o", relResultsDir,
		"--output-name", "all_results.json",
		"-i", meta.ID,
		"-d", relPayloadsFile,
		"-v",
		"--experimental-queries",
	)
	cmd.Dir    = root
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	fmt.Printf("\n▶️   Running scan for: %s\n", relQueryDir)
	fmt.Printf("    Command: go run %s scan -p %s -o %s --output-name all_results.json -i %s -d %s -v --experimental-queries\n\n",
		mainGoPath, relTestDir, relResultsDir, meta.ID, relPayloadsFile)

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("running kics scan: %w", err)
	}

	// 5. Parse the results and write positive_expected_result.json.
	resultsFile := filepath.Join(queryDir, "results", "all_results.json")
	return writePositiveExpectedResults(resultsFile, queryDir)
}

// ── Result parsing & writing ──────────────────────────────────────────────────

func writePositiveExpectedResults(resultsFile, queryDir string) error {
	data, err := os.ReadFile(resultsFile)
	if err != nil {
		return fmt.Errorf("reading all_results.json: %w", err)
	}

	var scanResult ScanResult
	if err := json.Unmarshal(data, &scanResult); err != nil {
		return fmt.Errorf("parsing all_results.json: %w", err)
	}

	var expected []ExpectedResult

	for _, q := range scanResult.Queries {
		for _, f := range q.Files {
			filename := filepath.Base(f.FileName)

			// Only include entries whose file name starts with "positive".
			if !strings.HasPrefix(filename, "positive") {
				continue
			}

			expected = append(expected, ExpectedResult{
				QueryName:     q.QueryName,
				Severity:      q.Severity,
				Line:          f.Line,
				Filename:      filename,
				ResourceType:  f.ResourceType,
				ResourceName:  f.ResourceName,
				SearchLine:    f.SearchLine,
				SearchValue:   f.SearchValue,
				ExpectedValue: f.ExpectedValue,
				ActualValue:   f.ActualValue,
				ResourceNameS: f.ResourceName,
				ResourceTypeS: f.ResourceType,
				SimilarityID:  f.SimilarityID,
			})
		}
	}

	outputPath := filepath.Join(queryDir, "test", "positive_expected_result.json")
	outputBytes, err := json.MarshalIndent(expected, "", "  ")
	if err != nil {
		return fmt.Errorf("marshaling expected results: %w", err)
	}

	if err := os.WriteFile(outputPath, outputBytes, 0o644); err != nil {
		return fmt.Errorf("writing positive_expected_result.json: %w", err)
	}

	fmt.Printf("📄  Written: %s  (%d entries)\n", outputPath, len(expected))
	return nil
}

// ── Helpers ───────────────────────────────────────────────────────────────────

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return !os.IsNotExist(err)
}

func fatalf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "fatal: "+format+"\n", args...)
	os.Exit(1)
}
