package main

import (
	"github.com/DataDog/kics/internal/console"
	"github.com/DataDog/kics/pkg/scan"
)

func main() {
	ExecuteKICSScan()
}

func ExecuteKICSScan() {
	params := &scan.Parameters{
		CloudProvider:       []string{""},
		DisableFullDesc:     false,
		ExcludeCategories:   []string{},
		ExcludeQueries:      []string{},
		ExcludeResults:      []string{},
		ExcludeSeverities:   []string{},
		ExcludePaths:        []string{},
		ExperimentalQueries: false,
		IncludeQueries:      []string{},
		InputData:           "",
		OutputName:          "kics-result",
		OutputPath:          "/Users/bahar.shah/go/src/github.com/DataDog/innovation-week-cloud-to-tf",
		Path: []string{
			"/Users/bahar.shah/go/src/github.com/DataDog/innovation-week-cloud-to-tf/terraform/ami.tf",
		},
		PayloadPath:                 "",
		PreviewLines:                3,
		QueriesPath:                 []string{"./assets/queries"},
		LibrariesPath:               "./assets/libraries",
		ReportFormats:               []string{"sarif"},
		Platform:                    []string{""},
		TerraformVarsPath:           "",
		QueryExecTimeout:            60,
		LineInfoPayload:             false,
		DisableSecrets:              true,
		SecretsRegexesPath:          "",
		ChangedDefaultQueryPath:     false,
		ChangedDefaultLibrariesPath: false,
		ScanID:                      "console",
		BillOfMaterials:             false,
		ExcludeGitIgnore:            false,
		OpenAPIResolveReferences:    false,
		ParallelScanFlag:            0,
		MaxFileSizeFlag:             5,
		UseOldSeverities:            false,
		MaxResolverDepth:            15,
		ExcludePlatform:             []string{""},
	}
	console.ExecuteScan(params)
}