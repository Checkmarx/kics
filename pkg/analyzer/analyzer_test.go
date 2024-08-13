/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package analyzer

import (
	"path/filepath"
	"sort"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAnalyzer_Analyze(t *testing.T) {
	tests := []struct {
		name                 string
		paths                []string
		typesFromFlag        []string
		excludeTypesFromFlag []string
		wantTypes            []string
		wantExclude          []string
		wantLOC              int
		wantErr              bool
		gitIgnoreFileName    string
		excludeGitIgnore     bool
		MaxFileSize          int
	}{
		{
			name:      "analyze_test_dir_single_path",
			paths:     []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes: []string{"ansible", "azureresourcemanager", "cicd", "cloudformation", "crossplane", "googledeploymentmanager", "knative", "kubernetes", "openapi", "pulumi", "serverlessfw", "terraform"},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/pnpm-lock.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml")},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              819,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_helm_single_path",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test/helm")},
			wantTypes:            []string{"kubernetes"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              118,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_multiple_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf"),
			},
			wantTypes:            []string{"terraform"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              10,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_multi_checks_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test"),
			},
			wantTypes:            []string{"openapi"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              107,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_not_openapi",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json"),
			},
			wantTypes:            []string{},
			wantExclude:          []string{filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json")},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              0,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_error_path",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/Dockserfile"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/terraform.tf")},
			wantTypes:            []string{},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              0,
			wantErr:              true,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_tfplan",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/tfplan"),
			},
			wantTypes:            []string{"terraform"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              26,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_considering_ignore_file",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/gitignore"),
			},
			wantTypes: []string{"kubernetes"},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/gitignore/positive.dockerfile"),
				filepath.FromSlash("../../test/fixtures/gitignore/secrets.tf"),
			},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              13,
			wantErr:              false,
			gitIgnoreFileName:    "gitignore",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_not_considering_ignore_file",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/gitignore"),
			},
			wantTypes:            []string{"kubernetes", "terraform"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              33,
			wantErr:              false,
			gitIgnoreFileName:    "gitignore",
			excludeGitIgnore:     true,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_knative_file",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/knative.yaml"),
			},
			wantTypes:            []string{"knative", "kubernetes"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              15,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_servelessfw_file",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/serverlessfw.yml"),
			},
			wantTypes:            []string{"serverlessfw", "cloudformation"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              88,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name: "analyze_test_undetected_yaml",
			paths: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml"),
			},
			wantTypes:            []string{},
			wantExclude:          []string{filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml")},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              0,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:      "analyze_test_dir_single_path_types_value",
			paths:     []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes: []string{"ansible", "pulumi"},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/azureResourceManager.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/cloudformation.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/crossplane.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/gdm.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/helm/Chart.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/helm/templates/service.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/helm/values.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/k8s.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/knative.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test/openAPI.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/openAPI_test/openAPI.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/pnpm-lock.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/github.yaml"),
			},
			typesFromFlag:        []string{"ansible", "pulumi"},
			excludeTypesFromFlag: []string{""},
			wantLOC:              374,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:      "analyze_test_dir_single_path_exclude_type_value",
			paths:     []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes: []string{"azureresourcemanager", "cicd", "cloudformation", "crossplane", "googledeploymentmanager", "knative", "kubernetes", "openapi", "serverlessfw", "terraform"},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/ansible.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/pnpm-lock.yaml"),
			},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{"ansible", "pulumi"},
			wantLOC:              561,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:      "analyze_test_ignore_pnpm_lock_yaml_file",
			paths:     []string{filepath.FromSlash("../../test/fixtures/analyzer_test")},
			wantTypes: []string{"ansible", "azureresourcemanager", "cicd", "cloudformation", "crossplane", "googledeploymentmanager", "knative", "kubernetes", "openapi", "pulumi", "serverlessfw", "terraform"},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/analyzer_test/pnpm-lock.yaml"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/not_openapi.json"),
				filepath.FromSlash("../../test/fixtures/analyzer_test/undetected.yaml"),
			},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              819,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_ansible_host",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test/hosts.ini")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              39,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_ansible_cfg",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test/ansible.cfg")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              173,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_ansible_conf",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test/ansible.conf")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              18,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_cicd_github",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test/github.yaml")},
			wantTypes:            []string{"cicd"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              42,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "ansible_host",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test_ansible_host/ansiblehost.yaml")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              33,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "ansible_by_children",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test_ansible_host/ansiblehost2.yaml")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              22,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "ansible_by_host",
			paths:                []string{filepath.FromSlash("../../test/fixtures/analyzer_test_ansible_host/ansiblehost3.yaml")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              9,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:      "analyze_test_file_size_too_big",
			paths:     []string{filepath.FromSlash("../../test/fixtures/max_file_size")},
			wantTypes: []string{},
			wantExclude: []string{
				filepath.FromSlash("../../test/fixtures/max_file_size/sample.tf"),
			},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              0,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          3,
		},
		{
			name:                 "analyze_ansible_by_path",
			paths:                []string{filepath.FromSlash("../../test/fixtures/ansible_project_path")},
			wantTypes:            []string{"ansible"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              54,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
		{
			name:                 "analyze_test_bicep",
			paths:                []string{filepath.FromSlash("../../test/fixtures/bicep_test")},
			wantTypes:            []string{"bicep"},
			wantExclude:          []string{},
			typesFromFlag:        []string{""},
			excludeTypesFromFlag: []string{""},
			wantLOC:              697,
			wantErr:              false,
			gitIgnoreFileName:    "",
			excludeGitIgnore:     false,
			MaxFileSize:          -1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			exc := []string{""}

			analyzer := &Analyzer{
				Paths:             tt.paths,
				Types:             tt.typesFromFlag,
				ExcludeTypes:      tt.excludeTypesFromFlag,
				Exc:               exc,
				ExcludeGitIgnore:  tt.excludeGitIgnore,
				GitIgnoreFileName: tt.gitIgnoreFileName,
				MaxFileSize:       tt.MaxFileSize,
			}

			got, err := Analyze(analyzer)
			if (err != nil) != tt.wantErr {
				t.Errorf("Analyze = %v, wantErr = %v", err, tt.wantErr)
			}
			sort.Strings(tt.wantTypes)
			sort.Strings(tt.wantExclude)
			sort.Strings(got.Types)
			sort.Strings(got.Exc)

			require.Equal(t, tt.wantTypes, got.Types, "wrong types from analyzer")
			require.Equal(t, tt.wantExclude, got.Exc, "wrong excludes from analyzer")
			require.Equal(t, tt.wantLOC, got.ExpectedLOC, "wrong loc from analyzer")
		})
	}
}
