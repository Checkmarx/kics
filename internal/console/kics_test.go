package console

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"
)

func TestConsole_Execute(t *testing.T) { //nolint
	tests := []struct {
		name    string
		args    []string
		wantErr bool
		remove  string
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
			wantErr: false,
			remove:  "",
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
			wantErr: false,
			remove:  "results.json",
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
			wantErr: false,
			remove:  "payload.json",
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
			wantErr: false,
			remove:  "",
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
			wantErr: false,
			remove:  "",
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
			wantErr: false,
			remove:  "",
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
			wantErr: false,
			remove:  "",
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
			wantErr: true,
			remove:  "",
		},
		{
			name:    "test_kics_version_cmd",
			args:    []string{"kics", "version"},
			wantErr: false,
			remove:  "",
		},
		{
			name:    "test_kics_list_platforms_cmd",
			args:    []string{"kics", "list-platforms"},
			wantErr: false,
			remove:  "",
		},
		{
			name:    "test_kics_generate_id_cmd",
			args:    []string{"kics", "generate-id"},
			wantErr: false,
			remove:  "",
		},
		{
			name: "test_kics_fail_without_scan",
			args: []string{"kics", "--path", filepath.FromSlash("../../test/fixtures/tc-sim01/positive1.tf"),
				"-q", filepath.FromSlash("../../assets/queries/terraform/aws/alb_is_not_integrated_with_waf")},
			wantErr: true,
			remove:  "",
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
		})
	}
}
