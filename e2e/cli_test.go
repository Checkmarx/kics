package e2e

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
	"text/template"
	"time"

	"github.com/Checkmarx/kics/e2e/utils"
	"github.com/stretchr/testify/require"
)

type TestTemplates struct {
	Help     string
	ScanHelp string
}

type cmdArgs []string

type args struct {
	args            []cmdArgs // args to pass to kics binary
	expectedOut     []string  // path to file with expected output
	expectedPayload []string
	expectedResult  []ResultsValidation
	expectedLog     LogValidation
}

type ResultsValidation struct {
	resultsFile    string
	resultsFormats []string
}

type LogValidation struct {
	logFile        string
	validationFunc Validation
}

type Validation func(string) bool

type testCase struct {
	name       string
	args       args
	wantStatus []int
	validation Validation
}

var tests = []testCase{
	// E2E-CLI-001 - KICS command should display a help text in the CLI when provided with the
	// 	 --help flag and it should describe the available commands plus the global flags
	{
		name: "E2E-CLI-001",
		args: args{
			args: []cmdArgs{
				[]string{"--help"},
			},
			expectedOut: []string{"E2E_CLI_001"},
		},
		wantStatus: []int{0},
	},
	// E2E-CLI-002 - KICS scan command should display a help text in the CLI when provided with the
	// --help flag and it should describe the options related with scan plus the global options
	{
		name: "E2E-CLI-002",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--help"},
			},
			expectedOut: []string{"E2E_CLI_002"},
		},
		wantStatus: []int{0},
	},
	// E2E-CLI-003 - KICS scan command had a mandatory flag -p the CLI should exhibit
	// an error message and return exit code 1
	{
		name: "E2E-CLI-003",
		args: args{
			args: []cmdArgs{
				[]string{"scan"},
			},
			expectedOut: []string{"E2E_CLI_003"},
		},
		wantStatus: []int{126},
	},
	// E2E-CLI-004 - KICS has an invalid flag combination
	// an error message and return exit code 1
	{
		name: "E2E-CLI-004",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--ci", "--verbose"},
				[]string{"--ci", "scan", "--verbose"},
			},
			expectedOut: []string{
				"E2E_CLI_004",
				"E2E_CLI_004",
			},
		},
		wantStatus: []int{126, 126},
	},
	// E2E-CLI-005 - KICS scan with -- payload-path flag should create a file with the
	// passed name containing the payload of the files scanned
	{
		name: "E2E-CLI-005",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--payload-path", "output/E2E_CLI_005_PAYLOAD.json"},
			},
			expectedOut: []string{
				"E2E_CLI_005",
			},
			expectedPayload: []string{
				"E2E_CLI_005_PAYLOAD.json",
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-006 - KICS generate-id should exhibit
	// a valid UUID in the CLI and return exit code 0
	{
		name: "E2E-CLI-006",
		args: args{
			args: []cmdArgs{
				[]string{"generate-id"},
			},
		},
		wantStatus: []int{0},
		validation: func(outputText string) bool {
			uuidRegex := "[a-f0-9]{8}-[a-f0-9]{4}-4{1}[a-f0-9]{3}-[89ab]{1}[a-f0-9]{3}-[a-f0-9]{12}"
			match, _ := regexp.MatchString(uuidRegex, outputText)
			return match
		},
	},
	// E2E-CLI-007 - the default kics scan must show informations such as 'Files scanned',
	// 'Queries loaded', 'Scan Duration', '...' in the CLI
	{
		name: "E2E-CLI-007",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		wantStatus: []int{50},
		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Files scanned: \d+`, outputText)
			match2, _ := regexp.MatchString(`Parsed files: \d+`, outputText)
			match3, _ := regexp.MatchString(`Queries loaded: \d+`, outputText)
			match4, _ := regexp.MatchString(`Queries failed to execute: \d+`, outputText)
			match5, _ := regexp.MatchString(`Results Summary:`, outputText)
			match6, _ := regexp.MatchString(`Scan duration: \d+(.\d+)?s`, outputText)
			return match1 && match2 && match3 && match4 && match5 && match6
		},
	},
	// E2E-CLI-008 - KICS  scan with --silent global flag
	// must hide all the output text in the CLI (empty output)
	{
		name: "E2E-CLI-008",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
			expectedOut: []string{"E2E_CLI_008"},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-009 - kics scan with no-progress flag should perform a scan
	// without showing progress bar in the CLI
	{
		name: "E2E-CLI-009",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf", "--no-progress"},
			},
		},
		wantStatus: []int{50},
		validation: func(outputText string) bool {
			getProgressRegex := "Executing queries:"
			match, _ := regexp.MatchString(getProgressRegex, outputText)
			// if not found -> the the test was successful
			return !match
		},
	},
	// E2E-CLI-010 - KICS  scan with invalid --type flag
	// should exhibit an error message and return exit code 1
	{
		name: "E2E-CLI-010",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf", "-t", "xml", "--silent"},
			},
		},
		validation: func(outputText string) bool {
			unknownArgRegex := regexp.MustCompile(`Error: unknown argument for --type: \[xml\]`)
			match := unknownArgRegex.MatchString(outputText)
			return match
		},
		wantStatus: []int{126},
	},
	// E2E-CLI-011 - KICS  scan with a valid case insensitive --type flag
	// must perform the scan successfully and return exit code 50
	{
		name: "E2E-CLI-011",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"-t", "TeRraFOrM", "--silent", "--payload-path", "output/E2E_CLI_011_PAYLOAD.json"},
			},
			expectedPayload: []string{
				"E2E_CLI_011_PAYLOAD.json",
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-012 - kics scan with minimal-ui flag should perform a scan
	// without showing detailed results on each line of code
	{
		name: "E2E-CLI-012",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-q", "../assets/queries", "-p", "../test/fixtures/tc-sim01/positive1.tf", "--minimal-ui"},
			},
		},
		wantStatus: []int{50},
		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString("Description:", outputText)
			match2, _ := regexp.MatchString("Platform:", outputText)
			// if not found -> the the test was successful
			return !match1 && !match2
		},
	},
	// E2E-CLI-013 - KICS root command list-platforms
	// must return all the supported platforms in the CLI
	{
		name: "E2E-CLI-013",
		args: args{
			args: []cmdArgs{
				[]string{"list-platforms"},
			},
			expectedOut: []string{
				"E2E_CLI_013",
			},
		},
		wantStatus: []int{0},
	},
	// E2E-CLI-014 - KICS preview-lines command must delimit the number of
	// code lines that are displayed in each scan results code block.
	{
		name: "E2E-CLI-014",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--preview-lines", "1", "--no-color", "--no-progress",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		validation: func(outputText string) bool {
			// only the match1 must be true
			match1, _ := regexp.MatchString(`001\: resource \"aws_redshift_cluster\" \"default1\" \{`, outputText)
			match2, _ := regexp.MatchString(`002\:   publicly_accessible = false`, outputText)
			return match1 && !match2
		},
		wantStatus: []int{40},
	},
	// E2E-CLI-015 KICS scan with --no-color flag
	// must disable the colored outputs of kics in the CLI
	{
		name: "E2E-CLI-015",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--no-color", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`HIGH: \d+`, outputText)
			match2, _ := regexp.MatchString(`MEDIUM: \d+`, outputText)
			match3, _ := regexp.MatchString(`LOW: \d+`, outputText)
			match4, _ := regexp.MatchString(`INFO: \d+`, outputText)
			return match1 && match2 && match3 && match4
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-016 - KICS has an invalid flag or invalid command
	// an error message and return exit code 1
	{
		name: "E2E-CLI-016",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--invalid-flag"},
				[]string{"--invalid-flag"},
				[]string{"invalid"},
				[]string{"-i"},
			},
			expectedOut: []string{
				"E2E_CLI_016_INVALID_SCAN_FLAG",
				"E2E_CLI_016_INVALID_FLAG",
				"E2E_CLI_016_INVALID_COMMAND",
				"E2E_CLI_016_INVALID_SHOTHAND",
			},
		},
		wantStatus: []int{126, 126, 126, 126},
	},
	// E2E-CLI-017 - KICS scan command with the -v (--verbose) flag
	// should display additional informations in the CLI, such as 'Inspector initialized'...
	{
		name: "E2E-CLI-017",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-v", "--no-progress", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`Inspector initialized, number of queries=\d+`, outputText)
			match2, _ := regexp.MatchString(`Inspector stopped`, outputText)
			return match1 && match2
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-018  - KICS scan command with --exclude-categories flag should
	// not run queries that are part of the provided categories.
	{
		name: "E2E-CLI-018",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--exclude-categories", "Observability,Insecure Configurations", "-s",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},

				[]string{"scan", "-s",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		wantStatus: []int{20, 40},
	},
	// E2E-CLI-019 - KICS scan with multiple paths
	// should run a scan for all provided paths/files
	{
		name: "E2E-CLI-019",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf,fixtures/samples/terraform-single.tf"},
			},
			expectedOut: []string{
				"E2E_CLI_019",
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-020 - KICS scan with --exclude-queries flag
	// should not run queries that was provided in this flag.
	{
		name: "E2E-CLI-020",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--exclude-queries", "15ffbacc-fa42-4f6f-a57d-2feac7365caa,0a494a6a-ebe2-48a0-9d77-cf9d5125e1b3", "-s",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		wantStatus: []int{20},
	},
	// E2E-CLI-021 - KICS can return different status code based in the scan results (High/Medium/Low..)
	// when excluding categories/queries and losing results we can get a different status code.
	{
		name: "E2E-CLI-021",
		args: args{
			args: []cmdArgs{
				[]string{"scan",
					"-q", "../assets/queries", "-p", "../test/fixtures/all_auth_users_get_read_access/test/positive.tf"},

				[]string{"scan", "--exclude-categories",
					"Access Control,Availability,Backup,Best Practices,Build Process,Encryption," +
						"Insecure Configurations,Insecure Defaults,Networking and Firewall,Observability," +
						"Resource Management,Secret Management,Supply-Chain,Structure and Semantics",
					"-q", "../assets/queries", "-p", "../test/fixtures/all_auth_users_get_read_access/test/positive.tf"},
			},
		},
		wantStatus: []int{50, 0},
	},
	// E2E-CLI-022 - Kics  scan command with --profiling CPU and -v flags
	// must display CPU usage in the CLI
	{
		name: "E2E-CLI-022",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--profiling", "CPU", "-v",
					"--no-progress", "--no-color", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Total CPU usage for start_scan: \d+`, outputText)
			return match
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-023 - Kics  scan command with --profiling MEM and -v flags
	// must display MEM usage in the CLI
	{
		name: "E2E-CLI-023",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--profiling", "MEM", "-v",
					"--no-progress", "--no-color", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
		},
		validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Total MEM usage for start_scan: \d+`, outputText)
			return match
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-024  - KICS version command
	// should display the version of the kics in the CLI.
	{
		name: "E2E-CLI-024",
		args: args{
			args: []cmdArgs{
				[]string{"version"},
			},
		},
		validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Keeping Infrastructure as Code Secure [0-9a-zA-Z]+`, outputText)
			return match
		},
		wantStatus: []int{0},
	},
	// E2E-CLI-025 - KICS scan command with --fail-on flag should
	// return status code different from 0 only when results match the severity provided in this flag
	{
		name: "E2E-CLI-025",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--fail-on", "info,low",
					"-s", "-q", "../assets/queries", "-p", "../assets/queries/dockerfile/apk_add_using_local_cache_path/test/positive.dockerfile"},

				[]string{"scan", "--fail-on", "info",
					"-s", "-q", "../assets/queries", "-p", "../assets/queries/dockerfile/apk_add_using_local_cache_path/test/positive.dockerfile"},
			},
		},
		wantStatus: []int{30, 20},
	},
	// E2E-CLI-026 - KICS scan command with --ignore-on-exit flag
	// should return status code 0 if the provided flag occurs.
	// Example: '--ignore-on-exit errors' -> Returns 0 if an error was found, instead of 126/130...
	{
		name: "E2E-CLI-026",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--ignore-on-exit",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.invalid.name"},

				[]string{"scan", "--ignore-on-exit", "errors",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.invalid.name"},

				[]string{"scan", "--ignore-on-exit", "errors",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},

				[]string{"scan", "--ignore-on-exit", "all",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		wantStatus: []int{126, 0, 40, 0},
	},
	// E2E-CLI-027 - KICS scan command with --exclude-paths
	// should not perform the scan on the files/folders provided by this flag
	{
		name: "E2E-CLI-027",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--exclude-paths", "../test/fixtures/all_auth_users_get_read_access/test/positive.tf",
					"-q", "../assets/queries", "-p", "../test/fixtures/all_auth_users_get_read_access/test/"},
			},
		},
		validation: func(outputText string) bool {
			match, _ := regexp.MatchString(`Files scanned: 1`, outputText)
			return match
		},
		wantStatus: []int{50},
	},

	// E2E-CLI-028 - KICS scan command with --log-format
	// should modify the view structure of output messages in the CLI (json/pretty)
	{
		name: "E2E-CLI-028",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--log-format", "json", "--verbose",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`{"level":"info"`, outputText)
			match2, _ := regexp.MatchString(`"message":"Inspector initialized, number of queries=\d+"`, outputText)
			return match1 && match2
		},

		wantStatus: []int{40},
	},

	// E2E-CLI-029 - KICS scan command with --config flag
	// should load a config file that provides commands and arguments to kics.
	{
		name: "E2E-CLI-029",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--config", "fixtures/samples/config.json"},

				[]string{"scan", "--config", "fixtures/samples/config.json", "--silent"},
			},
		},

		wantStatus: []int{40, 126},
	},
	// E2E-CLI-030 - Kics scan command with --output-path flags
	// should export the result files to the path provided by this flag.
	{
		name: "E2E-CLI-030",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--output-path", "output",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},
		wantStatus: []int{40},
	},
	// E2E-CLI-031 - Kics  scan command with --report-formats and --output-path flags
	// should export the results based on the formats provided by this flag.
	{
		name: "E2E-CLI-031",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_031_RESULT",
					"--report-formats", "json,sarif,glsast,html",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_031_RESULT",
					resultsFormats: []string{"json", "sarif", "glsast", "html"},
				},
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-032 - KICS scan command with --output-path flag
	// and check the results.json report format
	{
		name: "E2E-CLI-032",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "-o", "output", "--output-name", "E2E_CLI_032_RESULT",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
				},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_032_RESULT",
					resultsFormats: []string{"json"},
				},
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-033 - KICS scan command with --output-path and --payload-path flags
	// should performe a scan and create result file(s) and payload file
	{
		name: "E2E-CLI-033",
		args: args{
			args: []cmdArgs{
				[]string{"scan",
					"--output-path", "output",
					"--output-name", "E2E_CLI_033_RESULT",
					"--report-formats", "json,sarif,glsast",
					"--payload-path", "output/E2E_CLI_033_PAYLOAD.json",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf",
				},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_033_RESULT",
					resultsFormats: []string{"json", "sarif", "glsast"},
				},
			},
			expectedPayload: []string{
				"E2E_CLI_033_PAYLOAD.json",
			},
		},
		wantStatus: []int{40},
	},
	// E2E-CLI-034 - KICS scan command with --log-format without --verbose
	// should not output log messages in the CLI (json)
	{
		name: "E2E-CLI-034",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--log-format", "json",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		validation: func(outputText string) bool {
			match1, _ := regexp.MatchString(`{"level":"info"`, outputText)
			match2, _ := regexp.MatchString(`"message":"Inspector initialized, number of queries=\d+"`, outputText)
			return !match1 && !match2
		},

		wantStatus: []int{40},
	},
	// E2E-CLI-035 - KICS scan command with --exclude-results
	// should not run/found results (similarityID) provided by this flag
	{
		name: "E2E-CLI-035",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--exclude-results", "2abf26c3014fc445da69d8d5bb862c1c511e8e16ad3a6c6f6e14c28aa0adac1d," +
					"d1c5f6aec84fd91ed24f5f06ccb8b6662e26c0202bcb5d4a58a1458c16456d20",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},

				[]string{"scan", "--exclude-results",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		wantStatus: []int{20, 126},
	},
	// E2E-CLI-036 - KICS scan command with --include-queries
	// should performe a scan running only the provided queries
	{
		name: "E2E-CLI-036",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--include-queries", "cfdcabb0-fc06-427c-865b-c59f13e898ce",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10,15ffbacc-fa42-4f6f-a57d-2feac7365caa",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"-s", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf"},

				[]string{"scan", "--include-queries",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		wantStatus: []int{50, 40, 20, 126},
	},
	// E2E-CLI-037 - KICS scan command with --exclude-results and --include-queries
	// should run only provided queries and does not run results (similarityID) provided by this flag
	{
		name: "E2E-CLI-037",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"--exclude-results", "406b71d9fd0edb656a4735df30dde77c5f8a6c4ec3caa3442f986a92832c653b",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},

				[]string{"scan", "--include-queries", "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
					"--exclude-results", "d1c5f6aec84fd91ed24f5f06ccb8b6662e26c0202bcb5d4a58a1458c16456d20",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},
		},

		wantStatus: []int{0, 20},
	},

	// E2E-CLI-038 - KICS scan command with --log-path
	// should generate and save a log file for the scan
	{
		name: "E2E-CLI-038",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--log-path", "output/E2E_CLI_038_LOG",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},

			expectedLog: LogValidation{
				logFile: "E2E_CLI_038_LOG",
				validationFunc: func(logText string) bool {
					match1, _ := regexp.MatchString("Scanning with Keeping Infrastructure as Code Secure", logText)
					match2, _ := regexp.MatchString(`Files scanned: \d+`, logText)
					match3, _ := regexp.MatchString(`Queries loaded: \d+`, logText)
					return match1 && match2 && match3
				},
			},
		},
		wantStatus: []int{40},
	},

	// E2E-CLI-039 - KICS scan command with --log-path and --log-level
	// should generate and save a log file based in the provided log-level
	{
		name: "E2E-CLI-039",
		args: args{
			args: []cmdArgs{

				[]string{"scan", "--log-path", "output/E2E_CLI_039_LOG",
					"--log-level", "TRACE",
					"-q", "../assets/queries", "-p", "fixtures/samples/terraform-single.tf"},
			},

			expectedLog: LogValidation{
				logFile: "E2E_CLI_039_LOG",
				validationFunc: func(logText string) bool {
					match1, _ := regexp.MatchString("TRACE", logText)
					match2, _ := regexp.MatchString(`Inspector executed with result`, logText)
					match3, _ := regexp.MatchString(`Scan duration: \d+`, logText)
					return match1 && match2 && match3
				},
			},
		},
		wantStatus: []int{40},
	},

	// E2E-CLI-040 - Kics  scan command with --report-formats and --output-path flags
	// should export the results based on the formats provided by this flag.
	{
		name: "E2E-CLI-040",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_040_RESULT",
					"--report-formats", "json,sarif,glsast,html",
					"-q", "../assets/queries", "-p", "fixtures/samples/positive.yaml"},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_040_RESULT",
					resultsFormats: []string{"json", "sarif", "glsast", "html"},
				},
			},
		},
		wantStatus: []int{50},
	},

	// E2E-CLI-041 - Kics scan command with -p targeting remote path (git)
	// should download and scan the provided path.
	{
		name: "E2E-CLI-041",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_041_RESULT",
					"--report-formats", "json,sarif,glsast", "-q", "../assets/queries",
					"-p", "git::https://github.com/dockersamples/example-voting-app"},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_041_RESULT",
					resultsFormats: []string{"json", "sarif", "glsast"},
				},
			},
		},
		wantStatus: []int{50},
	},
	// E2E-CLI-042 - Kics scan command with -p targeting remote path (http/https)
	// should download and scan the provided path/file.
	{
		name: "E2E-CLI-042",
		args: args{
			args: []cmdArgs{
				[]string{"scan", "--output-path", "output", "--output-name", "E2E_CLI_042_RESULT",
					"--report-formats", "json,sarif,glsast", "-q", "../assets/queries",
					"-p", "https://raw.githubusercontent.com/dockersamples/example-voting-app/master/docker-compose-simple.yml"},
			},
			expectedResult: []ResultsValidation{
				{
					resultsFile:    "E2E_CLI_042_RESULT",
					resultsFormats: []string{"json", "sarif", "glsast"},
				},
			},
		},
		wantStatus: []int{50},
	},
}

func Test_E2E_CLI(t *testing.T) {
	kicsPath := utils.GetKICSBinaryPath("")
	scanStartTime := time.Now()

	if testing.Short() {
		t.Skip("skipping E2E tests in short mode.")
	}

	templates := prepareTemplates()

	for _, tt := range tests {
		for arg := range tt.args.args {
			tt := tt
			arg := arg
			t.Run(fmt.Sprintf("%s_%d", tt.name, arg), func(t *testing.T) {
				t.Parallel()
				out, err := utils.RunCommand(append(kicsPath, tt.args.args[arg]...))
				// Check command Error
				require.NoError(t, err, "Capture CLI output should not yield an error")
				// Check exit status code
				require.Equalf(t, out.Status, tt.wantStatus[arg],
					"Actual KICS status code: %v\nExpected KICS status code: %v",
					out.Status, tt.wantStatus[arg])

				if tt.validation != nil {
					fullString := strings.Join(out.Output, ";")
					validation := tt.validation(fullString)
					require.True(t, validation, "KICS CLI output doesn't match the regex validation.")
				}

				if tt.args.expectedResult != nil {
					checkExpectedOutput(t, &tt, arg)
				}

				if tt.args.expectedPayload != nil {
					// Check payload file
					utils.FileCheck(t, tt.args.expectedPayload[arg], tt.args.expectedPayload[arg], "payload")
				}

				if tt.args.expectedLog.validationFunc != nil {
					// Check log file
					logData, _ := utils.ReadFixture(tt.args.expectedLog.logFile, "output")
					validation := tt.args.expectedLog.validationFunc(logData)
					require.Truef(t, validation, "The output log file 'output/%s' doesn't match the regex validation",
						tt.args.expectedLog.logFile)
				}

				if tt.args.expectedOut != nil {
					// Get and preapare expected output
					want, errPrep := utils.PrepareExpected(tt.args.expectedOut[arg], "fixtures")
					require.NoErrorf(t, errPrep, "[fixtures/%s] Reading a fixture should not yield an error",
						tt.args.expectedOut[arg])

					formattedWant := loadTemplates(want, templates)

					// Check number of Lines
					require.Equal(t, len(formattedWant), len(out.Output),
						"[fixtures/%s] Expected number lines: %d\n[CLI] Actual KICS output lines: %d",
						tt.args.expectedOut[arg], len(formattedWant), len(out.Output))

					// Check output lines
					for idx := range formattedWant {
						utils.CheckLine(t, out.Output[idx], formattedWant[idx], idx+1)
					}
				}
			})
		}
	}

	t.Cleanup(func() {
		err := os.RemoveAll("output")
		require.NoError(t, err)
		t.Logf("E2E tests ::ellapsed time:: %v", time.Since(scanStartTime))
	})
}

func checkExpectedOutput(t *testing.T, tt *testCase, argIndex int) {
	jsonFileName := tt.args.expectedResult[argIndex].resultsFile + ".json"
	resultsFormats := tt.args.expectedResult[argIndex].resultsFormats
	// Check result file (compare with sample)
	if _, err := os.Stat(filepath.Join("fixtures", jsonFileName)); err == nil {
		utils.FileCheck(t, jsonFileName, jsonFileName, "result")
	}
	// Check result file (JSON)
	if utils.Contains(resultsFormats, "json") {
		utils.JSONSchemaValidation(t, jsonFileName, "result.json")
	}
	// Check result file (GLSAST)
	if utils.Contains(resultsFormats, "glsast") {
		utils.JSONSchemaValidation(t, "gl-sast-"+jsonFileName, "result-gl-sast.json")
	}
	// Check result file (SARIF)
	if utils.Contains(resultsFormats, "sarif") {
		utils.JSONSchemaValidation(t, tt.args.expectedResult[argIndex].resultsFile+".sarif", "result-sarif.json")
	}
	// Check result file (HTML)
	if utils.Contains(resultsFormats, "html") {
		utils.HTMLValidation(t, tt.args.expectedResult[argIndex].resultsFile+".html")
	}
}

func prepareTemplates() TestTemplates {
	var help, errH = utils.PrepareExpected("help", "fixtures/assets")
	if errH != nil {
		help = []string{}
	}

	var scanHelp, errSH = utils.PrepareExpected("scan_help", "fixtures/assets")
	if errSH != nil {
		scanHelp = []string{}
	}

	return TestTemplates{
		strings.Join(help, "\n"),
		strings.Join(scanHelp, "\n")}
}

func loadTemplates(lines []string, templates TestTemplates) []string {
	temp, err := template.New("templates").Parse(strings.Join(lines, "\n"))
	if err != nil {
		return []string{}
	}

	builder := &strings.Builder{}

	err = temp.Execute(builder, templates)
	if err != nil {
		return []string{}
	}

	return strings.Split(builder.String(), "\n")
}
