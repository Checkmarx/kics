package kics

import (
	"github.com/Checkmarx/kics/internal/console"
	"github.com/Checkmarx/kics/pkg/scan"
)

func ExecuteKICSScan(inputPaths []string, outputPath string) {
	params := scan.GetDefaultParameters()
	params.Path = inputPaths
	params.OutputPath = outputPath
	console.ExecuteScan(params)
}
