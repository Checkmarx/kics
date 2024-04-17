//go:build !parallelScans
// +build !parallelScans

package console

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestConsole_Execute(t *testing.T) { //nolint

	tests := []struct {
		name                     string
		args                     []string
		wantErr                  bool
		remove                   string
		rewriteRemediateTestFile bool
	}{
		{
			name: "test_kics",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"--path",
				filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
			},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_output_flag",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"-o",
				"results.json",
			},
			wantErr:                  false,
			remove:                   "results.json",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_payload_flag",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"-d",
				"payload.json",
			},
			wantErr:                  false,
			remove:                   "payload.json",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_exclude_flag",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				filepath.FromSlash("../../test/fixtures/tc-sim01"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"-e",
				filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
			},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_exclude_results_flag",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"-x", "c8f2b4b2a74bca2aa6d94336c144f9713524b745c1a3590e6492e98d819e352d",
			},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_multiple_paths",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				fmt.Sprintf("%s,%s",
					filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
					filepath.FromSlash("../../test/fixtures/tc-sim01/positive2.tf")),
				"-q", filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
			},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_config_flag",
			args: []string{"kics",
				"scan",
				"--disable-secrets",
				"-p",
				filepath.FromSlash("../../test/fixtures/config"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"--config",
				filepath.FromSlash("../../test/fixtures/config/kics.config_json"),
			},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_unknown_config_flag",
			args: []string{"kics",
				"scan",
				"-p",
				filepath.FromSlash("../../test/fixtures/config"),
				"-q",
				filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf"),
				"--config",
				filepath.FromSlash("../../test/fixtures/config/kics_unknown.config_json"),
			},
			wantErr:                  true,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_version_cmd",
			args:                     []string{"kics", "version"},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_list_platforms_cmd",
			args:                     []string{"kics", "list-platforms"},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_generate_id_cmd",
			args:                     []string{"kics", "generate-id"},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_fail_without_scan",
			args: []string{"kics", "--path", filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q", filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf")},
			wantErr:                  true,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_fail_remediate_invalid_arg",
			args:                     []string{"kics", "remediate"},
			wantErr:                  true,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_remediate_help",
			args:                     []string{"kics", "remediate", "--help"},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_fail_remediate_invalid_path",
			args:                     []string{"kics", "remediate", "--results", "../../test/results.json"},
			wantErr:                  true,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name:                     "test_kics_fail_remediate_invalid_json",
			args:                     []string{"kics", "remediate", "--results", filepath.FromSlash("../../test/assets/invalid.json")},
			wantErr:                  true,
			remove:                   "",
			rewriteRemediateTestFile: false,
		},
		{
			name: "test_kics_remediate_with_id",
			args: []string{"kics", "remediate", "--results", filepath.FromSlash("../../test/assets/results_for_ar.json"),
				"--include-ids", "760d3bbce5e83fe48d20cbd70736bfac43fda67253238f31bde8206ba06c8821"},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: true,
		},
		{
			name:                     "test_kics_remediate_all",
			args:                     []string{"kics", "remediate", "--results", filepath.FromSlash("../../test/assets/results_for_ar.json")},
			wantErr:                  false,
			remove:                   "",
			rewriteRemediateTestFile: true,
		},
		{
			name:                     "test_kics_analyze",
			args:                     []string{"kics", "analyze", "--analyze-path", filepath.FromSlash("../../test/assets/"), "--analyze-results", "analyze-results.json"},
			wantErr:                  false,
			remove:                   "analyze-results.json",
			rewriteRemediateTestFile: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			os.Args = tt.args
			err := Execute()
			if (err != nil) != tt.wantErr {
				t.Errorf("Execute() = %v, wantErr = %v", err, tt.wantErr)
			}
			currentWorkDir, err := os.Getwd()
			if err != nil {
				t.Errorf("failed to get current dir, %v", err)
			}
			if tt.remove != "" {
				err = os.RemoveAll(filepath.Join(currentWorkDir, tt.remove))
				if err != nil {
					t.Errorf("failed to remove file: %v, %v", tt.remove, err)
				}
			}
			if tt.rewriteRemediateTestFile == true {
				err = rewriteRemediateTestFile()
				if err != nil {
					t.Errorf("failed to rewrite remediate test file: %v, %v", tt.rewriteRemediateTestFile, err)
				}

			}
		})
	}
}

func TestScanPerformance(t *testing.T) { //nolint

	tests := []struct {
		name           string
		firstExecArgs  []string
		secondExecArgs []string
	}{
		{
			name: "test_kics",
			firstExecArgs: []string{"kics",
				"scan",
				"--disable-secrets", "-s",
				"--path", filepath.FromSlash("../../e2e/fixtures/samples/long_terraform.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/"),
				"--ignore-on-exit", "all",
				"--parallel", "1",
			},
			secondExecArgs: []string{"kics",
				"scan",
				"--disable-secrets", "-s",
				"--path", filepath.FromSlash("../../e2e/fixtures/samples/long_terraform.tf"),
				"-q",
				filepath.FromSlash("../../assets/queries/"),
				"--ignore-on-exit", "all",
			},
		},
	}

	for _, tt := range tests {
		//check the number of cpus available - if it's 1, then skip this test
		numCPUs := runtime.GOMAXPROCS(-1)
		if numCPUs == 1 {
			t.Skip("Skipping test since only 1 cpu available")
		}
		t.Run(tt.name, func(t *testing.T) {
			//calling the command with a silent mode would nullify the standard output
			tmpStdout := os.Stdout
			defer func() { os.Stdout = tmpStdout }()
			os.Args = tt.firstExecArgs
			startTime1Worker := time.Now()
			err := Execute()
			elapsedTime1Worker := time.Since(startTime1Worker)
			t.Logf("Time taken with numWorkers=1: %s\n", elapsedTime1Worker)
			if err != nil {
				t.Errorf("Execute() = %v", err)
			}
			os.Args = tt.secondExecArgs
			startTime2Workers := time.Now()
			err = Execute()
			elapsedTimeMultiWorkers := time.Since(startTime2Workers)
			t.Logf("Time taken with numWorkers=%d: %s\n", numCPUs, elapsedTimeMultiWorkers)
			if err != nil {
				t.Errorf("Execute() = %v", err)
			}
			require.Greater(t, elapsedTime1Worker, elapsedTimeMultiWorkers)
		})
	}
}

func rewriteRemediateTestFile() error {
	d1 := []byte("resource \"alicloud_ram_account_password_policy\" \"corporate1\" {\n\t\trequire_lowercase_characters = false\n\t\trequire_uppercase_characters = false\n\t\trequire_numbers              = false\n\t\trequire_symbols              = false\n\t\thard_expiry                  = true\n\t\tpassword_reuse_prevention    = 5\n\t\tmax_login_attempts           = 3\n\t}\n\nresource \"alicloud_ram_account_password_policy\" \"corporate2\" {\n\t\tminimum_password_length = 14\n\t\trequire_lowercase_characters = false\n\t\trequire_uppercase_characters = false\n\t\trequire_numbers              = false\n\t\trequire_symbols              = false\n\t\thard_expiry                  = true\n\t\tpassword_reuse_prevention    = 5\n\t\tmax_login_attempts           = 3\n\t}")
	err := os.WriteFile(filepath.FromSlash("../../test/assets/auto_remediation_sample.tf"), d1, 0666)
	return err
}
